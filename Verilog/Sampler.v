`define SYS_CLK     25000000                        // 25MHz
`define CLK_OUT     4096                            // 4096Hz = 2^12

// Counter that counts up indefinitely and is reset every 1 second by the 1PPS from the GPS

module Sampler #(
    parameter CLK_OUT_FREQ = 4096, 		// Frequency of desired output
    parameter SYS_CLK_FREQ = 25_000_000	// Frequency of input clock (used in calculations)
	)(
    input 			clk_in		,
    input 			pps			,
    input 			reset		,
    output [31:0] 	count_out	,
    output [11:0] 	rem
    );
    
    reg [31:0] count;
    reg [31:0] data;
    reg [31:0] latched_data;	// Most recent count
	reg [11:0] remainder;
    reg prev_sample;
    reg curr_sample;
    
    assign count_out 	= latched_data;
    assign rem 			= remainder;
	
    always @(posedge clk_in) begin
        count = count + 1;
        // Detect rising edge of PPS
        prev_sample = curr_sample;
        curr_sample = pps;
        if ((prev_sample == 0) && (curr_sample == 1)) begin
			data = SYS_CLK_FREQ >> 12;
			remainder  = count & 'h0000_0FFF;
			
            latched_data = data;
            count = 0;
        end
        if (reset) begin
            count <= 0;
        end
    end
endmodule