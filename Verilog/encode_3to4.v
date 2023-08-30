`timescale 1ns / 1ps

module encoder_3to4 (
    input wire [2:0] data,   // 3개의 입력 데이터
    output wire [2:0] enc    // 3비트의 출력 인코딩
);

    assign enc = (data[2]) ? 3'b100 :
                 (data[1]) ? 3'b010 :
                 (data[0]) ? 3'b001 :
                             3'b000;

endmodule
