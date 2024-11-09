 `timescale 1ns / 1ps
    
    module MC_FSM(
        input CLK, 
        input CE, 
        input RST,
        input [4:0] op,
        (*KEEP = "true"*)
        output  AdrSrc, MemWrite, IRWrite, RegWrite, Branch, PCUpdate,
        (*KEEP = "true"*)
        output [1:0] ALUSrcA, ALUSrcB, ALUOp, ResultSrc 
        );
    
    wire [6:0] opc;
    
    assign opc = {op, 2'b11};
    
    localparam  S00 = 4'd0,     // Inicio
                S01 = 4'd1,     // Decode
                S02 = 4'd2,     // MemAdr
                S03 = 4'd3,     // MemRead
                S04 = 4'd4,     // MemWB
                S05 = 4'd5,     // MemWrite
                S06 = 4'd6,     // ExecuteR
                S07 = 4'd7,     // ALUWB
                S08 = 4'd8,     // ExecuteI
                S09 = 4'd9,     // JAL
                S10 = 4'd10,    // BEQ
                S11 = 4'd11;    // LUI
    
    reg [3:0] e_siguiente;
    (*KEEP = "true"*)
    reg [3:0] e_actual = S00;
    
    (*KEEP = "true"*)
    reg [13:0] Salidas;
    
    always @(*)
        case(e_actual)
            S00: e_siguiente = S01;
            S01: if((op == 7'b0000011)|(op == 7'b0100011))  // lw or sw
                    e_siguiente = S02;
                 else if(op == 7'b0110011)                  // R - type
                    e_siguiente = S06;
                 else if(op == 7'b0010011)                  // I - type
                    e_siguiente = S08;
                 else if(op == 7'b1101111)                  // JAL
                    e_siguiente = S09;
                 else if(op == 7'b1100011)                  // BEQ
                    e_siguiente = S10;
                 else if(op == 7'b0110111)                  // LUI
                    e_siguiente = S11;
            S02: if(op == 7'b0000011)                       // lw
                    e_siguiente = S03;
                 else if(op == 7'b0100011)                  // sw
                    e_siguiente = S05;
            S03: e_siguiente = S04;
            S04: e_siguiente = S00;
            S05: e_siguiente = S00;
            S06: e_siguiente = S07;
            S07: e_siguiente = S00;
            S08: e_siguiente = S07;
            S09: e_siguiente = S07;
            S10: e_siguiente = S00;
            S11: e_siguiente = S00;                         // LUI goes back to S00
        endcase
    
    always @(posedge CLK)
        if(RST)
            e_actual <= S00;
        else if(CE)
            e_actual <= e_siguiente;
    
    // {Branch, PCUpdate, AdrSrc, MemWrite, IRWrite, RegWrite, ALUSrcA, ALUSrcB, ResultSrc, ALUOp}
    
    always @(*)
        case(e_actual)
            S00:    Salidas = 14'b01001000101000;
            S01:    Salidas = 14'b00x0000101xx00;
            S02:    Salidas = 14'b00x0001001xx00;
            S03:    Salidas = 14'b001000xxxx00xx;
            S04:    Salidas = 14'b00x001xxxx01xx;
            S05:    Salidas = 14'b001100xxxx00xx;
            S06:    Salidas = 14'b00x0001000xx10;
            S07:    Salidas = 14'b00x001xxxx00xx;
            S08:    Salidas = 14'b00x0001001xx10;
            S09:    Salidas = 14'b01x00001100000;
            S10:    Salidas = 14'b10x00010000001;
            S11:    Salidas = 14'b00x001xxxx11xx;  // LUI: Set ResultSrc to 11, enable RegWrite
        endcase
    
    assign Branch    = Salidas[13];
    assign PCUpdate  = Salidas[12];
    assign AdrSrc    = Salidas[11];
    assign MemWrite  = Salidas[10];
    assign IRWrite   = Salidas[9]; 
    assign RegWrite  = Salidas[8];
    assign ALUSrcA   = Salidas[7:6]; 
    assign ALUSrcB   = Salidas[5:4];
    assign ResultSrc = Salidas[3:2];
    assign ALUOp     = Salidas[1:0];
    
    endmodule
