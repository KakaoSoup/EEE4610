`timescale 1ns / 1ps

module RAC (
    input clk,
    input [9:0] RRx_addr,
    input [9:0] NPry_addr,
    input RRx_block,
    input NPry_block,
    input RLSS,
    output reg compare_result
);

always @ (posedge clk) begin
    compare_result = (RRx_addr !== NPry_addr) ? 0 : (RLSS || (RRx_block == NPry_block)) ? 1 : 0;
end

endmodule