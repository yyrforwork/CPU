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
    insts[2] = 16'b01101_010_000_00011; // LI R3 3
    insts[3] = 16'b01101_011_000_00000; // LI R4 0
    insts[4] = 16'b10011_000_000_00011; // LW R1 3
    insts[5] = 16'b11011_011_000_00000; // SW R4 R1 0
end

assign inst = insts[pc[3:0]];

endmodule

`endif