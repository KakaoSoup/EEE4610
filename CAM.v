`timescale 1ns / 1ps

module CAM (
    input clk,
    input rst,
    input early_term,
    input [9:0] row_addr,
    input [9:0] col_addr,
    input [1:0] bank_addr,
    input [7:0] col_flag,

    output [1:0] pivot_bnk [0:PCAM-1],
    output [2:0] must_repair [0:PCAM-1],
    output wire [PCAM-1:0][25:0] pivot_fault_addr,
    output wire [NPCAM-1:0][16:0] nonpivot_fault_addr,
    output [2:0] pointer_addr [0:NPCAM-1]
);

parameter PCAM = 8;
parameter NPCAM = 30;

reg find;                                  // if faults is npcam, set 1

// pcam
reg [PCAM-1:0]pcam_enable;
reg [PCAM-1:0][9:0] pcam_row_addr;
reg [PCAM-1:0][9:0] pcam_col_addr;
reg [PCAM-1:0][1:0] pcam_bnk_addr;
reg [PCAM-1:0][2:0] pcam_must_flag;

// npcam
reg [NPCAM-1:0]npcam_enable;
reg [NPCAM-1:0][2:0] npcam_ptr;
reg [NPCAM-1:0]npcam_dscrpt;
reg [NPCAM-1:0][9:0] npcam_addr;
reg [NPCAM-1:0][1:0] npcam_bnk_addr;

// XX_XX_XX : row, col, adj
reg [5:0] cnt[0:PCAM-1];                    

assign pivot_fault_addr = { pcam_enable, pcam_row_addr, pcam_col_addr, pcam_bnk_addr, pcam_must_flag };
assign nonpivot_fault_addr = { npcam_enable, npcam_ptr, npcam_dscrpt, npcam_addr, npcam_bnk_addr };

/*
// Combinational logic for pivot_fault_addr
genvar i;
generate
    for (i = 0; i < PCAM; i = i + 1) begin : assign_pivot_fault
        assign pivot_fault_addr[i] = { pcam_enable[i], pcam_row_addr[i], pcam_col_addr[i], pcam_bnk_addr[i], pcam_must_flag[i] };
    end
endgenerate

// Combinational logic for nonpivot_fault_addr
genvar j;
generate
    for (j = 0; j < NPCAM; j = j + 1) begin : assign_nonpivot_fault
        assign nonpivot_fault_addr[j] = { npcam_enable[j], npcam_ptr[j], npcam_dscrpt[j], npcam_addr[j], npcam_bnk_addr[j] };
    end
endgenerate
*/

always @ (posedge clk) begin : CAM_alloct
    integer p_idx;
    integer np_idx;
    integer idx;
    find <= 0;                   // reset find
    // reset value
    if((rst) || (early_term)) begin
        p_idx = 0;
        np_idx = 0;
        for (idx = 0; idx < PCAM; idx = idx + 1) begin
            pcam_enable[idx] = 1'b0;
            pcam_row_addr[idx] = 10'b0;
            pcam_col_addr[idx] = 10'b0;
            pcam_bnk_addr[idx] = 2'b0;
            pcam_must_flag[idx] = 3'b0;
            cnt[idx] = 6'b0;
        end
         for (idx = 0; idx < NPCAM; idx = idx + 1) begin
            npcam_enable[idx] = 1'b0;
            npcam_ptr[idx] = 3'b0;
            npcam_dscrpt[idx] = 1'b0;
            npcam_addr[idx] = 10'b0;
            npcam_bnk_addr[idx] = 2'b0;
        end
    end
    else begin
        for(idx = 0; idx < PCAM; idx = idx+1) begin
            if(pcam_row_addr[idx] == row_addr) begin
                // faults in row > #spares
                if((cnt[idx] & 6'b11_00_00) == 6'b11_00_00) begin
                    pcam_must_flag[idx] = 3'b100;
                    break;
                end
                // faults in row adjacent block > #spares
                else if((cnt[idx] & 6'b00_00_11) == 6'b00_00_11) begin
                    pcam_must_flag[idx] = 3'b001;
                    break;
                end
                // set npcam
                npcam_enable[np_idx] <= 1;
                npcam_ptr[np_idx] <= idx;
                npcam_dscrpt[np_idx] <= 0;
                npcam_addr[np_idx] <= row_addr;
                npcam_bnk_addr[np_idx] <= bank_addr;
                find <= 1;
                np_idx = np_idx + 1;
                // count faults
                if(bank_addr == pcam_bnk_addr[idx]) begin
                    cnt[idx] = cnt[idx] + 6'b01_00_00;
                end
                else begin
                    cnt[idx] = cnt[idx] + 6'b00_00_01;
                end
            end 
            else if((pcam_col_addr[idx] == (col_addr | MUX(col_flag))) && (pcam_bnk_addr[idx] == bank_addr)) begin
                // faults in col > #spares
                if((cnt[idx] & 6'b00_11_00) == 6'b00_11_00) begin
                    pcam_must_flag[idx] = 3'b010;
                    break;
                end
                // set npcam
                npcam_enable[np_idx] <= 1;
                npcam_ptr[np_idx] <= idx;
                npcam_dscrpt[np_idx] <= 1;
                npcam_addr[np_idx] <= col_addr;
                npcam_bnk_addr[np_idx] <= bank_addr;
                find <= 1;
                np_idx = np_idx + 1;
                // count faults
                cnt[idx] = cnt[idx] + 6'b00_01_00;
            end
        end
        if(!find) begin
            // set pcam
            pcam_enable[p_idx] <= 1;
            pcam_row_addr[p_idx] <= row_addr;
            pcam_col_addr[p_idx] <= (col_addr | MUX(col_flag));
            pcam_bnk_addr[p_idx] <= bank_addr;
            p_idx = p_idx + 1;
        end
    end
end

function [2:0] MUX;
input [7:0] input_bits;
    begin
        MUX =   (input_bits == 8'b1XXX_XXXX) ? 3'd7 :
                (input_bits == 8'b01XX_XXXX) ? 3'd6 :
                (input_bits == 8'b001X_XXXX) ? 3'd5 :
                (input_bits == 8'b0001_XXXX) ? 3'd4 :
                (input_bits == 8'b0000_1XXX) ? 3'd3 :
                (input_bits == 8'b0000_01XX) ? 3'd2 :
                (input_bits == 8'b0000_001X) ? 3'd1 : 3'd0;
    end
endfunction

endmodule