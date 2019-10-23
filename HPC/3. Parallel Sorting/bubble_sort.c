#include<stdio.h>
#include<omp.h>

// Structure for enabling reduction on the index of elements
struct Compare { int val; int index; };
// Custom reduction for finding hte index of the max element.
#pragma omp declare reduction(maximum : struct Compare : omp_out = omp_in.val > omp_out.val ? omp_in : omp_out)


void print_arr(int *a, int N){
	for (int i = 0; i < N; i++)
	{
		printf("%d\t", a[i]);
	}
	printf("\n");
}

int max(int A[], int ith, int jth)
{
	struct Compare max;
    // Initialize the variables
    max.val = A[ith];
    max.index = ith;

  	#pragma omp parallel for reduction(maximum:max)
	for(int i= ith ; i< jth; i++){
		if(A[i] > max.val){
			max.val = A[i];
			max.index = i;
		}
	}

	return max.index;
}

int main(){


	int N = 10 ;
	int a[N] ; 
	for (int i = 0; i < N; i++)
	{
		a[i] = rand() % 100;
	}

	// Find Max from array
	int k = max(a, 0, 9) ; 
	printf("%d\n", k);
	
	for (int i = 0; i < N - 1; ++i)
	{
		int index = max(a, 0, N - 1 - i) ; 
		int temp = a[index];
		a[index] = a[N-1-i] ; 
		a[N-1-i] = temp ;
	}

	print_arr(a, N) ; 
	return 0;
}