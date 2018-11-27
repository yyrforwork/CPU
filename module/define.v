`timescale 1ns / 1ps

`ifdef _DEFINE_
`else
`define _DEFINE_

`define INST_BUS 15:0
`define ADDR_BUS 17:0
`define DATA_BUS 15:0

`define DATA_ZERO 16'b0000_0000_0000_0000
`define ADDR_ZERO 18'b00_0000_0000_0000_0000

// sram op
`define RAM_RD 0
`define RAM_WR 1

// alu op
`define OP_BUS 3:0
`define OP_ADD  4'b0000
`define OP_SUB  4'b0001
`define OP_AND  4'b0010
`define OP_OR   4'b0011
`define OP_XOR  4'b0100
`define OP_NOT  4'b0101
`define OP_RETA 4'b0110
`define OP_RETB 4'b0111
`define OP_EQU  4'b1000
`define OP_SLL  4'b1010
`define OP_SLLV 4'b1011
`define OP_SRA  4'b1100
`define OP_SRL  4'b1101

// sign extend
`define _5_bit_1_  5'b1_1111
`define _5_bit_0_  5'b0_0000
`define _8_bit_1_  8'b1111_1111
`define _8_bit_0_  8'b0000_0000
`define _11_bit_1_ 12'b111_1111_1111
`define _11_bit_0_ 12'b000_0000_0000
`define _12_bit_1_ 12'b1111_1111_1111
`define _12_bit_0_ 12'b0000_0000_0000

// WB Mux
`define WB_OP_BUS 1:0
`define WB_OP_ALU 2'b00
`define WB_OP_MEM 2'b01
`define WB_OP_PC  2'b10
`define WB_OP_IH  2'b11

`endif