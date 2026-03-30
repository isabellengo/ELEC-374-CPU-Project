module sel_encode(
    input [31:0] IR,
    input Gra, Grb, Grc, Rin, Rout, BAout, Cout,
    output wire [15:0] Select,
    output wire [15:0] Encode, 
    output wire [31:0] C_sign_extended
);


    wire [3:0] Ra = IR[26:23];
    wire [3:0] Rb = IR[22:19];
    wire [3:0] Rc = IR[18:15];
    
    wire [3:0] decoder_in = ({4{Gra}} & Ra) | ({4{Grb}} & Rb) | ({4{Grc}} & Rc);

    wire [15:0] decoder_out = 16'b1 << decoder_in; // 16-to-1 decoder output

    assign Select = {16{Rin}} & decoder_out; // 16-bit one-hot for register inputs
    assign Encode = {16{(Rout | BAout)}} & decoder_out; // 16-bit one-hot for register outputs
    assign C_sign_extended = {{14{IR[17]}}, IR[17:0]}; // Sign-extend the 18-bit immediate to 32 bits
endmodule