`timescale 1ns / 1ps

`ifdef _EXTENDER_
`else
`define _EXTENDER_
`include "define.v"

module extender(
        input      [`INST_BUS]  inst,
        
        output reg [`DATA_BUS]  z_e_7_0,
        output reg [`DATA_BUS]  s_e_10_0,
        output reg [`DATA_BUS]  s_e_7_0,
        output reg [`DATA_BUS]  s_e_3_0
    );

assign z_e_7_0 = {`_8_bit_0_, inst[7:0]};
assign s_e_10_0= inst[10]? {`_5_bit_1_, inst[10:0]}:{`_5_bit_0_, inst[10:0]};
assign s_e_7_0 = inst[7] ? {`_8_bit_1_, inst[7:0]} :{`_8_bit_0_, inst[7:0]};
assign s_e_3_0 = inst[3] ? {`_12_bit_1_,inst[7:0]} :{`_12_bit_0_,inst[3:0]};

endmodule

`endif