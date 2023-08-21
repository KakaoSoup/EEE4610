`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/20 15:27:23
// Design Name: 
// Module Name: signal_validity_checker
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

// 1. are spares in block over?
// 2. are must-repair lines covered?

module signal_validity_checker (
    input clk,
    input rst,
	input [7:0] DSSS,				// 8bits DSSS signal
	input [3:0] RLSS,				// 4bits RLSS signal
	input [1:0] bank_addr [0:7],		// 2bits bank_addr X 8
	input [2:0] must_flag [0:7],	// 3bits must flag X 8
	
	output reg [7:0] unused_spare,
	output reg [7:0] uncover_must_pivot,
	output signal_valid
);

// state types
localparam struct1 = 'd1;
localparam struct2 = 'd2;		
localparam struct3 = 'd3;		

reg [3:0] state;
reg [3:0] count1;
reg [2:0] count2;
reg v_signal;

	
wire [1:0] partial_counts1 [3:0];
wire [1:0] partial_counts2 [1:0];

// DLSS
assign partial_counts1[0] = DSSS[0] + DSSS[1];
assign partial_counts1[1] = DSSS[2] + DSSS[3];
assign partial_counts1[2] = DSSS[4] + DSSS[5];
assign partial_counts1[3] = DSSS[6] + DSSS[7];

// RLSS
assign partial_counts2[0] = RLSS[0] + RLSS[1];
assign partial_counts2[1] = RLSS[2] + RLSS[3];

assign signal_valid = v_signal;

initial begin
    state <= 4'b0;
    count1 <= 4'b0;
    count2 <= 3'b0;
    v_signal <= 0;
    unused_spare = 8'b1111_1111;
	uncover_must_pivot = 8'b1111_1111; 
end

// DSSS?? RLSS?? spec??? 맞는 spare signal??? 발생????? ?????? 경우 signal valid -> false
// DSSS : 1 X 4bits + 0 X 4bits
// RLSS : 1 X 2bits + 0 X 2bits
always @ (posedge clk) begin
    count1 = partial_counts1[0] + partial_counts1[1] + partial_counts1[2] + partial_counts1[3];
    count2 = partial_counts2[0] + partial_counts2[1];
    
	if((count1 != 4) || (count2 != 2))
		v_signal <= 0;
	else
		v_signal <= 1;
end

always @ (posedge clk) begin : signal_validity_check
	integer i;
	if(rst) begin
		unused_spare = 8'b1111_1111;
		uncover_must_pivot = 8'b1111_1111;
	end
	else begin
		case (state)
			// spare structure 1
			struct1 : begin
				for(i = 0; i < 8; i = i + 1) begin
					// bank0
					if(bank_addr[i] == 2'b01) begin	
						if(must_flag[i] == 3'b100) begin
							if(unused_spare & 8'b1010_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b010) begin
							if(unused_spare & 8'b0000_1010) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b001) begin
							if(unused_spare & 8'b0101_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
					end
					// bank1
					else begin			
						if(must_flag[i] == 3'b100) begin
							if(unused_spare & 8'b0101_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b010) begin
							if(unused_spare & 8'b0000_0101) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b001) begin
							if(unused_spare & 8'b1010_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
					end
				end
			end
			// spare structure 2
			struct2 : begin
				integer i;
				for(i = 0; i < 8; i = i + 1) begin
				// bank0
					if(bank_addr[i] == 2'b01) begin	
						if(must_flag[i] == 3'b100) begin		// row must
							if(unused_spare & 8'b1010_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b010) begin	// col must
							if(unused_spare & 8'b0000_1011) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b001) begin	// adj row must
							if(unused_spare & 8'b0101_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
					end
					// bank1
					else begin			
						if(must_flag[i] == 3'b100) begin		// row must
							if(unused_spare & 8'b0101_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b010) begin	// col must
							if(unused_spare & 8'b0000_0111) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b001) begin	// adj row must
							if(unused_spare & 8'b1010_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
					end
				end			
			end
			
			// spare structure 3
			struct3: begin
				integer i;
				for(i = 0; i < 8; i = i + 1) begin
				// bank0
					if(bank_addr[i] == 2'b01) begin	
						if(must_flag[i] == 3'b100) begin		// row must
							if(unused_spare & 8'b1011_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b010) begin	// col must
							if(unused_spare & 8'b0000_1011) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b001) begin	// adj row must
							if(unused_spare & 8'b0111_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
					end
					// bank1
					else begin			
						if(must_flag[i] == 3'b100) begin		// row must
							if(unused_spare & 8'b0111_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b010) begin	// col must
							if(unused_spare & 8'b0000_0111) begin
								v_signal <= 1;
						    end
							else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
						else if(must_flag[i] == 3'b001) begin	// adj row must
							if(unused_spare & 8'b1011_0000) begin
								v_signal <= 1;
							end else begin
								uncover_must_pivot[i] <= 1;
								v_signal <= 0;
							end
						end
					end
				end
			end
		endcase
	end
end

endmodule
