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
    insts[0] = 16'b01101_000_000_00001; // LI R1 1
    insts[1] = 16'b01101_001_000_00010; // LI R2 2
    insts[2] = 16'b01101_010_000_00001; // LI R3 1
    insts[3] = 16'b11101_000_001_01010; // CMP R1 R2
    insts[4] = 16'b01100_000_111_11101; // BTEQZ FD
    insts[5] = 16'b11101_000_010_01010; // CMP R1 R3
    insts[6] = 16'b01100_000_000_00011; // BTEQZ 03
    insts[7] = 16'b00001_000_000_00000; // NOP
    insts[8] = 16'b00001_000_000_00000; // NOP
    insts[9] = 16'b00001_000_000_00000; // NOP
    insts[10]= 16'b01110_000_000_00001; // CMPI R1 1
    insts[11]= 16'b01100_000_111_11101; // BTEQZ FD
    insts[12]= 16'b00010_111_111_11111; // B FF
end

assign inst = insts[pc[3:0]];

endmodule

`endif