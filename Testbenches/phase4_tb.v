`timescale 1ns/10ps
module phase4_tb;

    // Clock and control signals
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

    // Clock generation: 20ns period (50 MHz equivalent)
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // Monitor OutPort changes (7-segment display output)
    reg [31:0] prev_output;
    initial prev_output = 32'hDEADBEEF;
    always @(posedge Clock) begin
        if (Output_Data !== prev_output) begin
            $display("[%0t] OutPort changed: 0x%02H", $time, Output_Data[7:0]);
            prev_output <= Output_Data;
        end
    end

    // Main test sequence
    initial begin
        // Initialize control signals
        Reset = 1;
        Stop = 0;
        Strobe = 0;
        Input_Data = 32'h000000E0; // Switches set to 0xE0

        // Load Program into RAM

        // --- Phase 3 program (addresses 0x00 - 0x28) ---
        DUT.dp.ram1.mem[0]  = 32'h8A800043; // ldi R5, 0x43         ; R5=0x43
        DUT.dp.ram1.mem[1]  = 32'h8AA80006; // ldi R5, 6(R5)        ; R5=0x49
        DUT.dp.ram1.mem[2]  = 32'h82000089; // ld  R4, 0x89         ; R4=0xA7
        DUT.dp.ram1.mem[3]  = 32'h8A200004; // ldi R4, 4(R4)        ; R4=0xAB
        DUT.dp.ram1.mem[4]  = 32'h8023FFF8; // ld  R0, -8(R4)       ; R0=0x68
        DUT.dp.ram1.mem[5]  = 32'h89000004; // ldi R2, 4            ; R2=4
        DUT.dp.ram1.mem[6]  = 32'h8A800087; // ldi R5, 0x87         ; R5=0x87
        DUT.dp.ram1.mem[7]  = 32'hAA980003; // brmi R5, 3           ; won't branch (R5=0x87 positive in 32-bit)
        DUT.dp.ram1.mem[8]  = 32'h8AA80005; // ldi R5, 5(R5)        ; R5=0x8C
        DUT.dp.ram1.mem[9]  = 32'h80ABFFFD; // ld  R1, -3(R5)       ; R1=mem[0x89]=0xA7
        DUT.dp.ram1.mem[10] = 32'hD0000000; // nop
        DUT.dp.ram1.mem[11] = 32'hA8900002; // brpl R1, 2           ; branch (R1=0xA7 positive)
        DUT.dp.ram1.mem[12] = 32'h89A80007; // ldi R3, 7(R5)        ; SKIPPED
        DUT.dp.ram1.mem[13] = 32'h8B9BFFFC; // ldi R7, -4(R3)       ; SKIPPED
        DUT.dp.ram1.mem[14] = 32'h03A90000; // add R7, R5, R2       ; R7=0x90
        DUT.dp.ram1.mem[15] = 32'h48880003; // addi R1, R1, 3       ; R1=0xAA
        DUT.dp.ram1.mem[16] = 32'h70880000; // neg R1, R1           ; R1=0xFFFFFF56
        DUT.dp.ram1.mem[17] = 32'h78880000; // not R1, R1           ; R1=0xA9
        DUT.dp.ram1.mem[18] = 32'h5088000F; // andi R1, R1, 0xF     ; R1=9
        DUT.dp.ram1.mem[19] = 32'h3A010000; // ror R4, R0, R2       ; R4=0x80000006
        DUT.dp.ram1.mem[20] = 32'h58A00005; // ori R1, R4, 5        ; R1=0x80000007
        DUT.dp.ram1.mem[21] = 32'h2A090000; // shra R4, R1, R2      ; R4=0xF8000000
        DUT.dp.ram1.mem[22] = 32'h22A90000; // shr R5, R5, R2       ; R5=0x8
        DUT.dp.ram1.mem[23] = 32'h928000A3; // st 0xA3, R5          ; mem[0xA3]=0x8
        DUT.dp.ram1.mem[24] = 32'h42810000; // rol R5, R0, R2       ; R5=0x680
        DUT.dp.ram1.mem[25] = 32'h1B900000; // or  R7, R2, R0       ; R7=0x6C
        DUT.dp.ram1.mem[26] = 32'h12280000; // and R4, R5, R0       ; R4=0
        DUT.dp.ram1.mem[27] = 32'h93A00089; // st 0x89(R4), R7      ; mem[0x89]=0x6C
        DUT.dp.ram1.mem[28] = 32'h082B8000; // sub R0, R5, R7       ; R0=0x614
        DUT.dp.ram1.mem[29] = 32'h32290000; // shl R4, R5, R2       ; R4=0x6800
        DUT.dp.ram1.mem[30] = 32'h8B800007; // ldi R7, 7            ; R7=7
        DUT.dp.ram1.mem[31] = 32'h89800019; // ldi R3, 0x19         ; R3=0x19
        DUT.dp.ram1.mem[32] = 32'h69B80000; // mul R3, R7           ; HI=0, LO=0xAF
        DUT.dp.ram1.mem[33] = 32'hB0800000; // mfhi R1              ; R1=0
        DUT.dp.ram1.mem[34] = 32'hBB000000; // mflo R6              ; R6=0xAF
        DUT.dp.ram1.mem[35] = 32'h61B80000; // div R3, R7           ; HI=4, LO=3
        DUT.dp.ram1.mem[36] = 32'h8C380002; // ldi R8, 2(R7)        ; R8=9
        DUT.dp.ram1.mem[37] = 32'h8C9BFFFC; // ldi R9, -4(R3)       ; R9=0x15
        DUT.dp.ram1.mem[38] = 32'h8D300003; // ldi R10, 3(R6)       ; R10=0xB2
        DUT.dp.ram1.mem[39] = 32'h8D880005; // ldi R11, 5(R1)       ; R11=5
        DUT.dp.ram1.mem[40] = 32'h9D600000; // jal R10              ; PC->R12=0x29, PC<-R10=0xB2

        // --- Phase 4 new code (addresses 0x29 - 0x3B) ---
        DUT.dp.ram1.mem[41] = 32'hCB000000; // in R6                ; R6 <- InPort (0xE0 from switches)
        DUT.dp.ram1.mem[42] = 32'h93000077; // st 0x77, R6          ; mem[0x77] = R6 (save for reload)
        DUT.dp.ram1.mem[43] = 32'h8980002E; // ldi R3, 0x2E         ; R3 = address of "loop"
        DUT.dp.ram1.mem[44] = 32'h8A800001; // ldi R5, 1            ; R5 = 1 (shift amount)
        DUT.dp.ram1.mem[45] = 32'h89000028; // ldi R2, 40           ; R2 = 40 (loop counter: 5*8)
        DUT.dp.ram1.mem[46] = 32'hC3000000; // loop: out R6         ; display R6 on 7-seg
        DUT.dp.ram1.mem[47] = 32'h8917FFFF; // ldi R2, -1(R2)       ; R2 = R2 - 1
        DUT.dp.ram1.mem[48] = 32'hA9000008; // brzr R2, 8           ; if R2==0 goto done
        DUT.dp.ram1.mem[49] = 32'h83800088; // ld R7, 0x88          ; R7 = mem[0x88] = delay value
        DUT.dp.ram1.mem[50] = 32'h8BBFFFFF; // loop2: ldi R7, -1(R7); R7 = R7 - 1
        DUT.dp.ram1.mem[51] = 32'hD0000000; // nop
        DUT.dp.ram1.mem[52] = 32'hAB8FFFFD; // brnz R7, -3          ; if R7!=0 goto loop2
        DUT.dp.ram1.mem[53] = 32'h23328000; // shr R6, R6, R5       ; R6 = R6 >> 1
        DUT.dp.ram1.mem[54] = 32'hAB0FFFF7; // brnz R6, -9          ; if R6!=0 goto loop
        DUT.dp.ram1.mem[55] = 32'h83000077; // ld R6, 0x77          ; R6 = mem[0x77] (reload 0xE0)
        DUT.dp.ram1.mem[56] = 32'hA1800000; // jr R3                ; goto loop (R3=0x2E)
        DUT.dp.ram1.mem[57] = 32'h8B000063; // done: ldi R6, 0x63   ; R6 = 0x63
        DUT.dp.ram1.mem[58] = 32'hC3000000; // out R6               ; display 0x63
        DUT.dp.ram1.mem[59] = 32'hD8000000; // halt

        // --- Subroutine subA at address 0xB2 ---
        DUT.dp.ram1.mem[178] = 32'h07450000; // add R14, R8, R10     ; R14=0xBB
        DUT.dp.ram1.mem[179] = 32'h0ECD8000; // sub R13, R9, R11     ; R13=0x10
        DUT.dp.ram1.mem[180] = 32'h0F768000; // sub R14, R14, R13    ; R14=0xAB
        DUT.dp.ram1.mem[181] = 32'hA6000000; // jr R12               ; return

        // --- Initialize memory data locations ---
        DUT.dp.ram1.mem[137] = 32'h000000A7; // mem[0x89] = 0xA7
        DUT.dp.ram1.mem[163] = 32'h00000068; // mem[0xA3] = 0x68
        // Phase 4: delay counter value
        // Use 0x000F for fast simulation, 0x0000FFFF for full test
        DUT.dp.ram1.mem[136] = 32'h0000000F; // mem[0x88] = 0x000F (fast sim)
        // DUT.dp.ram1.mem[136] = 32'h0000FFFF; // mem[0x88] = 0xFFFF (full delay)

        // Release Reset after a few clock cycles
        #65 Reset = 0;

        // Pre-load InPort with input data (0xE0) via Strobe
        // Must be done AFTER reset release so Clear doesn't erase it
        @(posedge Clock);
        Strobe = 1;
        @(posedge Clock);
        Strobe = 0;

        // Wait for processor to halt (Run goes low)
        wait (Run == 0);
        #40; // let signals settle
    end

endmodule
