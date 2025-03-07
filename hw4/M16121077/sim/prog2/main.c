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

int main(void){
  extern int array_size_i;
  extern int array_size_j;
  extern int array_size_k;
  extern short array_addr;
  extern int _test_start;

  int* result = &_test_start;
  short* data_a = &array_addr;
  short* data_b = (&array_addr + array_size_i*array_size_k);

  int a;
  int counter = 0;
  
  
  
  for(int i = 0; i < array_size_i; i++) {
	  for(int j = 0; j < array_size_j; j++) {
		  
		  a = 0;
		  for(int k =0 ; k<array_size_k; k++){
			a += data_a[k]*data_b[k*array_size_j];
		  }
		  result[counter] = a;
		  
		  counter  = counter+1;
		  data_b = data_b + 1;
	  }
	  data_b = (&array_addr + array_size_i*array_size_k);
	  data_a = data_a + array_size_k;
  }
  
  
 /*
 for(int k =0 ; k<array_size_k; k++){
	 a += data_a[k]*data_b[k*array_size_j];
 }
  result[0] = a;
  
  a =0;
  data_b = data_b + 1;
  for(int k =0 ; k<array_size_k; k++){
	 a += data_a[k]*data_b[k*array_size_j];
 }
  result[1] = a;
  
  a =0;
  data_b = data_b + 1;
  for(int k =0 ; k<array_size_k; k++){
	 a += data_a[k]*data_b[k*array_size_j];
 }
 
  result[2] = a
  
  /*
  a =0;
  data_b = data_b + 3;
  for(int k =0 ; k<array_size_k; k++){
	 a += data_a[k]*data_b[k*array_size_j];
 }
  result[3] = a;
 */
  //result[0] = data_a[0];
	
  return 0;
}
