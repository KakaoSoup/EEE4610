`timescale 1ns / 1ps

module xnor_8bit (
    input wire [7:0] input_a,
    input wire [7:0] input_b,
    output wire [7:0] result
);

    assign result = ~(input_a ^ input_b);

endmodule