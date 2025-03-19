module Mux_32to1_8bits (
    input [7:0] I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15,
    input [7:0] I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31,
    input [4:0] Sel,
    output reg [7:0] Y
);

    always @(*) begin
        case(Sel)
            5'b00000: Y = I0;
            5'b00001: Y = I1;
            5'b00010: Y = I2;
            5'b00011: Y = I3;
            5'b00100: Y = I4;
            5'b00101: Y = I5;
            5'b00110: Y = I6;
            5'b00111: Y = I7;
            5'b01000: Y = I8;
            5'b01001: Y = I9;
            5'b01010: Y = I10;
            5'b01011: Y = I11;
            5'b01100: Y = I12;
            5'b01101: Y = I13;
            5'b01110: Y = I14;
            5'b01111: Y = I15;
            5'b10000: Y = I16;
            5'b10001: Y = I17;
            5'b10010: Y = I18;
            5'b10011: Y = I19;
            5'b10100: Y = I20;
            5'b10101: Y = I21;
            5'b10110: Y = I22;
            5'b10111: Y = I23;
            5'b11000: Y = I24;
            5'b11001: Y = I25;
            5'b11010: Y = I26;
            5'b11011: Y = I27;
            5'b11100: Y = I28;
            5'b11101: Y = I29;
            5'b11110: Y = I30;
            5'b11111: Y = I31;
            default: Y = 8'b0;  // Default case
        endcase
    end
endmodule