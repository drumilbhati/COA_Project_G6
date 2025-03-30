module ALU(
    input clk,
    input Reset,
    input Imm7,                   // Immediate flag
    input [4:0] OpCode,           // Operation code
    input [7:0] Op1, Op2,         // Operands
    output reg ZFlag_Save,        // Zero flag
    output reg CFlag_Save,        // Carry flag
    output reg [7:0] ALU_Save     // ALU result
);

    reg [8:0] temp_result;        // Temporary register to hold results with carry

    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            ALU_Save   <= 8'b0;
            ZFlag_Save <= 1'b0;
            CFlag_Save <= 1'b0;
        end else begin
            case (OpCode)
                5'b00000: temp_result = Op1 + Op2;      // Addition
                5'b00001: temp_result = Op1 - Op2;      // Subtraction
                5'b00010: temp_result = Op1 & Op2;      // Bitwise AND
                5'b00011: temp_result = Op1 | Op2;      // Bitwise OR
                5'b00100: temp_result = Op1 ^ Op2;      // Bitwise XOR
                5'b00101: temp_result = Op1 << 1;       // Left Shift
                5'b00110: temp_result = Op1 >> 1;       // Right Shift
                5'b00111: temp_result = ~Op1;           // Bitwise NOT
                5'b01000: temp_result = (Op1 < Op2) ? 8'b1 : 8'b0; // Comparison
                default:  temp_result = 8'b0;           // Default case
            endcase

            // Assign final result
            ALU_Save <= temp_result[7:0];

            // Zero Flag: Set if result is zero
            ZFlag_Save <= (temp_result[7:0] == 8'b0) ? 1'b1 : 1'b0;

            // Carry Flag: Set if overflow occurs
            CFlag_Save <= temp_result[8];  // 9th bit indicates carry
        end
    end
endmodule
