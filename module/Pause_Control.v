`timescale 1ns / 1ps

`ifdef _PAUSE_CONTROL_
`else
`define _PAUSE_CONTROL_
`include "define.v"

module Pause_Control(
    input wire [`REG_OP_BUS]   reg_op,
    input wire [`REG_ADDR_BUS] wb_addr,
    input wire [`REG_ADDR_BUS] reg1_addr,
    input wire [`REG_ADDR_BUS] reg2_addr,
    output reg PC_pause,
    output reg if_id_pause,
    output reg id_exe_pause
    );

always @(*) begin
    if(reg_op==`REG_OP_REG && ((wb_addr==reg1_addr)||(wb_addr==reg2_addr))) begin
        PC_pause <= `PAUSE_ENABLE;
        if_id_pause <= `PAUSE_ENABLE;
        id_exe_pause <= `PAUSE_ENABLE;
    end else begin
        PC_pause <= `PAUSE_DISABLE;
        if_id_pause <= `PAUSE_DISABLE;
        id_exe_pause <= `PAUSE_DISABLE;
    end
end

endmodule

`endif