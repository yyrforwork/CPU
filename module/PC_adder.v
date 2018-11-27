`timescale 1ns / 1ps

`ifdef _PC_ADDER_
`else
`define _PC_ADDER_
`include "define.v"

module PC_Adder(
        input wire[`PC_BUS] old_pc,
        output reg[`PC_BUS] new_pc
    );

always @(*)begin
    new_pc <= old_pc + 1'b1;
end

endmodule

`endif