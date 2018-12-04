`timescale 1ns / 1ps

`ifdef _RAM_
`else
`define _RAM_
`include "define.v"

module ram(
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
        output     [`INST_BUS] inst,

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
// parameter S_EMPTY = 1'b0,
//           S_ENDDO = 1'b1;
assign inst = sram2_data;
assign data_o = (addr<18'h8000) ? sram2_data : sram1_data;
assign sram2_data = (ram2_op == `RAM && op == `RAM_OP_WR ) ? data_i : 16'bz;
assign sram1_data = (addr >18'h7FFF && op == `RAM_OP_WR) ? data_i : 16'bz;

//state machine
always @(*) begin
    if (en == `RAM_ENABLE) begin
        if (addr == 18'hBF01)
        begin
            ram1_en <= `DISABLE;
            ram2_op <= `PC;
            com <= `ENABLE;
            ram_pause <= `PAUSE_DISABLE;
        end
        else
            if (addr < 18'h8000)
            begin
                ram1_en <= `DISABLE;
                ram2_op <= `RAM;
                com <= `DISABLE;
                ram_pause <= `PAUSE_ENABLE;
            end
            else
                begin
                    ram1_en <= `ENABLE;
                    ram2_op <= `PC;
                    com <=`DISABLE; 
                    ram_pause <= `PAUSE_DISABLE;
                end
    end
    else 
        ram1_en <= `DISABLE;
        ram2_op <= `PC;
        com <= `DISABLE;
        ram_pause <= `PAUSE_DISABLE;
    end

//sram1_r&w
always @(*) begin
    if (ram1_en == `ENABLE) begin
        if (op == `RAM_OP_RD)
        begin
            sram1_en <= 1'b0;
            sram1_oe <= 1'b0;
            sram1_we <= 1'b1;
            sram1_addr <= addr;
        end
        else//write
        begin
            sram1_en <= 1'b0;
            sram1_oe <= 1'b1;
            sram1_addr <= addr;
            if (clk_50MHz == 1'b0)
            begin
                sram1_we <= 1'b0;
            end
            else begin
                sram1_we <= 1'b1;
            end
        end
    end
    else 
    begin
        sram1_en <= 1'b1;
        sram1_oe <= 1'b1;
        sram1_we <= 1'b1;
    end
end

//sram2 r&w
always @(*) begin
    if (ram2_op == `PC) 
    begin
        sram2_en <= 1'b0;
        sram2_oe <= 1'b0;
        sram2_we <= 1'b1;
        sram2_addr <= {2'b00, pc};
    end
    else if (ram2_op == `RAM) 
    begin
        if (op == `RAM_OP_RD)
        begin
            sram2_en <= 1'b0;
            sram2_oe <= 1'b0;
            sram2_we <= 1'b1;
            sram2_addr <= addr;
        end
        else
        //if (op == `RAM_OP_WR)
        begin
            sram2_en <= 1'b0;
            sram2_oe <= 1'b1;
            sram2_addr <= addr;
            if (clk_50MHz == 1'b0)
            begin
                sram2_we <= 1'b0;
            end
            else begin
                sram2_we <= 1'b1;
            end
        end
    end
end

//com r&w
always @(*) begin
    if (com == `ENABLE) 
    begin
        if (sram1_en ==1'b1 && sram1_we == 1'b1 && sram1_oe == 1'b1 ) begin
            if (op == `RAM_OP_RD)
            begin
                if (data_ready == 1'b1)
                    rdn <= 1'b0;
                wrn <= 1'b1;
            end
            else
            //if (op == `RAM_OP_WR)
            begin
                rdn <= 1'b1;
                if (clk_50MHz == 1'b0)
                begin
                    wrn <= 1'b0;
                end
                else begin
                    wrn <= 1'b1;
                end
            end
        end
    end
    else begin
        rdn <= 1'b1;
        wrn <= 1'b1;
    end
end

endmodule // sram

`endif