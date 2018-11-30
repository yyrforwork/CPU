`timescale 1ns / 1ps

`ifdef _PC_JUMP_MUX_
`else
`define _PC_JUMP_MUX_
`include "define.v"

module PC_Jump_Mux(
        input               PC_jump_op,
        input     [`PC_BUS] PC_jump,
        input     [`PC_BUS] PC_add,
        output reg[`PC_BUS] PC_new
    );

always @(*) begin
    case(PC_jump_op)
        `PC_JUMP_ENABLE:  PC_new <= PC_jump;
        `PC_JUMP_DISABLE: PC_new <= PC_add;
    endcase
end

endmodule

`endif