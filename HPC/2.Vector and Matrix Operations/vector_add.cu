%%cu
#include<iostream>
#include<cstdio>
#include <vector> 

using namespace std;


__global__
void vector_add_kernel(int *d_a, int *d_b, int *d_c){

  
	int id = blockIdx.x * blockDim.x + threadIdx.x ; 
  printf("%d \n", id);
	d_c[id] = d_a[id] + d_b[id] ; 

}

void trad_vector_add(int *a, int *b, int *c, int N){
	cudaEvent_t start, end;
	float elapsed_time = 0.0f; 
	cudaEventCreate(&start);
	cudaEventCreate(&end);
	cudaEventRecord(start) ; 

	for (int i = 0; i < N; i++)
	{
		c[i] = a[i] + b[i] ; 
	}

	cudaEventRecord(end);
	cudaEventSynchronize(end) ; 

	cudaEventElapsedTime(&elapsed_time, start, end) ; 

	cout << "Traditional Time Required was " << elapsed_time << endl ; 

	for (int i = 0; i < 10; i++){
		
		cout << c[i] << " " << endl ; 

	}

}

int main(){

	int N = 10;
	int a[N], b[N], c[N]; 

	for(int i = 0 ; i < N ; i++){
		a[i] = i ; 
		b[i] = i ; 
	}

	int *d_a, *d_b, *d_c ; 

	int bytes = sizeof(int) * N ; 

	cudaMalloc(&d_a, bytes) ; 
	cudaMemcpy(d_a, a, bytes, cudaMemcpyHostToDevice) ; 

	cudaMalloc(&d_b, bytes) ; 
	cudaMemcpy(d_b, b, bytes, cudaMemcpyHostToDevice) ; 

	cudaMalloc(&d_c, bytes) ; 

	// Timing Code

	cudaEvent_t start, end;
	float elapsed_time = 0.0f; 
	cudaEventCreate(&start);
	cudaEventCreate(&end);
	cudaEventRecord(start) ; 

	vector_add_kernel<<<10,N/10>>>(d_a, d_b, d_c);

	cudaEventRecord(end);
	cudaEventSynchronize(end) ; 

	cudaEventElapsedTime(&elapsed_time, start, end) ; 

	cout << "Cuda Time Required was " << elapsed_time << endl ; 

	cudaMemcpy(c, d_c, bytes, cudaMemcpyDeviceToHost) ; 

	// Free Device Memory
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	for (int i = 0; i < N; i++){
		
		cout << c[i] << " " << endl ; 

	}
    
  // Doing the traditional way

	// trad_vector_add(a, b, c, N) ; 


	return 0 ; 
}