`timescale 1ns / 1ps

`ifdef _REG_FILE_
`else
`define _REG_FILE_
`include "define.v"

module REG_File(
        input rst,
        input clk_50MHz,

        input  [`REG_ADDR_BUS] A_addr,
        input  [`REG_ADDR_BUS] B_addr,

        input  [`REG_ADDR_BUS] wb_addr,
        input  [`DATA_BUS]     wb_data,
        input  [`REG_OP_BUS]   reg_op,

        output [`DATA_BUS]     A_data,
        output [`DATA_BUS]     B_data,
        output [`DATA_BUS]     T_data,
        output [`DATA_BUS]     SP_data,
        output [`DATA_BUS]     IH_data,
        output [`DATA_BUS]     RA_data
    );

reg [`DATA_BUS] reg_T;
reg [`DATA_BUS] reg_SP;
reg [`DATA_BUS] reg_IH;
reg [`DATA_BUS] reg_RA;
reg [`DATA_BUS] regs[`REG_ADDR_NUM-1:0];

assign  T_data = reg_T;
assign SP_data = reg_SP;
assign IH_data = reg_IH;
assign RA_data = reg_RA;

assign A_data = regs[A_addr];
assign B_data = regs[B_addr];

always @(posedge clk_50MHz or negedge rst)
begin
    if(~rst) begin
         reg_T <= `DATA_ZERO;
         reg_SP <= `DATA_ZERO;
         reg_IH <= `DATA_ZERO;
         reg_RA <= `DATA_ZERO;
         regs[0]<= `DATA_ZERO;
         regs[1]<= `DATA_ZERO;
         regs[2]<= `DATA_ZERO;
         regs[3]<= `DATA_ZERO;
         regs[4]<= `DATA_ZERO;
         regs[5]<= `DATA_ZERO;
         regs[6]<= `DATA_ZERO;
         regs[7]<= `DATA_ZERO;
    end else begin
        case(reg_op)
            `REG_OP_T:   reg_T  <= wb_data;
            `REG_OP_SP:  reg_SP <= wb_data;
            `REG_OP_IH:  reg_IH <= wb_data;
            `REG_OP_RA:  reg_RA <= wb_data;
            `REG_OP_REG: regs[wb_addr] <= wb_data;
            `REG_OP_NOP: ;
        endcase
    end
end

endmodule

`endif