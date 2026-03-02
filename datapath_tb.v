// and datapath_tb.v file: <This is the filename>
`timescale 1ns/10ps
module datapath_tb;
 reg PCout, Zout, MDRout, R5out, R6out, R7out, R1out, R3out, R0out, R4out; // add any other signals to see in your simulation
 reg MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin;
 reg IncPC, Read, AND, R2in, R5in, R6in, R1in, R3in, R7in, R0in, R4in; // add any other signals to see in your simulation
 reg Clock;
 reg clear;
 reg SelZ;
 reg [31:0] Mdatain;
 reg [4:0] controlSignal;
 wire [31:0] BusMuxOut;
 
 parameter Default = 16'd0, Reg_load1a = 16'd1, Reg_load1b = 16'd2, Reg_load2a = 16'd3,
 Reg_load2b = 16'd4, Reg_load3a = 16'd5, Reg_load3b = 16'd6, T0 = 16'd7,
 T1 = 16'd8, T2 = 16'd9, T3 = 16'd10, T4 = 16'd11, T5 = 16'd12, T6 = 16'd13, 
 T7 = 16'd14, T8 = 16'd15, T9 = 16'd16, T10 = 16'd17, T11 = 16'd18, T12 = 16'd19, 
 T13 = 16'd20, T14 = 16'd21, T15 = 16'd22, T16 = 16'd23, T17 = 16'd24, T18 = 16'd25, 
 T19 = 16'd26, T20 = 16'd27, T21 = 16'd28, T22 = 16'd29, T23 = 16'd30, 
 Reg_load4a = 16'd31, Reg_load4b = 16'd32, Reg_load5a = 16'd33, Reg_load5b = 16'd34,
 T24 = 16'd35, T25 = 16'd36, T26 = 16'd37, T27 = 16'd38, T28 = 16'd39, T29 = 16'd40, T30 = 16'd41,
 T31 = 16'd42, T32 = 16'd43, T33 = 16'd44, T34 = 16'd45, T35 = 16'd46, T36 = 16'd47, T37 = 16'd48,
 Reg_load6a = 16'd49, Reg_load6b = 16'd50, Reg_load7a = 16'd51, Reg_load7b = 16'd52, Reg_load8a = 16'd53, Reg_load8b = 16'd54,
 T38 = 16'd55, T39 = 16'd56, T40 = 16'd57, T41 = 16'd58, T42 = 16'd59, T43 = 16'd60,
 T44 = 16'd61, T45 = 16'd62, T46 = 16'd63, T47 = 16'd64, T48 = 16'd65, T49 = 16'd66,
 T50 = 16'd67, T51 = 16'd68, T52 = 16'd69, T53 = 16'd70, T54 = 16'd71, T55 = 16'd72,
 T56 = 16'd73, T57 = 16'd74, T58 = 16'd75, T59 = 16'd76, T60 = 16'd77, T61 = 16'd78,
 T62 = 16'd79, T63 = 16'd80, T64 = 16'd81, T65 = 16'd82, T66 = 16'd83, T67 = 16'd84,
 T68 = 16'd85, T69 = 16'd86, T70 = 16'd87, T71 = 16'd88, T72 = 16'd89,
 T73 = 16'd90, T74 = 16'd91, T75 = 16'd92, T76 = 16'd93, T77 = 16'd94;
 
 reg [15:0] Present_state = Default;

 DataPath DUT(.PCout(PCout),
            .MDRout(MDRout),
            .R0out(R0out),
            .R1out(R1out),
            .R2out(R2out),
            .R3out(R3out),
            .R4out(R4out),
            .R5out(R5out),
            .R6out(R6out),
            .R7out(R7out),
            .R8out(R8out),
            .R9out(R9out),
            .R10out(R10out),
            .R11out(R11out),
            .R12out(R12out),
            .R13out(R13out),
            .R14out(R14out),
            .R15out(R15out),
            .HIout(HIout),
            .LOout(LOout),
            .Zout(Zout),
            .SelZ(SelZ),

            .MARin(MARin),
            .Zin(Zin),
            .PCin(PCin),
            .MDRin(MDRin),
            .IRin(IRin), 
            .Yin(Yin), 
            .IncPC(IncPC), 
            .HIin(HIin),
            .LOin(LOin),
            .Read(Read), 
            .R0in(R0in),
            .R1in(R1in),
            .R2in(R2in),
            .R3in(R3in),
            .R4in(R4in),
            .R5in(R5in), 
            .R6in(R6in), 
            .R7in(R7in),
            .R8in(R8in),
            .R9in(R9in),
            .R10in(R10in),
            .R11in(R11in),
            .R12in(R12in),
            .R13in(R13in),
            .R14in(R14in),
            .R15in(R15in),
            .Clock(Clock),
            .clear(clear),
            .Mdatain(Mdatain),
            .controlSignal(controlSignal),
            .BusMuxOut(BusMuxOut));
// add test logic here
initial
 begin
 Clock = 1;
 forever #10 Clock = ~ Clock;
end
always @(negedge Clock) // finite state machine; if clock rising-edge
 begin
    case (Present_state)
        // AND Section
        Default : Present_state = Reg_load1a;
        Reg_load1a : Present_state = Reg_load1b;
        Reg_load1b : Present_state = Reg_load2a;
        Reg_load2a : Present_state = Reg_load2b;
        Reg_load2b : Present_state = Reg_load3a;
        Reg_load3a : Present_state = Reg_load3b;
        Reg_load3b : Present_state = T0;

        // AND Section
        T0 : Present_state = T1;
        T1 : Present_state = T2;
        T2 : Present_state = T3;
        T3 : Present_state = T4;
        T4 : Present_state = T5;
        T5 : Present_state = T6;

        // OR Section
        T6 : Present_state = T7;
        T7 : Present_state = T8;
        T8 : Present_state = T9;
        T9 : Present_state = T10;
        T10 : Present_state = T11;
        T11 : Present_state = T12;

        // AND Section
        T12 : Present_state = T13;
        T13 : Present_state = T14;
        T14 : Present_state = T15;
        T15 : Present_state = T16;
        T16 : Present_state = T17;
        T17 : Present_state = T18;

        // SUB Section
        T18 : Present_state = T19;
        T19 : Present_state = T20;
        T20 : Present_state = T21;
        T21 : Present_state = T22;
        T22 : Present_state = T23;
        T23 : Present_state = Reg_load4a;

        // Load reg 1 and 3
        Reg_load4a : Present_state = Reg_load4b;
        Reg_load4b : Present_state = Reg_load5a;
        Reg_load5a : Present_state = Reg_load5b;
        Reg_load5b : Present_state = T24;

        // MUL Section 
        T24 : Present_state = T25;
        T25 : Present_state = T26;
        T26 : Present_state = T27;
        T27 : Present_state = T28;
        T28 : Present_state = T29;
        T29 : Present_state = T30;
        T30 : Present_state = T31;

        // DIV Section 
        T31 : Present_state = T32;
        T32 : Present_state = T33;
        T33 : Present_state = T34;
        T34 : Present_state = T35;
        T35 : Present_state = T36;
        T36 : Present_state = T37;
        T37 : Present_state = Reg_load6a;

        // Load reg 7, 0, 4
        Reg_load6a : Present_state = Reg_load6b;
        Reg_load6b : Present_state = Reg_load7a;
        Reg_load7a : Present_state = Reg_load7b;
        Reg_load7b : Present_state = Reg_load8a;
        Reg_load8a : Present_state = Reg_load8b;
        Reg_load8b : Present_state = T38;

        // SHR Section
        T38 : Present_state = T39;
        T39 : Present_state = T40;
        T40 : Present_state = T41;
        T41 : Present_state = T42;
        T42 : Present_state = T43;
        T43 : Present_state = T44;

        // SHRA Section
        T44 : Present_state = T45;
        T45 : Present_state = T46;
        T46 : Present_state = T47;
        T47 : Present_state = T48;
        T48 : Present_state = T49;
        T49 : Present_state = T50;

        // SHL Section
        T50 : Present_state = T51;
        T51 : Present_state = T52;
        T52 : Present_state = T53;
        T53 : Present_state = T54;
        T54 : Present_state = T55;
        T55 : Present_state = T56;

        // ROR Section
        T56 : Present_state = T57;
        T57 : Present_state = T58;
        T58 : Present_state = T59;
        T59 : Present_state = T60;
        T60 : Present_state = T61;
        T61 : Present_state = T62;

        // ROL Section
        T62 : Present_state = T63;
        T63 : Present_state = T64;
        T64 : Present_state = T65;
        T65 : Present_state = T66;
        T66 : Present_state = T67;
        T67 : Present_state = T68;

        // NEG Section
        T68 : Present_state = T69;
        T69 : Present_state = T70;
        T70 : Present_state = T71;
        T71 : Present_state = T72;
        T72 : Present_state = T73;

        // NOT Section
        T73 : Present_state = T74;
        T74 : Present_state = T75;
        T75 : Present_state = T76;
        T76 : Present_state = T77;
        T77 : Present_state = Default;

    endcase
 end

always @(Present_state) // do the required job in each state
 begin
    case (Present_state) // assert the required signals in each clock cycle
        Default: begin
        PCout <= 0; Zout <= 0; MDRout <= 0; // initialize the signals
        R3out <= 0; R7out <= 0; MARin <= 0; Zin <= 0;
        PCin <=0; MDRin <= 0; IRin <= 0; Yin <= 0;
        IncPC <= 0; Read <= 0; AND <= 0;
        R2in <= 0; R5in <= 0; R6in <= 0; Mdatain <= 32'h00000000;
        controlSignal <= 5'b00000; SelZ <= 0; 
        end
        Reg_load1a: begin
            Mdatain <= 32'h00000034;
            Read = 0; MDRin = 0; // the first zero is there for completeness
            Read <= 1; MDRin <= 1; // Took out #15 for '1', as it may not be needed
            #15 Read <= 0; MDRin <= 0; // for your current implementation
        end
        Reg_load1b: begin
            MDRout <= 1; R5in <= 1;
            #15 MDRout <= 0; R5in <= 0; // initialize R5 with the value 0x34
        end
        Reg_load2a: begin
            Mdatain <= 32'h00000045;
            Read <= 1; MDRin <= 1;
            #15 Read <= 0; MDRin <= 0;
        end
        Reg_load2b: begin
            MDRout <= 1; R6in <= 1;
            #15 MDRout <= 0; R6in <= 0; // initialize R6 with the value 0x45
        end
        Reg_load3a: begin
            Mdatain <= 32'h00000067;
            Read <= 1; MDRin <= 1;
            #15 Read <= 0; MDRin <= 0;
        end
        Reg_load3b: begin
            MDRout <= 1; R2in <= 1;
            #15 MDRout <= 0; R2in <= 0; // initialize R2 with the value 0x67
        end

        // AND Section
        T0: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T1: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h112B0000; // opcode for “and R2, R5, R6”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T2: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T3: begin
            R5out <= 1; Yin <= 1;
            #15 R5out <= 0; Yin <= 0;
        end
        T4: begin
            R6out <= 1; controlSignal <= 5'b00010; Zin <= 1;
            #15 R6out <= 0; Zin <= 0;
        end
        T5: begin
            Zout <= 1; R2in <= 1;
            #15 Zout <= 0; R2in <= 0;
        end

        // OR Section
        T6: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T7: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h312B0000; // opcode for “or R2, R5, R6”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T8: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T9: begin
            R5out <= 1; Yin <= 1;
            #15 R5out <= 0; Yin <= 0;
        end
        T10: begin
            R6out <= 1; controlSignal <= 5'b00011; Zin <= 1;
            #15 R6out <= 0; Zin <= 0;
        end
        T11: begin
            Zout <= 1; R2in <= 1;
            #15 Zout <= 0; R2in <= 0;
        end

        // ADD Section
        T12: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T13: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h192B0000; // opcode for “add R2, R5, R6”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T14: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T15: begin
            R5out <= 1; Yin <= 1;
            #15 R5out <= 0; Yin <= 0;
        end
        T16: begin
            R6out <= 1; controlSignal <= 5'b00000; Zin <= 1;
            #15 R6out <= 0; Zin <= 0;
        end
        T17: begin
            Zout <= 1; R2in <= 1;
            #15 Zout <= 0; R2in <= 0;
        end

        // SUB Section
        T18: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T19: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h212B0000; // opcode for “sub R2, R5, R6”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T20: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T21: begin
            R5out <= 1; Yin <= 1;
            #15 R5out <= 0; Yin <= 0;
        end
        T22: begin
            R6out <= 1; controlSignal <= 5'b00001; Zin <= 1;
            #15 R6out <= 0; Zin <= 0;
        end
        T23: begin
            Zout <= 1; R2in <= 1;
            #15 Zout <= 0; R2in <= 0;
        end

        // Load reg 1 and 3
        Reg_load4a: begin
            Mdatain <= 32'h00000009;
            Read <= 1; MDRin <= 1;
            #15 Read <= 0; MDRin <= 0;
        end
        Reg_load4b: begin
            MDRout <= 1; R1in <= 1;
            #15 MDRout <= 0; R1in <= 0; // initialize R1 with the value 0x
        end
        Reg_load5a: begin
            Mdatain <= 32'h73;
            Read <= 1; MDRin <= 1;
            #15 Read <= 0; MDRin <= 0;
        end
        Reg_load5b: begin
            MDRout <= 1; R3in <= 1;
            #15 MDRout <= 0; R3in <= 0; // initialize R3 with the value 0x
        end

        // MUL Section
        T24: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T25: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h79880000; // opcode for “mul R2, R5, R6”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T26: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T27: begin
            R3out <= 1; Yin <= 1;
            #15 R3out <= 0; Yin <= 0;
        end
        T28: begin
            R1out <= 1; controlSignal <= 5'b01101; Zin <= 1;
            #15 R1out <= 0; Zin <= 0;
        end
        T29: begin
            Zout <= 1; LOin <= 1;
            #15 Zout <= 0; LOin <= 0;
        end
        T30: begin
            SelZ <= 1; Zout <= 1; HIin <= 1;
            #15 SelZ <= 0; Zout <= 0; HIin <= 0;
        end

        // DIV Section
        T31: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T32: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h81880000; // opcode for “div R2, R5, R6”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T33: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T34: begin
            R3out <= 1; Yin <= 1;
            #15 R3out <= 0; Yin <= 0;
        end
        T35: begin
            R1out <= 1; controlSignal <= 5'd12; Zin <= 1;
            #15 R1out <= 0; Zin <= 0;
        end
        T36: begin
            Zout <= 1; LOin <= 1;
            #15 Zout <= 0; LOin <= 0;
        end
        T37: begin
            SelZ <= 1; Zout <= 1; HIin <= 1;
            #15 SelZ <= 0; Zout <= 0; HIin <= 0;
        end       

        Reg_load6a: begin
            Mdatain <= 32'h00000000;
            Read = 0; MDRin = 0; // the first zero is there for completeness
            Read <= 1; MDRin <= 1; // Took out #15 for '1', as it may not be needed
            #15 Read <= 0; MDRin <= 0; // for your current implementation
        end
        Reg_load6b: begin
            MDRout <= 1; R7in <= 1;
            #15 MDRout <= 0; R7in <= 0; 
        end
        Reg_load7a: begin
            Mdatain <= 32'ha000_0000;
            Read <= 1; MDRin <= 1;
            #15 Read <= 0; MDRin <= 0;
        end
        Reg_load7b: begin
            MDRout <= 1; R0in <= 1;
            #15 MDRout <= 0; R0in <= 0; 
        end
        Reg_load8a: begin
            Mdatain <= 32'h2;
            Read <= 1; MDRin <= 1;
            #15 Read <= 0; MDRin <= 0;
        end
        Reg_load8b: begin
            MDRout <= 1; R4in <= 1;
            #15 MDRout <= 0; R4in <= 0; 
        end 

        // SHR Section
        T38: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T39: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h3B820000; // opcode for “shr ”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T40: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T41: begin
            R0out <= 1; Yin <= 1;
            #15 R0out <= 0; Yin <= 0;
        end
        T42: begin
            R4out <= 1; controlSignal <= 5'd4; Zin <= 1;
            #15 R4out <= 0; Zin <= 0;
        end
        T43: begin
            Zout <= 1; R7in <= 1;
            #15 Zout <= 0; R7in <= 0;
        end

        // SHRA Section
        T44: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T45: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h43820000; // opcode for “shra”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T46: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T47: begin
            R0out <= 1; Yin <= 1;
            #15 R0out <= 0; Yin <= 0;
        end
        T48: begin
            R4out <= 1; controlSignal <= 5'd5; Zin <= 1;
            #15 R4out <= 0; Zin <= 0;
        end
        T49: begin
            Zout <= 1; R7in <= 1;
            #15 Zout <= 0; R7in <= 0;
        end

        // SHL Section
        T50: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T51: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h48238000; // opcode for “shl”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T52: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T53: begin
            R0out <= 1; Yin <= 1;
            #15 R0out <= 0; Yin <= 0;
        end
        T54: begin
            R4out <= 1; controlSignal <= 5'd6; Zin <= 1;
            #15 R4out <= 0; Zin <= 0;
        end
        T55: begin
            Zout <= 1; R7in <= 1;
            #15 Zout <= 0; R7in <= 0;
        end

        // ROR Section
        T56: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T57: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h50238000; // opcode for “ror”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T58: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T59: begin
            R0out <= 1; Yin <= 1;
            #15 R0out <= 0; Yin <= 0;
        end
        T60: begin
            R4out <= 1; controlSignal <= 5'd7; Zin <= 1;
            #15 R4out <= 0; Zin <= 0;
        end
        T61: begin
            Zout <= 1; R7in <= 1;
            #15 Zout <= 0; R7in <= 0;
        end

        // ROL Section
        T62: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T63: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h58238000; // opcode for “rol”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T64: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T65: begin
            R0out <= 1; Yin <= 1;
            #15 R0out <= 0; Yin <= 0;
        end
        T66: begin
            R4out <= 1; controlSignal <= 5'd8; Zin <= 1;
            #15 R4out <= 0; Zin <= 0;
        end
        T67: begin
            Zout <= 1; R7in <= 1;
            #15 Zout <= 0; R7in <= 0;
        end

        // NEG Section
        T68: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T69: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h88200000; // opcode for “neg”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T70: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T71: begin
            R4out <= 1; controlSignal <= 5'd14; Zin <= 1;
            #15 R4out <= 0; Zin <= 0;
        end
        T72: begin
            Zout <= 1; R7in <= 1;
            #15 Zout <= 0; R7in <= 0;
        end

        // NOT Section
        T73: begin // see if you need to de-assert these signals
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end
        T74: begin
            Zout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h90200000; // opcode for “not”
            #15 Zout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end
        T75: begin
            MDRout <= 1; IRin <= 1;
            #15 MDRout <= 0; IRin <= 0;
        end
        T76: begin
            R4out <= 1; controlSignal <= 5'd15; Zin <= 1;
            #15 R4out <= 0; Zin <= 0;
        end
        T77: begin
            Zout <= 1; R7in <= 1;
            #15 Zout <= 0; R7in <= 0;
        end

        endcase
    end
endmodule 