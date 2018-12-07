`timescale 1ns / 1ps

`ifdef _RAM_
`else
`define _RAM_
`include "define.v"

module ram(
        input                  rst,      // reset signal
        input                  clk_50MHz,// system clock 50 MHz
        input                  clk_25MHz,// system clock 25 MHz

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

        output reg [`VGA_ROW_BUS]  vga_row,
        output reg [`VGA_COL_BUS]  vga_col,
        output reg [`VGA_DATA_BUS] vga_data,

        output reg             rdn,
        output reg             wrn,
        output reg             ram_pause
    );

reg state;
reg com;
reg ram1_en;
reg ram2_op;

reg[`ADDR_BUS] vga_addr;
reg[`DATA_BUS] vga_data_reg[0:`VGA_REG_NUM-1];

assign inst = (ram2_op == `PC)? sram2_data : `INST_ZERO;
assign data_o = (addr<18'h8000) ? sram2_data : sram1_data;
assign sram2_data = (ram2_op == `RAM && op == `RAM_OP_WR ) ? data_i : 16'bz;
assign sram1_data = (addr == 18'hBF01) ? {14'b0, data_ready, (tsre && tbre)}: ((addr >18'h7FFF && (op == `RAM_OP_WR)) ? data_i : 16'hz);

always @(*) begin
    if (en == `RAM_ENABLE && addr == 18'hBF00) begin
        ram1_en <= `DISABLE;
        ram2_op <= `PC;
        com <= `ENABLE;
        ram_pause <= `PAUSE_DISABLE;
    end
    else if (en == `RAM_ENABLE && addr < 18'h8000) begin
        ram1_en <= `DISABLE;
        ram2_op <= `RAM;
        com <= `DISABLE;
        ram_pause <= `PAUSE_ENABLE;
    end
    else if(en == `RAM_ENABLE) begin
        ram1_en <= `ENABLE;
        ram2_op <= `PC;
        com <=`DISABLE; 
        ram_pause <= `PAUSE_DISABLE;
    end
    else begin
        ram1_en <= `DISABLE;
        ram2_op <= `PC;
        com <= `DISABLE;
        ram_pause <= `PAUSE_DISABLE;
    end
end

//sram1_r&w
always @(*) begin
    if (ram1_en == `ENABLE) begin
        if (op == `RAM_OP_RD) begin
            sram1_en <= 1'b0;
            sram1_oe <= 1'b0;
            sram1_we <= 1'b1;
            sram1_addr <= addr;
        end
        else begin
            sram1_en <= 1'b0;
            sram1_oe <= 1'b1;
            sram1_addr <= addr;
            if (clk_50MHz == 1'b1)
                sram1_we <= 1'b0;
            else 
                sram1_we <= 1'b1;
        end
    end
    else begin
        sram1_en <= 1'b1;
        sram1_oe <= 1'b1;
        sram1_we <= 1'b1;
    end
end

//sram2 r&w
always @(*) begin
    if (ram2_op == `PC) begin
        sram2_en <= 1'b0;
        sram2_oe <= 1'b0;
        sram2_we <= 1'b1;
        sram2_addr <= {2'b00, pc};
    end
    else if (ram2_op == `RAM) begin
        if (op == `RAM_OP_RD) begin
            sram2_en <= 1'b0;
            sram2_oe <= 1'b0;
            sram2_we <= 1'b1;
            sram2_addr <= addr;
        end
        else begin
            sram2_en <= 1'b0;
            sram2_oe <= 1'b1;
            sram2_addr <= addr;
            if (clk_50MHz == 1'b1)
                sram2_we <= 1'b0;
            else
                sram2_we <= 1'b1;
        end
    end
end

//com r&w
always @(*) begin
    if (com == `ENABLE) begin
        if (sram1_en ==1'b1 && sram1_we == 1'b1 && sram1_oe == 1'b1 ) begin
            if (op == `RAM_OP_RD) begin
                if (data_ready == 1'b1)
                    rdn <= 1'b0;
                wrn <= 1'b1;
            end
            else begin //if (op == `RAM_OP_WR)
                rdn <= 1'b1;
                if (clk_50MHz == 1'b0)
                    wrn <= 1'b0;
                else
                    wrn <= 1'b1;
            end
        end
    end
    else begin
        rdn <= 1'b1;
        wrn <= 1'b1;
    end
end

reg vga_enable;
reg [`VGA_POS_BUS] vga_reg_row;
reg [`VGA_POS_BUS] vga_reg_col;
reg [`VGA_POS_BUS] vga_reg_pos;
reg [31:0] vga_reg_data;
reg [3:0]  vga_reg_addr;

always @(negedge clk_50MHz or negedge rst) begin
    if(~rst) begin
        vga_data_reg[0] = 16'hFFFF;
        vga_data_reg[1] = 16'hFFFF;
        vga_data_reg[2] = 16'hFFFF;
        vga_data_reg[3] = 16'hFFFF;
        vga_data_reg[4] = 16'hFFFF;
        vga_data_reg[5] = 16'hFFFF;
        vga_data_reg[6] = 16'hFF00;
    end else begin
        if (op == `RAM_OP_WR && addr >= `VGA_ADDR_BEG && addr <= `VGA_ADDR_END) begin
            vga_data_reg[addr-`VGA_ADDR_BEG] = data_i;
        end
    end
end

always @(posedge clk_25MHz or negedge rst) begin
    if (~rst) begin
        vga_row = 0;
        vga_col = 0;
        vga_data = 9'b0;
        vga_enable = `ENABLE;
    end else begin
        if (vga_enable == `ENABLE) begin
            vga_reg_row = vga_row>>4; // 640/16 -> 40
            vga_reg_col = vga_col>>4; // 480/16 -> 30
            vga_reg_pos = 3*(vga_reg_col*`VGA_REG_ROW+vga_reg_row);
            vga_reg_addr = vga_reg_pos[3:0];

            vga_reg_data = {vga_data_reg[vga_reg_pos>>4],vga_data_reg[(vga_reg_pos>>4)+1]};
            vga_data[`VGA_R_BUS] = vga_reg_data[31-vga_reg_addr];
            vga_data[`VGA_G_BUS] = vga_reg_data[30-vga_reg_addr];
            vga_data[`VGA_B_BUS] = vga_reg_data[29-vga_reg_addr];
        end
        else begin
            vga_data = 9'b0;
        end
        
        // update row and col
        vga_row  = vga_row + 1;
        if (vga_row > 799) begin
            vga_row = 0;
            vga_col = vga_col + 1;
        end
        if (vga_col > 524) begin
            vga_row = 0;
            vga_col = 0;
            vga_data = 9'b0;
            vga_enable = `ENABLE;
        end 
        if ((vga_row < 640) && (vga_col < 480)) begin
            vga_enable = `ENABLE;
        end
        else begin
            vga_enable = `DISABLE;
        end
    end
end

endmodule // ram

`endif