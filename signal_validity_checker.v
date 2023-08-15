`timescale 1ns / 1ps

module signal_validity_checker (
	input [7:0] DSSS;				// 8bits DSSS signal
	input [3:0] RLSS;				// 4bits RLSS signal
	input [1:0] p_bnk [0:7];		// 2bits bank_addr X 8
	input [2:0] must_flag [0:7];	// 3bits must flag X 8
	
	output [7:0] unused_spare;
	output reg uncover_must_pivot [7:0];
	output signal_valid;
);

local parameter [2:0] spare [1:0][2:0][1:0];

reg v_signal;
reg [7:0] spares;
reg [3:0] count1;
reg [2:0] count2;

	
wire [1:0] partial_counts1 [3:0];
wire [1:0] partial_counts2 [1:0];

// DLSS
assign partial_counts1[0] = DSSS[0] + DSSS[1];
assign partial_counts1[1] = DSSS[2] + DSSS[3];
assign partial_counts1[2] = DSSS[4] + DSSS[5];
assign partial_counts1[3] = DSSS[6] + DSSS[7];
assign count1 = partial_counts1[0] + partial_counts1[1] +
				partial_counts1[2] + partial_counts1[3];

// RLSS
assign partial_counts2[0] = RLSS[0] + RLSS[1];
assign partial_counts2[1] = RLSS[2] + RLSS[3];
assign count2 = partial_counts2[0] + partial_counts2[1];

assign signal_valid = v_signal;
assign unused_spare = spares;

// DSSS와 RLSS가 spec에 맞는 spare signal을 발생하지 않는 경우 signal valid -> false
always @ (posedge clk) begin
	if((count1 != 4) && (count2 != 2))
		v_signal <= 0;
	else
		v_signal <= 1;
end

