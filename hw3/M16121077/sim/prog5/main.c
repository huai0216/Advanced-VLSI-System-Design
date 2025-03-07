#include <stdint.h>
unsigned int *copy_addr; // = &_test_start;
volatile unsigned int *WDT_addr = (int *) 0x10010000;


#define MIP_MEIP (1 << 11) // External interrupt pending
#define MIP_MTIP (1 << 7)  // Timer interrupt pending
#define MIP 0x344

void timer_interrupt_handler(void) {
  asm("csrsi mstatus, 0x0"); // MIE of mstatus
  WDT_addr[0x40] = 0; // WDT_en
  asm("j _start");
}

void external_interrupt_handler(void) {
	volatile unsigned int *dma_addr_boot = (int *) 0x10020000;
	asm("csrsi mstatus, 0x0"); // MIE of mstatus
	dma_addr_boot[0x40] = 0; // disable DMA
}


void trap_handler(void) {
    uint32_t mip;


    // 讀取中斷狀態寄存器
    asm volatile("csrr %0, %1" : "=r"(mip) : "i"(MIP));

    // 檢查並處理計時器中斷
    if ((mip & MIP_MTIP) >> 7) {
        timer_interrupt_handler(); // 調用計時器中斷處理程序
    }

    // 檢查並處理外部中斷
    if ((mip & MIP_MEIP) >> 11) {
        external_interrupt_handler(); // 調用外部中斷處理程序
    }
}



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



