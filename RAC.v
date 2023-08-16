`timescale 1ns / 1ps

module RAC (
    input [9:0] RRx_addr,
    input [9:0] NPry_addr,
    input [1:0] RRx_Block,
    input [1:0] NPry_Block,
    input RLSS,
    output reg compare_result
);

assign compare_result = (RRx_addr !== NPry_addr) ? 0 :
                        (RLSS || (RRx_Block == NPry_Block)) ? 1 : 0;
endmodule