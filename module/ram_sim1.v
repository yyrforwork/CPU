`timescale 1ns / 1ps

`ifdef _RAM_SIM1_
`else
`define __RAM_SIM_
`include "define.v"

module RAM_SIM1(
        input  [`PC_BUS] pc,

        output [`INST_BUS] inst
    );

reg [`INST_BUS] insts[0:15] ;
initial begin
    insts[0] = 16'b01101_000_000_00001;  // LI
	insts[1] = 16'b01101_001_000_00010;  // LI
	insts[2] = 16'b01101_010_000_00011;  // LI
    insts[3] = 16'b01001_000_000_00100;  // ADDIU
    insts[4] = 16'b01000_000_011_00110;  // ADDIU3
    insts[5] = 16'b11100_000_001_01001;  // ADDU
    // insts[3] = 16'b
end

assign inst = insts[pc[3:0]];

endmodule

`endif