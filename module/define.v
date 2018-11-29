`timescale 1ns / 1ps

`ifdef _DEFINE_
`else
`define _DEFINE_

`define PC_BUS 15:0
`define INST_BUS 15:0
`define ADDR_BUS 17:0
`define DATA_BUS 15:0

`define DATA_ZERO 16'b0000_0000_0000_0000
`define ADDR_ZERO 18'b00_0000_0000_0000_0000

// reg file 
`define REG_ADDR_BUS 2:0
`define REG_OP_T   3'b000
`define REG_OP_SP  3'b001
`define REG_OP_IH  3'b010
`define REG_OP_RA  3'b011
`define REG_OP_REG 3'b100
`define REG_OP_NOP 3'b101

// sram op
`define RAM_OP_RD 0
`define RAM_OP_WR 1

// sign extend
`define _5_bit_1_  5'b1_1111
`define _5_bit_0_  5'b0_0000
`define _8_bit_1_  8'b1111_1111
`define _8_bit_0_  8'b0000_0000
`define _11_bit_1_ 12'b111_1111_1111
`define _11_bit_0_ 12'b000_0000_0000
`define _12_bit_1_ 12'b1111_1111_1111
`define _12_bit_0_ 12'b0000_0000_0000

// Control
`define INST_OP 15:11
`define INST_ADDIU  5'b01001 /* *** ***-***** */
`define INST_ADDIU3 5'b01000 /* *** *** 0**** */
`define INST_ADDSP3 5'b00000 /* *** ***-***** */
`define INST_ADDSP  5'b01100 /* 011 ***-***** */ /* G1 */
`define INST_ADDU   5'b11100 /* *** *** ***01 */ /* G2 */
`define INST_AND    5'b11101 /* *** *** 01100 */ /* G3 */
`define INST_B      5'b00010 /* ***-***-***** */
`define INST_BEQZ   5'b00100 /* *** ***-***** */
`define INST_BNEZ   5'b00101 /* *** ***-***** */
`define INST_BTEQZ  5'b01100 /* 000 *** ***** */ /* G1 */
`define INST_CMP    5'b11101 /* *** *** 01010 */ /* G3 */
`define INST_CMPI   5'b01110 /* *** ***-***** */
`define INST_JR     5'b11101 /* *** 000 00000 */ /* G3 */
`define INST_LI     5'b01101 /* *** ***-***** */
`define INST_LW     5'b10011 /* *** *** ***** */
`define INST_LW_SP  5'b10010 /* *** ***-***** */
`define INST_MFIH   5'b11110 /* *** 000 00000 */ /* G4 */
`define INST_MFPC   5'b11101 /* *** 010 00000 */ /* G3 */
`define INST_MTIH   5'b11110 /* *** 000 00001 */ /* G4 */
`define INST_MTSP   5'b01100 /* 100 *** 00000 */ /* G1 */
`define INST_NOP    5'b00001 /* 000 000 00000 */
`define INST_OR     5'b11101 /* *** *** 01101 */ /* G3 */
`define INST_SLL    5'b00110 /* *** *** ***00 */ /* G5 */
`define INST_SLLV   5'b11101 /* *** *** 00100 */ /* G3 */
`define INST_SRA    5'b00110 /* *** *** ***11 */ /* G5 */
`define INST_SRL    5'b00110 /* *** *** ***10 */ /* G5 */
`define INST_SUBU   5'b11100 /* *** *** ***11 */ /* G2 */
`define INST_SW     5'b11011 /* *** *** ***** */
`define INST_SW_RS  5'b01100 /* 010 ***-***** */ /* G1 */
`define INST_SW_SP  5'b11010 /* *** ***-***** */

// im mux
`define IM_OP_BUS 2:0
`define IM_OP_NOP      3'b000
`define IM_OP_S_E_3_0  3'b001
`define IM_OP_S_E_4_0  3'b010
`define IM_OP_S_E_7_0  3'b011
`define IM_OP_S_E_10_0 3'b100
`define IM_OP_Z_E_7_0  3'b101

// ALU A mux
`define ALU_A_OP_BUS 2:0
`define ALU_A_OP_T    3'b000
`define ALU_A_OP_SP   3'b001
`define ALU_A_OP_RZ   3'b010
`define ALU_A_OP_REGA 3'b011
`define ALU_A_OP_NOP  3'b100

// ALU B mux
`define ALU_B_OP_BUS 1:0
`define ALU_B_OP_IM   2'b00
`define ALU_B_OP_REGB 2'b01
`define ALU_B_OP_NOP  2'b10

// ALU op
`define ALU_OP_BUS 3:0
`define ALU_OP_ADD  4'b0000
`define ALU_OP_SUB  4'b0001
`define ALU_OP_AND  4'b0010
`define ALU_OP_OR   4'b0011
`define ALU_OP_XOR  4'b0100
`define ALU_OP_NOT  4'b0101
`define ALU_OP_RETA 4'b0110
`define ALU_OP_RETB 4'b0111
`define ALU_OP_EQU  4'b1000
`define ALU_OP_SLL  4'b1010
`define ALU_OP_SLLV 4'b1011
`define ALU_OP_SRA  4'b1100
`define ALU_OP_SRL  4'b1101
`define ALU_OP_NOP  4'b1110

// jump control
`define CLEAR_ENABLE  1'b1;
`define CLEAR_DISABLE 1'b0;

// jump data
`define JUMP_DATA_BUS 1:0
`define JUMP_DATA_NOP  2'b00
`define JUMP_DATA_ALU  2'b01
`define JUMP_DATA_JANS 2'b10

// jump enable 
`define JUMP_EN_OP_BUS 1:0
`define JUMP_EN_OP_EN     2'b00
`define JUMP_EN_OP_ZEROJ  2'b01
`define JUMP_EN_OP_NZEROJ 2'b10
`define JUMP_EN_OP_NOP    2'b11
`define PC_JUMP_ENABLE    1'b1
`define PC_JUMP_DISABLE   1'b0

// WB Data Mux
`define WB_DATA_OP_BUS 2:0
`define WB_DATA_OP_NOP 3'b000
`define WB_DATA_OP_ALU 3'b001
`define WB_DATA_OP_MEM 3'b010
`define WB_DATA_OP_PC  3'b011
`define WB_DATA_OP_IH  3'b100

// WB Addr Mux
`define WB_ADDR_OP_BUS 1:0
`define WB_ADDR_OP_NOP 2'b00
`define WB_ADDR_OP_RX  2'b01
`define WB_ADDR_OP_RY  2'b10
`define WB_ADDR_OP_RZ  2'b11

`endif