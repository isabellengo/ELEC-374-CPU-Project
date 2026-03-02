module subtractor(A, B, Result);
    input signed [31:0] A, B;
    output signed [31:0] Result;
    
    wire signed [31:0] notB;
    wire signed [31:0] adder_result;
    
    assign notB = ~B + 32'd1;  // Two's complement combinationally
    adder add(A, notB, adder_result);
    assign Result = adder_result;
endmodule
 