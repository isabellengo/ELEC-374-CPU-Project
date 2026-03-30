`timescale 1ns/10ps
module MiniSRC (
    input wire Clock, Reset, Stop,
    input wire Strobe,
    input wire [31:0] Input_Data,
    output wire [31:0] Output_Data,
    output wire Run
);

// Internal wires: control signals from Control Unit to DataPath
wire Gra, Grb, Grc, Rin, Rout, BAout, Cout;
wire PCin, HIin, LOin, Zin, MARin, MDRin, MDRout;
wire Yin, IRin, IncPC, Read, Write;
wire PCout, HIout, LOout, Zout, SelZ;
wire CONin;
wire OutPortin, InPortout;
wire Clear;
wire [4:0] controlSignal;

// Feedback wires: DataPath to Control Unit
wire [31:0] IR_out;
wire CON_FF;
wire [31:0] BusMuxOut;

// Instantiate Control Unit
control_unit cu (
    .Clock(Clock), .Reset(Reset), .Stop(Stop), .CON_FF(CON_FF),
    .IR(IR_out),
    .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout), .Cout(Cout),
    .PCin(PCin), .HIin(HIin), .LOin(LOin), .Zin(Zin), .MARin(MARin), .MDRin(MDRin), .MDRout(MDRout),
    .Yin(Yin), .IRin(IRin), .IncPC(IncPC), .Read(Read), .Write(Write),
    .PCout(PCout), .HIout(HIout), .LOout(LOout), .Zout(Zout), .SelZ(SelZ),
    .CONin(CONin),
    .OutPortin(OutPortin), .InPortout(InPortout),
    .Run(Run), .Clear(Clear),
    .controlSignal(controlSignal)
);

// Instantiate DataPath
DataPath dp (
    .Clock(Clock), .clear(Clear),
    .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout), .Cout(Cout),
    .PCin(PCin), .HIin(HIin), .LOin(LOin), .Zin(Zin), .MARin(MARin), .MDRin(MDRin),
    .Yin(Yin), .IRin(IRin), .IncPC(IncPC), .Read(Read), .Write(Write),
    .PCout(PCout), .HIout(HIout), .LOout(LOout), .MDRout(MDRout), .Zout(Zout),
    .SelZ(SelZ), .controlSignal(controlSignal),
    .conIn(CONin), .conOut(CON_FF),
    .OutPortin(OutPortin), .InPortout(InPortout), .Strobe(Strobe),
    .Input_Data(Input_Data), .Output_Data(Output_Data),
    .BusMuxOut(BusMuxOut),
    .IR_out(IR_out)
);

endmodule
