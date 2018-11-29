`timescale 1ns / 1ps

`ifdef _JUMP_DATA_MUX_
`else
`define _JUNP_DATA_MUX_
`include "define.v"

module JUMP_DATA_MUX(
        input     [`PC_BUS]        jump_answer,
        input     [`DATA_BUS]      alu_answer,
        input     [`JUMP_DATA_BUS] jump_data_op,
        output reg[`PC_BUS]        jump_addr
    );

always @(*) begin
    case(jump_data_op)
        `JUMP_DATA_ALU:  jump_addr <= alu_answer;
        `JUMP_DATA_JANS: jump_addr <= jump_answer;
        `JUMP_DATA_NOP:  jump_addr <= jump_addr;
    endcase
end

endmodule

`endif