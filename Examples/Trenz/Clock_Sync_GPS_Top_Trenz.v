`timescale 1ns / 1ps

`define SYS_CLK_FREQ 25_000_000
`define CLK_OUT_FREQ 4096

module Clock_Sync_GPS_Top (
    input SYSCLK_25M,
    input B14_L12_P,     // GPS     -- Orange
    output B14_L13_N,    // CLK_OUT -- Blue
    output GPIO_LED
    );
    
    wire reset = 0;
    assign GPIO_LED = B14_L12_P;
    
    Clock_Sync_GPS #( .CLK_OUT_FREQ(`CLK_OUT_FREQ), .SYS_CLK_FREQ(`SYS_CLK_FREQ) ) u0 ( .SYS_CLK(SYSCLK_25M), .PPS(B14_L12_P), .RESET(reset), .CLK_OUT(B14_L13_N) );
    
endmodule
    