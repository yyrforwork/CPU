`timescale 1ns / 1ps

`ifdef _JUMP_ADD_
`else
`define _JUMP_ADD_
`include "define.v"

module Jump_Add(
        input     [`PC_BUS]   old_pc,
        input     [`DATA_BUS] im,
        output reg[`PC_BUS]   new_pc
    );

always @(*) begin
    new_pc <= old_pc + im;
end

endmodule

`endif