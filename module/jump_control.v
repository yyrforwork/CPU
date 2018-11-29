`timescale 1ns / 1ps

`ifdef _JUMP_CONTROL_
`else
`define _JUMP_CONTROL_
`include "define.v"

module JUMP_CONTRAL(
        input      rst,
        input      pc_jump_en,
        output reg clear
    );

always @(*) begin
    if (~rst) begin
        clear <= `CLEAR_DISABLE;            
    end
    else if (pc_jump_en == `PC_JUMP) begin
        clear <= `CLEAR_ENABLE;
    end else begin
        clear <= `CLEAR_DISABLE;
    end
end

endmodule
`endif
