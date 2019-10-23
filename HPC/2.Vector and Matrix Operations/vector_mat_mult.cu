%%cu
#include<iostream>
#include <cstdio>

using namespace std ;

void print_arr(int *a, int N){

	cout << "Array is " << endl ;

	for (int i = 0; i < N; i++)
	{
		cout << a[i] << "\t" ; 
	}
	cout << endl ; 
}

void print_mat(int *matrix, int N, int M){

	cout << "Matrix is " << endl ;

	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < M; j++)
		{
			cout << matrix[ i * M + j] <<  "\t" ; 
		}
		cout << endl ; 
	}
	cout << endl ;
}

void trad_vector_mat_mult(int *vec, int *matrix, int N, int M){
	int store[M] ; 

	// Timing Code
	cudaEvent_t start, end ;
	float elapsed_time = 0.0f ; 

	cudaEventCreate(&start) ;
	cudaEventCreate(&end) ;

	cudaEventRecord(start) ; 

	// end of timing code

	for (int j = 0; j < M; j++)
	{
		store[j] = 0 ; 
		for (int i = 0; i < N; i++)
		{
			store[j] += vec[i] * matrix[i * M + j] ; 
		}
	}
	// timing code
	cudaEventRecord(end) ; 
	cudaEventSynchronize(end) ; 

	cudaEventElapsedTime(&elapsed_time, start, end) ; 
	cout << "Sequential Version Vector Matrix Multiplication Time is " << elapsed_time << endl ; 

	// end of timing code
	print_arr(store, M) ; 
}

// Kernels

__global__
void vector_matrix_multiplication_kernel(int *d_vec, int *d_matrix, int *store, int N, int M){
	int tid = blockIdx.x * blockDim.x + threadIdx.x ; 
	int value = 0 ;

	for (int i = 0; i < N; i++)
	{
		value += d_vec[i] * d_matrix[i * M + tid] ;  
	}

	store[tid] = value ; 

}

// End of Kernels


int main(){
	int N = 10 ; 
	int vec[N], temp_store[N]; 

	for (int i = 0; i < N; i++)
	{
		vec[i] = i + 1 ; 
	}

	// print_arr(vec, N) ; 

	int M = N ; 
	int matrix[N * M] ; 
	int k = 1 ; 

	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < M; j++)
		{
			matrix[i * M + j] = k++ ; 
		}
	}

	// print_mat(matrix, N, M) ; 

	trad_vector_mat_mult(vec, matrix, N, M) ; 

	int *d_vec, *d_temp_store, *d_matrix ; 

	int vec_bytes = sizeof(int) * N ; 
	int mat_bytes = sizeof(int) * N * sizeof(int) * M ; 

	cudaMalloc(&d_vec, vec_bytes) ; 
	cudaMalloc(&d_temp_store, vec_bytes) ;
	cudaMalloc(&d_matrix, mat_bytes) ;

	cudaMemcpy(d_vec, vec, vec_bytes, cudaMemcpyHostToDevice) ;  
	cudaMemcpy(d_matrix, matrix, mat_bytes, cudaMemcpyHostToDevice) ;  

	// Timing Code
	// cudaEvent_t start, end ;
	// float elapsed_time = 0.0f ; 

	// cudaEventCreate(&start) ;
	// cudaEventCreate(&end) ;

	// cudaEventRecord(start) ; 

	// end of timing code

	vector_matrix_multiplication_kernel<<<1, M>>>(d_vec, d_matrix, d_temp_store, N, M) ; 

	// timing code
	// cudaEventRecord(end) ; 
	// cudaEventSynchronize(end) ; 

	// cudaEventElapsedTime(&elapsed_time, start, end) ; 
	// cout << "CUDA Version Vector Matrix Multiplication Time is " << elapsed_time << endl ; 
	// end of timing code

	cudaMemcpy(temp_store, d_temp_store, vec_bytes, cudaMemcpyDeviceToHost) ; 

	cudaFree(d_vec);
	cudaFree(d_matrix);
	cudaFree(d_temp_store);


	print_arr(temp_store, N) ; 
	return  0 ; 
}