`timescale 1ns / 1ps

`ifdef _PAUSE_CONTROL_
`else
`define _PAUSE_CONTROL_
`include "define.v"

module RAW_R(
    input wire [`WB_] wb_op,
    input wire [`REG_ADDR_BUS] wb_addr,
    input wire [`REG_ADDR_BUS] reg1_addr,
    input wire [`REG_ADDR_BUS] reg2_addr,
    output reg PC_pause,
    output reg if_id_pause,
    output reg id_exe_pause
    );

always @(*) begin
    if (wb_op==`WB_REGS) begin //regfiles op 为写通用寄存器
        if((reg1_addr == wb_addr)||(reg2_addr == wb_addr)) 
        begin
            PC_pause == `PAUSE_ENABLE;
            if_id_pause == `PAUSE_ENABLE;
            id_exe_pause == `PAUSE_ENABLE;  
        end

        else begin
            PC_pause == `PAUSE_DISABLE;
            if_id_pause == `PAUSE_DISABLE;
            id_exe_pause == `PAUSE_DISABLE;
        end
    end else begin
        PC_pause == `PAUSE_DISABLE;
        if_id_pause == `PAUSE_DISABLE;
        id_exe_pause == `PAUSE_DISABLE;
    end
end

endmodule
`endif

`define PAUSE_ENABLE 1'b1;
`define PAUSE_ENABLE 1'b0;
