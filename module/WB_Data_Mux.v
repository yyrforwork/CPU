`timescale 1ns / 1ps

`ifdef _WB_DATA_MUX_
`else
`define _WB_DATA_MUX_
`include "define.v"

module WB_Data_Mux(
        input     [`DATA_BUS]       alu_data,
        input     [`DATA_BUS]       mem_data,
        input     [`ADDR_BUS]       wb_PC,
        input     [`DATA_BUS]       wb_IH,
        input     [`WB_DATA_OP_BUS] wb_data_op,
        output reg[`DATA_BUS]       wb_data
    );

always @(*) begin
    case(wb_data_op)
        `WB_DATA_OP_ALU: wb_data <= alu_data;
        `WB_DATA_OP_MEM: wb_data <= mem_data;
        `WB_DATA_OP_PC:  wb_data <= wb_PC[`DATA_BUS];
        `WB_DATA_OP_IH:  wb_data <= wb_IH;
        `WB_DATA_OP_NOP: wb_data <= wb_data;
    endcase
end

endmodule

`endif