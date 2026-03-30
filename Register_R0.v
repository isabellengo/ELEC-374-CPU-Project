module Register_R0(
    input clear, clock, Rin, BAout,
    input wire [31:0] BusMuxOut,
    output wire [31:0] BusMuxIn
);

    reg [31:0] q;

    initial q = 32'd0;

    always @(posedge clock) begin
        if (clear) begin
            q <= 32'd0;
        end else if (Rin) begin
            q <= BusMuxOut;
        end
    end

    assign BusMuxIn = q & {32{~BAout}};
endmodule