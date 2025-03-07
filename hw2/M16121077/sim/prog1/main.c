#include <stdint.h>
#include <stdio.h>

int main(){

    extern int array_size;
    extern int array_addr[];
    extern int _test_start[];

    int tmp;

    //bubble sort
    for(int i=1;i<array_size;i=i+1){    
        for(int j=i;j>0;j=j-1){
            if(array_addr[j-1] > array_addr[j]){
                tmp = array_addr[j];    
                array_addr[j] = array_addr[j-1];
                array_addr[j-1] = tmp;
            }  
        }
    }

    for(int i=0;i<array_size;i=i+1){
        _test_start[i] = array_addr[i];
    }

    return 0;
}