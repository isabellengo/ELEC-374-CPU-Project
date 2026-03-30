module Bus(
	//Mux 
	input [31:0]BusMuxInR0,
	input [31:0]BusMuxInR1,
	input [31:0]BusMuxInR2,
	input [31:0]BusMuxInR3,
	input [31:0]BusMuxInR4,
	input [31:0]BusMuxInR5,
	input [31:0]BusMuxInR6,
	input [31:0]BusMuxInR7,
	input [31:0]BusMuxInR8,
	input [31:0]BusMuxInR9,
	input [31:0]BusMuxInR10,
	input [31:0]BusMuxInR11,
	input [31:0]BusMuxInR12,
	input [31:0]BusMuxInR13,
	input [31:0]BusMuxInR14,
	input [31:0]BusMuxInR15,

	input [31:0]BusMuxInPC,	
	input [31:0]BusMuxHI,
	input [31:0]BusMuxLO,
	input [31:0]BusMuxInZ, //Z is 64-bits, but we only have a 32-bit bus, will transfer half at a time

	input [31:0]Mdatain,
	input [31:0]MDR_Q,

	input [31:0] C_sign_extended, BusMuxInPort, //added in phase 2 but just change buxmuxport if needed
	input InPortout,

	input [15:0] ROut,
	input PCOut, HIOut, LOOut, ZOut,
	input MDRout, Cout,
	
	output wire [31:0] BusMuxOut
);
reg [31:0]q;

always @(*) begin
	q = 32'b0;

	if(ROut[0]) q = BusMuxInR0;
	if(ROut[1]) q = BusMuxInR1;
	if(ROut[2]) q = BusMuxInR2;
	if(ROut[3]) q = BusMuxInR3;
	if(ROut[4]) q = BusMuxInR4;
	if(ROut[5]) q = BusMuxInR5;
	if(ROut[6]) q = BusMuxInR6;
	if(ROut[7]) q = BusMuxInR7;
	if(ROut[8]) q = BusMuxInR8;
	if(ROut[9]) q = BusMuxInR9;
	if(ROut[10]) q = BusMuxInR10;
	if(ROut[11]) q = BusMuxInR11;
	if(ROut[12]) q = BusMuxInR12;
	if(ROut[13]) q = BusMuxInR13;
	if(ROut[14]) q = BusMuxInR14;
	if(ROut[15]) q = BusMuxInR15;

	if(PCOut) q = BusMuxInPC;
	if(HIOut) q = BusMuxHI;
	if(LOOut) q = BusMuxLO;
	if(ZOut) q = BusMuxInZ;
	if(MDRout) q = Mdatain;
	if(MDRout) q = MDR_Q;
	if(Cout) q = C_sign_extended;
	if(InPortout) q = BusMuxInPort;
	end
assign BusMuxOut = q;
endmodule 