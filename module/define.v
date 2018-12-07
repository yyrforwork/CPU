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
`define INST_ZERO 16'b0000_1000_0000_0000
`define FIRST_PC  16'b0000_0000_0000_0000

// reg file
`define REG_ADDR_NUM 8
`define REG_ADDR_BUS 2:0
`define REG_OP_BUS 2:0
`define REG_OP_T   3'b000
`define REG_OP_SP  3'b001
`define REG_OP_IH  3'b010
`define REG_OP_RA  3'b011
`define REG_OP_REG 3'b100
`define REG_OP_NOP 3'b101

// ram op
`define RAM_OP_RD   1'b0
`define RAM_OP_WR   1'b1
`define RAM_ENABLE  1'b1
`define RAM_DISABLE 1'b0

// ram data mux
`define RAM_DATA_OP_BUS 1:0
`define RAM_DATA_OP_RX  2'b00
`define RAM_DATA_OP_RY  2'b01
`define RAM_DATA_OP_RA  2'b10
`define RAM_DATA_OP_NOP 2'b11

// sign extend
`define _5_BIT_1_  5'b1_1111
`define _5_BIT_0_  5'b0_0000
`define _8_BIT_1_  8'b1111_1111
`define _8_BIT_0_  8'b0000_0000
`define _11_BIT_1_ 12'b111_1111_1111
`define _11_BIT_0_ 12'b000_0000_0000
`define _12_BIT_1_ 12'b1111_1111_1111
`define _12_BIT_0_ 12'b0000_0000_0000

// Control
`define INST_OP 15:11
`define INST_ADDIU  5'b01001 /* *** ***-***** */
`define INST_ADDIU3 5'b01000 /* *** *** 0**** */
`define INST_ADDSP3 5'b00000 /* *** ***-***** */

`define INST_GROUP1 5'b01100
`define INST_ADDSP  5'b01100 /* 011 ***-***** */ /* G1 */
`define INST_BTEQZ  5'b01100 /* 000 *** ***** */ /* G1 */
`define INST_MTSP   5'b01100 /* 100 *** 00000 */ /* G1 */
`define INST_SW_RS  5'b01100 /* 010 ***-***** */ /* G1 */

`define INST_GROUP2 5'b11100
`define INST_ADDU   5'b11100 /* *** *** ***01 */ /* G2 */
`define INST_SUBU   5'b11100 /* *** *** ***11 */ /* G2 */

`define INST_GROUP3 5'b11101
`define INST_AND    5'b11101 /* *** *** 01100 */ /* G3 */
`define INST_CMP    5'b11101 /* *** *** 01010 */ /* G3 */
`define INST_JR     5'b11101 /* *** 000 00000 */ /* G3 */
`define INST_MFPC   5'b11101 /* *** 010 00000 */ /* G3 */
`define INST_OR     5'b11101 /* *** *** 01101 */ /* G3 */
`define INST_SLLV   5'b11101 /* *** *** 00100 */ /* G3 */

`define INST_B      5'b00010 /* ***-***-***** */
`define INST_BEQZ   5'b00100 /* *** ***-***** */
`define INST_BNEZ   5'b00101 /* *** ***-***** */
`define INST_CMPI   5'b01110 /* *** ***-***** */
`define INST_LI     5'b01101 /* *** ***-***** */
`define INST_LW     5'b10011 /* *** *** ***** */
`define INST_LW_SP  5'b10010 /* *** ***-***** */

`define INST_GROUP4 5'b11110
`define INST_MFIH   5'b11110 /* *** 000 00000 */ /* G4 */
`define INST_MTIH   5'b11110 /* *** 000 00001 */ /* G4 */

`define INST_NOP    5'b00001 /* 000 000 00000 */

`define INST_GROUP5 5'b00110
`define INST_SLL    5'b00110 /* *** *** ***00 */ /* G5 */
`define INST_SRA    5'b00110 /* *** *** ***11 */ /* G5 */
`define INST_SRL    5'b00110 /* *** *** ***10 */ /* G5 */

`define INST_SW     5'b11011 /* *** *** ***** */
`define INST_SW_SP  5'b11010 /* *** ***-***** */

// inst control op
`define INST_CTL_OP 4:0
`define INST_CTL_ADDIU  5'b00001
`define INST_CTL_ADDIU3 5'b00010
`define INST_CTL_ADDSP3 5'b00011
`define INST_CTL_ADDSP  5'b00100
`define INST_CTL_ADDU   5'b00101
`define INST_CTL_AND    5'b00110
`define INST_CTL_B      5'b00111
`define INST_CTL_BEQZ   5'b01001
`define INST_CTL_BNEZ   5'b01010
`define INST_CTL_BTEQZ  5'b01011
`define INST_CTL_CMP    5'b01100
`define INST_CTL_CMPI   5'b01101
`define INST_CTL_JR     5'b01110
`define INST_CTL_LI     5'b01111
`define INST_CTL_LW     5'b10000
`define INST_CTL_LW_SP  5'b10001
`define INST_CTL_MFIH   5'b10010
`define INST_CTL_MFPC   5'b10011
`define INST_CTL_MTIH   5'b10100
`define INST_CTL_MTSP   5'b10101
`define INST_CTL_NOP    5'b10110
`define INST_CTL_OR     5'b10111
`define INST_CTL_SLL    5'b11000
`define INST_CTL_SLLV   5'b11001
`define INST_CTL_SRA    5'b11010
`define INST_CTL_SRL    5'b11011
`define INST_CTL_SUBU   5'b11100
`define INST_CTL_SW     5'b11101
`define INST_CTL_SW_RS  5'b11110
`define INST_CTL_SW_SP  5'b11111

// inst rx ry rz addr
`define INST_RX_ADDR 10:8
`define INST_RY_ADDR 7:5
`define INST_RZ_ADDR 4:2

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
`define CLEAR_ENABLE  1'b1
`define CLEAR_DISABLE 1'b0

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

// pause control
`define PAUSE_ENABLE  1'b1
`define PAUSE_DISABLE 1'b0

// forward control
`define FORWARD_ENABLE  1'b1
`define FORWARD_DISABLE 1'b0

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

// RAM Data Mux
`define RAM_DATA_OP_BUS 1:0
`define RAM_DATA_OP_NOP  2'b00
`define RAM_DATA_OP_REGA 2'b01
`define RAM_DATA_OP_REGB 2'b10
`define RAM_DATA_OP_RA   2'b11

// ram
`define ENABLE  1'b1
`define DISABLE 1'b0
`define PC  1'b0
`define RAM 1'b1

// VGA
`define VGA_ADDR_BEG 18'hC000
`define VGA_ADDR_END 18'hC090

`define VGA_ROW 10'b10_1000_0000 /* 640 */
`define VGA_COL 10'b01_1110_0000 /* 480 */
`define VGA_ROW_BUS [9:0]
`define VGA_COL_BUS [9:0]

`define VGA_DATA_BUS [8:0]
`define VGA_R_BUS [8:6]
`define VGA_G_BUS [5:3]
`define VGA_B_BUS [2:0]

`define VGA_REG_ROW 6'h20  /* 32 */
`define VGA_REG_COL 6'h18  /* 24 */
`define VGA_REG_ROW_BUS [5:0]
`define VGA_REG_COL_BUS [5:0]
`define VGA_REG_NUM 8'h90  /* 144 */

`define VGA_POS_BUS 9:0

`endif