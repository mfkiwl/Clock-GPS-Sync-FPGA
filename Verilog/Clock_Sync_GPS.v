`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 		Berkeley Wireless Research Center
// Designer: 		James Dalton (jamesdalton@berkeley.edu) and Greg LaCaille (greglac@berkeley.edu)	
// Create Date: 	05/22/2018
// Design Name: 
// Module Name: 	Clock_Sync_GPS
// Project Name: 	Clock Synchronization using GPS
// Target Devices:	Xilinx Artix-7 XC7A35T-CSG325, XC7A100T-CSG324
// 					https://wiki.trenz-electronic.de/display/PD/TEBA0714+TRM
//					https://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/
// Description: 
// 
// Dependencies: 	Sampler.v, N_Counter.v, SD_mod_1st.v
// 
// Revision 0.3 - Code clean up

module Clock_Sync_GPS #(
    parameter CLK_OUT_FREQ = 4096, 		// Frequency of desired output
    parameter SYS_CLK_FREQ = 25_000_000	// Frequency of input clock (used in calculations)
	)(
    input 	SYS_CLK		,	// SYS_CLK, sample rate
    input 	PPS		, 	// PPS
    input 	RESET		,	// Global reset
    output 	CLK_OUT			// CLK_OUT
    );

    wire [11:0] remainder;
    wire [31:0] count;
    
    Sampler  	#(.CLK_OUT_FREQ(CLK_OUT_FREQ), .SYS_CLK_FREQ(SYS_CLK_FREQ))	u0( .clk_in(SYS_CLK), .reset(RESET), .pps(PPS), .count_out(count), .rem(remainder) );
    N_Counter 	u1( .clk_in(SYS_CLK), .reset(RESET), .clk_out(CLK_OUT), .n(count), .rem(remainder) );    

endmodule
