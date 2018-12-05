`timescale 1ns / 1ps

`ifdef _RAM_DATA_MUX_
`else
`define _RAM_DATA_MUX_
`include "define.v"

module RAM_Data_Mux(
        input     [`DATA_BUS]        data_REGA,
        input     [`DATA_BUS]        data_REGB,
        input     [`DATA_BUS]        data_RA,
        input     [`DATA_BUS]        data_FOWD,

        input     [`RAM_DATA_OP_BUS] RAM_data_op,
        input                        forward_enable,
        output reg[`DATA_BUS]        RAM_data
    );

always @(*) begin
    if (forward_enable == `FORWARD_ENABLE)
        RAM_data <= data_FOWD;
    else
    begin
        case(RAM_data_op)
            `RAM_DATA_OP_REGA: RAM_data <= data_REGA;
            `RAM_DATA_OP_REGB: RAM_data <= data_REGB;
            `RAM_DATA_OP_RA:   RAM_data <= data_RA;
            `RAM_DATA_OP_NOP:  RAM_data <= `DATA_ZERO;
        endcase
    end
end

endmodule

`endif