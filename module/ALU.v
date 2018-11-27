`timescale 1ns / 1ps

`ifdef _ALU_
`else
`define _ALU_
`include "define.v"

module ALU(input      [`DATA_BUS] a,
           input      [`DATA_BUS] b, 
           input      [`OP_BUS]   op,
           output reg [`DATA_BUS] y,
           output reg [`FLAG_BUS] f);

reg c; // carry

always@(a or b or op) begin
  c=0;
  case(op)
    `OP_ADD: {c,y} = a + b; // ADD
    `OP_SUB: {c,y} = a - b; // SUB
    `OP_AND: y = a & b;     // AND
    `OP_OR:  y = a | b;     // OR
    `OP_XOR: y = a ^ b;     // XOR
    `OP_NOT: y = ~a;        // NOT
    `OP_SLL: y = a <<b;     // SLL
    `OP_SRL: y = a >>b;     // SRL
    `OP_SRA: y = a>>>b;     // SRA
    `OP_ROL: y = (a<<(b&16'h000F)) | (a>>(16-(b&16'h000F))); // ROL
  endcase
  f[`FLAG_ZF] = y==0;
  f[`FLAG_CF] = c;
  f[`FLAG_OF] = a[15]^b[15]^y[15]^c;
  f[`FLAG_SF] = y[15];
  f[`FLAG_PF] = ~^y;
end

endmodule

`endif