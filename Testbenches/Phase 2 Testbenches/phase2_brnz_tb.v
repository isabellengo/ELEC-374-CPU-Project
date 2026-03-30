`timescale 1ns/10ps
module phase2_brnz_tb;
 
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
        .Input_Data(Input_Data), .Output_Data(Output_Data), .BusMuxOut(BusMuxOut)
    );
    // Generate Clock
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end
    // Simulation Initialization & Memory Setup
    initial begin
        // Reset the system
        clear = 1;
        Present_state = Default;

        DUT.ram1.mem[0] = 32'h99900030; 
        #15 clear = 0; // Release reset

        // Preload R3 = 5 
        // Expected: PC = PC_after_fetch(1) + 48 = 0x31
        DUT.R3.q = 32'h00000005;
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
                T6 : Present_state <= Default; // Done
            endcase
        end
    end
    
    always @(*) begin
        // Default: De-assert all signals
        PCout = 0; Zout = 0; MDRout = 0; MARin = 0; Zin = 0;
        PCin = 0; MDRin = 0; IRin = 0; Yin = 0; IncPC = 0;
        Read = 0; Write = 0; Gra = 0; Grb = 0; Grc = 0;
        Rin = 0; Rout = 0; BAout = 0; Cout = 0; CONin = 0;
        HIin = 0; LOin = 0; HIout = 0; LOout = 0;
        OutPortin = 0; InPortout = 0; Strobe = 0;
        SelZ = 0;
        controlSignal = 5'd0; 
        case (Present_state)
            T0: begin
                PCout = 1; MARin = 1; IncPC = 1; Zin = 1;
            end
            T1: begin
                Zout = 1; SelZ = 0; PCin = 1; Read = 1; MDRin = 1;
            end
            T2: begin
                MDRout = 1; IRin = 1;
            end
            T3: begin
                Gra = 1; Rout = 1; CONin = 1;
            end
            T4: begin
                PCout = 1; Yin = 1;
            end
            T5: begin
                Cout = 1; controlSignal = 5'd0; Zin = 1; // ADD
            end
            T6: begin
                Zout = 1; SelZ = 0;
                if (CON_out) PCin = 1;
            end
        endcase
    end
 
endmodule
