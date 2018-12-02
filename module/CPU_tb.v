`timescale 1ns / 1ps

`ifdef _CPU_TB_
`else
`define _CPU_TB_
`include "define.v"

`include "ALU_A_Mux.v"
`include "ALU_B_Mux.v"
`include "ALU.v"
`include "Control.v"
`include "CPU.v"
`include "EXE_MEM.v"
`include "Extender.v"
`include "Forward.v"
`include "ID_EXE.v"
`include "IF_ID.v"
`include "Im_Mux.v"
`include "Jump_Add.v"
`include "Jump_Control.v"
`include "Jump_Data_Mux.v"
`include "Jump_En_Mux.v"
`include "MEM_WB.v"
`include "Pause_Control.v"
`include "PC_Adder.v"
`include "PC_Jump_Mux.v"
`include "PC.v"
`include "RAM_Data_Mux.v"
`include "REG_File.v"
`include "sram.v"
`include "WB_Addr_Mux.v"
`include "WB_Data_Mux.v"
`include "RAM_SIM1.v"
`include "RAM_SIM2.v"

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
    .wr(wr)n
   );

initial begin
    rst = 1'b0;
    clk = 1'b0;
    clk_11MHz = 1'b0;
    clk_50MHz = 1'b0;
    $monitor("%dns monitor: ram1_data=%x, ram1_addr=%x", $stime, ram1_data, ram1_addr);
end

always #10   begin clk_50MHz = ~clk_50MHz; end
always #45   begin clk_11MHz = ~clk_11MHz; end
always #1000 begin clk = ~clk; end

initial #10000 $finish;