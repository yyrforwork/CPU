`timescale 1ns / 1ps

`ifdef _ALU_A_MUX_
`else
`define _ALU_A_MUX_
`include "define.v"

module ALU_A_Mux(
        input     [`DATA_BUS]     data_T,
        input     [`DATA_BUS]     data_SP,
        input     [`REG_ADDR_BUS] data_RZ,
        input     [`DATA_BUS]     data_REGA,
        input     [`DATA_BUS]     data_FOWD,
        input                     ALU_A_FOWD_en,
        input     [`ALU_A_OP_BUS] ALU_A_op,
        output reg[`DATA_BUS]     ALU_A_data
    );

always @(*) begin
    if(ALU_A_FOWD_en)
        ALU_A_data <= data_FOWD;
    else begin
        case(ALU_A_op)
            `ALU_A_OP_T:    ALU_A_data <= data_T;
            `ALU_A_OP_SP:   ALU_A_data <= data_SP;
            `ALU_A_OP_RZ:   ALU_A_data <= data_RZ; // im inst[4:2]
            `ALU_A_OP_REGA: ALU_A_data <= data_REGA;
        endcase
    end
end

endmodule
`endif