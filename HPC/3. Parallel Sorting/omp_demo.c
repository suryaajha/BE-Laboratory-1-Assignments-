#include<stdio.h>
#include<omp.h>

int main(){
	omp_set_num_threads(10);
	#pragma omp parallel for 
	for (int i = 0; i < 100; i++)
	{
		int tid = omp_get_thread_num();
		printf("Value %d Thread ID %d\n", i, tid) ; 
	}
}