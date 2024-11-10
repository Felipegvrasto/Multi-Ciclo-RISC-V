`timescale 1ns / 1ps

module Instr_Datamemory #(parameter N=32, M=7)(
    input CLK,
    input WE,
    input [N-1:0] A,
    input [N-1:0] WD,
    output reg [N-1:0] RD
    );

reg [7:0] mem [0:(2**M-1)];

always @ (posedge CLK)
    if (WE) begin
        {mem[A], mem[A+1], mem[A+2], mem[A+3]} <= WD;
      
    end 

always@(negedge CLK)
    RD <= {mem[A], mem[A+1], mem[A+2], mem[A+3]};

initial
 $readmemh("datos_memory.mem", mem, 0,	(2**M)-1);
        //(File name, Memory array name, Start Address, Stop Address)

endmodule
