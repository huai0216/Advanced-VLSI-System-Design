/*int boot() {

	extern unsigned int _dram_i_start;
	extern unsigned int _dram_i_end;
	extern unsigned int _imem_start;
	extern unsigned int __data_paddr_start;
	extern unsigned int __data_start;
	extern unsigned int __data_end;
	extern unsigned int __sdata_paddr_start;
	extern unsigned int __sdata_start;
	extern unsigned int __sdata_end;
	
    int imem_size =_dram_i_end - _dram_i_start;
	 for (unsigned int i = 0; i < imem_size; i=i+1) {
        *(&_imem_start+i) = *(&_dram_i_start+i);
    }
    
    int data_size = __data_end - __data_start;
	for (unsigned int i = 0; i < data_size; i=i+1) {
        *(&__data_start+i) = *(&__data_paddr_start+i);
    }
  
    int sdata_size = __sdata_end - __sdata_start;
	for (unsigned int i = 0; i < sdata_size; i=i+1) {
        *(&__sdata_start+i) = *(&__sdata_paddr_start+i);
    }
    return 0;
}*/
void boot() {
  extern unsigned int _dram_i_start;
  extern unsigned int _dram_i_end;
  extern unsigned int _imem_start;

  extern unsigned int __sdata_start;
  extern unsigned int __sdata_end;
  extern unsigned int __sdata_paddr_start;

  extern unsigned int __data_start;
  extern unsigned int __data_end;
  extern unsigned int __data_paddr_start;
  
  volatile unsigned int *dma_addr_boot = (int *) 0x10020000;
  
  // Enable Local Interrupt
  asm("li t6, 0x800");
  asm("csrw mie, t6"); // MEIE of mie 
  //DMA source addr
  dma_addr_boot[0x80] = &_dram_i_start;
  //DMA dest addr
  dma_addr_boot[0xC0] = &_imem_start;
  //DMA len
  dma_addr_boot[0x100]= &_dram_i_end - &_dram_i_start + 1;
  // Enable DMA Controller
  dma_addr_boot[0x40] = 1; // Enable DMA
  asm("wfi");
  // disable DMA Controller
  dma_addr_boot[0x40] = 0; // disable DMA
  
  /*
  int *dram_i_start = &_dram_i_start;
  for(int i=0; i<=(&_dram_i_end-&_dram_i_start); i++)
  {
 *(&_imem_start+i) = dram_i_start[i];  
  }
  */
	
  // Enable Local Interrupt
  asm("li t6, 0x800");
  asm("csrw mie, t6"); // MEIE of mie 
  //DMA source addr
  dma_addr_boot[0x80] = &__data_paddr_start;
  //DMA dest addr
  dma_addr_boot[0xC0] = &__data_start;
  //DMA len
  dma_addr_boot[0x100]= &__data_end - &__data_start + 1;
  // Enable DMA Controller
  dma_addr_boot[0x40] = 1; // Enable DMA
  asm("wfi");
  // disable DMA Controller
  dma_addr_boot[0x40] = 0; // disable DMA
  
 /* 
  int *data_paddr_start = &__data_paddr_start;
  for(int k=0; k<=(&__data_end-&__data_start); k++)
  {
 *(&__data_start+k) = data_paddr_start[k];
  }  */
 


  // Enable Local Interrupt
  asm("li t6, 0x800");
  asm("csrw mie, t6"); // MEIE of mie 
  //DMA source addr
  dma_addr_boot[0x80] = &__sdata_paddr_start;
  //DMA dest addr
  dma_addr_boot[0xC0] = &__sdata_start;
  //DMA len
  dma_addr_boot[0x100]= &__sdata_end - &__sdata_start + 1;
  // Enable DMA Controller
  dma_addr_boot[0x40] = 1; // Enable DMA
  asm("wfi");
  // disable DMA Controller
  dma_addr_boot[0x40] = 0; // disable DMA
  asm("li t6, 0x000");
  asm("csrw mie, t6"); // MEIE of mie
  
 /* 
  int *sdata_paddr_start = &__sdata_paddr_start;
  for(int j=0; j<=(&__sdata_end-&__sdata_start); j++)
  {
 *(&__sdata_start+j) = sdata_paddr_start[j];
  }*/
  
  
}