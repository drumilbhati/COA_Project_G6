module Control_Logic(clk, Reset, T1, T2, T3, T4, Zflag, PC_Update, SRam_R, SRam_W,Cflag,opcode, StackRead, StackWrite, ALU_Save,ZFlag_Save,CFlag_Save,INportRead, OutportWrite, RegfileRead, Regfilewrite);
input clk, Reset, T1, T2, T3, T4, Zflag, Cflag;
input [4:0] opcode;
output wire StackRead, StackWrite, ALU_Save, ZFlag_Save, CFlag_Save, INportRead, OutportWrite, RegfileRead, Regfilewrite, PC_Update, SRam_R, SRam_W;
wire [31:0] I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12;
assign I1=32'b00000000100000000001000000000000; // 0x00801000
assign I2=32'b00000000010000000000100000000000; // 0x00400800
assign I3=32'b00000111111001000001001111111110; // 0x07e413fe
assign I4=32'b00000111010110000000111111111110; // 0x07580ffe
assign I5=32'b00000000001000000000000000000000; // 0x00200000
assign I6=32'b00011111101001000001011111111110; // 0x1fa417fe
assign I7=32'b00000111000000000000000111111110; // 0x070000fe
assign I8=32'b00000111000000000000000100010000; // 0x07000110
assign I9=32'b00000000000001000000000000000000; // 0x00040000
assign I10=32'b00000000000010000000000000000000; // 0x00080000
assign I11=32'b00000000000100000000000000000000; // 0x00100000
assign I12=32'b00000000000001000000000000000000;
assign I12[14]=Zflag;
assign I12[27]=Zflag;
assign I12[16]=Cflag;
wire Zflag_inverted, Cflag_inverted;
assign Zflag_inverted = ~Zflag;
assign Cflag_inverted = ~Cflag;
assign I12[15]=Zflag_inverted;
assign I12[28]=Zflag_inverted;
assign I12[17]=Cflag_inverted;

Mux_32to1withE inst1(I1, opcode,T3, SRam_W);
Mux_32to1withE inst2(I2, opcode,T3, SRam_R);
Mux_32to1withE inst3(I3, opcode,T1, RegfileRead);
Mux_32to1withE inst4(I4, opcode,T4 ,Regfilewrite);
Mux_32to1withE inst5(I5, opcode,T3, OutportWrite);
Mux_32to1withE inst6(I6, opcode,T2, ALU_Save);
Mux_32to1withE inst7(I7, opcode,T2, ZFlag_Save);
Mux_32to1withE inst8(I8, opcode, T2,CFlag_Save);
Mux_32to1withE inst9(I9, opcode,T3, StackWrite);
Mux_32to1withE inst10(I10, opcode,T3, StackRead);
Mux_32to1withE inst11(I11, opcode,T3, INportRead);
Mux_32to1withE inst12(I12, opcode,T4, PC_Update);
endmodule