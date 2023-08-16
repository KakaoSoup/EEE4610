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



endmodule