`timescale 1ns / 1ps

module Instr_Datamemory_TB();

reg [31:0] WD;
reg CLK;
reg WE;
reg [31:0] A;
wire [31:0] RD;

Instr_Datamemory IDM(
.CLK(CLK),
.WE(WE),
.WD(WD),
.A(A),
.RD(RD)
);

initial begin
 CLK = 1'd0;
 WE = 1'b0;
 WD = 32'd0;
 A = 32'd0;
end

always begin
#5 CLK = ~CLK;
end

always begin
#10;    A = A + 32'd4;
end

initial begin
#130;           // sw x7, 84(x3)
WE = 1'b1;      WD = 32'd7;        A = 32'd96;
#10;            // lw x2, 96(x0)
WE = 1'b0;      WD = 32'dx;        A = 32'd96;
#50;            // sw x2, 0x20(x3)
WE = 1'b1;      WD = 32'd25;       A = 32'd100;
#10;            // lw x2, 96(x0)
WE = 1'b0;      WD = 32'dx;        A = 32'd100;
end

endmodule
