// First-order Sigma-Delta Modulator

module SD_mod_1st  #(
    parameter NUM_MODULATED_BITS = 12,
    parameter INTEG_PAD = 3  //For sure needs to be 1, 2 probably needed, 3 feels very safe
    )(
    input wire                            clk               ,
    input wire                            global_rst        ,
    output wire                           out               ,
    input wire [NUM_MODULATED_BITS -1:0]  in
    );

    wire signed [NUM_MODULATED_BITS:0] diff_signed;
    reg [NUM_MODULATED_BITS -1:0] out_gained;

    reg signed [NUM_MODULATED_BITS+INTEG_PAD:0] integ_sig;

    wire int_overflow;
    assign int_overflow = integ_sig[NUM_MODULATED_BITS+INTEG_PAD] ^ integ_sig[NUM_MODULATED_BITS+INTEG_PAD -1];


    always @(posedge clk or posedge global_rst) begin
        if (global_rst==1) begin
            integ_sig <= 0;
            out_gained <=0;
        end else begin
            integ_sig <= integ_sig + diff_signed;

            if (integ_sig > 0) begin
                out_gained <= (1 << NUM_MODULATED_BITS) -1;
            end else begin
                out_gained <= 0;
            end
        end
    end

    assign diff_signed = $signed({1'b0, in}) - $signed({1'b0,out_gained});
    assign out = out_gained[0];

endmodule