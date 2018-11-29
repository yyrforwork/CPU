`timescale 1ns / 1ps

`ifdef _IM_MUX_
`else
`define _IM_MUX_
`include "define.v"

module Im_Mux(
        input     [`DATA_BUS]  im_s_e3_0,
        input     [`DATA_BUS]  im_s_e4_0,
        input     [`DATA_BUS]  im_s_e7_0,
        input     [`DATA_BUS]  im_s_e10_0,
        input     [`DATA_BUS]  im_z_e7_0,
        input     [`IM_OP_BUS] im_op,
        output reg[`DATA_BUS]  im_out
    );

always @(*) begin
    case(im_op)
        `IM_OP_S_E_3_0:  im_out <= im_s_e3_0;
        `IM_OP_S_E_4_0:  im_out <= im_s_e4_0;
        `IM_OP_S_E_7_0:  im_out <= im_s_e7_0;
        `IM_OP_S_E_10_0: im_out <= im_s_e10_0;
        `IM_OP_Z_E_7_0:  im_out <= im_z_e7_0;
        `IM_OP_NOP:      im_out <= `DATA_ZERO;
    endcase
end

endmodule

`endif