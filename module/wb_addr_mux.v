`timescale 1ns / 1ps

`ifdef _WB_ADDR_MUX_
`else
`define _WB_ADDR_MUX_
`include "define.v"

module WB_Addr_Mux(
    input     [`WB_ADDR_OP_BUS] wb_addr_op,
    input     [`REG_ADDR_BUS] rx_addr,
    input     [`REG_ADDR_BUS] ry_addr,
    input     [`REG_ADDR_BUS] rz_addr,
    output reg[`REG_ADDR_BUS] wb_addr
    );

always @(*) begin
    case(wb_addr_op)
        `WB_ADDR_RX:  wb_addr <= rx_addr;
        `WB_ADDR_RY:  wb_addr <= ry_addr;
        `WB_ADDR_RZ:  wb_addr <= rz_addr;
        `WB_ADDR_NOP: wb_addr <= wb_addr;
    endcase 
end

endmodule
`endif