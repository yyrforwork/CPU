`timescale 1ns / 1ps

`ifdef _CPU_
`else
`define _CPU_
`include "define.v"
`include "sram.v"

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// CPU
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

module CPU(
    input rst,
    input clk,
    input clk_50MHz,
    input clk_11MHz,

    // RAM1
    inout  [`DATA_BUS] ram1_data,
    output [`ADDR_BUS] ram1_addr,
    output ram1_en,
    output ram1_oe,
    output ram1_we,

    // RAM2
    inout  [`DATA_BUS] ram2_data,
    output [`ADDR_BUS] ram2_addr,
    output ram2_en,
    output ram2_oe,
    output ram2_we,

    // UART
    input  tsre,
    input  tbre,
    input  data_ready,
    output rdn,
    output wrn,

    // Other
   );

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// clk_25MHz
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

reg clk_25MHz;
always @ (posedge clk_50MHz, negedge rst)
begin
  if (!rst)
    clk_25MHz = 0;
  else
    clk_25MHz = ~ clk_25MHz;
end

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// RAM1
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

// ram1 declaration
wire[`DATA_BUS] ram1_ctl_data_o;
reg [`DATA_BUS] ram1_ctl_data_i;
reg [`ADDR_BUS] ram1_ctl_addr;
reg ram1_ctl_op;
reg ram1_ctl_en;

// ram1 combination
sram ram1(
        .rst(rst),
        .clk_50MHz(clk_50MHz),

        .sram_data(ram1_data),
        .sram_addr(ram1_addr),
        .sram_en(ram1_en),
        .sram_oe(ram1_oe),
        .sram_we(ram1_we),

        .data_o(ram1_ctl_data_o),
        .data_i(ram1_ctl_data_i),
        .addr(ram1_ctl_addr),
        .op(ram1_ctl_op),
        .en(ram1_ctl_en)
    );

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// RAM2
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

// ram2 declaration
wire[`DATA_BUS] ram2_ctl_data_o;
reg [`DATA_BUS] ram2_ctl_data_i;
reg [`ADDR_BUS] ram2_ctl_addr;
reg ram2_ctl_op;
reg ram2_ctl_en;

// ram2 combination
sram ram2(
        .rst(rst),
        .clk_50MHz(clk_50MHz),

        .sram_data(ram2_data),
        .sram_addr(ram2_addr),
        .sram_en(ram2_en),
        .sram_oe(ram2_oe),
        .sram_we(ram2_we),

        .data_o(ram2_ctl_data_o),
        .data_i(ram2_ctl_data_i),
        .addr(ram2_ctl_addr),
        .op(ram2_ctl_op),
        .en(ram2_ctl_en)
    );
endmodule

`endif