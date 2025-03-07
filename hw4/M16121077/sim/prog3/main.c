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


int main(void) {
  extern unsigned int _test_start;
  copy_addr = &_test_start;
  
  *(copy_addr) = 0;
  *(copy_addr) = -1;
  // Enable Global Interrupt
  asm("csrsi mstatus, 0x8"); // MIE of mstatus

  // Enable Local Interrupt
  asm("li t6, 0x80");
  asm("csrs mie, t6"); // MEIE of mie 
 
  WDT_addr[0xc0] = 10000; // tonet
  WDT_addr[0x40] = 1; // WDT_en
  
  int a = 1;
  int b = 2;
  int c = 0;
  
	  for(int i = 0; i < 100; i++){
		for(int j = 0; j < 100; j++){ 
		  c = c + j;
		}
		  WDT_addr[0x80] = 1; // live_en
          WDT_addr[0x80] = 0; // live_en 
	  }
	  *(copy_addr + 1) = c;

  return 0;
}
