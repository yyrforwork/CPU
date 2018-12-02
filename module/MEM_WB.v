`timescale 1ns / 1ps

`ifdef _MEM_WB_
`else
`define _MEM_WB_
`include "define.v"

module MEM_WB(
        input                        rst,
        input                        clk_50MHz,

        input     [`WB_DATA_OP_BUS]  n_mw_WB_data_op,
        input     [`REG_OP_BUS]      n_mw_REG_op,

        input     [`DATA_BUS]        n_mw_IH,
        input     [`DATA_BUS]        n_mw_PC,
        input     [`DATA_BUS]        n_mw_ALU_data,
        input     [`DATA_BUS]        n_mw_RAM_data,
        input     [`REG_ADDR_BUS]    n_mw_WB_addr,

        output reg[`WB_DATA_OP_BUS]  mw_WB_data_op,
        output reg[`REG_OP_BUS]      mw_REG_op,

        output reg[`DATA_BUS]        mw_IH,
        output reg[`DATA_BUS]        mw_PC,
        output reg[`DATA_BUS]        mw_ALU_data,
        output reg[`DATA_BUS]        mw_RAM_data,
        output reg[`REG_ADDR_BUS]    mw_WB_addr
    );

always @(posedge clk_50MHz or negedge rst) begin
    if (~rst) begin
        mw_WB_data_op <= `WB_DATA_OP_NOP;
        mw_REG_op     <= `REG_OP_NOP;
    end
    else begin
        mw_WB_data_op <= n_mw_WB_data_op;
        mw_REG_op     <= n_mw_REG_op;

        mw_IH         <= n_mw_IH;
        mw_PC         <= n_mw_PC;
        mw_ALU_data   <= n_mw_ALU_data;
        mw_RAM_data   <= n_mw_RAM_data;
        mw_WB_addr    <= n_mw_WB_addr;
    end
end

endmodule

`endif