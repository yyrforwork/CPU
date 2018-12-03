`timescale 1ns / 1ps

`ifdef _JUMP_CONTROL_
`else
`define _JUMP_CONTROL_
`include "define.v"

module Jump_Control(
        input      pc_jump_en,
        output reg clear,
        output reg pause
    );

always @(*) begin
    case(pc_jump_en)
        `PC_JUMP_ENABLE:
            begin
                clear <= `CLEAR_ENABLE;
                pause <= `PAUSE_ENABLE;
            end
        `PC_JUMP_DISABLE:
            begin
                clear <= `CLEAR_DISABLE;
                pause <= `PAUSE_DISABLE;
            end
    endcase
end

endmodule

`endif