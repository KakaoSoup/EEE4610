`timescale 1ns / 1ps

module RC_MUX (
    input clk,
    input [9:0] PCAM_addr [0:PCAM-1],
    input [PCAM-1:0] dsss,
    output reg [9:0] repair_addr[0:3]
);

parameter mask = 3'b111;

always @ (posedge clk) begin
    assign repair_addr[0] <= PCAM_addr[(find_idx(dsss) >> 9) & mask];
    assign repair_addr[1] <= PCAM_addr[(find_idx(dsss) >> 6) & mask];
    assign repair_addr[2] <= PCAM_addr[(find_idx(dsss) >> 3) & mask];
    assign repair_addr[3] <= PCAM_addr[find_idx(dsss) & mask];
end

function [11:0] find_idx;
input [7:0] dsss;
    begin
        integer [2:0] i;
        integer [2:0] idx[0:3];
        integer cnt = 0;

        for(i = 0; i < 8; i = i + 1) begin
            if(dsss[7-i]) begin
                idx[cnt] = i;
                cnt = cnt + 1;
            end
        end
    end
    find_idx = { idx[0], idx[1], idx[2], idx[3] };
endfunction
endmodule