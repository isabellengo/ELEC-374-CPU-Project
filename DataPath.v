module DataPath(
    input wire Clock, clear,
    // input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, PCin, HIin, LOin, Zin, MARin, MDRin, Yin, IRin, IncPC, Read,
    // input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, PCout, HIout, LOout, MDRout, Zout,
    input wire Gra, Grb, Grc, Rin, Rout, BAout, Cout,
    input wire PCin, HIin, LOin, Zin, MARin, MDRin, Yin, IRin, IncPC, Read, Write,
    input wire PCout, HIout, LOout, MDRout, Zout, 
    input wire OutPortin, InPortout, Strobe, //phase 2 addition
    input wire SelZ, conIn,
    input wire [31:0] Input_Data, //phase 2 addition
    input wire [4:0] controlSignal,
    output wire conOut,
    output wire [31:0] BusMuxOut, Output_Data, //phase 2 addition
    output wire [31:0] IR_out 
 );

wire [31:0] BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3, BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7, BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11, BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15, BusMuxInPC, BusMuxInHI, BusMuxInLO, BusMuxInZ;
wire [31:0] AIn;
wire [63:0] COut;

wire [31:0] MDR_Q;
wire [31:0] Address;
wire [15:0] R_in;
wire [15:0] R_out;
wire [31:0] IR_Q;
wire [31:0] Mdatain;

wire [31:0] C_sign_extended;

//Devices
Register_R0 R0(.clear(clear), .clock(Clock), .Rin(R_in[0]), .BAout(BAout), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR0));


Register R1(clear, Clock, R_in[1], BusMuxOut, BusMuxInR1);
Register R2(clear, Clock, R_in[2], BusMuxOut, BusMuxInR2);
Register R3(clear, Clock, R_in[3], BusMuxOut, BusMuxInR3);
Register R4(clear, Clock, R_in[4], BusMuxOut, BusMuxInR4);
Register R5(clear, Clock, R_in[5], BusMuxOut, BusMuxInR5);
Register R6(clear, Clock, R_in[6], BusMuxOut, BusMuxInR6);
Register R7(clear, Clock, R_in[7], BusMuxOut, BusMuxInR7);
Register R8(clear, Clock, R_in[8], BusMuxOut, BusMuxInR8);
Register R9(clear, Clock, R_in[9], BusMuxOut, BusMuxInR9);
Register R10(clear, Clock, R_in[10], BusMuxOut, BusMuxInR10);
Register R11(clear, Clock, R_in[11], BusMuxOut, BusMuxInR11);
Register R12(clear, Clock, R_in[12], BusMuxOut, BusMuxInR12);
Register R13(clear, Clock, R_in[13], BusMuxOut, BusMuxInR13);
Register R14(clear, Clock, R_in[14], BusMuxOut, BusMuxInR14);
Register R15(clear, Clock, R_in[15], BusMuxOut, BusMuxInR15);
Register PC(clear, Clock, PCin, BusMuxOut, BusMuxInPC);
Register HI(clear, Clock, HIin, BusMuxOut, BusMuxInHI);
Register LO(clear, Clock, LOin, BusMuxOut, BusMuxInLO);
Register_64 Z(clear, Clock, Zin, COut, SelZ, BusMuxInZ);

Register IR(clear, Clock, IRin, BusMuxOut, IR_Q); // IR register

Register Y(clear, Clock, Yin, BusMuxOut, AIn); // Y register; no output bus connection needed as it's only used internally in the ALU

Register MAR(clear, Clock, MARin, BusMuxOut, Address); // MAR register; no output bus connection needed as it's only used internally for memory addressing

Register OutPort(.clear(clear), .clock(Clock), .enable(OutPortin), .BusMuxOut(BusMuxOut), .BusMuxIn(Output_Data)); // Output port register for phase 2

wire [31:0] BusMuxInPort;

Register InPort(.clear(clear), .clock(Clock), .enable(InPortout), .BusMuxOut(Input_Data), .BusMuxIn(BusMuxInPort)); // Input port register for phase 2

wire [31:0] ALU_A;
assign ALU_A = IncPC ? 32'd1 : AIn; // IncPC forces A=1 so ALU computes Bus+1 (PC+1)
ALU ALU1(clear, Clock, controlSignal, ALU_A, BusMuxOut, COut);

//Bus
Bus bus1(
    .BusMuxInR0(BusMuxInR0),
    .BusMuxInR1(BusMuxInR1),
    .BusMuxInR2(BusMuxInR2),
    .BusMuxInR3(BusMuxInR3),
    .BusMuxInR4(BusMuxInR4),
    .BusMuxInR5(BusMuxInR5),
    .BusMuxInR6(BusMuxInR6),
    .BusMuxInR7(BusMuxInR7),
    .BusMuxInR8(BusMuxInR8),
    .BusMuxInR9(BusMuxInR9),
    .BusMuxInR10(BusMuxInR10),
    .BusMuxInR11(BusMuxInR11),
    .BusMuxInR12(BusMuxInR12),
    .BusMuxInR13(BusMuxInR13),
    .BusMuxInR14(BusMuxInR14),
    .BusMuxInR15(BusMuxInR15),
    .BusMuxInPC(BusMuxInPC),
    .BusMuxHI(BusMuxInHI),
    .BusMuxLO(BusMuxInLO),
    .BusMuxInZ(BusMuxInZ),
    .MDR_Q(MDR_Q),
    .Mdatain(Mdatain),
    .ROut(R_out),
    .PCOut(PCout),
    .HIOut(HIout),
    .LOOut(LOout), 
    .ZOut(Zout),
    .MDRout(MDRout),
    .BusMuxInPort(BusMuxInPort), //phase 2 addition
    .InPortout(InPortout), //phase 2 addition
    .Cout(Cout),
    .C_sign_extended(C_sign_extended),
    .BusMuxOut(BusMuxOut)
    );

MDR #(32,32,32'h0) mdr1(.clear(clear), .clock(Clock), .MDRIn(MDRin), .read(Read), .MDataIn(Mdatain), .BusMuxOut(BusMuxOut), .Q(MDR_Q));
// MDR_Q is the 32-bit data output from the MDR register; MDRout remains the control signal

RAM ram1(
    .read(Read),
    .write(Write),
    .address(Address[8:0]), // Using the lower 9 bits of the address for indexing
    .data_in(MDR_Q),
    .data_out(Mdatain)
);

sel_encode sel_encode1(
    .IR(IR_Q),
    .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout),
    .BAout(BAout), .Select(R_in), .Encode(R_out), .C_sign_extended(C_sign_extended), .Cout(Cout)
);

con_ff con_ff1(
    .clear(clear), 
    .Clock(Clock),
    .conIn(conIn),
    .IR_section(IR_Q[20:19]),
    .BusMuxOut(BusMuxOut),
    .conOut(conOut)
);

assign IR_out = IR_Q;

endmodule