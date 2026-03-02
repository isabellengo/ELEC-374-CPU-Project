module multiplier(M, Q, Result);
 
input signed [31:0] M;
input signed [31:0] Q;
output signed [63:0] Result;
 
reg signed[63:0] Result;
reg signed[63:0] encoding;
 
integer i;
 
always@(M or Q)
    begin
        Result = 64'd0;
        
        for(i = 0; i < 32; i = i + 1)
        begin
            if (i == 0)
                encoding[1:0] = 2'b00 - {1'b0,Q[i]};
            else
                encoding[2*i +: 2] = ({1'b0,Q[i-1]} - {1'b0,Q[i]});
        end
 
        for(i = 0; i < 32; i = i + 1)
        begin
            case(encoding[2*i +: 2])
                2'b00: ;
                2'b01: Result = Result + (M << i);
                2'b11: Result = Result - (M << i);
                default: ;
            endcase
        end
    end
endmodule