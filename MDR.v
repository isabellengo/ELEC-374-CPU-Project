module MDR #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)(
	input clear, clock, MDRIn, read,
	input [DATA_WIDTH_IN-1:0] BusMuxOut,
	input [DATA_WIDTH_IN-1:0] MDataIn,
	output wire [DATA_WIDTH_OUT-1:0] Q
);

wire [DATA_WIDTH_IN-1:0]MuxOut;
Mux2to1 MDMux(BusMuxOut, MDataIn, read, MuxOut);
reg [DATA_WIDTH_IN-1:0]q;

initial q = INIT;
always @ (posedge clock)
	begin
		if (clear) begin
			q <= {DATA_WIDTH_IN{1'b0}};
			end
		else if (MDRIn) begin
			q <= MuxOut;
			end
		end
	assign Q = q[DATA_WIDTH_OUT-1:0];
endmodule