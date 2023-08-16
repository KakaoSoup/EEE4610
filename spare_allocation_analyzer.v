`timescale 1ns / 1ps

module spare_allocation_analyzer (
	input [25:0] pivot_fault_addr,
	input [16:0] nonpivot_fault_addr,
	input [PCAM-1:0] dsss,
	input [3:0] rlss,

	output [16:0] uncover_nonpivot_addr,
	output [25:0] cover_pivot_addr,
	output [NPCAM-1:0] nonpivot_cover_result,
	output [25:0] uncover_must_addr
);

reg [NPCAM-1:0] nonpivot_cover_info;

wire [9:0] pivot_row[0:PCAM-1];
wire [9:0] pivot_col[0:PCAM-1];
wire comp_result[0:NPCAM-1][0:3];

assign pivot_row = pivot_fault_addr[24:15];
assign pivot_col = pivot_fault_addr[14:5];



endmodule