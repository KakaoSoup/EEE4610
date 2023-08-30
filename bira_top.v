`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Yonsei University
// Engineer: Kyeongseok Oh
// 
// Create Date: 2023/08/21 15:30:21
// Design Name: 1.0.0
// Module Name: bira_top
// Project Name: BIRA
// Target Devices: Memory
// Tool Versions: Verilog
// Description: Top module of BIRA
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module bira_top(
    input clk,						// 100MHz clk signal from top module
    input rst, 						// reset signal from top module
	input [1:0] spare_struct,		// types of spare structure from top module
    input test_end,					// Test End signal from BIST
    input fault_detect,				// fault alertion from BIST
    input [9:0] row_add_in,			// fault row address from BIST
    input [9:0] col_add_in,			// fault col address from BIST
	input [7:0] col_flag,			// fault col flag from BIST
	input [1:0] bank_in,			// fault bank address from BIST
    
	output early_term,				// if # of pivot fault > total # of spares, stop BIST
    output repair,					// repair possible?
    output [15:0] solution			// 16 bits = 3 bits(spare types) + 1 bit(row:0 or col:1 flag) + 2 bits(bank addr) + 10 bits(row or col solution)
);

//                  BIRA DESIGN                         //
parameter PCAM = 8;
parameter NPCAM = 30;

wire [7:0] DSSS;
wire [3:0] RLSS;
wire [7:0] unused_spare;
wire [PCAM-1:0] uncover_must_pivot;
wire signal_valid;
wire [16:0] uncover_nonpivot_addr;
wire [25:0] cover_pivot_addr;
wire [NPCAM-1:0] nonpivot_cover_result;
wire [25:0] uncover_must_addr;

wire [PCAM-1:0][25:0] pivot_fault_addr;
wire [NPCAM-1:0][16:0] nonpivot_fault_addr;
wire [2:0] pointer_addr;

CAM cam_storage(
    // input
	.clk(clk),
	.rst(rst),
	.row_addr(row_add_in),
	.col_addr(col_add_in),
	.bank_addr(bank_in),
	.col_flag(col_flag),
    // output
	.pivot_fault_addr(pivot_fault_addr),
	.nonpivot_fault_addr(nonpivot_fault_addr),
	.pointer_addr(pointer_addr)
);

signal_generator generator(
    // input
    .rst(rst),
    .clk(clk),
    // output
    .spare_struct_type(spare_struct),
    .DSSS(DSSS),
    .RLSS(RLSS)
);

signal_validity_checker validity_checker(
	// input
	.DSSS(DSSS),
	.RLSS(RLSS),
	.p_bnk(pivot_fault_addr[4:3]),
	.must_flag(pivot_fault_addr[2:0]),
	// output
	.unused_spare(unused_spare),
	.uncover_must_pivot(uncover_must_pivot),
	.signal_valid(signal_valid)
);

spare_allocation_analyzer spare_allcot (
    // input
    .pivot_fault_addr(pivot_fault_addr),
	.nonpivot_fault_addr(nonpivot_fault_addr),
	.dsss(DSSS),
	.rlss(RLSS),
    // output
	.uncover_nonpivot_addr(uncover_nonpivot_addr),
	.cover_pivot_addr(cover_pivot_addr),
	.nonpivot_cover_result(nonpivot_cover_result),
	.uncover_must_addr(uncover_must_addr)
);


RedundantAnalyzer redudnat_analyzer (
	.unused_spare(),
	.uncover_must_pivot(),
	.signal_valid(),
	.uncover_nonpivot_addr(),
	.cover_pivot_addr(),
	.nonpivot_cover_result(),
	.uncover_must_addr(),
	
	.final_result(),
	.final_cover_addr()
);

//////////////////////////////////////////////////////////
endmodule

