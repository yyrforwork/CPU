`timescale 1ns / 1ps

`ifdef _VGA_
`else
`define _VGA_
`include "define.v"

module vga(
        input                       rst,
        input                       clk_25MHz,
        input      [`VGA_ROW_BUS]   vga_row,
        input      [`VGA_COL_BUS]   vga_col,
        input      [`VGA_DATA_BUS]  vga_data,

        output reg [`VGA_DATA_BUS]  vga_rgb,
        output reg                  vga_row_ctrl,
        output reg                  vga_col_ctrl
    );

    if(vga_row >= 656 && vga_row <= 764) begin
        
    end
    if(vga_col >= 492 && vga_col <= 512) begin

    end
    if ((vga_row < 640) && (vga_col < 480)) begin
        vga_rgb = vga_data;
    end

endmodule // vga

`endif