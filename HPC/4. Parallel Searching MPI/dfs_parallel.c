#include<stdio.h>
#include<mpi.h>
#include<math.h>

void print_tree(int *tree, int N){

	int j = 0;
	int last ;
	for (int i = 0; i < floor(log(N)/log(2) + 1); i++)
	{
		for (;j < pow(2,i) + last && j < N ; j++)
		{
			printf("%d\t", tree[j]) ; 
		}
		last = j ; 
		printf("\n");
	}

	printf("\n") ; 
}

int breath_first_search(int *tree, int tos, int start_node_idx, int end_node_idx, int N){

	int *queue ; 
	queue = (int*)malloc(sizeof(int) * N) ; 

	for (int i = 0; i < N; i++)
	{
		queue[i] = -1 ; 
	}

	int q_ptr =  0 ; 
	queue[0] = tree[start_node_idx] ; 
	int q_put_ptr = 1 ; 

	while(queue[q_ptr] != -1 && q_ptr < N){
		if(queue[q_ptr] == tos)
			return q_ptr;
		printf("%d\n", queue[q_ptr]);
		int left_ptr = 2 * q_ptr + 1 ; 
		int right_ptr = 2 * q_ptr + 2 ; 
		if(left_ptr <= end_node_idx)
			queue[q_put_ptr++] = tree[left_ptr]; 
		if(right_ptr <= end_node_idx)
			queue[q_put_ptr++] = tree[right_ptr]; 

		q_ptr++ ; 
	}

}

int binary_search(int *tree, int tos, int start, int end){

	if(start > end)
		return -1 ; 

	int mid = (start + end) / 2 ; 
	if(tree[mid] == tos)
		return mid ; 
	else if (tos > tree[mid])
		return binary_search(tree, tos, mid + 1, end) ;
	else
		return binary_search(tree, tos, start, mid - 1) ; 
}

int main(int argc, char const *argv[]){

	int *tree ; 
	int N = 16 ; 
	int tos = 14 ; 

	tree = (int*) malloc(N * sizeof(int)) ; 

	for (int i = 0; i < N; i++)
	{
		tree[i] = i ;
	}

	print_tree(tree, N) ; 

	int p = breath_first_search(tree, 5, 0, 7, 16) ;

	printf("Fuck %d\n", p); 

	return 0 ;

	MPI_Init(NULL, NULL) ; 

	MPI_Status status ; 

	int this_proc_id, number_of_processes ;

	MPI_Comm_rank(MPI_COMM_WORLD, &this_proc_id) ; 
	MPI_Comm_size(MPI_COMM_WORLD, &number_of_processes) ; 

	// First Process is Master Process which distributes the task among the other slave process 
	if (this_proc_id == 0){

		printf("Orginal tree from process #%d\n", this_proc_id);
		print_tree(tree, N) ; 

		int avg_nu_of_process = N / number_of_processes ; 

		// Do its own JOB

		int k = binary_search(tree, tos, 0, avg_nu_of_process - 1) ; 

		// Done own JOB
		if(k > 0){
			printf("Found %d at %d\n", tos, k) ; 
		}
		else{
			// Distribution of work load
			for (int i = 1; i < number_of_processes; i++)
			{
				int start = i * avg_nu_of_process ; 
				int end = start + avg_nu_of_process - 1 ;

				if(end > (N-1))
					end = N - 1 ; 

				MPI_Send(&start, 1, MPI_INT, i, 1, MPI_COMM_WORLD);
				MPI_Send(&end,   1, MPI_INT, i, 2, MPI_COMM_WORLD);
			}

			for (int i = 1; i < number_of_processes; i++)
			{
				int found_index ;
				MPI_Recv(&found_index, 1, MPI_INT, i, 10, MPI_COMM_WORLD, &status) ; 

				int sender = status.MPI_SOURCE; 

				if(found_index > 0){
					printf("%d found at %d by Process #%d\n", tos, found_index, sender);
					break;
				}
				else{
					printf("%d failed to find %d\n", sender, tos);
				}
			}
		}

	}
	else{

		// Slave Processes

		int start, end ; 

		MPI_Recv(&start, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status) ; 
		MPI_Recv(&end,   1, MPI_INT, 0, 2, MPI_COMM_WORLD, &status) ; 

		// printf("%d %d\n", start, end);

		int found_index = binary_search(tree, tos, start, end) ;

		// printf("%d\n", found_index);

		MPI_Send(&found_index, 1, MPI_INT, 0, 10, MPI_COMM_WORLD) ; 

	}

	MPI_Finalize() ; 

	return 0 ;

}