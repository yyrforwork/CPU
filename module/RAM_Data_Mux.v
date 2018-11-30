`timescale 1ns / 1ps

`ifdef _RAM_DATA_MUX_
`else
`define _RAM_DATA_MUX_
`include "define.v"

module WB_Data_Mux(
        input     [`DATA_BUS]        data_REGA,
        input     [`DATA_BUS]        data_REGB,
        input     [`ADDR_BUS]        data_RA,
        input     [`RAM_DATA_OP_BUS] RAM_data_op,
        output reg[`DATA_BUS]        RAM_data
    );

always @(*) begin
    case(RAM_data_op)
        `RAM_DATA_OP_REGA: RAM_data <= data_REGA;
        `RAM_DATA_OP_REGB: RAM_data <= data_REGB;
        `RAM_DATA_OP_RA:   RAM_data <= data_RA;
        `RAM_DATA_OP_NOP:  RAM_data <= RAM_data;
    endcase
end

endmodule

`endif