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

	input R0Out, R1Out, R2Out, R3Out, R4Out, R5Out, R6Out, R7Out, R8Out, R9Out, R10Out, R11Out, R12Out, R13Out, R14Out, R15Out,
	input PCOut, HIOut, LOOut, ZOut,
	input MDRout,
	
	output wire [31:0] BusMuxOut
  	/*
	output wire [31:0]BusMuxOutR0,
	output wire [31:0]BusMuxOutR1,
	output wire [31:0]BusMuxOutR2,
	output wire [31:0]BusMuxOutR3,
	output wire [31:0]BusMuxOutR4,
	output wire [31:0]BusMuxOutR5,
	output wire [31:0]BusMuxOutR6,
	output wire [31:0]BusMuxOutR7,
	output wire [31:0]BusMuxOutR8,
	output wire [31:0]BusMuxOutR9,
	output wire [31:0]BusMuxOutR10,
	output wire [31:0]BusMuxOutR11,
	output wire [31:0]BusMuxOutR12,
	output wire [31:0]BusMuxOutR13,
	output wire [31:0]BusMuxOutR14,
	output wire [31:0]BusMuxOutR15,

	output wire [31:0]PC,
	output wire [31:0]IR,
	output wire [31:0]MAR,
	output wire [31:0]HI,
	output wire [31:0]LO,
	output wire [31:0]Y,
	output wire [31:0]B
	*/
);
reg [31:0]q;

always @(*) begin
	if(R0Out) q = BusMuxInR0;
	if(R1Out) q = BusMuxInR1;
	if(R2Out) q = BusMuxInR2;
	if(R3Out) q = BusMuxInR3;
	if(R4Out) q = BusMuxInR4;
	if(R5Out) q = BusMuxInR5;
	if(R6Out) q = BusMuxInR6;
	if(R7Out) q = BusMuxInR7;
	if(R8Out) q = BusMuxInR8;
	if(R9Out) q = BusMuxInR9;
	if(R10Out) q = BusMuxInR10;
	if(R11Out) q = BusMuxInR11;
	if(R12Out) q = BusMuxInR12;
	if(R13Out) q = BusMuxInR13;
	if(R14Out) q = BusMuxInR14;
	if(R15Out) q = BusMuxInR15;

	if(PCOut) q = BusMuxInPC;
	//if(HIOut) q = BusMuxInHI;
	//if(LOOut) q = BusMuxInLO;
	if(ZOut) q = BusMuxInZ;
	if(MDRout) q = Mdatain;
	end
assign BusMuxOut = q;
endmodule 