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
wire uncover_must_pivot[0:PCAM-1];
wire signal_valid;

wire [25:0] pivot_fault_addr [0:PCAM-1];
wire [16:0] nonpivot_fault_addr [0:NPCAM-1];
wire [2:0] pointer_addr [0:NPCAM-1]



signal_validity_checker validity_checker(
	// input
	.DSSS(DSSS),
	.RLSS(RLSS),
	.p_bnk(),
	.must_flag(),
	
	// output
	.unused_spare(),
	.uncover_must_pivot(),
	.signal_valid()
);










//////////////////////////////////////////////////////////
endmodule
