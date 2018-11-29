`timescale 1ns / 1ps

`ifdef _JUMP_CONTROL_
`else
`define _JUMP_CONTROL_
`include "define.v"

module Jump_Control(
        input      rst,
        input      pc_jump_en,
        output reg clear
    );

assign clear = (pc_jump_en == `PC_JUMP) ? `CLEAR_ENABLE : `CLEAR_DISABLE;

endmodule

`endif
