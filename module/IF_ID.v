`timescale 1ns / 1ps

`ifdef _IF_ID_
`else
`define _IF_ID_
`include "define.v"

module IF_ID(
        input                  rst,
        input                  clk_50MHz,
        input                  pc_pause,
        input                  pc_clear,
        input      [`INST_BUS] ram_out_inst,
        input      [`PC_BUS]   pc_add_value,
        output reg [`PC_BUS]   ii_PC,
        output reg [`INST_BUS] ii_inst
    );

always @(posedge clk_50MHz or negedge rst) begin
    if (~rst) begin
        // reset
        ii_inst <= `INST_ZERO;
    end
    else if (pc_pause == `PAUSE_DISABLE) begin
        if (pc_clear == `CLEAR_ENABLE) begin
            ii_inst <= `INST_ZERO;
        end else begin
            ii_inst <= ram_out_inst;
            ii_PC  <= pc_add_value;
        end
    end
end
    
endmodule

`endif