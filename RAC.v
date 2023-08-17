`timescale 1ns / 1ps

module RAC (
    input [9:0] RRx_addr,
    input [9:0] NPry_addr,
    input [1:0] RRx_block,
    input [1:0] NPry_block,
    input RLSS,
    output reg compare_result
);

//assign compare_result = (RRx_addr !== NPry_addr) ? 0 :
                        (RLSS || (RRx_block == NPry_block)) ? 1 : 0;

assign compare_result = RLSS;
endmodule