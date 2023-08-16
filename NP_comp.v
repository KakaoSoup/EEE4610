`timescale 1ns / 1ps

module NP_comp (
    input [11:0] NPr,
    input [11:0] RRx1,
    input [11:0] RRx2,
    input [11:0] RRx3,
    input [11:0] RRx4,
    input [3:0] RLSS,
    output comp
);

wire [9:0] NPry_addr;
wire [1:0] NPry_block;
wire [9:0] RRx_addr [0:3];
wire [1:0] RRx_block[0:3];
wire comp_result [0:3];

assign NPry_addr = NPr[9:0];
assign NPry_block = NPr[11:10];

assign RRx_addr[0] = RRx1[9:0];
assign RRx_addr[1] = RRx2[9:0];
assign RRx_addr[2] = RRx3[9:0];
assign RRx_addr[3] = RRx4[9:0];

assign RRx_block[0] = RRx1[11:10];
assign RRx_block[1] = RRx2[11:10];
assign RRx_block[2] = RRx3[11:10];
assign RRx_block[3] = RRx4[11:10];

assign comp = (comp_result[0] | comp_result[1] | comp_result[2] | comp_result[3]);

RAC rac1(
    .RRx_addr(RRx_addr[0]),
    .NPry_addr(NPry_addr),
    .RRx_block(RRx_block[0]),
    .NPry_block(NPry_block),   
    .RLSS(RLSS[0]),
    .compare_result(comp_result[0])
);

RAC rac2(
    .RRx_addr(RRx_addr[1]),
    .NPry_addr(NPry_addr),
    .RRx_block(RRx_block[1]),
    .NPry_block(NPry_block),   
    .RLSS(RLSS[1]),
    .compare_result(comp_result[1])
);

RAC rac3(
    .RRx_addr(RRx_addr[2]),
    .NPry_addr(NPry_addr),
    .RRx_block(RRx_block[2]),
    .NPry_block(NPry_block),   
    .RLSS(RLSS[2]),
    .compare_result(comp_result[2])
);

RAC rac4(
    .RRx_addr(RRx_addr[3]),
    .NPry_addr(NPry_addr),
    .RRx_block(RRx_block[3]),
    .NPry_block(NPry_block),   
    .RLSS(RLSS[3]),
    .compare_result(comp_result[3])
);


endmodule