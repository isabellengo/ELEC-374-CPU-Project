module ALU (
	input clear, clock,
	input [4:0] controlSignal,
	input [31:0] A, B,
	output wire [63:0] Result
);

reg [63:0]C;
wire [31:0] adder_result;
wire [31:0] subtractor_result;
wire [63:0] multiplier_result;
wire [63:0] divider_result;

adder add(A, B, adder_result);
subtractor sub(A, B, subtractor_result);
multiplier mul(A, B, multiplier_result);
divider div(A, B, divider_result);

parameter ADD = 5'd0, SUB = 5'd1, AND = 5'd2, OR = 5'd3,
	SHR = 5'd4, SHRA = 5'd5, SHL = 5'd6, ROR = 5'd7, ROL = 5'd8, 
	ADDI = 5'd9, ANDI = 5'd10, ORI = 5'd11, 
	DIV = 5'd12, MUL = 5'd13, NEG = 5'd14, NOT = 5'd15,
	LD = 5'd16, LDI = 5'd17, ST = 5'd18,
	JAL = 5'd19, JR = 5'd20;

always @*
    begin
        case (controlSignal)
            ADD: begin
                C = 64'd0;
                C[31:0] = adder_result;
            end
 
            SUB: begin
                C = 64'd0;
                C[31:0] = subtractor_result;
            end
 
            AND: begin
                C = 64'd0;
                C[31:0] = A & B;
            end
 
            OR: begin
                C = 64'd0;
                C[31:0] = A | B;
            end
 
            SHR: begin
                C = 64'd0;
                C[31:0] = A >> B;
            end
 
            SHRA: begin
                C = 64'd0;
                if(A[31] == 1) // if the number is negative, fill left bits with 1s
                    C[31:0] = (A >> B) | ~(32'hFFFF_FFFF >> B);
                else
                    C[31:0] = $signed(A) >>> B;
            end
 
            SHL: begin
                C = 64'd0;
                C[31:0] = A << B;
            end
 
            ROR: begin
                C = 64'd0;
                C[31:0] = (A >> B) | (A << (32 - B));
            end
 
            ROL: begin
                C = 64'd0;
                C[31:0] = (A << B) | (A >> (32 - B));
            end
 
            NEG: begin
                C = 64'd0;
                C[31:0] = (~A) + 32'd1; //Two's complement
            end
 
            NOT: begin
                C = 64'd0;
                C[31:0] = ~A;
            end
 
            MUL: begin
                C = multiplier_result;
            end
 
            DIV: begin
                C = divider_result;
            end
 
            default: begin
                C = 64'd0;
            end
 
        endcase
    end
    assign Result = C[63:0];
endmodule
 