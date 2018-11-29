`timescale 1ns / 1ps

`ifdef _PC_ADDER_
`else
`define _PC_ADDER_
`include "define.v"

module PC_Adder(
        input     [`PC_BUS] old_PC,
        output reg[`PC_BUS] new_PC
    );

always @(*)begin
    new_PC <= old_PC + 1'b1;
end

endmodule

`endif