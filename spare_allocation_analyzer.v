`timescale 1ns / 1ps

module spare_allocation_analyzer (
	input [25:0] pivot_fault_addr [0:PCAM-1],
	input [16:0] nonpivot_fault_addr [0:NPCAM-1],
	input [PCAM-1:0] dsss,
	input [3:0] rlss,

	output [16:0] uncover_nonpivot_addr,
	output [25:0] cover_pivot_addr,
	output [NPCAM-1:0] nonpivot_cover_result,
	output [25:0] uncover_must_addr
);

wire [11:0] RRx [0:3];
wire [11:0] RCx [0:3];
wire [9:0] pivot_row[0:PCAM-1];
wire [9:0] pivot_col[0:PCAM-1];

assign pivot_row = pivot_fault_addr[24:15];
assign pivot_col = pivot_fault_addr[14:5];
assign nonpivot_cover_result = nonpivot_cover_result1 | nonpivot_cover_result2;

RC_MUX RRx(
	.clk(clk),
	.PCAM_addr(pivot_fault_addr[24:15]),
	.dsss(dsss),
	.repair_addr(RRx)
);

RC_MUX RCx(
	.clk(clk),
	.PCAM_addr(pivot_fault_addr[14:5]),
	.dsss(dsss),
	.repair_addr(RCx)
);

NP_comp row_comp_block1 (
	.NPr(nonpivot_fault_addr[0]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[0])
);

NP_comp row_comp_block2 (
	.NPr(nonpivot_fault_addr[1]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[1])
);

NP_comp row_comp_block3 (
	.NPr(nonpivot_fault_addr[2]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[2])
);

NP_comp row_comp_block4 (
	.NPr(nonpivot_fault_addr[3]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[3])
);

NP_comp row_comp_block5 (
	.NPr(nonpivot_fault_addr[4]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[4])
);

NP_comp row_comp_block6 (
	.NPr(nonpivot_fault_addr[5]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[5])
);

NP_comp row_comp_block7 (
	.NPr(nonpivot_fault_addr[6]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[6])
);

NP_comp row_comp_block8 (
	.NPr(nonpivot_fault_addr[7]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[7])
);

NP_comp row_comp_block9 (
	.NPr(nonpivot_fault_addr[8]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[8])
);

NP_comp row_comp_block10 (
	.NPr(nonpivot_fault_addr[9]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[9])
);

NP_comp row_comp_block11 (
	.NPr(nonpivot_fault_addr[10]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[10])
);

NP_comp row_comp_block12 (
	.NPr(nonpivot_fault_addr[11]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[11])
);

NP_comp row_comp_block13 (
	.NPr(nonpivot_fault_addr[12]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[12])
);

NP_comp row_comp_block14 (
	.NPr(nonpivot_fault_addr[13]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[13])
);

NP_comp row_comp_block15 (
	.NPr(nonpivot_fault_addr[14]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[14])
);

NP_comp row_comp_block16 (
	.NPr(nonpivot_fault_addr[15]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[15])
);

NP_comp row_comp_block17 (
	.NPr(nonpivot_fault_addr[16]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[16])
);

NP_comp row_comp_block18 (
	.NPr(nonpivot_fault_addr[17]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[17])
);

NP_comp row_comp_block19 (
	.NPr(nonpivot_fault_addr[18]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[18])
);

NP_comp row_comp_block20 (
	.NPr(nonpivot_fault_addr[19]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[19])
);

NP_comp row_comp_block21 (
	.NPr(nonpivot_fault_addr[20]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[20])
);

NP_comp row_comp_block22 (
	.NPr(nonpivot_fault_addr[21]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[21])
);

NP_comp row_comp_block23 (
	.NPr(nonpivot_fault_addr[22]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[22])
);

NP_comp row_comp_block24 (
	.NPr(nonpivot_fault_addr[23]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[23])
);

NP_comp row_comp_block25 (
	.NPr(nonpivot_fault_addr[24]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[24])
);

NP_comp row_comp_block26 (
	.NPr(nonpivot_fault_addr[25]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[25])
);

NP_comp row_comp_block27 (
	.NPr(nonpivot_fault_addr[26]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[26])
);

NP_comp row_comp_block28 (
	.NPr(nonpivot_fault_addr[27]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[27])
);

NP_comp row_comp_block29 (
	.NPr(nonpivot_fault_addr[28]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[28])
);

NP_comp row_comp_block30 (
	.NPr(nonpivot_fault_addr[29]),
	.RRx1(RRx[0]),
	.RRx2(RRx[1]),
	.RRx3(RRx[2]),
	.RRx4(RRx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result1[29])
);

NP_comp col_comp_block1 (
	.NPr(nonpivot_fault_addr[0]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[0])
);

NP_comp col_comp_block2 (
	.NPr(nonpivot_fault_addr[1]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[1])
);

NP_comp col_comp_block3 (
	.NPr(nonpivot_fault_addr[2]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[2])
);

NP_comp col_comp_block4 (
	.NPr(nonpivot_fault_addr[3]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[3])
);

NP_comp col_comp_block5 (
	.NPr(nonpivot_fault_addr[4]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[4])
);

NP_comp col_comp_block6 (
	.NPr(nonpivot_fault_addr[5]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[5])
);

NP_comp col_comp_block7 (
	.NPr(nonpivot_fault_addr[6]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[6])
);

NP_comp col_comp_block8 (
	.NPr(nonpivot_fault_addr[7]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[7])
);

NP_comp col_comp_block9 (
	.NPr(nonpivot_fault_addr[8]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[8])
);

NP_comp col_comp_block10 (
	.NPr(nonpivot_fault_addr[9]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[9])
);

NP_comp col_comp_block11 (
	.NPr(nonpivot_fault_addr[10]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[10])
);

NP_comp col_comp_block12 (
	.NPr(nonpivot_fault_addr[11]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[11])
);

NP_comp col_comp_block13 (
	.NPr(nonpivot_fault_addr[12]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[12])
);

NP_comp col_comp_block14 (
	.NPr(nonpivot_fault_addr[13]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[13])
);

NP_comp col_comp_block15 (
	.NPr(nonpivot_fault_addr[14]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[14])
);

NP_comp col_comp_block16 (
	.NPr(nonpivot_fault_addr[15]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[15])
);

NP_comp col_comp_block17 (
	.NPr(nonpivot_fault_addr[16]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[16])
);

NP_comp col_comp_block18 (
	.NPr(nonpivot_fault_addr[17]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[17])
);

NP_comp col_comp_block19 (
	.NPr(nonpivot_fault_addr[18]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[18])
);

NP_comp col_comp_block20 (
	.NPr(nonpivot_fault_addr[19]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[19])
);

NP_comp col_comp_block21 (
	.NPr(nonpivot_fault_addr[20]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[20])
);

NP_comp col_comp_block22 (
	.NPr(nonpivot_fault_addr[21]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[21])
);

NP_comp col_comp_block23 (
	.NPr(nonpivot_fault_addr[22]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[22])
);

NP_comp col_comp_block24 (
	.NPr(nonpivot_fault_addr[23]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[23])
);

NP_comp col_comp_block25 (
	.NPr(nonpivot_fault_addr[24]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[24])
);

NP_comp col_comp_block26 (
	.NPr(nonpivot_fault_addr[25]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[25])
);

NP_comp col_comp_block27 (
	.NPr(nonpivot_fault_addr[26]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[26])
);

NP_comp col_comp_block28 (
	.NPr(nonpivot_fault_addr[27]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[27])
);

NP_comp col_comp_block29 (
	.NPr(nonpivot_fault_addr[28]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[28])
);

NP_comp col_comp_block30 (
	.NPr(nonpivot_fault_addr[29]),
	.RCx1(RCx[0]),
	.RCx2(RCx[1]),
	.RCx3(RCx[2]),
	.RCx4(RCx[3]),
	.RLSS(rlss),
	.comp(nonpivot_cover_result2[29])
);


endmodule