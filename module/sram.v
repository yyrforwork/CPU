`timescale 1ns / 1ps

`ifdef _SRAM_
`else
`define _SRAM_
`include "define.v"

module sram(
        input                  rst,      // reset signal
        input                  clk_50MHz,// system clock 50 MHz

        inout      [`DATA_BUS] sram_data,// sram data
        output reg [`ADDR_BUS] sram_addr,// sram address
        output reg             sram_en,  // sram chip enable [CE]
        output reg             sram_oe,  // sram output enable [OE]
        output reg             sram_we,  // sram write enable [WE]
        
        output     [`DATA_BUS] data_o,   // data out
        input      [`DATA_BUS] data_i,   // data in
        input      [`ADDR_BUS] addr,     // address in
        input                  op,       // operation
        input                  en,       // enable
    );

reg state;

parameter S_EMPTY = 1'b0,
          S_ENDDO = 1'b1;

assign data_o = sram_data;
assign sram_data = (~sram_en && (op==`RAM_OP_WR)) ? data_i : 'bz;

initial begin
    state = S_EMPTY;
    sram_en = 1'b1;
    sram_oe = 1'b1;
    sram_we = 1'b1;
    sram_addr = 18'h0;
end

always@(posedge clk_50MHz or negedge rst) begin
    if(!rst)
        state <= S_EMPTY;
    else begin
    case(state)
        // sram action state is empty
        S_EMPTY: begin
            if (en) begin
                if(op==`RAM_OP_RD) begin
                    sram_addr <= addr;
                    sram_en <= 1'b0;
                    sram_oe <= 1'b0;
                end
                else begin
                    sram_addr <= addr;
                    sram_en <= 1'b0;
                    sram_we <= 1'b0;
                end
                state <= S_ENDDO;
            end
        end
        
        S_ENDDO: begin
            if(op==`RAM_OP_RD) begin
                sram_en <= 1'b0;
                sram_oe <= 1'b0;
            end
            else begin
                sram_en <= 1'b1;
                sram_we <= 1'b1;
            end
            state <= S_EMPTY;
        end

        // default action
        default:
            state <= S_EMPTY;
    endcase
    end
end

endmodule // sram

`endif