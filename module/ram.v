`timescale 1ns / 1ps

`ifdef _RAM_
`else
`define _RAM_
`include "define.v"

module ram(
        input                  rst,      // reset signal
        input                  clk_50MHz,// system clock 50 MHz
        input                  clk_25MHz,

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

        output reg [9:0]       vga_row,
        output reg [9:0]       vga_col,
        output reg [8:0]       vga_data,

        output reg             rdn,
        output reg             wrn,
        output reg             ram_pause
    );

reg state;
reg com;
reg ram1_en;
reg ram2_op;
reg sram1_r_data;

reg [31:0] sram1_data_buffer;
reg[`ADDR_BUS] vga_addr;
reg vga_enable;
reg[31:0] vga_buffer;
reg[7:0] vga_end;

// parameter S_EMPTY = 1'b0,
//           S_ENDDO = 1'b1;
assign inst = (ram2_op == `PC)? sram2_data : `INST_ZERO;
assign data_o = (addr<18'h8000) ? sram2_data : sram1_r_data;
assign sram2_data = (ram2_op == `RAM && op == `RAM_OP_WR ) ? data_i : 16'bz;
assign sram1_data = (clk_25MHz == 1'b0 && clk_50MHz == 1'b0) ? 16'bz :((addr == 18'hBF01) ? {14'b0, data_ready, (tsre && tbre)}: ((addr >18'h7FFF && (op == `RAM_OP_WR)) ? data_i : 16'bz));
// always @(*) begin
//     if (addr == 18'hBF01) begin
//         sram1_data <= {14'b0, data_ready, (tsre && tbre)};
//     end
//     else if (addr >18'h7FFF && op == `RAM_OP_WR) begin
//         sram1_data <= data_i;
//     end else begin
//         sram1_data <= 18'hz;
//     end
// end

always @(negedge clk_25MHz) begin
    sram1_r_data = sram1_data; 
end


// always @(*) begin
//     if (sram1_addr == vga_addr) begin
//         sram1_data_buffer = sram1_data;
//     end
// end

//state machine
always @(*) begin
    if (en == `RAM_ENABLE && addr == 18'hBF00) begin
        ram1_en = `DISABLE;
        ram2_op = `PC;
        com = `ENABLE;
        ram_pause = `PAUSE_DISABLE;
    end
    else if (en == `RAM_ENABLE && addr < 18'h8000) begin
        ram1_en = `DISABLE;
        ram2_op = `RAM;
        com = `DISABLE;
        ram_pause = `PAUSE_ENABLE;
    end
    else if(en == `RAM_ENABLE ) begin
        ram1_en = `ENABLE;
        ram2_op = `PC;
        com =`DISABLE; 
        ram_pause = `PAUSE_DISABLE;
    end
    else begin 
        ram1_en = `DISABLE;
        ram2_op = `PC;
        com = `DISABLE;
        ram_pause = `PAUSE_DISABLE;
    end
end
//sram1_r&w
always @(*) begin

    if (ram1_en == `ENABLE) begin
        if (op == `RAM_OP_RD)
        begin
            sram1_en = 1'b0;
            sram1_oe = 1'b0;
            sram1_we = 1'b1;
            if (clk_25MHz == 1'b1 )
                sram1_addr = vga_addr;
            else begin
                sram1_addr = addr;
            end
        end
        else//write
        begin
            sram1_en = 1'b0;
            if (clk_25MHz == 1'b1 && clk_50MHz ==1'b1)
            begin
                sram1_oe = 1'b1;
                sram1_addr = addr;
                sram1_we = 1'b0;
            end
            else begin
                sram1_oe = 1'b0;
                sram1_we = 1'b1;
                sram1_addr = vga_addr;
            end
        end
    end
    else 
    begin
        if (clk_25MHz == 1'b1)begin
            sram1_en = 1'b0;
            sram1_oe = 1'b0;
            sram1_we = 1'b1;
            sram1_addr = vga_addr;
        end else begin
            sram1_en = 1'b1;
            sram1_oe = 1'b1;
            sram1_we = 1'b1;
        end
    end


    
end

//sram2 r&w
always @(*) begin
    if (ram2_op == `PC) 
    begin
        sram2_en = 1'b0;
        sram2_oe = 1'b0;
        sram2_we = 1'b1;
        sram2_addr = {2'b00, pc};
    end
    else if (ram2_op == `RAM) 
    begin
        if (op == `RAM_OP_RD)
        begin
            sram2_en = 1'b0;
            sram2_oe = 1'b0;
            sram2_we = 1'b1;
            sram2_addr = addr;
        end
        else
        //if (op == `RAM_OP_WR)
        begin
            sram2_en = 1'b0;
            sram2_oe = 1'b1;
            sram2_addr = addr;
            if (clk_25MHz == 1'b0)
            begin
                sram2_we = 1'b1;
            end
            else begin
                sram2_we = 1'b0;
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
                    rdn = 1'b0;
                wrn = 1'b1;
            end
            else
            //if (op == `RAM_OP_WR)
            begin
                rdn = 1'b1;
                if (clk_25MHz == 1'b0)
                begin
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

always @(posedge clk_25MHz or negedge rst) begin
    if (~rst) begin
        vga_addr = 18'hC000;
        vga_buffer = 32'b0;
        vga_end = 31;
        vga_row = 0;
        vga_col = 0;
        vga_enable = `ENABLE;
        vga_data = 9'b0;
    end else begin
        if (vga_enable == `ENABLE) begin
            if (vga_end > 15) begin
                if (vga_end == 31) begin
                    vga_buffer = sram1_data_buffer << 16;
                    vga_end = 16;
                end else 
                begin
                    vga_buffer = vga_buffer & (sram1_data_buffer << (vga_end-16));//
                    vga_addr = vga_addr + 1;
                    vga_end = vga_end - 16;
                end
            end
            vga_data = vga_buffer[31:23];
            vga_buffer = vga_buffer << 9;
            vga_end = vga_end + 9;    
        end else vga_data =9'b0;

        begin
            vga_row  = vga_row + 1;
            if (vga_row > 799) begin
                vga_row = 0;
                vga_col = vga_col + 1;
            end
            if (vga_col > 524) begin
                vga_addr = 18'hC000;
                vga_buffer = 32'b0;
                vga_end = 31;
                vga_row = 0;
                vga_col = 0;
                vga_enable = `ENABLE;
                vga_data = 9'b0;
            end 
            begin
                if ((vga_row < 160) && (vga_col < 120)) begin
                    //vga_addr = vga_addr + 1;
                    vga_enable = `ENABLE;
                end
                else begin
                    vga_enable = `DISABLE;
                end
            end
        end
    end
end

endmodule // sram

`endif