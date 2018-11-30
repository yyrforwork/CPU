`timescale 1ns / 1ps

`ifdef _PC_
`else
`define _PC
`include "define.v"

module PC(
    input               rst,
    input               clk_50Mhz,
    input               PC_pause,
    input     [`PC_BUS] PC_in,
    output reg[`PC_BUS] PC_out
    );

always @(posedge clk_50Mhz or negedge rst) begin
    if(~rst) begin
        PC_out <= `FIRST_PC;
    end else begin
        if (PC_pause != `PAUSE_ENABLE) begin
            PC_out <= PC_in;
        end
    end
end

endmodule

`endif