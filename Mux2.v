module Mux2to1(input [31:0] D0, D1, 
        input read, 
        output wire [31:0] q);
    assign q = read ? D0 : D1;
endmodule 