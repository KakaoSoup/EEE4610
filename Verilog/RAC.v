`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/21 16:40:25
// Design Name: 
// Module Name: RAC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module RAC (
    input clk,
    input [9:0] RRx_addr,
    input [9:0] NPry_addr,
    input [1:0] RRx_block,
    input [1:0] NPry_block,
    input RLSS,
    output reg compare_result
);

always @ (posedge clk) begin
    compare_result = (RRx_addr !== NPry_addr) ? 0 : (RLSS || (RRx_block == NPry_block)) ? 1 : 0;
end

endmodule
