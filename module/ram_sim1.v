`timescale 1ns / 1ps

`ifdef _RAM_SIM1_
`else
`define __RAM_SIM_
`include "define.v"

module RAM_SIM1(
        input  [`PC_BUS] pc,

        output [`INST_BUS] inst
    );

reg [`INST_BUS] insts[0:15];

initial begin
    insts[0] = 16'b01101_001_000_00001; // LI R1 1
    insts[1] = 16'b01101_010_000_00001; // LI R2 1
    insts[2] = 16'b01101_011_100_00000; // LI R3 80
    insts[3] = 16'b00110_011_011_00000; // SLL R3 R3 0
    insts[4] = 16'b01101_100_000_01001; // LI R4 9
    insts[5] = 16'b11011_011_001_00000; // SW R3 R1 0
    insts[6] = 16'b11011_011_010_00001; // SW R3 R2 1
    insts[7] = 16'b11100_001_010_00101; // ADDU R1 R2 R1
    insts[8] = 16'b11100_001_010_01001; // ADDU R1 R2 R2
    insts[9] = 16'b01001_011_000_00010; // ADDIU R3 2
    insts[10]= 16'b01001_100_111_11111; // ADDIU R4 FF
    insts[11]= 16'b00101_100_111_11010; // BNEZ R4 F9
    insts[12]= 16'b00001_000_000_00000; // NOP
end

assign inst = insts[pc[3:0]];

endmodule

`endif