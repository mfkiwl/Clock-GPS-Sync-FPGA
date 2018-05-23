// Counts clk_in up to n. //

module N_Counter (
    input 			clk_in	,
    input 			reset	,
    input [31:0] 	n		,
    input [11:0] 	rem		,
	output 			clk_out
    );

    reg [31:0] count = 0;
    reg out = 0; // Output signal
    
    wire [31:0] count_in;
    assign count_in = n;
    assign clk_out = out;
    
    wire [31:0] duty;
    assign duty = n >> 2; // 1/4 --> 25% duty
    
    reg [31:0] counter_var = 0;
    wire extra_count;
    reg SD_extra;
    SD_mod_1st #(.NUM_MODULATED_BITS(12), .INTEG_PAD(13)) sigma_delta(.clk(clk_out), .global_rst(reset), .out(extra_count), .in(rem));
    
    
    always @(posedge clk_in)
    begin
        SD_extra = extra_count;
        count = count + 1;
        if (reset) begin
            out	= 0;
            count = 0;
        end else if (count >= count_in + SD_extra) begin
            count = 0;
            out	= 1;
        end

        if (count >= duty) begin
            out = 0;
        end

    end
endmodule