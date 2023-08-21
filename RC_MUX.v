`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/21 16:36:30
// Design Name: 
// Module Name: RC_MUX
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

module RC_MUX (
    input clk,
    input [PCAM-1:0][9:0] PCAM_addr,
    input [PCAM-1:0] dsss,
    output reg [9:0] repair_addr1,
    output reg [9:0] repair_addr2,
    output reg [9:0] repair_addr3,
    output reg [9:0] repair_addr4
);

parameter PCAM = 8;
parameter NPCAM = 30;
parameter mask = 3'b111;
reg [2:0] idx[0:3];

always @ (posedge clk) begin
    repair_addr1 <= PCAM_addr[(find_idx(dsss) >> 9) & mask];
    repair_addr2 <= PCAM_addr[(find_idx(dsss) >> 6) & mask];
    repair_addr3 <= PCAM_addr[(find_idx(dsss) >> 3) & mask];
    repair_addr4 <= PCAM_addr[find_idx(dsss) & mask];
end



function [11:0] find_idx;
input [7:0] dsss;
begin
    integer i;
    integer cnt = 0;
    for(i = 0; i < 8; i = i + 1) begin
        if(dsss[7-i]) begin
            idx[cnt] = i;
            cnt = cnt + 1;
        end
    end
    find_idx = { idx[0], idx[1], idx[2], idx[3] };
end
endfunction

endmodule