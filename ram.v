module RAM (
    input read, write,
    input [8:0] address,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    reg [31:0] mem [0:511];

    always @(*) begin
        if (read) begin
            data_out <= mem[address];
        end
        else data_out <= 32'b0; // High impedance when not reading
    end

    always @(posedge write) begin
        if (write) begin
            mem[address] <= data_in;
        end
    end
endmodule