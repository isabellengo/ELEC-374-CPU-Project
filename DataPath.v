module DataPath(
    input wire Clock, clear,
    input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, PCin, HIin, LOin, Zin, MARin, MDRin, Yin, IRin, IncPC, Read,
    input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, PCout, HIout, LOout, MDRout, Zout,
    input wire SelZ,
    input wire [31:0] Mdatain,
    input wire [4:0] controlSignal,
    output wire [31:0] BusMuxOut
 );

wire [31:0] BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3, BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7, BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11, BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15, BusMuxInPC, BusMuxInHI, BusMuxInLO, BusMuxInZ;
wire [31:0] AIn;
wire [31:0] MDR_Q;
wire [63:0] COut;

//Devices
Register R0(clear, Clock, R0in, BusMuxOut, BusMuxInR0);
Register R1(clear, Clock, R1in, BusMuxOut, BusMuxInR1);
Register R2(clear, Clock, R2in, BusMuxOut, BusMuxInR2);
Register R3(clear, Clock, R3in, BusMuxOut, BusMuxInR3);
Register R4(clear, Clock, R4in, BusMuxOut, BusMuxInR4);
Register R5(clear, Clock, R5in, BusMuxOut, BusMuxInR5);
Register R6(clear, Clock, R6in, BusMuxOut, BusMuxInR6);
Register R7(clear, Clock, R7in, BusMuxOut, BusMuxInR7);
Register R8(clear, Clock, R8in, BusMuxOut, BusMuxInR8);
Register R9(clear, Clock, R9in, BusMuxOut, BusMuxInR9);
Register R10(clear, Clock, R10in, BusMuxOut, BusMuxInR10);
Register R11(clear, Clock, R11in, BusMuxOut, BusMuxInR11);
Register R12(clear, Clock, R12in, BusMuxOut, BusMuxInR12);
Register R13(clear, Clock, R13in, BusMuxOut, BusMuxInR13);
Register R14(clear, Clock, R14in, BusMuxOut, BusMuxInR14);
Register R15(clear, Clock, R15in, BusMuxOut, BusMuxInR15);
Register PC(clear, Clock, PCin, BusMuxOut, BusMuxInPC);
Register HI(clear, Clock, HIin, BusMuxOut, BusMuxInHI);
Register LO(clear, Clock, LOin, BusMuxOut, BusMuxInLO);
Register_64 Z(clear, Clock, Zin, COut, SelZ, BusMuxInZ);

Register Y(clear, Clock, Yin, BusMuxOut, AIn); // Y register; no output bus connection needed as it's only used internally in the ALU

ALU ALU1(clear, Clock, controlSignal, AIn, BusMuxOut, COut);

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
    .Mdatain(Mdatain),
    .R0Out(R0out),
    .R1Out(R1out),
    .R2Out(R2out),
    .R3Out(R3out),
    .R4Out(R4out),
    .R5Out(R5out),
    .R6Out(R6out),
    .R7Out(R7out),
    .R8Out(R8out),
    .R9Out(R9out),
    .R10Out(R10out),
    .R11Out(R11out),
    .R12Out(R12out),
    .R13Out(R13out),
    .R14Out(R14out),
    .R15Out(R15out),
    .PCOut(PCout),
    .HIOut(HIout),
    .LOOut(LOout), 
    .ZOut(Zout),
    .MDRout(MDRout),
    .BusMuxOut(BusMuxOut)
    );

MDR #(32,32,32'h0) mdr1(clear, Clock, MDRin, Read, BusMuxOut, Mdatain, MDR_Q);
// MDR_Q is the 32-bit data output from the MDR register; MDRout remains the control signal
endmodule