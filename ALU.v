module ALU(clk, Reset, Imm7, Op1, Op2, OpCode, ALU_Save, ZFlag_Save, CFlag_Save);
    input clk, Reset, Imm7;
    input [4:0] OpCode;
    input [7:0] Op1, Op2;
    output wire ZFlag_Save, CFlag_Save;
    output wire [7:0] ALU_Save;

    
endmodule