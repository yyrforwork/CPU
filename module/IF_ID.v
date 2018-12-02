`timescale 1ns / 1ps

`ifdef _IF_ID_
`else
`define _IF_ID_
`include "define.v"

module IF_ID(
        input                  rst,
        input                  clk_50MHz,
        input                  ii_PC_pause,
        input                  ii_PC_clear,
        input      [`INST_BUS] ram_out_inst,
        input      [`PC_BUS]   pc_add_value,
        output reg [`INST_BUS] ii_inst,
        output reg [`PC_BUS]   ii_PC
    );

always @(posedge clk_50MHz or negedge rst) begin
    if (~rst) begin
        // reset
        ii_inst <= `INST_ZERO;
    end
    else if (ii_PC_pause == `PAUSE_DISABLE) begin
        if (ii_PC_clear == `CLEAR_ENABLE) begin
            ii_inst <= `INST_ZERO;
        end else begin
            ii_inst <= ram_out_inst;
            ii_PC  <= pc_add_value;
        end
    end
end
    
endmodule

`endif