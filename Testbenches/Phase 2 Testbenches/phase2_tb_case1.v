`timescale 1ns/10ps

module phase2_tb_case1;
    // Clock and Reset
    reg Clock, clear;

    // Control Signals
    reg PCout, Zout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, IncPC;
    reg HIin, LOin, HIout, LOout;
    reg SelZ;
    reg [4:0] controlSignal;
    reg Gra, Grb, Grc, Rin, Rout, BAout, Cout, Read, Write, CONin;
    reg OutPortin, InPortout, Strobe;

    // Data buses
    wire [31:0] BusMuxOut;
    wire CON_out;
    reg [31:0] Input_Data;
    wire [31:0] Output_Data;

    // FSM States
    parameter Default = 4'd0, T0 = 4'd1, T1 = 4'd2, T2 = 4'd3,
              T3 = 4'd4, T4 = 4'd5, T5 = 4'd6, T6 = 4'd7, T7 = 4'd8;
    reg [3:0] Present_state = Default;

    // Instantiate DataPath
    DataPath DUT (
        .Clock(Clock), .clear(clear),
        .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout), .Cout(Cout),
        .PCin(PCin), .HIin(HIin), .LOin(LOin), .Zin(Zin), .MARin(MARin), .MDRin(MDRin),
        .Yin(Yin), .IRin(IRin), .IncPC(IncPC), .Read(Read), .Write(Write),
        .PCout(PCout), .HIout(HIout), .LOout(LOout), .MDRout(MDRout), .Zout(Zout),
        .SelZ(SelZ), .controlSignal(controlSignal),
        .conIn(CONin), .conOut(CON_out),
        .OutPortin(OutPortin), .InPortout(InPortout), .Strobe(Strobe),
        .Input_Data(Input_Data), .Output_Data(Output_Data),
        .BusMuxOut(BusMuxOut)
    );

    // Generate Clock
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // Simulation Initialization & Memory Setup
    initial begin
        // Reset the system
        Present_state = Default;
        // Case 1: ld R7, 0x65
        DUT.ram1.mem[0] = 32'h03800065;
        // Target memory initialization: mem[0x65] = 0x84 [cite: 598]
        DUT.ram1.mem[9'h065] = 32'h00000084;
    end

    // FSM State Transitions
    always @(negedge Clock) begin
        if (clear) begin
            Present_state <= Default;
        end else begin
            case (Present_state)
                Default : Present_state <= T0;
                T0 : Present_state <= T1;
                T1 : Present_state <= T2;
                T2 : Present_state <= T3;
                T3 : Present_state <= T4;
                T4 : Present_state <= T5;
                T5 : Present_state <= T6;
                T6 : Present_state <= T7;
                T7 : Present_state <= Default; // Loop or Halt
            endcase
        end
    end

    // FSM Control Signal Outputs for ld instruction
    always @(*) begin
        // Default: De-assert all signals
        PCout = 0; Zout = 0; MDRout = 0; MARin = 0; Zin = 0;
        PCin = 0; MDRin = 0; IRin = 0; Yin = 0; IncPC = 0;
        Read = 0; Write = 0; Gra = 0; Grb = 0; Grc = 0;
        Rin = 0; Rout = 0; BAout = 0; Cout = 0; CONin = 0;
        controlSignal = 5'd0; // ADD default

        case (Present_state)
            T0: begin
                PCout = 1; MARin = 1; IncPC = 1; Zin = 1;
                #15 PCout = 0; MARin = 0; IncPC = 0; Zin = 0;
            end
            T1: begin
                Zout = 1; SelZ = 0; PCin = 1; Read = 1; MDRin = 1;
                #15 Zout = 0; PCin = 0; Read = 0; MDRin = 0;
            end
            T2: begin
                MDRout = 1; IRin = 1;
                #15 MDRout = 0; IRin = 0;
            end
            T3: begin
                Grb = 1; BAout = 1; Yin = 1;
                #15 Grb = 0; BAout = 0; Yin = 0;
            end
            T4: begin
                Cout = 1; controlSignal = 5'd0; Zin = 1; // ADD
                #15 Cout = 0; controlSignal = 5'd0; Zin = 0;
            end
            T5: begin
                Zout = 1; SelZ = 0; MARin = 1;
                #15 Zout = 0; MARin = 0;
            end
            T6: begin
                Read = 1; MDRin = 1;
                #15 Read = 0; MDRin = 0;
            end
            T7: begin
                MDRout = 1; Gra = 1; Rin = 1;
                #15 MDRout = 0; Gra = 0; Rin = 0;
            end
        endcase
    end

endmodule
 
