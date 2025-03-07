#include <stdint.h>
#include <stdio.h>

int main(){
    extern int div1;
    extern int div2;
    extern int _test_start;

    int a = div1;
    int b = div2;
    int tmp;

    while(b!=0){
        tmp = b;
        b = a % b;
        a = tmp;
    }

    *(&_test_start) = a;


    return 0;
}