`ifdef _IM_MUX_
`else
`define _IM_MUX_
`include define.v

module IM_MUX(
	input wire[`IM_MUX_OP_BUS] im_mux_op;
	input wire[`DATA_BUS] im_s_e3_0;
	input wire[`DATA_BUS] im_s_e4_0;
	input wire[`DATA_BUS] im_s_e7_0;
	input wire[`DATA_BUS] im_s_e10_0;
	input wire[`DATA_BUS] im_z_e7_0;
	output reg[`DATA_BUS] im_out;
	)

	always @(*) begin
		case(im_mux_op)
			`IM_S_E_3_0: im_out = im_s_e3_0;
			`IM_S_E_4_0: im_out = im_s_e4_0;
			`IM_S_E_7_0: im_out = im_s_e7_0;
			`IM_S_E_10_0:im_out = im_s_e10_0;
			`IM_Z_E_7_0: im_out = im_z_e7_0;
		default:
			im_out = `EMPTY_DATA;
		endcase;	
	end

endmodule
`endif