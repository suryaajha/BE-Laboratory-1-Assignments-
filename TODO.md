1. How to add C code to measure time taken by piece of code
2. Structure of Chat Bot etc
3. Matrix Multiplication
4. Add or remember other GITHUB REPO LINK
5. How to run cuda programs in LAB
6. Change IP to get INTERNET


APIS:

int tid = blockIdx.x * blockDim.x + threadIdx.x ;

a[i][j] === a[i * cols + j]

cudaMalloc(
		  address_of_device_var, 
		  bytes_to_allocate
		  )

cudaMemcpy(
		  destination_var, 
		  source_var,
		  bytes_to_copy,
		  direction -> cudaMemcpyHostToDevice, cudaMemcpyDeviceToHost
		  )

cudaFree(
		 driver_var
 		)

omp_set_num_threads(num)

int tid = omp_get_thread_num()

# #pragma omp parallel 
# #pragma omp parallel for
# #pragma omp parallel sections
# #pragma omp section 

MPI_Init(NULL, NULL)

MPI_Finalize()

MPI_Comm_rank(
			 MPI_COMM_WORLD,
			 add_of_process_id_var
			 )

MPI_Comm_size(
			 MPI_COMM_WORLD,
			 add_of_process_numbers_var
			 )

MPI_Send(
		add_of_variable_send, 
		count_of_such_vars(1),
		MPI_INT,
		recv_process_id,
		msg_tag,
		MPI_COMM_WORLD
		)

MPI_Recv(
		add_of_variable_to_get_value,
		count_of_such_vars(1),
		MPI_INT,
		sender_process_id,
		msg_tag,
		MPI_COMM_WORLD,
		MPI_Status &status
		)

Formulas

1. STD_DEV = sqrt( sigma(x_i - mu)^2 / n )
