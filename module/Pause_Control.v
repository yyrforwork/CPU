`timescale 1ns / 1ps

`ifdef _PAUSE_CONTROL_
`else
`define _PAUSE_CONTROL_
`include "define.v"

module Pause_Control(
        input      [`REG_OP_BUS]     reg_op,
        input      [`REG_ADDR_BUS]   wb_addr,
        input      [`WB_DATA_OP_BUS] wb_data_op,
        input      [`REG_ADDR_BUS]   REGA_addr,
        input      [`REG_ADDR_BUS]   REGB_addr,
        input      [`ALU_A_OP_BUS]   ALU_A_op,
        input      [`ALU_B_OP_BUS]   ALU_B_op,

        input                        ram_pause,
        output reg                   PC_pause,
        output reg                   ii_pause,
        output reg                   ie_pause
    );

always @(*) begin
    if(reg_op==`REG_OP_REG && wb_data_op==`WB_DATA_OP_MEM
                           && (  (wb_addr==REGA_addr && ALU_A_op==`ALU_A_OP_REGA)
                               ||(wb_addr==REGB_addr && ALU_B_op==`ALU_B_OP_REGB) ) ) begin
        PC_pause <= `PAUSE_ENABLE;
        ii_pause <= `PAUSE_ENABLE;
        ie_pause <= `PAUSE_ENABLE;
    end else begin
        PC_pause <= `PAUSE_DISABLE | ram_pause;
        ii_pause <= `PAUSE_DISABLE | ram_pause;
        ie_pause <= `PAUSE_DISABLE;
    end
end

endmodule

`endif