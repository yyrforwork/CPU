`timescale 1ns / 1ps

`ifdef _JUMP_CONTROL_
`else
`define _JUMP_CONTROL_
`include "define.v"

module Jump_Control(
        input      pc_jump_en,
        output reg clear
    );

assign clear = (pc_jump_en == `PC_JUMP) ? `CLEAR_ENABLE : `CLEAR_DISABLE;

always @(*) begin
    case(pc_jump_en)
        `PC_JUMP_ENABLE:  clear <= `CLEAR_ENABLE;
        `PC_JUMP_DISABLE: clear <= `CLEAR_DISABLE;
    endcase
end

endmodule

`endif
