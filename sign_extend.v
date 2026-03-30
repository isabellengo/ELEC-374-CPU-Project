module sign_extend(
    input [31:0] IR,
    output wire [31:0] C_sign_extended
);

    assign C_sign_extended = {{14{IR[18]}}, IR[17:0]}; 
endmodule