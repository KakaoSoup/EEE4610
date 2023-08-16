`timescale 1ns / 1ps

module CAM (
    input clk,
    input rst,
    input [9:0] row_addr,
    input [9:0] col_addr,
    input [1:0] bank_addr,
    input [7:0] col_flag,

 //   output [1:0] pivot_bnk [0:PCAM-1],
 //   output [2:0] must_repair [0:PCAM-1],
    output [25:0] pivot_fault_addr [0:PCAM-1],
    output [16:0] nonpivot_fault_addr [0:NPCAM-1],
    output [2:0] pointer_addr [0:NPCAM-1]
);

reg find;

reg pcam_enable [0:PCAM-1];
reg [9:0] pcam_row_addr [0:PCAM-1];
reg [9:0] pcam_col_addr [0:PCAM-1];
reg [1:0] pcam_bnk_addr [0:PCAM-1];
reg [2:0] pcam_must_flag [0:PCAM-1];

reg npcam_enable [0:NPCAM-1];
reg [2:0] npcam_ptr [0:NPCAM-1];
reg npcam_dscrpt [0:NPCAM-1];
reg [9:0] npcam_addr [0:NPCAM-1];
reg [1:0] npcam_bnk_addr [0:NPCAM-1];

reg [5:0] cnt[0:PCAM-1];

assign pivot_bnk = pcam_bnk_addr;
assign must_repair = pcam_must_flag;
assign pivot_fault_addr = { pcam_enable, pcam_row_addr, pcam_col_addr,
                            pcam_bnk_addr, pcam_must_flag };
assign nonpivot_fault_addr = { npcam_enable, npcam_ptr, npcam_dscrpt,
                            npcam_addr, npcam_bnk_addr };

integer p_idx;
integer np_idx;

MUX flag_to_idx(
	.input_bits(col_flag),
	.output_idx(flag_idx)
)

always @ (posedge clk) begin
    if((rst) || (early_term)) begin
        p_idx = 0;
        np_idx = 0;
        integer i;
        for (int i = 0; i < PCAM; i = i + 1) begin
            pcam_enable[i] = 1'b0;
            pcam_row_addr[i] = 10'b0;
            pcam_col_addr[i] = 10'b0;
            pcam_bnk_addr[i] = 2'b0;
            pcam_must_flag[i] = 3'b0;
            cnt[i] = 6'b0;
        end
         for (int i = 0; i < NPCAM; i = i + 1) begin
            npcam_enable[i] = 1'b0;
            npcam_ptr[i] = 3'b0;
            npcam_dscrpt[i] = 1'b0;
            npcam_addr[i] = 10'b0;
            npcam_bnk_addr[i] = 2'b0;
        end
    end
    else begin
        integer i;
        for(i = 0; i < PCAM; i = i+1) begin
            if(pcam_row_addr[i] == row_addr) begin
                if((cnt[i] & 6'b11_00_00) == 6'b11_00_00) begin
                    pcam_must_flag[i] = 3'b100;
                    disable
                end
                else if((cnt[i] & 6'b00_00_11) == 6'b00_00_11) begin
                    pcam_must_flag[i] = 3'b001;
                    disable
                end
                npcam_enable[np_idx] <= 1;
                npcam_ptr[np_idx] <= i;
                npcam_dscrpt[np_idx] <= 0;
                npcam_addr[np_idx] <= row_addr;
                npcam_bnk_addr[np_idx] <= bank_addr;
                find <= 1;
                np_idx = np_idx + 1;
                if(bank_addr == pcam_bnk_addr[i])
                    cnt[i] = cnt[i] + 6'b01_00_00;
                else
                    cnt[i] = cnt[i] + 6'b00_00_01;
                disable
            end 
            else if((pcam_col_addr[i] == (col_addr | MUX(col_flag))) && (pcam_bnk_addr[i] == bank_addr)) begin
                if((cnt[i] & 6'b00_11_00) == 6'b00_11_00) begin
                    pcam_must_flag[i] = 3'b010;
                    disable
                end
                npcam_enable[np_idx] <= 1;
                npcam_ptr[np_idx] <= i;
                npcam_dscrpt[np_idx] <= 1;
                npcam_addr[np_idx] <= col_addr;
                npcam_bnk_addr[np_idx] <= bank_addr;
                find <= 1;
                np_idx = np_idx + 1;
                cnt[i] = cnt[i] + 6'b00_01_00;
                disable
            end
        end
        if(!find) begin
            pcam_enable[p_dix] <= 1;
            pcam_row_addr[p_idx] <= row_addr;
            pcam_col_addr[p_idx] <= (col_addr | MUX(col_flag));
            pcam_bnk_addr[p_idx] <= bank_addr;
            p_idx = p_idx + 1;
        end
        find = 0;
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