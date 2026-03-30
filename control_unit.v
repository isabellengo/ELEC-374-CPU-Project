`timescale 1ns/10ps
module control_unit (
    input Clock, Reset, Stop, CON_FF,
    input [31:0] IR,
    output reg Gra, Grb, Grc, Rin, Rout, BAout, Cout,
    output reg PCin, HIin, LOin, Zin, MARin, MDRin, MDRout,
    output reg Yin, IRin, IncPC, Read, Write,
    output reg PCout, HIout, LOout, Zout, SelZ,
    output reg CONin,
    output reg OutPortin, InPortout,
    output reg Run, Clear,
    output reg [4:0] controlSignal
);

// Opcodes
parameter OP_ADD  = 5'd0,  OP_SUB  = 5'd1,  OP_AND  = 5'd2,  OP_OR   = 5'd3,
          OP_SHR  = 5'd4,  OP_SHRA = 5'd5,  OP_SHL  = 5'd6,  OP_ROR  = 5'd7,
          OP_ROL  = 5'd8,  OP_ADDI = 5'd9,  OP_ANDI = 5'd10, OP_ORI  = 5'd11,
          OP_DIV  = 5'd12, OP_MUL  = 5'd13, OP_NEG  = 5'd14, OP_NOT  = 5'd15,
          OP_LD   = 5'd16, OP_LDI  = 5'd17, OP_ST   = 5'd18,
          OP_JAL  = 5'd19, OP_JR   = 5'd20, OP_BR   = 5'd21,
          OP_MFHI = 5'd22, OP_MFLO = 5'd23,
          OP_OUT  = 5'd24, OP_IN   = 5'd25,
          OP_NOP  = 5'd26, OP_HALT = 5'd27;

// FSM states
parameter
    reset_state  = 7'd0,
    fetch0       = 7'd1,
    fetch1       = 7'd2,
    fetch2       = 7'd3,
    // ALU: add/sub/and/or/shr/shra/shl/ror/rol
    alu3         = 7'd4,
    alu4         = 7'd5,
    alu5         = 7'd6,
    // mul/div (extra steps for HI/LO)
    mul3         = 7'd7,
    mul4         = 7'd8,
    mul5         = 7'd9,
    mul6         = 7'd10,
    div3         = 7'd11,
    div4         = 7'd12,
    div5         = 7'd13,
    div6         = 7'd14,
    // neg/not (unary)
    neg3         = 7'd15,
    neg4         = 7'd16,
    neg5         = 7'd45,
    // ALU immediate: addi/andi/ori
    imm3         = 7'd17,
    imm4         = 7'd18,
    imm5         = 7'd19,
    // ld
    ld3          = 7'd20,
    ld4          = 7'd21,
    ld5          = 7'd22,
    ld6          = 7'd23,
    ld7          = 7'd24,
    // ldi
    ldi3         = 7'd25,
    ldi4         = 7'd26,
    ldi5         = 7'd27,
    // st
    st3          = 7'd28,
    st4          = 7'd29,
    st5          = 7'd30,
    st6          = 7'd31,
    st7          = 7'd32,
    // branch
    br3          = 7'd33,
    br4          = 7'd34,
    br5          = 7'd35,
    br6          = 7'd36,
    // jr
    jr3          = 7'd37,
    // jal
    jal3         = 7'd38,
    jal4         = 7'd39,
    // mfhi/mflo
    mfhi3        = 7'd40,
    mflo3        = 7'd41,
    // in/out
    in3          = 7'd42,
    out3         = 7'd43,
    // halt
    halt_state   = 7'd44;

reg [6:0] present_state = reset_state;

// State transitions
always @(negedge Clock, posedge Reset) begin
    if (Reset == 1'b1)
        present_state = reset_state;
    else begin
        case (present_state)
            reset_state: present_state = fetch0;
            fetch0:      present_state = fetch1;
            fetch1:      present_state = fetch2;
            fetch2: begin
                case (IR[31:27])
                    OP_ADD, OP_SUB, OP_AND, OP_OR,
                    OP_SHR, OP_SHRA, OP_SHL, OP_ROR, OP_ROL:
                                     present_state = alu3;
                    OP_MUL:          present_state = mul3;
                    OP_DIV:          present_state = div3;
                    OP_NEG, OP_NOT:  present_state = neg3;
                    OP_ADDI, OP_ANDI, OP_ORI:
                                     present_state = imm3;
                    OP_LD:           present_state = ld3;
                    OP_LDI:          present_state = ldi3;
                    OP_ST:           present_state = st3;
                    OP_BR:           present_state = br3;
                    OP_JR:           present_state = jr3;
                    OP_JAL:          present_state = jal3;
                    OP_MFHI:         present_state = mfhi3;
                    OP_MFLO:         present_state = mflo3;
                    OP_IN:           present_state = in3;
                    OP_OUT:          present_state = out3;
                    OP_NOP:          present_state = fetch0;
                    OP_HALT:         present_state = halt_state;
                    default:         present_state = halt_state;
                endcase
            end

            // ALU register-register
            alu3: present_state = alu4;
            alu4: present_state = alu5;
            alu5: present_state = fetch0;

            // multiply
            mul3: present_state = mul4;
            mul4: present_state = mul5;
            mul5: present_state = mul6;
            mul6: present_state = fetch0;

            // divide
            div3: present_state = div4;
            div4: present_state = div5;
            div5: present_state = div6;
            div6: present_state = fetch0;

            // neg/not
            neg3: present_state = neg4;
            neg4: present_state = neg5;
            neg5: present_state = fetch0;

            // ALU immediate
            imm3: present_state = imm4;
            imm4: present_state = imm5;
            imm5: present_state = fetch0;

            // ld
            ld3: present_state = ld4;
            ld4: present_state = ld5;
            ld5: present_state = ld6;
            ld6: present_state = ld7;
            ld7: present_state = fetch0;

            // ldi
            ldi3: present_state = ldi4;
            ldi4: present_state = ldi5;
            ldi5: present_state = fetch0;

            // st
            st3: present_state = st4;
            st4: present_state = st5;
            st5: present_state = st6;
            st6: present_state = st7;
            st7: present_state = fetch0;

            // branch
            br3: present_state = br4;
            br4: present_state = br5;
            br5: present_state = br6;
            br6: present_state = fetch0;

            // jr
            jr3: present_state = fetch0;

            // jal
            jal3: present_state = jal4;
            jal4: present_state = fetch0;

            // mfhi/mflo
            mfhi3: present_state = fetch0;
            mflo3: present_state = fetch0;

            // in/out
            in3:  present_state = fetch0;
            out3: present_state = fetch0;

            // halt stays in halt
            halt_state: present_state = halt_state;

            default: present_state = halt_state;
        endcase
    end
end

// Control signal outputs
always @(*) begin
    // Default: de-assert everything
    Gra = 0; Grb = 0; Grc = 0; Rin = 0; Rout = 0; BAout = 0; Cout = 0;
    PCin = 0; HIin = 0; LOin = 0; Zin = 0; MARin = 0; MDRin = 0; MDRout = 0;
    Yin = 0; IRin = 0; IncPC = 0; Read = 0; Write = 0;
    PCout = 0; HIout = 0; LOout = 0; Zout = 0; SelZ = 0;
    CONin = 0;
    OutPortin = 0; InPortout = 0;
    Run = 1; Clear = 0;
    controlSignal = 5'd0;

    case (present_state)
        // Reset
        reset_state: begin
            Clear = 1;
            Run = 1;
        end

        // Instruction Fetch (T0-T2)
        fetch0: begin // T0: PCout, MARin, IncPC, Zin
            PCout = 1; MARin = 1; IncPC = 1; Zin = 1;
        end
        fetch1: begin // T1: Zlowout, PCin, Read, MDRin
            Zout = 1; SelZ = 0; PCin = 1; Read = 1; MDRin = 1;
        end
        fetch2: begin // T2: MDRout, IRin
            MDRout = 1; IRin = 1;
        end

        // ALU : add, sub, and, or, shr, shra, shl, ror, rol
        // T3: Grb, Rout, Yin
        // T4: Grc, Rout, [OP], Zin
        // T5: Zlowout, Gra, Rin
        alu3: begin
            Grb = 1; Rout = 1; Yin = 1;
        end
        alu4: begin
            Grc = 1; Rout = 1; Zin = 1;
            controlSignal = IR[31:27]; // opcode IS the ALU control signal
        end
        alu5: begin
            Zout = 1; SelZ = 0; Gra = 1; Rin = 1;
        end

        // Multiply: mul Ra, Rb  (HI||LO <- Ra * Rb)
        // T3: Gra, Rout, Yin
        // T4: Grb, Rout, MUL, Zin
        // T5: Zlowout, LOin
        // T6: Zhighout, HIin

        mul3: begin
            Gra = 1; Rout = 1; Yin = 1;
        end
        mul4: begin
            Grb = 1; Rout = 1; Zin = 1;
            controlSignal = 5'd13; // MUL
        end
        mul5: begin
            Zout = 1; SelZ = 0; LOin = 1;
        end
        mul6: begin
            Zout = 1; SelZ = 1; HIin = 1;
        end

        // Divide: div Ra, Rb  (HI <- Ra%Rb, LO <- Ra/Rb)
        // Divider computes B/A (Q/M), so put Rb (divisor) into Y (A)
        // and Ra (dividend) onto bus (B)
        // T3: Grb, Rout, Yin
        // T4: Gra, Rout, DIV, Zin
        // T5: Zlowout, LOin
        // T6: Zhighout, HIin
        div3: begin
            Grb = 1; Rout = 1; Yin = 1;
        end
        div4: begin
            Gra = 1; Rout = 1; Zin = 1;
            controlSignal = 5'd12; // DIV
        end
        div5: begin
            Zout = 1; SelZ = 0; LOin = 1;
        end
        div6: begin
            Zout = 1; SelZ = 1; HIin = 1;
        end

        // NEG/NOT (Unary): neg Ra, Rb  or  not Ra, Rb
        // T3: Grb, Rout, [NEG/NOT], Zin
        // T4: Zlowout, Gra, Rin
        neg3: begin
            Grb = 1; Rout = 1; Yin = 1;
        end
        neg4: begin
            Zin = 1;
            controlSignal = IR[31:27];
        end
        neg5: begin
            Zout = 1; SelZ = 0; Gra = 1; Rin = 1;
        end

        // ALU Immediate: addi, andi, ori
        // T3: Grb, Rout, Yin
        // T4: Cout, ADD/AND/OR, Zin
        // T5: Zlowout, Gra, Rin
        imm3: begin
            Grb = 1; Rout = 1; Yin = 1;
        end
        imm4: begin
            Cout = 1; Zin = 1;
            case (IR[31:27])
                OP_ADDI: controlSignal = 5'd0;  // ADD
                OP_ANDI: controlSignal = 5'd2;  // AND
                OP_ORI:  controlSignal = 5'd3;  // OR
                default: controlSignal = 5'd0;
            endcase
        end
        imm5: begin
            Zout = 1; SelZ = 0; Gra = 1; Rin = 1;
        end

        // Load: ld Ra, C(Rb)
        // T3: Grb, BAout, Yin
        // T4: Cout, ADD, Zin
        // T5: Zlowout, MARin
        // T6: Read, MDRin
        // T7: MDRout, Gra, Rin
        ld3: begin
            Grb = 1; BAout = 1; Yin = 1;
        end
        ld4: begin
            Cout = 1; controlSignal = 5'd0; Zin = 1; // ADD
        end
        ld5: begin
            Zout = 1; SelZ = 0; MARin = 1;
        end
        ld6: begin
            Read = 1; MDRin = 1;
        end
        ld7: begin
            MDRout = 1; Gra = 1; Rin = 1;
        end

        // Load Immediate: ldi Ra, C(Rb)
        // T3: Grb, BAout, Yin
        // T4: Cout, ADD, Zin
        // T5: Zlowout, Gra, Rin
        ldi3: begin
            Grb = 1; BAout = 1; Yin = 1;
        end
        ldi4: begin
            Cout = 1; controlSignal = 5'd0; Zin = 1; // ADD
        end
        ldi5: begin
            Zout = 1; SelZ = 0; Gra = 1; Rin = 1;
        end

        // Store: st C(Rb), Ra
        // T3: Grb, BAout, Yin
        // T4: Cout, ADD, Zin
        // T5: Zlowout, MARin
        // T6: Gra, Rout, MDRin  (MDR <- R[Ra] from bus, NOT from memory)
        // T7: Write
        st3: begin
            Grb = 1; BAout = 1; Yin = 1;
        end
        st4: begin
            Cout = 1; controlSignal = 5'd0; Zin = 1; // ADD
        end
        st5: begin
            Zout = 1; SelZ = 0; MARin = 1;
        end
        st6: begin
            Gra = 1; Rout = 1; MDRin = 1;
        end
        st7: begin
            Write = 1;
        end

        // Branch: brzr/brnz/brpl/brmi  Ra, C
        // T3: Gra, Rout, CONin
        // T4: PCout, Yin
        // T5: Cout, ADD, Zin
        // T6: Zlowout, PCin (if CON_FF = 1)
        br3: begin
            Gra = 1; Rout = 1; CONin = 1;
        end
        br4: begin
            PCout = 1; Yin = 1;
        end
        br5: begin
            Cout = 1; controlSignal = 5'd0; Zin = 1; // ADD
        end
        br6: begin
            Zout = 1; SelZ = 0;
            if (CON_FF) PCin = 1;
        end

        // Jump Register: jr Ra
        // T3: Gra, Rout, PCin
        jr3: begin
            Gra = 1; Rout = 1; PCin = 1;
        end

        // Jump and Link: jal Ra  (R[Rb] <- PC, PC <- R[Ra])
        // Rb is encoded as R15 (link register) in the instruction word
        // T3: PCout, Grb, Rin    (save return address)
        // T4: Gra, Rout, PCin   (jump)

        jal3: begin
            PCout = 1; Grb = 1; Rin = 1;
        end
        jal4: begin
            Gra = 1; Rout = 1; PCin = 1;
        end

        // MFHI: mfhi Ra   (R[Ra] <- HI)
        // T3: HIout, Gra, Rin

        mfhi3: begin
            HIout = 1; Gra = 1; Rin = 1;
        end

        // MFLO: mflo Ra   (R[Ra] <- LO)
        // T3: LOout, Gra, Rin

        mflo3: begin
            LOout = 1; Gra = 1; Rin = 1;
        end

        // IN: in Ra   (R[Ra] <- InPort)
        // T3: InPortout, Gra, Rin

        in3: begin
            InPortout = 1; Gra = 1; Rin = 1;
        end

        // OUT: out Ra   (OutPort <- R[Ra])
        // T3: Gra, Rout, OutPortin

        out3: begin
            Gra = 1; Rout = 1; OutPortin = 1;
        end

        // stop the processor
        halt_state: begin
            Run = 0;
        end
    endcase
end

endmodule
