`timescale 1ns/10ps
module phase3_tb;

    // Clock and control
    reg Clock, Reset, Stop;
    reg Strobe;
    reg [31:0] Input_Data;
    wire [31:0] Output_Data;
    wire Run;

    // Instantiate MiniSRC top-level
    MiniSRC DUT (
        .Clock(Clock), .Reset(Reset), .Stop(Stop),
        .Strobe(Strobe),
        .Input_Data(Input_Data),
        .Output_Data(Output_Data),
        .Run(Run)
    );

    // Generate Clock: 20ns period
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // Main test sequence
    initial begin
        // Initialize
        Reset = 1;
        Stop = 0;
        Strobe = 0;
        Input_Data = 32'd0;

        // Display Results
        $display("Phase 3 Contents beforte program");
        $display("");
        $display("--- Registers ---");
        $display("R0  = 0x%08H  ", DUT.dp.R0.q);
        $display("R1  = 0x%08H  ", DUT.dp.R1.q);
        $display("R2  = 0x%08H  ", DUT.dp.R2.q);
        $display("R3  = 0x%08H  ", DUT.dp.R3.q);
        $display("R4  = 0x%08H  ", DUT.dp.R4.q);
        $display("R5  = 0x%08H  ", DUT.dp.R5.q);
        $display("R6  = 0x%08H  ", DUT.dp.R6.q);
        $display("R7  = 0x%08H  ", DUT.dp.R7.q);
        $display("R8  = 0x%08H  ", DUT.dp.R8.q);
        $display("R9  = 0x%08H  ", DUT.dp.R9.q);
        $display("R10 = 0x%08H  ", DUT.dp.R10.q);
        $display("R11 = 0x%08H  ", DUT.dp.R11.q);
        $display("R12 = 0x%08H  ", DUT.dp.R12.q);
        $display("R13 = 0x%08H  ", DUT.dp.R13.q);
        $display("R14 = 0x%08H  ", DUT.dp.R14.q);
        $display("R15 = 0x%08H  ", DUT.dp.R15.q);
        $display("");
        $display("PC  = 0x%08H  ", DUT.dp.PC.q);
        $display("HI  = 0x%08H  ", DUT.dp.HI.q);
        $display("LO  = 0x%08H  ", DUT.dp.LO.q);
        $display("IR  = 0x%08H  ", DUT.dp.IR.q);
        $display("");
        $display("--- Memory ---");
        $display("mem[0x89] = 0x%08H  ", DUT.dp.ram1.mem[137]);
        $display("mem[0xA3] = 0x%08H  ", DUT.dp.ram1.mem[163]);
        $display("");
        $display("--- Status ---");
        $display("Run = %b ", Run);
        $finish;

        DUT.dp.ram1.mem[0] = 32'h8A800043; // ldi R5, 0x43
        DUT.dp.ram1.mem[1] = 32'h8AA80006; // ldi R5, 6(R5)
        DUT.dp.ram1.mem[2] = 32'h82000089; // ld R4, 0x89
        DUT.dp.ram1.mem[3] = 32'h8A200004; // ldi R4, 4(R4)
        DUT.dp.ram1.mem[4] = 32'h8023FFF8; // ld R0, -8(R4)
        DUT.dp.ram1.mem[5] = 32'h89000004; // ldi R2, 4
        DUT.dp.ram1.mem[6] = 32'h8A800087; // ldi R5, 0x87
        DUT.dp.ram1.mem[7] = 32'hAA980003; // brmi R5, 3
        DUT.dp.ram1.mem[8] = 32'h8AA80005; // ldi R5, 5(R5)
        DUT.dp.ram1.mem[9] = 32'h80ABFFFD; // ld R1, -3(R5)
        DUT.dp.ram1.mem[10] = 32'hD0000000; // nop
        DUT.dp.ram1.mem[11] = 32'hA8900002; // brpl R1, 2
        DUT.dp.ram1.mem[12] = 32'h89A80007; // ldi R3, 7(R5) (skipped by branch)
        DUT.dp.ram1.mem[13] = 32'h8B9BFFFC; // ldi R7, -4(R3) (skipped by branch)
        DUT.dp.ram1.mem[14] = 32'h03A90000; // target: add R7, R5, R2
        DUT.dp.ram1.mem[15] = 32'h48880003; // addi R1, R1, 3
        DUT.dp.ram1.mem[16] = 32'h70880000; // neg R1, R1
        DUT.dp.ram1.mem[17] = 32'h78880000; // not R1, R1
        DUT.dp.ram1.mem[18] = 32'h5088000F; // andi R1, R1, 0xF
        DUT.dp.ram1.mem[19] = 32'h3A010000; // ror R4, R0, R2
        DUT.dp.ram1.mem[20] = 32'h58A00005; // ori R1, R4, 5
        DUT.dp.ram1.mem[21] = 32'h2A090000; // shra R4, R1, R2
        DUT.dp.ram1.mem[22] = 32'h22A90000; // shr R5, R5, R2
        DUT.dp.ram1.mem[23] = 32'h928000A3; // st 0xA3, R5
        DUT.dp.ram1.mem[24] = 32'h42810000; // rol R5, R0, R2
        DUT.dp.ram1.mem[25] = 32'h1B900000; // or R7, R2, R0
        DUT.dp.ram1.mem[26] = 32'h12280000; // and R4, R5, R0
        DUT.dp.ram1.mem[27] = 32'h93A00089; // st 0x89(R4), R7
        DUT.dp.ram1.mem[28] = 32'h082B8000; // sub R0, R5, R7
        DUT.dp.ram1.mem[29] = 32'h32290000; // shl R4, R5, R2
        DUT.dp.ram1.mem[30] = 32'h8B800007; // ldi R7, 7
        DUT.dp.ram1.mem[31] = 32'h89800019; // ldi R3, 0x19
        DUT.dp.ram1.mem[32] = 32'h69B80000; // mul R3, R7
        DUT.dp.ram1.mem[33] = 32'hB0800000; // mfhi R1
        DUT.dp.ram1.mem[34] = 32'hBB000000; // mflo R6
        DUT.dp.ram1.mem[35] = 32'h61B80000; // div R3, R7
        DUT.dp.ram1.mem[36] = 32'h8C380002; // ldi R8, 2(R7)
        DUT.dp.ram1.mem[37] = 32'h8C9BFFFC; // ldi R9, -4(R3)
        DUT.dp.ram1.mem[38] = 32'h8D300003; // ldi R10, 3(R6)
        DUT.dp.ram1.mem[39] = 32'h8D880005; // ldi R11, 5(R1)
        DUT.dp.ram1.mem[40] = 32'h9D600000; // jal R10
        DUT.dp.ram1.mem[41] = 32'hD8000000; // halt

        // Subroutine subA at address 0xB2
        DUT.dp.ram1.mem[178] = 32'h07450000; // add R14, R8, R10
        DUT.dp.ram1.mem[179] = 32'h0ECD8000; // sub R13, R9, R11
        DUT.dp.ram1.mem[180] = 32'h0F768000; // sub R14, R14, R13
        DUT.dp.ram1.mem[181] = 32'hA6000000; // jr R12

        // Initialize memory data locations
        DUT.dp.ram1.mem[137] = 32'h000000A7; // mem[0x89] = 0xA7
        DUT.dp.ram1.mem[163] = 32'h00000068; // mem[0xA3] = 0x68

        // Release Reset after 3 clock cycles
        #65 Reset = 0;

        // Wait for processor to stop (Run goes low)
        wait (Run == 0);
        #40; // add delay

        // Display Results
        $display("Phase 3 Simulation Results");
        $display("");
        $display("--- Registers ---");
        $display("R0  = 0x%08H  ", DUT.dp.R0.q);
        $display("R1  = 0x%08H  ", DUT.dp.R1.q);
        $display("R2  = 0x%08H  ", DUT.dp.R2.q);
        $display("R3  = 0x%08H  ", DUT.dp.R3.q);
        $display("R4  = 0x%08H  ", DUT.dp.R4.q);
        $display("R5  = 0x%08H  ", DUT.dp.R5.q);
        $display("R6  = 0x%08H  ", DUT.dp.R6.q);
        $display("R7  = 0x%08H  ", DUT.dp.R7.q);
        $display("R8  = 0x%08H  ", DUT.dp.R8.q);
        $display("R9  = 0x%08H  ", DUT.dp.R9.q);
        $display("R10 = 0x%08H  ", DUT.dp.R10.q);
        $display("R11 = 0x%08H  ", DUT.dp.R11.q);
        $display("R12 = 0x%08H  ", DUT.dp.R12.q);
        $display("R13 = 0x%08H  ", DUT.dp.R13.q);
        $display("R14 = 0x%08H  ", DUT.dp.R14.q);
        $display("R15 = 0x%08H  ", DUT.dp.R15.q);
        $display("");
        $display("PC  = 0x%08H  ", DUT.dp.PC.q);
        $display("HI  = 0x%08H  ", DUT.dp.HI.q);
        $display("LO  = 0x%08H  ", DUT.dp.LO.q);
        $display("IR  = 0x%08H  ", DUT.dp.IR.q);
        $display("");
        $display("--- Memory ---");
        $display("mem[0x89] = 0x%08H  ", DUT.dp.ram1.mem[137]);
        $display("mem[0xA3] = 0x%08H  ", DUT.dp.ram1.mem[163]);
        $display("");
        $display("--- Status ---");
        $display("Run = %b ", Run);
        $finish;    
    end

endmodule
