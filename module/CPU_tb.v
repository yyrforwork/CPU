`timescale 1ns / 1ps

`ifdef _CPU_TB_
`else
`define _CPU_TB_
`include "define.v"

`include "CPU.v"

module main;
reg rst;
reg clk;
reg clk_50MHz;
reg clk_11MHz;
wire[`DATA_BUS] ram1_data;
wire[`ADDR_BUS] ram1_addr;
wire ram1_en, ram1_oe, ram1_we;
wire[`DATA_BUS] ram2_data;
wire[`ADDR_BUS] ram2_addr;
wire ram2_en, ram2_oe, ram2_we;
reg tsre, tbre, data_ready;
wire rdn, wrn;

CPU cpu_v1(
    .rst(rst),
    .clk(clk),
    .clk_50MHz(clk_50MHz),
    .clk_11MHz(clk_11MHz),

    // RAM1
    .ram1_data(ram1_data),
    .ram1_addr(ram1_addr),
    .ram1_en(ram1_en),
    .ram1_oe(ram1_oe),
    .ram1_we(ram1_we),

    // RAM2
    .ram2_data(ram2_data),
    .ram2_addr(ram2_addr),
    .ram2_en(ram2_en),
    .ram2_oe(ram2_oe),
    .ram2_we(ram2_we),

    // UART
    .tsre(tsre),
    .tbre(tbre),
    .data_ready(data_ready),
    .rdn(rdn),
    .wrn(wrn)
   );

initial begin
    rst = 1'b1;
    clk = 1'b1;
    clk_11MHz = 1'b0;
    clk_50MHz = 1'b0;
	 #10 rst = ~rst;
	 #10 rst = ~rst;
end

always #10   begin clk_50MHz = ~clk_50MHz; end
always #45   begin clk_11MHz = ~clk_11MHz; end
always #1000 begin clk = ~clk; end

initial #2000 $finish;

endmodule

`endif