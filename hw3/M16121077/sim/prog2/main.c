#include <stdint.h>

#define MIP_MEIP (1 << 11) // External interrupt pending
#define MIP_MTIP (1 << 7)  // Timer interrupt pending
#define MIP 0x344

volatile unsigned int *WDT_addr = (int *) 0x10010000;
volatile unsigned int *dma_addr_boot = (int *) 0x10020000;




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
    asm volatile("csrr %0, %1" : "=r"(mip) : "i"(MIP));
	
    if ((mip & MIP_MTIP) >> 7) {
        timer_interrupt_handler();
    }

    if ((mip & MIP_MEIP) >> 11) {
        external_interrupt_handler();
    }
}

extern char _test_start;
extern char _binary_image_bmp_start;
extern char _binary_image_bmp_end;
extern unsigned int _binary_image_bmp_size;

int main(void) {
    char* test_start = &_test_start;
    char* bmp_start = &_binary_image_bmp_start;
    unsigned int size = (unsigned int)(&_binary_image_bmp_size);

    // Copy the first 54 bytes directly
    for (int i = 0; i < 54; i++) {
        test_start[i] = bmp_start[i];
    }

    for (int i = 54; i < size; i += 3) {
        char* a0 = &test_start[i];
        char* a1 = a0 + 1;
        char* a2 = a0 + 2;
        char* now_data_address = &bmp_start[i];

        if (*now_data_address == *(now_data_address + 1) &&
            *now_data_address == *(now_data_address + 2)) {
            // If all three components are equal, set all components to that value
            *a0 = *now_data_address;
            *a1 = *now_data_address;
            *a2 = *now_data_address;
        } else {
            // Apply a weighted average to the three components
            char temp = ((*now_data_address) * 11 +
                         (*(now_data_address + 1)) * 59 +
                         (*(now_data_address + 2)) * 30) / 100;

            *a0 = temp;
            *a1 = temp;
            *a2 = temp;
        }
    }

    return 0;
}
