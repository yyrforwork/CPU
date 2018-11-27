`timescale 1ns / 1ps

`ifdef _SIGN_EXTEND_
`else
`define _SIGN_EXTEND_
`include "define.v"

module sign_extend(
        input      [10:0]  inst,
        output reg [15:0]  s_e_10_0,
        output reg [15:0]  s_e_7_0,
        output reg [15:0]  s_e_3_0
    );

assign s_e_10_0= inst[10]? {`_5_bit_1_, inst[10:0]}:{`_5_bit_0_, inst[10:0]};
assign s_e_7_0 = inst[7] ? {`_8_bit_1_, inst[7:0]} :{`_8_bit_0_, inst[7:0]};
assign s_e_3_0 = inst[3] ? {`_12_bit_1_,inst[7:0]} :{`_12_bit_0_,inst[3:0]};

endmodule

`endif