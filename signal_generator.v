`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/20 10:27:02
// Design Name: 
// Module Name: signal_generator
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

module signal_generator (
    input rst,
    input clk,
    input [1:0] spare_struct_type,
    output reg [7:0] DSSS,
    output reg [3:0] RLSS
);

localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;
reg [2:0] i, j, k, p;
reg [1:0] ri, rj;
reg rlss_term;
reg gen_sig;

always @ (posedge clk) begin
    if(rst) begin
        DSSS <= 8'b0;
        RLSS <= 4'b0;
        gen_sig <= 1;
        rlss_term <= 0;
        i <= 3'd7;
        j <= 3'd6;
        k <= 3'd5;
        p <= 3'd4;
        ri <= 2'd3;
        rj <= 2'd2;
    end
    else begin
        DSSS <= 8'b0;
        RLSS <= 4'b0;
        case (spare_struct_type)
            S1, S2 : begin
                if (gen_sig) begin
                    DSSS[i] <= 1;
                    DSSS[j] <= 1;
                    DSSS[k] <= 1;
                    DSSS[p] <= 1; 
                    if (p > 0) begin
                        p <= p - 1;
                    end else if (k > 1) begin
                        k <= k - 1;
                        p <= k - 2;
                    end else if (j > 2) begin
                        j <= j - 1;
                        k <= j - 2;
                        p <= j - 3;
                    end else if (i > 3) begin
                        i <= i - 1;
                        j <= i - 2;
                        k <= i - 3; 
                        p <= i - 4;
                    end else begin
                        gen_sig <= 0; // 루프 종료
                    end                
                end
            end
            S3 : begin
                if (gen_sig) begin
                    DSSS[i] <= 1;
                    DSSS[j] <= 1;
                    DSSS[k] <= 1;
                    DSSS[p] <= 1;
                    RLSS[ri] <= 1;
                    RLSS[rj] <= 1;
                    if (rj > 0) begin
                        rj <= rj - 1;
                    end else if (ri > 1) begin
                        ri <= ri - 1;
                        rj <= ri - 2;
                    end else begin
                        ri <= 2'd3;
                        rj <= 2'd2;
                        if (p > 0) begin
                            p <= p - 1;
                        end else if (k > 1) begin
                            k <= k - 1;
                            p <= k - 2;
                        end else if (j > 2) begin
                            j <= j - 1;
                            k <= j - 2;
                            p <= j - 3;
                        end else if (i > 3) begin
                            i <= i - 1;
                            j <= i - 2;
                            k <= i - 3; 
                            p <= i - 4;
                        end else begin
                            gen_sig <= 0; // 루프 종료
                        end
                    end
                end
            end
        endcase
    end
end

endmodule