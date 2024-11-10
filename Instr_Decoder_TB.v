`timescale 1ns / 1ps

module Instr_Decoder_TB();

reg [6:0] op;
wire [2:0] ImmSrc;

Instr_Decoder ID(
    .op(op),
    .ImmSrc(ImmSrc)
);

initial begin
op = 7'b0010011;  #10;   // addi x2, x0, 5
op = 7'b0010011;  #10;   // addi x3, x0, 12
op = 7'b0010011;  #10;   // addi x7, x3, -9
op = 7'b0110011;  #10;   // or x4, x7, x2
op = 7'b0110011;  #10;   // and x5, x3, x4
op = 7'b0110011;  #10;   // add x5, x5, x4
op = 7'b1100011;  #10;   // beq x5, x7, end
op = 7'b0110011;  #10;   // slt x4, x3, x4
op = 7'b1100011;  #10;   // beq x4, x0, around
op = 7'b0010011;  #10;   // addi x5, x0, 0
op = 7'b0110011;  #10;   // slt x4, x7, x2
op = 7'b0110011;  #10;   // add x7, x4, x5
op = 7'b0110011;  #10;   // sub x7, x7, x2
op = 7'b0100011;  #10;   // sw x7, 84(x3)
op = 7'b0000011;  #10;   // lw x2, 96(x0)
op = 7'b0110011;  #10;   // add x9, x2, x5
op = 7'b1101111;  #10;   // jal x3, end 
op = 7'b0010011;  #10;   // addi x2, x0, 1
op = 7'b0110011;  #10;   // add x2, x2, x9
op = 7'b0100011;  #10;   // sw x2, 0x20(x3)
op = 7'b0110111;  #10;   // lui x7, 2 
op = 7'b1100011;  #10;   // beq x2, x2, done
end
endmodule
