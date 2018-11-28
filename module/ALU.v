`timescale 1ns / 1ps

`ifdef _ALU_
`else
`define _ALU_
`include "define.v"

module ALU( input      [`DATA_BUS]   a,
            input      [`DATA_BUS]   b, 
            input      [`ALU_OP_BUS] op,
            output reg [`DATA_BUS]   y,
            output reg               zero
    );

always@(a or b or op) begin
  case(op)
    `ALU_OP_ADD:  y <= a + b; // ADD
    `ALU_OP_SUB:  y <= a - b; // SUB
    `ALU_OP_AND:  y <= a & b; // AND
    `ALU_OP_OR:   y <= a | b; // OR
    `ALU_OP_XOR:  y <= a ^ b; // XOR
    `ALU_OP_NOT:  y <= ~ a;   // NOT
    
    `ALU_OP_RETA: y <= a;     // RETA
    `ALU_OP_RETB: y <= b;     // RETB
    `ALU_OP_EQU:  y <= a==b;  // EQU
    
    `ALU_OP_SLL:  y <= b <<(a==0 ? 8 : a); // SLL
    `ALU_OP_SLLV: y <= b <<a;              // SLLV
    `ALU_OP_SRA:  y <= b>>>(a==0 ? 8 : a); // SRA
    `ALU_OP_SRL:  y <= b >>(a==0 ? 8 : a); // SRL

    `ALU_OP_NOP:  y <= y;                  // NOP
  endcase
  zero = a==0;
end

endmodule

`endif