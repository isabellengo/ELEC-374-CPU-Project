module Register_64 #(parameter DATA_WIDTH_IN = 64, DATA_WIDTH_OUT = 64, INIT = 64'h0)(
	input clear, clock, enable,
	input [DATA_WIDTH_IN-1:0]BusMuxOut,
	input wire Sel,
	output wire [31:0]BusMuxIn
);
reg [DATA_WIDTH_IN-1:0]q;
initial q = INIT;
always @ (posedge clock)
	begin
		if (clear) begin
			q <= {DATA_WIDTH_IN{1'b0}};
			end
		else if (enable) begin
			q <= BusMuxOut;
			end
		end
	assign BusMuxIn = Sel ? q[63:32] : q[31:0];
endmodule
