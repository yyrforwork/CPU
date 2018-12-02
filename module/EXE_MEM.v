`timescale 1ns / 1ps

`ifdef _EXE_MEM_
`else
`define _EXE_MEM_
`include "define.v"

module EXE_MEM(
        input      rst,
        input      clk_50MHz,

        input                       n_em_RAM_en,
        input                       n_em_RAM_op,
        input     [`WB_DATA_OP_BUS] n_em_WB_DATA_op,
        input     [`REG_OP_BUS]     n_em_REG_op,

        input     [`DATA_BUS]       n_em_IH,
        input     [`DATA_BUS]       n_em_PC,
        input     [`DATA_BUS]       n_em_ALU_data,
        input     [`DATA_BUS]       n_em_RAM_WB_data,
        input     [`REG_ADDR_BUS]   n_em_WB_addr,

        output reg                  em_RAM_en,
        output reg                  em_RAM_op,
        output reg[`WB_DATA_OP_BUS] em_WB_DATA_op,
        output reg[`REG_OP_BUS]     em_REG_op,
        
        output reg[`DATA_BUS]       em_IH,
        output reg[`DATA_BUS]       em_PC,
        output reg[`DATA_BUS]       em_ALU_data,
        output reg[`DATA_BUS]       em_RAM_WB_data,
        output reg[`REG_ADDR_BUS]   em_WB_addr
    );

always @(posedge clk_50MHz or negedge rst) begin
    if (~rst) begin
        em_RAM_en      <= `RAM_DISABLE;
        em_RAM_op      <= `RAM_OP_RD;
        em_WB_DATA_op  <= `WB_DATA_OP_NOP;
        em_REG_op      <= `REG_OP_NOP;        
    end
    else begin
        em_RAM_en      <= n_em_RAM_en;
        em_RAM_op      <= n_em_RAM_op;
        em_WB_DATA_op  <= n_em_WB_DATA_op;
        em_REG_op      <= n_em_REG_op;

        em_IH          <= n_em_IH;
        em_PC          <= n_em_PC;
        em_ALU_data    <= n_em_ALU_data;
        em_RAM_WB_data <= n_em_RAM_WB_data;
        em_WB_addr     <= n_em_WB_addr;
    end
end

endmodule

`endif