`timescale 1ns / 1ps

`define SYS_CLK_FREQ 100_000_000
`define CLK_OUT_FREQ 4096

module Clock_Sync_GPS_Top_Nexys (
    input   CLK100MHZ       ,
    input   PPS             ,   // jb[3]
    output  CLK_OUT         ,   // jb[10]
    output  LED
    );
    
    wire reset = 0;
    assign LED = PPS;
    
    Clock_Sync_GPS #( .CLK_OUT_FREQ(`CLK_OUT_FREQ), .SYS_CLK_FREQ(`SYS_CLK_FREQ) ) u0 ( .SYS_CLK(CLK100MHZ), .PPS(PPS), .RESET(reset), .CLK_OUT(CLK_OUT) );
    
endmodule