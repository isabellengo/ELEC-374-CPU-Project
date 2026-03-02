module divider(M, Q, Result);

input  signed [31:0] M, Q;       // M = divisor, Q = dividend
output signed [63:0] Result;

reg signed [63:0] Result;

reg [32:0] rem;
reg [32:0] divisor_abs;
reg [31:0] quotient_abs;
reg [31:0] dividend_abs;

reg [31:0] quotient_u;
reg [31:0] remainder_u;

reg sign_quotient, sign_remainder;

integer i;

always @* begin
    // Defaults
    Result        = 64'sd0;
    rem           = 33'd0;
    divisor_abs   = 33'd0;
    quotient_abs  = 32'd0;
    dividend_abs  = 32'd0;
    quotient_u    = 32'd0;
    remainder_u   = 32'd0;

    sign_quotient = Q[31] ^ M[31];
    sign_remainder = Q[31];

    if (M == 32'sd0) begin
        // Quotient = all 1s, remainder = dividend
        quotient_u  = 32'hFFFF_FFFF;
        remainder_u = Q[31:0];
    end else begin
        // Magnitudes
        dividend_abs = Q[31] ? (~Q + 32'd1) : Q;
        divisor_abs  = M[31] ? {1'b0, (~M + 32'd1)} : {1'b0, M};

        quotient_abs = dividend_abs;
        rem = 33'd0;

        // Unsigned restoring division
        for (i = 0; i < 32; i = i + 1) begin
            rem = {rem[31:0], quotient_abs[31]};
            quotient_abs = {quotient_abs[30:0], 1'b0};

            if (rem >= divisor_abs) begin
                rem = rem - divisor_abs;
                quotient_abs[0] = 1'b1;
            end
        end

        // Apply signs
        quotient_u  = sign_quotient  ? (~quotient_abs + 32'd1) : quotient_abs;
        remainder_u = sign_remainder ? (~rem[31:0] + 32'd1)    : rem[31:0];
    end

    // Result[31:0] = quotient, Result[63:32] = remainder
    Result = {remainder_u, quotient_u};
end

endmodule

//Had an issue with A=115 and B=73