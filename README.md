# Advanced VLSI System Design
Course AVSD in NCKU 2024

## HW1 
### 5 stage pipelined RISC-V CPU
Implement 49 instructions + 10 CSR instructions

(14 R-type, 15 I-type, 4 S-type, 6 B-type, 2 U-type, 1 J-type, 4 F-type)

Read/Write data from/to SRAM

Verified function with 6 prog

1. Test 49 instructions
2. Sort Algorithm
3. Complete Mulitiplication without MUL/MUL[[S]U] 
4. Greatest common divisor
5. Test rdinstret, rdinstreth, rdcycle, rdcycleh with c code
6. Calculate using floating point instructions

Tool Used : Design Compiler, Superlint, Verdi


## HW2
### AXI4-bus 
Designed AXI-4 Bridge Crossbar, Slave Interface, and Master Interface

Verified CPU Wrapper, SRAM Wrapper, and AXI seperately with JasperGold Verification IP

Verified functionality with 6 prog as above mentioned

CPU has two masters, IM(Slave 1), DM(Slave 2)

Tool Used : JasperGold VIP, 


## HW3
### New Instructions
CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI, MRET, WFI

### New IPs
DRAM Wrapper, ROM Wrapper(storing booting code), DMA, Watch Dog timer
### Software & Bootloader
45 instructions, Sort algorithm of half-word, Grayscale, Timer interrupt, Timer interrupt with clock uncertainty, Bootloader(Load software from DRAM to IM/DM)

Tool Used : Spyglass CDC


## HW4
### AXI CDC
Total 4 clock domains (AXI 2.5ns, WDT/ROM 50.1ns, DRAM 5.1ns, others user defined)

Soved multi-bits clock domains using AFIFO CDC

### Cache
Implemented connection of two caches beneath CPU
* Instance

L1CI (IM Cache)

L1CD (DM Cache)

* Read Policy

Read miss : read allocate

* Write Policy

Write hit : write through

Write miss : write no allocate

Cache : 1KB, 2 way set, LRU, block size 16 Bytes

### APR
Verified with 4 prog and ranked in 5 groups
1. Booting + Testing I/M/F instructions
2. Booting + Floating point
3. Booting + Matrix Multiplication
4. Booting + CPU malfunction + CPU operate normally


Tool Used : ICC2


## Final Project


