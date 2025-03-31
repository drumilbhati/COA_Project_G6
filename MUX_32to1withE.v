module Mux_32to1withE (
    I, OpCod0e,E, Y
);
    input [31:0] I;
    input E;
    input [4:0] Sel;
    output reg Y;

    always @(*) begin
        if (E) begin
        case(Sel)
            5'b00000: Y = I[0];
            5'b00001: Y = I[1];
            5'b00010: Y = I[2];
            5'b00011: Y = I[3];
            5'b00100: Y = I[4];
            5'b00101: Y = I[5];
            5'b00110: Y = I[6];
            5'b00111: Y = I[7];
            5'b01000: Y = I[8];
            5'b01001: Y = I[9];
            5'b01010: Y = I[10];
            5'b01011: Y = I[11];
            5'b01100: Y = I[12];
            5'b01101: Y = I[13];
            5'b01110: Y = I[14];
            5'b01111: Y = I[15];
            5'b10000: Y = I[16];
            5'b10001: Y = I[17];
            5'b10010: Y = I[18];
            5'b10011: Y = I[19];
            5'b10100: Y = I[20];
            5'b10101: Y = I[21];
            5'b10110: Y = I[22];
            5'b10111: Y = I[23];
            5'b11000: Y = I[24];
            5'b11001: Y = I[25];
            5'b11010: Y = I[26];
            5'b11011: Y = I[27];
            5'b11100: Y = I[28];
            5'b11101: Y = I[29];
            5'b11110: Y = I[30];
            5'b11111: Y = I[31];
            default: Y = 1'b0;  // Default case
        endcase
        end
         else begin
            Y = 1'b0; // If E is low, output 0 regardless of Sel
        end
       
    end
endmodule