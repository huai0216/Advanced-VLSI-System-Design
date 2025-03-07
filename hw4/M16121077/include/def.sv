//================================================
// Auther:      Chen Yun-Ru (May)
// Filename:    def.svh
// Description: Hart defination
// Version:     0.1
//================================================
// `ifndef DEF_SVH
// `define DEF_SVH

// CPU
`define DATA_BITS 32
`define INS_SIZE 32
`define NOP 32'b0
`define DATA_SIZE 32
`define OPCODE 6:0

// OPCODE types
`define RTYPE 	7'b0110011
`define LOAD	7'b0000011
`define ITYPE	7'b0010011
`define JALR	7'b1100111
`define STYPE	7'b0100011
`define BTYPE	7'b1100011
`define AUIPC	7'b0010111
`define LUI		7'b0110111
`define JAL		7'b1101111
`define CSR		7'b1110011


// Cache
`define CACHE_BLOCK_BITS 2
`define CACHE_INDEX_BITS 5
`define CACHE_TAG_BITS 23
`define CACHE_DATA_BITS 128
`define CACHE_LINES 2**(`CACHE_INDEX_BITS)
`define CACHE_WRITE_BITS 16
`define CACHE_TYPE_BITS 3
`define CACHE_BYTE `CACHE_TYPE_BITS'b000
`define CACHE_HWORD `CACHE_TYPE_BITS'b001
`define CACHE_WORD `CACHE_TYPE_BITS'b010
`define CACHE_BYTE_U `CACHE_TYPE_BITS'b100
`define CACHE_HWORD_U `CACHE_TYPE_BITS'b101

//Read Write data length
`define WRITE_LEN_BITS 2
`define BYTE `WRITE_LEN_BITS'b00
`define HWORD `WRITE_LEN_BITS'b01
`define WORD `WRITE_LEN_BITS'b10

// `endif
