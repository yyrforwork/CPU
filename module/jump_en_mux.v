`timescale 1ns / 1ps

`ifdef _JUMP_EN_MUX_
`else
`define _JUMP_EN_MUX_
`include "define.v"

module Jump_En_Mux(
        input                       zero,    // equal zero when alu_A == 0
        input     [`JUMP_EN_OP_BUS] jump_en_op,
        output reg                  jump_en
    );

always @(*) begin
    case(jump_en_op)
        `JUMP_EN_OP_EN:     jump_en <= `PC_JUMP_ENABLE;
        `JUMP_EN_OP_ZEROJ:  jump_en <= zero;
        `JUMP_EN_OP_NZEROJ: jump_en <= ~zero;
        `JUMP_EN_OP_NOP:    jump_en <= jump_en;
    endcase
end

endmodule
`endif