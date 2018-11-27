`timescale 1ns / 1ps

`ifdef _DEFINE_
`else
`define _DEFINE_

`define ADDR_BUS 17:0
`define DATA_BUS 15:0

`define PC_BUS 17:0

// alu op
`define OP_BUS 3:0
`define OP_ADD 4'b0000
`define OP_SUB 4'b0001
`define OP_AND 4'b0010
`define OP_OR  4'b0011
`define OP_XOR 4'b0000
`define OP_NOT 4'b0000
`define OP_SLL 4'b0000
`define OP_SRL 4'b0000
`define OP_SRA 4'b0000
`define OP_ROL 4'b0000

// alu flag
`define FLAG_BUS 4:0 
`define FLAG_ZF 0  /* Zero Flag     */
`define FLAG_CF 1  /* Carry Flag    */
`define FLAG_OF 2  /* Overflow Flag */
`define FLAG_SF 3  /* Sign Flag     */
`define FLAG_PF 4  /* Parity Flag   */

// sign extend
`define _5_bit_1_  5'b1_1111
`define _5_bit_0_  5'b0_0000
`define _8_bit_1_  8'b1111_1111
`define _8_bit_0_  8'b0000_0000
`define _12_bit_1_ 12'b1111_1111_1111
`define _12_bit_0_ 12'b0000_0000_0000

`endif