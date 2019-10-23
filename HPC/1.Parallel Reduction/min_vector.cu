%%cu
#include<iostream>
#include<cstdio>
#include<math.h>
#include <time.h>

using namespace std;


__global__
void reduction_kernel(int *d_a, int expo){

	int tid = blockIdx.x * blockDim.x + threadIdx.x ;

	int i = tid * pow(2, expo) ; 
	int next = i + pow(2, expo) / 2 ; 

	if(d_a[i] > d_a[next]){ // Doing Min Reduction swap

		int temp = d_a[i] ; 
		d_a[i] = d_a[next] ; 
		d_a[next] = temp ; 

	}	
	 // printf("%d\n", i);
}

void printArr(int *a, int N){
	cout << "Array is" << endl ; 
	for (int i = 0; i < N; i++)
	{
		cout << a[i] << "\t" ;
	}
  	cout << endl ; 	
}

int trad_min(int *a, int N){
	int mini = a[0] ; 
	for (int i = 0; i < N; i++)
	{
		if(a[i] < mini){
			mini = a[i] ; 
		}
	}
	return mini ; 
}

int foo(){

	int N = 1024 ; 
	int a[N] ; 

	for (int i = 0; i < N; i++)
	{
		a[i] = rand() ; 
	}

	int t_min = trad_min(a, N) ; 
	cout << "\nMinimum Element is " << t_min << endl; 
  	// printArr(a, N) ; 

	int *d_a;
	int bytes = sizeof(int) * N ; 

	cudaMalloc(&d_a, bytes) ; 
	cudaMemcpy(d_a, a, bytes, cudaMemcpyHostToDevice) ; 

	int num_thread = N ; 
	int expo = 1 ; 
	while(num_thread != 0){
		num_thread = num_thread / 2 ; 
		reduction_kernel<<<1,num_thread>>>(d_a, expo) ;
		expo++ ;  

	}
	// reduction_kernel<<<1,N/2>>>(d_a) ; 

	cudaMemcpy(a, d_a, bytes, cudaMemcpyDeviceToHost) ; 

	cudaFree(d_a) ; 

  	// printArr(a, N) ;
  	int c_min = a[0] ; 
  	cout << "\nMinimum Element is " << c_min << endl ;

  	return t_min == c_min ; 

}

int main(){
  srand(time(0)) ; 
  
   	for (int i = 0; i < 100; i++)
   	{
   		cout << foo() ; 
   	}
	
	return 0 ; 
}