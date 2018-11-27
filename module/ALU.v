`timescale 1ns / 1ps

`ifdef _ALU_
`else
`define _ALU_
`include "define.v"

module ALU( input      [`DATA_BUS] a,
            input      [`DATA_BUS] b, 
            input      [`OP_BUS]   op,
            output reg [`DATA_BUS] y,
            output reg zero
    );

always@(a or b or op) begin
  case(op)
    `OP_ADD:  y <= a + b; // ADD
    `OP_SUB:  y <= a - b; // SUB
    `OP_AND:  y <= a & b; // AND
    `OP_OR:   y <= a | b; // OR
    `OP_XOR:  y <= a ^ b; // XOR
    `OP_NOT:  y <= ~ a;   // NOT
    
    `OP_RETA: y <= a;     // RETA
    `OP_RETB: y <= b;     // RETB
    `OP_EQU:  y <= a==b;  // EQU
    
    `OP_SLL:  y <= b <<(a==0 ? 8 : a); // SLL
    `OP_SLLV: y <= b <<a;              // SLLV
    `OP_SRA:  y <= b>>>(a==0 ? 8 : a); // SRA
    `OP_SRL:  y <= b >>(a==0 ? 8 : a); // SRL
  endcase
  zero = a==0;
end

endmodule

`endif