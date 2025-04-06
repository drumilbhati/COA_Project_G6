`timescale 1ns/100ps

// Dataflow modelling_01 //
module decoder3to8_withoutE(A,D);
  input [2:0] A;
  output wire [7:0] D;
  
  assign D[0] = ~A[2]&~A[1]&~A[0];
  assign D[1] = ~A[2]&~A[1]&A[0];
  assign D[2] = ~A[2]&A[1]&~A[0];
  assign D[3] = ~A[2]&A[1]&A[0];
  assign D[4] = A[2]&~A[1]&~A[0];
  assign D[5] = A[2]&~A[1]&A[0];
  assign D[6] = A[2]&A[1]&~A[0];
  assign D[7] = A[2]&A[1]&A[0];
  
endmodule

module mux4to1_8bit (
    input [1:0] S,
    input [7:0] I0,
    input [7:0] I1,
    input [7:0] I2,
    input [7:0] I3,
    output [7:0] Y
);

    assign Y = (S == 2'b00) ? I0 :
               (S == 2'b01) ? I1 :
               (S == 2'b10) ? I2 :
                              I3;

endmodule
module mux8to1_withoutE(I,S,Y);
  input [2:0] S;
  input [7:0] I;
  output wire Y;
  
  wire [7:0] Ytemp;
  
  assign Ytemp[0] = ~S[2]&~S[1]&~S[0]&I[0];
  assign Ytemp[1] = ~S[2]&~S[1]&S[0]&I[1];
  assign Ytemp[2] = ~S[2]&S[1]&~S[0]&I[2];
  assign Ytemp[3] = ~S[2]&S[1]&S[0]&I[3];
  assign Ytemp[4] = S[2]&~S[1]&~S[0]&I[4];
  assign Ytemp[5] = S[2]&~S[1]&S[0]&I[5];
  assign Ytemp[6] = S[2]&S[1]&~S[0]&I[6];
  assign Ytemp[7] = S[2]&S[1]&S[0]&I[7];
  
  assign Y = Ytemp[7] | Ytemp[6] | Ytemp[5] | Ytemp[4] | Ytemp[3] | 			 Ytemp[2] | Ytemp[1] | Ytemp[0];
  
endmodule

// Structural modelling_03 //
module full_adder(A, B, Cin, S, Cout);
  input A, B, Cin;
  output wire S, Cout;
  
  wire [7:0] tempOut1;
  wire [2:0] tempA;
  
  assign tempA[0] = Cin;
  assign tempA[1] = B;
  assign tempA[2] = A;
  
  decoder3to8_withoutE inst1(tempA, tempOut1);
 	
  assign S = tempOut1[1] | tempOut1[2] | tempOut1[4] | tempOut1[7];
  
  mux8to1_withoutE inst2(8'b11101000, tempA, Cout);
endmodule

// Structural modelling_04 //
module ripple_carry_adder(A, B, Cin, S, Cout, C7);
  input [7:0] A, B;
  input Cin;
  output wire [7:0] S;
  output wire Cout, C7;
  
  wire temp1, temp2, temp3, temp4, temp5, temp6;
  
  full_adder inst3(A[0], B[0], Cin, S[0], temp1);
  full_adder inst4(A[1], B[1], temp1, S[1], temp2);
  full_adder inst5(A[2], B[2], temp2, S[2], temp3);
  full_adder inst6(A[3], B[3], temp3, S[3], temp4);
  full_adder inst7(A[4], B[4], temp4, S[4], temp5);
  full_adder inst8(A[5], B[5], temp5, S[5], temp6);
  full_adder inst9(A[6], B[6], temp6, S[6], C7);
  full_adder inst10(A[7], B[7], C7, S[7], Cout);
  
endmodule

// Structural modelling_05 //
module adder_subtractor(A, B, M, S, Cout, Overflow);
  input [7:0] A, B;
  input M;
  output wire [7:0] S;
  output wire Cout, Overflow;
  
  wire [7:0] tempB;
  wire C7;
  
  xor inst11(tempB[0], B[0], M);
  xor inst12(tempB[1], B[1], M);
  xor inst13(tempB[2], B[2], M);
  xor inst14(tempB[3], B[3], M);
  xor inst15(tempB[4], B[4], M);
  xor inst16(tempB[5], B[5], M);
  xor inst17(tempB[6], B[6], M);
  xor inst18(tempB[7], B[7], M);
  
  ripple_carry_adder inst8(A, tempB, M, S, Cout, C7);
  xor inst19(Overflow, Cout, C7);
  
endmodule

// Structural modelling_06 //
module comparator_unsigned(A, B, AgB, AlB, AeB);
  input [7:0] A, B;
  output wire AgB, AlB, AeB;
  
  wire [7:0] S;
  wire Cout, C7;
  
  adder_subtractor inst1(A, B, 1'b1, S, Cout, C7);
  
  assign AlB = ~Cout;
  assign AgB = Cout & ~AeB;
  assign AeB = (A == B);
  
endmodule
module ALU(
    input clk,
    input Reset,
    input ALUSave,              
    input Imm7,                 
    input [4:0] OpCode,         
    input [7:0] Op1, Op2,      
    output wire Zflag,         
    output wire Cflag,         
    output wire [7:0] ALUout
);
    wire M, Cout, temp, carryFlagValue;
    wire [7:0] Sum, Or, And, Xor, LShift, RShift, selectedAns;

    // Determine operation type
    Mux32to1_1bit_withoutE inst1(OpCode, {3'b0, Imm7, Imm7, 2'b0, 1'b1, 24'b0}, M);
    
    // ALU operations
    adder_subtractor inst2(Op1, Op2, M, Sum, Cout, temp);
    assign Or = Op1 | Op2;
    assign And = Op1 & Op2;
    assign Xor = Op1 ^ Op2;
    assign LShift = Op1 << {Op2[2], Op2[1], Op2[0]};
    assign RShift = Op1 >> {Op2[2], Op2[1], Op2[0]};

    // Result selection
    Mux32to1_8bitRP inst3(OpCode, 
        8'b0, 8'b0, 8'b0, Sum, Sum, LShift, RShift, Sum, 
        Sum, 8'b0, Sum, 8'b0, 8'b0, Sum, 8'b0, 8'b0, 
        8'b0, 8'b0, 8'b0, Sum, 8'b0, Sum, Sum, Sum, 
        Xor, Or, And, Sum, Xor, Or, And, Sum, selectedAns);

    // Carry flag logic
    Mux32to1_1bit_withoutE inst4(OpCode, 
        {{5{1'b0}}, Op1[7], Op1[0], Cout, {15{1'b0}}, Cout, {3{1'b0}}, Cout, {4{1'b0}}}, 
        carryFlagValue);

    // Output registers with original names
    eightbitRegwithLoad inst5(clk, Reset, ALUSave, selectedAns, ALUout);
    onebitRegwithLoad inst6(clk, Reset, ALUSave, carryFlagValue, Cflag);
    onebitRegwithLoad inst7(clk, Reset, ALUSave, 
        ~(selectedAns[7] | selectedAns[6] | selectedAns[5] | selectedAns[4] | 
          selectedAns[3] | selectedAns[2] | selectedAns[1] | selectedAns[0]), 
        Zflag);

endmodule
module ControlLogic(clk, Reset, T1, T2, T3, T4, Zflag, PC_Update, SRam_R, SRam_W, Cflag, opcode, StackRead, StackWrite, ALU_Save,ZFlag_Save,CFlag_Save,INportRead, OutportWrite, RegfileRead, Regfilewrite);
input clk, Reset, T1, T2, T3, T4, Zflag, Cflag;
input wire [4:0] opcode;
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

Mux_32to1withE inst20(I1, opcode,T3, SRam_W);
Mux_32to1withE inst21(I2, opcode,T3, SRam_R);
Mux_32to1withE inst22(I3, opcode,T1, RegfileRead);
Mux_32to1withE inst23(I4, opcode,T4 ,Regfilewrite);
Mux_32to1withE inst24(I5, opcode,T3, OutportWrite);
Mux_32to1withE inst25(I6, opcode,T2, ALU_Save);
Mux_32to1withE inst26(I7, opcode,T2, ZFlag_Save);
Mux_32to1withE inst27(I8, opcode, T2,CFlag_Save);
Mux_32to1withE inst28(I9, opcode,T3, StackWrite);
Mux_32to1withE inst29(I10, opcode,T3, StackRead);
Mux_32to1withE inst30(I11, opcode,T3, INportRead);
Mux_32to1withE inst31(I12, opcode,T4, PC_Update);

endmodule
module decoder4to16_withE_method1(A, E, D);
  input [3:0]A;			// 4-bit input
  input E;				// 1-bit enable
  output reg [15:0] D;	// 16-bit output
  
  
  always @(*)
    begin
      if (E == 1'b0)
       	D = 16'b0000_0000_0000_0000;
      else
       	begin
        	if (A == 4'b0000)
        		D = 16'b0000_0000_0000_0001;
      		else if (A == 4'b0001)
		        D = 16'b0000_0000_0000_0010;
          	else if (A == 4'b0010)
            	D = 16'b0000_0000_0000_0100;
          	else if (A == 4'b0011)
              	D = 16'b0000_0000_0000_1000;
          	else if (A == 4'b0100)
              	D = 16'b0000_0000_0001_0000;
          	else if (A == 4'b0101)
              	D = 16'b0000_0000_0010_0000;	
          	else if (A == 4'b0110)
            	D = 16'b0000_0000_0100_0000;	
          	else if (A == 4'b0111)
            	D = 16'b0000_0000_1000_0000;
          	else if (A == 4'b1000)
            	D = 16'b0000_0001_0000_0000;
          	else if (A == 4'b1001)
              	D = 16'b0000_0010_0000_0000;
          	else if (A == 4'b1010)
              	D = 16'b0000_0100_0000_0000;
          	else if (A == 4'b1011)
            	D = 16'b0000_1000_0000_0000;
          	else if (A == 4'b1100)
              	D = 16'b0001_0000_0000_0000;
          	else if (A == 4'b1101)
            	D = 16'b0010_0000_0000_0000;
            else if (A == 4'b1110)
            	D = 16'b0100_0000_0000_0000;
          	else if (A == 4'b1111)
              	D = 16'b1000_0000_0000_0000;
          	else
              	D = 16'b0000_0000_0000_0000;
        end
    end
endmodule

// register
module eightbitRegwithLoad(
    input clk,
    input Rst,
    input L,               // Changed order to match usage
    input [7:0] Datain,
    output reg [7:0] Dataout
);
    wire [7:0] Y;
    assign Y = (L == 1'b1) ? Datain : Dataout;

    always @(posedge clk) begin
        if (Rst)
            Dataout <= 8'b0000_0000;
        else
            Dataout <= Y;
    end
endmodule
///////////////////////////////////////////////

//mux16to1_8bit
module mux16to1_8_bit_withoutE(I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, S, Y);
    input [7:0] I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15;
    input [3:0] S;
    output reg [7:0] Y;

    always @(*) begin
        case (S)
            4'b0000: Y = I0;
            4'b0001: Y = I1;
            4'b0010: Y = I2;
            4'b0011: Y = I3;
            4'b0100: Y = I4;
            4'b0101: Y = I5;
            4'b0110: Y = I6;
            4'b0111: Y = I7;
            4'b1000: Y = I8;
            4'b1001: Y = I9;
            4'b1010: Y = I10;
            4'b1011: Y = I11;
            4'b1100: Y = I12;
            4'b1101: Y = I13;
            4'b1110: Y = I14;
            4'b1111: Y = I15;  
            default: Y = 8'b0000_0000;
        endcase
    end
endmodule

module registerfile(
    input [7:0] Datain,
    input [3:0] AddressR1, AddressR2, AddressW,
    input R, W, clk, Rst,
    output wire [7:0] Dataout1, Dataout2
);
    // Generate write address using decoder
    wire [15:0] write_address;
    wire [7:0] read_data_1, read_data_2;
    
    decoder4to16_withE_method1 inst32(
        .A(AddressW),
        .E(W),
        .D(write_address)
    );

    // Register array with proper initialization
    reg [7:0] D [0:15];
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1)
            D[i] = 8'b0;
    end

    // Write operation
    always @(posedge clk) begin
        if (Rst) begin
            for (i = 0; i < 16; i = i + 1)
                D[i] <= 8'b0;
        end
        else if (W)  // Only write when enabled
            if (write_address[AddressW])
                D[AddressW] <= Datain;
    end

    // Read multiplexers
    assign read_data_1 = (R) ? D[AddressR1] : 8'b0;
    assign read_data_2 = (R) ? D[AddressR2] : 8'b0;

    // Output registers
    RegisterSynW output_reg1(
        .clk(clk),
        .Reset(Rst),
        .W(R),
        .Datain(read_data_1),
        .Dataout(Dataout1)
    );

    RegisterSynW output_reg2(
        .clk(clk),
        .Reset(Rst),
        .W(R),
        .Datain(read_data_2),
        .Dataout(Dataout2)
    );

endmodule
module INPort (
    clk,
    Reset,
    INPortRead,
    InpExtWorld1,
    InpExtWorld2,
    InpExtWorld3,
    InpExtWorld4,
    Address,
    Dataout
);
    input clk, Reset, INPortRead;
    input [7:0] InpExtWorld1, InpExtWorld2, InpExtWorld3, InpExtWorld4, Address;
    output wire [7:0] Dataout;

    wire [7:0] InPort1Dout, InPort2Dout, InPort3Dout, InPort4Dout;

    RegisterSynW inst53(clk, 1'b0, 1'b1, InpExtWorld1, InPort1Dout);
    RegisterSynW inst54(clk, 1'b0, 1'b1, InpExtWorld2, InPort2Dout);
    RegisterSynW inst55(clk, 1'b0, 1'b1, InpExtWorld3, InPort3Dout);
    RegisterSynW inst56(clk, 1'b0, 1'b1, InpExtWorld4, InPort4Dout);
    
    wire comp1, comp2, comp3, comp4;
    wire dummy;
    comparator_unsigned inst57(Address, 8'b1111_0001, dummy, dummy, comp1); 
    comparator_unsigned inst58(Address, 8'b1111_0010, dummy, dummy, comp2);
    comparator_unsigned inst59(Address, 8'b1111_0011, dummy, dummy, comp3);
    comparator_unsigned inst60(Address, 8'b1111_0100, dummy, dummy, comp4);

   reg [1:0] portSel_reg;

always @(*) begin
    if (comp4 == 1'b1) begin
        portSel_reg = 2'b11;
    end
    else if (comp3 == 1'b1) begin
        portSel_reg = 2'b10;
    end
    else if (comp2 == 1'b1) begin
        portSel_reg = 2'b01;
    end
    else if (comp1 == 1'b1) begin
        portSel_reg = 2'b00;
    end
    else begin
        portSel_reg = 2'b00;
    end
end

    Mux_4to1 inst61(InPort1Dout, InPort2Dout, InPort3Dout, InPort4Dout, portSel_reg, Dataout);
endmodule
module InstMEM(
    input clk,
    input Reset,
    input [7:0] Address,
    input InstRead,
    output reg [24:0] Dataout,
    output reg [4:0] opcode,
    output reg [3:0] Destin, Source1, Source2,
    output reg [7:0] Imm
);

    wire [24:0] rom_out;
    wire [4:0] rom_opcode;
    wire [3:0] rom_Destin, rom_Source1, rom_Source2;
    wire [7:0] rom_Imm;
    
    ROM inst1(
        .Address(Address),
        .Dataout(rom_out),
        .Opcode(rom_opcode),
        .Destin(rom_Destin),
        .Source1(rom_Source1),
        .Source2(rom_Source2),
        .Imm(rom_Imm)
    );

    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            Dataout <= 25'b0;
            opcode  <= 5'b0;
            Destin  <= 4'b0;
            Source1 <= 4'b0;
            Source2 <= 4'b0;
            Imm     <= 9'b0;
        end else if (InstRead) begin
            Dataout <= rom_out;
            opcode  <= rom_opcode;
            Destin  <= rom_Destin;
            Source1 <= rom_Source1;
            Source2 <= rom_Source2;
            Imm     <= rom_Imm;
        end
    end

endmodule
module Mux_2to1(I0,I1,Sel,Y);
input [7:0] I1;
input[7:0] I0; 
input Sel;
output reg[7:0] Y;
always @(*)begin
    case(Sel)
    1'b1: Y=I1;
    1'b0: Y=I0;
    default: Y=8'b0;
    endcase
end
endmodule
module Mux_4to1 (
    input [7:0] I0, I1, I2, I3,
    input [1:0] Sel,  
    output reg [7:0] Y           
);
    
    always @(*) begin
        case(Sel)
            2'b00: Y = I0;
            2'b01: Y = I1;
            2'b10: Y = I2;
            2'b11: Y = I3;
            default: Y = 8'b0; 
        endcase
    end

endmodule
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
module Mux_32to1 (
    I, OpCode, Y
);
    input [31:0] I;
    input [4:0] OpCode;
    output reg Y;

    always @(*) begin
        case(OpCode)
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
endmodule
module Mux_32to1withE (
    I, OpCode,E, Y
);
    input [31:0] I;
    input E;
    
    input [4:0] OpCode;
    output reg Y;

    always @(*) begin
        if (E) begin
        case(OpCode)
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
module OUTPort (
    input clk,
    input Reset,
    input [7:0] Address,
    input [7:0] Datain,
    input OutportWrite,    // Missing write enable
    output reg [7:0] OUTPortWire1,
    output reg [7:0] OUTPortWire2,
    output reg [7:0] OUTPortWire3,
    output reg [7:0] OUTPortWire4
);
    // Fix: Add OutportWrite check
    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            OUTPortWire1 <= 8'b0;
            OUTPortWire2 <= 8'b0;
            OUTPortWire3 <= 8'b0;
            OUTPortWire4 <= 8'b0;
        end
        else if (OutportWrite) begin  // Only write when enabled
            case (Address[1:0])
                2'b00: OUTPortWire1 <= Datain;
                2'b01: OUTPortWire2 <= Datain;
                2'b10: OUTPortWire3 <= Datain;
                2'b11: OUTPortWire4 <= Datain;
            endcase
        end
    end
endmodule
module ProgCounter(PCenable, Reset, PCupdate, clk, CAddress, PC, PC_D2);
    input PCenable, PCupdate, clk, Reset;
    input [7:0] CAddress;
    output [7:0] PC;
    output [7:0] PC_D2;
    
    wire [7:0] mux1_out;
    wire [7:0] adder_out;
    
    // First mux to select between 0 and 1 based on PCenable
    Mux_2to1 inst62(8'b00000000, 8'b00000001, PCenable, mux1_out);
    
    // Simple addition instead of ripple carry adder
    assign adder_out = PC + mux1_out;
    
    wire [7:0] mux2_out;
    // Second mux to select between incremented PC and new address
    Mux_2to1 inst64(adder_out, CAddress, PCupdate, mux2_out);
    
    // Program Counter Register
    RegisterSynW inst65(clk, Reset, 1'b1, mux2_out, PC);
    
    // Two stage delay for PC
    wire [7:0] PC_D1;
    RegisterSynW inst66(clk, Reset, 1'b1, PC, PC_D1);
    RegisterSynW inst67(clk, Reset, 1'b1, PC_D1, PC_D2);
    
endmodule


module RegisterSynW_25bit (
    clk,
    Reset,
    W,
    Datain,
    Dataout
);
    input clk, Reset, W;
    input [24:0] Datain;
    output reg [24:0] Dataout;

    always @(posedge clk) begin
        if (Reset)
            Dataout <= 24'b0000_0000_0000_0000_0000_0000;
        else if (W)
            Dataout <= Datain;
    end
endmodule
module RegisterSynW (
    input clk,
    input Reset,
    input W,           // Write enable not properly used
    input [7:0] Datain,
    output reg [7:0] Dataout
);
    // Fix: Add write enable check
    always @(posedge clk) begin
        if (Reset)
            Dataout <= 8'b0000_0000;
        else if (W)  // Only update when write is enabled
            Dataout <= Datain;
    end
endmodule
module ROM(
    input [7:0] Address,
    output reg [24:0] Dataout,
    output reg [4:0] Opcode,
    output reg [3:0] Destin,
    output reg [3:0] Source1,
    output reg [3:0] Source2,
    output reg [7:0] Imm
);
    reg [24:0] memory [0:255];
    
    initial begin
        $readmemb("ROM.txt", memory);
    end
    
    always @(Address) begin  // Changed from @* to @(Address)
        Dataout = memory[Address];
        Opcode  = Dataout[24:20];
        Destin  = Dataout[19:16];
        Source1 = Dataout[15:12];
        Source2 = Dataout[11:8];
        Imm     = Dataout[7:0];
    end
endmodule
module SRAM (
    input clk,                 
    input Reset,                // Synchronous Reset
    input [7:0] Address,        // 8-bit Address input
    input SRAMRead,             // Read Enable
    input SRAMWrite,            // Write Enable
    input [7:0] Datain,         // 8-bit Data input
    output reg [7:0] Dataout    // 8-bit Data output
);

    // Declaring 256 x 8-bit memory array
    reg [7:0] datamem [0:255];

    // Synchronous reset (clears memory)
    integer i;
    always @(posedge clk) begin
        if (Reset) begin
            for (i = 0; i < 256; i = i + 1)
                datamem[i] <= 8'b00000000; // Clearing memory on reset
        end 
        else if (SRAMWrite) begin
            datamem[Address] <= Datain; // Writing operation
        end
    end

    // Read operation (Combinational)
    always @(Address, SRAMRead) begin
        Dataout = (SRAMRead) ? datamem[Address] : 8'b00000000; // Reading from memory
    end

endmodule
module Stack (
    input clk,
    input Reset,
    input StackRead,
    input StackWrite,
    input [7:0] Datain,
    output [7:0] Dataout
);

    // Stack pointers
    reg [7:0] SP;  // Stack Pointer

    wire [7:0] SRAM_Dataout;
    wire [7:0] mux1_out, mux2_out;

    // Incremented and decremented stack pointers
    wire [7:0] SP_plus1, SP_minus1;

    assign SP_plus1 = SP + 1;
    assign SP_minus1 = SP - 1;

    // First MUX: Stack Pointer update source (SP, SP+1, SP–1, 0)
    mux4to1_8bit MUX_SP_Update (
        .S({StackWrite, StackRead}),  // Priority: Write=2'b10, Read=2'b01
        .I0(SP),                      // Default hold
        .I1(SP_minus1),               // On read (pop)
        .I2(SP_plus1),                // On write (push)
        .I3(8'b00000000),             // Not used
        .Y(mux1_out)
    );

    // SRAM instance
    SRAM stack_mem (
        .clk(clk),
        .Reset(Reset),
        .Address(SP),
        .SRAMRead(StackRead),
        .SRAMWrite(StackWrite),
        .Datain(Datain),
        .Dataout(SRAM_Dataout)
    );

    // Second MUX: SRAM output 
    mux4to1_8bit MUX_Dataout_Select (
        .S({1'b0, StackRead}),   // Select line: 2'b01 = Read, 2'b00 = default
        .I0(8'b00000000),        // Default when not reading
        .I1(SRAM_Dataout),       // Output from SRAM
        .I2(8'b00000000),        
        .I3(8'b00000000),        
        .Y(mux2_out)
    );

    // Assign output
    assign Dataout = mux2_out;

    // Stack Pointer logic
    always @(posedge clk) begin
        if (Reset)
            SP <= 8'b11111111;  // Stack empty
        else
            SP <= mux1_out;
    end

endmodule

module TimingGen(
    input clk,
    input Reset,
    output reg T0, T1, T2, T3, T4
);
    reg [2:0] state;

    always @(posedge clk or posedge Reset) begin
        if (Reset)
            state <= 3'b000;
        else
            state <= state + 1;
    end

    always @(*) begin
        T0 = (state == 3'b000);
        T1 = (state == 3'b001);
        T2 = (state == 3'b010);
        T3 = (state == 3'b011);
        T4 = (state == 3'b100);
    end
endmodule
`timescale 1ns/100ps

module DFFwithSynReset(clk, D, Rst, Q);
input clk, D, Rst;
output reg Q;
//////////with synchronous reset//////////////
always @(posedge clk)
	begin
			if(Rst == 1'b1)
				Q<=1'b0;
			else
				Q<=D;
	end
endmodule
/////////////////////////////////////////////////////////////////////


module DFFwithASynReset(clk, D, Rst, Q);
input clk, D, Rst;
output reg Q;
//////////with Asynchronous reset//////////////
always @(posedge clk, posedge Rst)
	begin
			if(Rst == 1'b1)
				Q<=1'b0;
			else
				Q<=D;
	end
endmodule
/////////////////////////////////////////////////////////////////////

// Dataflow modelling_01 //
module mux2to1_withoutE(S, I, Y);
  input S;
  input [1:0] I;
  output wire Y;
  
  assign Y = ~S&I[0] | S&I[1];
endmodule

// Dataflow modelling_02 //
module mux4to1_withoutE(S, I, Y);
  input [1:0] S;
  input [3:0] I;
  output wire Y;
  
  wire [3:0] Dtemp;
	
  assign Dtemp[0] = ~S[1]&~S[0]&I[0];
  assign Dtemp[1] = ~S[1]&S[0]&I[1];
  assign Dtemp[2] = S[1]&~S[0]&I[2];
  assign Dtemp[3] = S[1]&S[0]&I[3];
	
  assign Y = Dtemp[3] | Dtemp[2] | Dtemp[1] | Dtemp[0];  
endmodule

// Strucutural modelling_03 //
module onebitregister(Datain, W, R, Rst, clk, Dataout);
  input Datain, W, R, Rst, clk;
  output wire Dataout;
  
  wire Q1, D1, D2;
  
  mux2to1_withoutE inst89(W, {Datain, Q1}, D1);
  DFFwithSynReset inst90(clk, D1, Rst, Q1);
  
  mux2to1_withoutE inst91(R, {Q1, Dataout}, D2);
  DFFwithSynReset inst92(clk, D2, Rst, Dataout);
  
endmodule

// Structural modelling_04 //
module eightbitregister(Datain, W, R, Rst, clk, Dataout);
  input [7:0] Datain;
  input W, R, Rst, clk;
  output wire [7:0] Dataout;
  
  onebitregister inst93(Datain[0], W, R, Rst, clk, Dataout[0]);
  onebitregister inst94(Datain[1], W, R, Rst, clk, Dataout[1]);
  onebitregister inst95(Datain[2], W, R, Rst, clk, Dataout[2]);
  onebitregister inst96(Datain[3], W, R, Rst, clk, Dataout[3]);
  onebitregister inst97(Datain[4], W, R, Rst, clk, Dataout[4]);
  onebitregister inst99(Datain[5], W, R, Rst, clk, Dataout[5]);
  onebitregister inst98(Datain[6], W, R, Rst, clk, Dataout[6]);
  onebitregister inst100(Datain[7], W, R, Rst, clk, Dataout[7]);
  
endmodule

// Structural modelling_05 //

module Mux32to1_8bitRP(
    S, 
    I31, 
    I30, 
    I29, 
    I28, 
    I27, 
    I26, 
    I25, 
    I24, 
    I23, 
    I22, 
    I21, 
    I20, 
    I19, 
    I18, 
    I17, 
    I16, 
    I15, 
    I14, 
    I13, 
    I12, 
    I11, 
    I10, 
    I9, 
    I8, 
    I7, 
    I6, 
    I5, 
    I4, 
    I3, 
    I2, 
    I1, 
    I0, 
    Y
);
    input [4:0] S;
    input [7:0] I31, I30, I29, I28, I27, I26, I25, I24, I23, I22, I21, I20, I19, I18, I17, I16, I15, I14, I13, I12, I11, I10, I9, I8, I7, I6, I5, I4, I3, I2, I1, I0; // may need to replace this with a single flattened array
    output wire [7:0] Y;
    wire [7:0] I [31:0];

    assign { I[31], I[30], I[29], I[28], I[27], I[26], I[25], I[24], I[23], I[22], I[21], I[20], I[19], I[18], I[17], I[16], I[15], I[14], I[13], I[12], I[11], I[10], I[9], I[8], I[7], I[6], I[5], I[4], I[3], I[2], I[1], I[0] } = { I31, I30, I29, I28, I27, I26, I25, I24, I23, I22, I21, I20, I19, I18, I17, I16, I15, I14, I13, I12, I11, I10, I9, I8, I7, I6, I5, I4, I3, I2, I1, I0 };
    assign Y = I[S];
endmodule

// Add missing module: Mux32to1_1bit_withoutE
module Mux32to1_1bit_withoutE(
    input [4:0] S,
    input [31:0] I,
    output wire Y
);
    assign Y = I[S];  // Direct selection using array indexing
endmodule

// Add missing module: Mux32to1_8bit
module Mux32to1_8bit(
    input [4:0] S,
    input [7:0] I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15,
    input [7:0] I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31,
    output reg [7:0] Y
);
    always @(*) begin
        case(S)
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
            default: Y = 8'b0;
        endcase
    end
endmodule

// Add missing module: onebitRegwithLoad
module onebitRegwithLoad(
    input clk,
    input Reset,
    input load,
    input Datain,
    output reg Dataout
);
    always @(posedge clk) begin
        if (Reset)
            Dataout <= 1'b0;
        else if (load)
            Dataout <= Datain;
    end
endmodule
