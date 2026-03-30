module con_ff(
    input clear, Clock, conIn,
    input [1:0] IR_section,
    input [31:0] BusMuxOut,
    output reg conOut
);

// eq_zero, neq_zero, geq_zero, lt_zero, D_in

wire eq_zero  = (BusMuxOut == 32'd0);
    wire neq_zero = (BusMuxOut != 32'd0);
    wire geq_zero = ~BusMuxOut[31];
    wire lt_zero  = BusMuxOut[31];
 
    wire D_in;
    assign D_in = (IR_section == 2'b00) ? eq_zero  :
                  (IR_section == 2'b01) ? neq_zero :
                  (IR_section == 2'b10) ? geq_zero :
                                        lt_zero  ;
 
    always @(posedge Clock) begin
        if (clear)
            conOut <= 1'b0;
        else if (conIn)
            conOut <= D_in;
    end
endmodule