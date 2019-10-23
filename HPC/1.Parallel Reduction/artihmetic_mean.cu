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

	d_a[i] = d_a[i] + d_a[next] ; 
}

void printArr(int *a, int N){
	cout << "Array is" << endl ; 
	for (int i = 0; i < N; i++)
	{
		cout << a[i] << "\t" ;
	}
  	cout << endl ; 	
}

float trad_mean(int *a, int N){
	int sum = 0 ; 
	for (int i = 0; i < N; i++)
	{
		sum += a[i] ; 
	}
	return float(sum) / float(N) ;  
}

int foo(){

	int N = 8 ; 
	int a[N] ; 

	for (int i = 0; i < N; i++)
	{
		a[i] = i;
	}

	float t_min = trad_mean(a, N) ; 
	cout << "\nArithmetic Mean is " << t_min << endl; 
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
  	float c_min = float(a[0]) / float(N) ; 
  	cout << "\nArithmetic Mean  is " << c_min << endl ;

  	return t_min == c_min ; 

}

int main(){
  srand(time(0)) ; 
  
    int i = 0;
   	for (i = 0; i < 100; i++)
   	{
   		if (foo() == 0)
         break;
   	}
    cout << i << endl ;
    if(i == 100)
      cout << "Well Done" << endl ; 
    else
      cout << "Wrong" << endl ; 
	
	return 0 ; 
}