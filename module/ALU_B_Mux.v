`timescale 1ns / 1ps

`ifdef _ALU_B_MUX_
`else
`define _ALU_B_MUX_
`include "define.v"

module ALU_B_Mux(
        input     [`DATA_BUS]     data_IM,
        input     [`DATA_BUS]     data_REGB,
        input     [`ALU_B_OP_BUS] ALU_B_op,
        output reg[`DATA_BUS]     ALU_B_data,
    );

always @(*) begin
    case(ALU_B_op)
        `ALU_B_OP_IM:   ALU_B_data <= data_IM;
        `ALU_B_OP_REGB: ALU_B_data <= data_REGB;
    endcase
end

endmodule
`endif