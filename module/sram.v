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
        output reg             sram_rw,  // sram write enable [WE]
        
        output     [`DATA_BUS] data_o,   // data out
        input      [`DATA_BUS] data_i,   // data in
        input      [`ADDR_BUS] addr,     // address in
        input                  op,       // operation
        input                  en,       // enable
    );

reg [2:0] state;

parameter op_rd = 1'b0,
          op_wr = 1'b1,
          s_empty = 3'b000,
          r_begin = 3'b001,
          r_enddo = 3'b010,
          w_begin = 3'b101,
          w_enddo = 3'b110;

assign data_o = sram_data;
assign sram_data = (~sram_en && (op==op_wr)) ? data_i : 'bz;

initial begin
    state = s_empty;
    sram_en = 1'b1;
    sram_oe = 1'b1;
    sram_rw = 1'b1;
    sram_addr = 18'h0;
end

always@(posedge clk_50MHz or negedge rst) begin
    if(!rst)
        state = s_empty;
    else begin
    case(state)
        // sram action state is empty
        s_empty: begin
            if (en) begin
                state = (op==op_rd) ? r_begin : w_begin;
            end
        end
        
        // prepare reading sram
        r_begin: begin
            sram_addr = addr;
            sram_en = 1'b0;
            sram_oe = 1'b0;
            state = r_enddo;
        end
        
        // read sram
        r_enddo: begin
            sram_en = 1'b1;
            sram_oe = 1'b1;
            state = s_empty;
        end
        
        // prepare writing sram
        w_begin: begin
            sram_addr = addr;
            sram_en = 1'b0;
            sram_rw = 1'b0;
            state = w_enddo;
        end
        
        // write sram
        w_enddo: begin
            sram_en = 1'b1;
            sram_rw = 1'b1;
            state = s_empty;
        end

        // default action
        default:
            state = s_empty;
    endcase
    end
end

endmodule // sram

`endif