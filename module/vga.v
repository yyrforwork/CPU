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

always @(posedge clk_25MHz) begin
    if (vga_row < 655 || vga_row > 750)
        vga_row_ctrl = 1'b1;
    else
        vga_row_ctrl = 1'b0;
    
    if (vga_col < 489 || vga_col > 490)
        vga_col_ctrl = 1'b1;
    else
        vga_col_ctrl = 1'b0;

    if (vga_row < 640 && vga_col < 480)
        vga_rgb = vga_data;
    else 
        vga_rgb = 9'b0;
end

endmodule // vga

`endif