`timescale 1ns / 1ps

`ifdef _RAM_SIM_
`else
`define __RAM_SIM_
`include "define.v"

module RAM_SIM(
        input                  rst,      // reset signal
        input                  clk_50MHz,// system clock 50 MHz

        inout      [`DATA_BUS] sram1_data,// sram data
        output reg [`ADDR_BUS] sram1_addr,// sram address
        output reg             sram1_en,  // sram chip enable [CE]
        output reg             sram1_oe,  // sram output enable [OE]
        output reg             sram1_we,  // sram write enable [WE]
       
        inout      [`DATA_BUS] sram2_data,// sram data
        output reg [`ADDR_BUS] sram2_addr,// sram address
        output reg             sram2_en,  // sram chip enable [CE]
        output reg             sram2_oe,  // sram output enable [OE]
        output reg             sram2_we,  // sram write enable [WE]
        
        output     [`DATA_BUS] data_o,   // data out
        input      [`DATA_BUS] data_i,   // data in
        input      [`ADDR_BUS] addr,     // address in
        input                  op,       // operation
        input                  en,       // enable

        input      [`PC_BUS]   pc,
        output reg [`INST_BUS] inst,

        input                  tsre,
        input                  tbre,
        input                  data_ready,

        output reg             rdn,
        output reg             wrn,
        output reg             ram_pause
    );

reg state;
reg com;
reg ram1_en;
reg ram2_op;

wire [`INST_BUS] inst_pc;
wire [`INST_BUS] inst_addr;
reg  [1:0] test;

reg [`DATA_BUS] data[0:262143];  // ram1 data
reg [`INST_BUS] insts[0:262143]; // ram2 data

initial begin
    insts[0] = 16'b01101_001_010_10101; // LI R1 55
    insts[1] = 16'b01101_101_111_11111; // LI R5 FF
    insts[2] = 16'b00110_101_101_00000; // SLL R5 R5 0
    insts[3] = 16'b01001_101_100_00010; // ADDIU R5 82
    insts[4] = 16'b01101_100_011_00000; // LI R4 60
    insts[5] = 16'b11100_001_001_01001; // ADDU R1 R1 R2
    insts[6] = 16'b11100_010_001_01101; // ADDU R2 R1 R3
    insts[7] = 16'b11100_011_010_01011; // SUBU R3 R2 R2
    insts[8] = 16'b11101_001_010_01010; // CMP R1 R2
    insts[9] = 16'b11100_010_011_01001; // ADDU R2 R3 R2
    insts[10]= 16'b00100_100_000_00011; // BEQZ R4 3
    insts[11]= 16'b01001_100_000_00001; // ADDIU R4 1
    insts[12]= 16'b01100_000_111_11000; // BTEQZ F8
    insts[13]= 16'b00001_000_000_00000; // NOP
    insts[14]= 16'b01001_101_000_00001; // ADDIU R5 1
    insts[15]= 16'b00101_101_111_10100; // BNEZ R5 F4
    insts[16]= 16'b00001_000_000_00000; // NOP
    insts[17]= 16'b11101_111_000_00000; // JR R7
    insts[18]= 16'b00001_000_000_00000; // NOP
end

always @(*) begin
    inst <= sram2_data;
end

// assign inst = sram2_data;
assign data_o = (addr<18'h08000) ? sram2_data : sram1_data;
assign sram2_data = ram2_op==`PC ? insts[pc] : insts[addr];
assign sram1_data = data[addr];
assign inst_pc = insts[pc];
assign inst_addr = insts[addr];

always @(*) begin
    if (en == `RAM_ENABLE && addr == 18'hBF01) begin
        ram1_en = `DISABLE;
        ram2_op = `PC;
        com = `ENABLE;
        ram_pause = `PAUSE_DISABLE;
    end
    else if (en == `RAM_ENABLE && addr < 18'h08000) begin
        ram1_en = `DISABLE;
        ram2_op = `RAM;
        com = `DISABLE;
        ram_pause = `PAUSE_ENABLE;
        test = 1;
    end
    else if (en == `RAM_ENABLE) begin
        ram1_en = `ENABLE;
        ram2_op = `PC;
        com =`DISABLE; 
        ram_pause = `PAUSE_DISABLE;
        test = 2;
    end
    else begin
        ram1_en = `DISABLE;
        ram2_op = `PC;
        com = `DISABLE;
        ram_pause = `PAUSE_DISABLE;
        test = 3;
    end
end

//sram1_r&w
always @(*) begin
    if (ram1_en == `ENABLE && op == `RAM_OP_RD) begin
        sram1_en = 1'b0;
        sram1_oe = 1'b0;
        sram1_we = 1'b1;
        sram1_addr = addr;
    end
    else if(ram1_en == `ENABLE) begin //write
        sram1_en = 1'b0;
        sram1_oe = 1'b1;
        sram1_addr = addr;
        if (clk_50MHz == 1'b0) begin
            sram1_we = 1'b1;
        end
        else begin
            sram1_we = 1'b0;
            data[addr] = data_i;
        end
    end
    else begin
        sram1_en = 1'b1;
        sram1_oe = 1'b1;
        sram1_we = 1'b1;
    end
end

//sram2 r&w
always @(*) begin
    if (ram2_op == `PC) begin
        sram2_en = 1'b0;
        sram2_oe = 1'b0;
        sram2_we = 1'b1;
        sram2_addr = {2'b00, pc};
    end
    else if (ram2_op == `RAM && op == `RAM_OP_RD)  begin
        sram2_en = 1'b0;
        sram2_oe = 1'b0;
        sram2_we = 1'b1;
        sram2_addr = addr;
    end
    else if(ram2_op == `RAM) begin
        sram2_en = 1'b0;
        sram2_oe = 1'b1;
        sram2_addr = addr;
        if (clk_50MHz == 1'b0) begin
            sram2_we = 1'b1;
        end
        else begin
            sram2_we = 1'b0;
            insts[addr] = data_i;
        end
    end
end

//com r&w
always @(*) begin
    if (com == `ENABLE) begin
        if (sram1_en ==1'b1 && sram1_we == 1'b1 && sram1_oe == 1'b1 ) begin
            if (op == `RAM_OP_RD) begin
                if (data_ready == 1'b1)
                    rdn = 1'b0;
                wrn = 1'b1;
            end
            else begin //if (op == `RAM_OP_WR)
                rdn = 1'b1;
                if (clk_50MHz == 1'b0) begin
                    wrn = 1'b0;
                end
                else begin
                    wrn = 1'b1;
                end
            end
        end
    end
    else begin
        rdn = 1'b1;
        wrn = 1'b1;
    end
end

endmodule

`endif