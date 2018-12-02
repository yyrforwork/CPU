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
    insts[0] = 16'b1101_1111_0001_0101;
end

assign address = pc[3:0];

assign inst = insts[address];

endmodule

`endif