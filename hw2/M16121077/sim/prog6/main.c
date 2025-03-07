#include <stdint.h>
#include <stdio.h>

int main() {
	extern float add1;  // 32-bit float
    extern float add2;  // 32-bit float
    extern float sub1;  // 32-bit float
    extern float sub2;  // 32-bit float

    // result address
    extern float _test_start;

    *(&_test_start) = add1 + add2;
    *(&_test_start + 1) = sub1 - sub2;

	return 0;
}

