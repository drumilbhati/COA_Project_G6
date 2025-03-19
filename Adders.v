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

// Dataflow modelling_02 //
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
  
  mux8to1_withoutE inst2(8'b10010110, tempA, Cout);
endmodule

// Structural modelling_04 //
module ripple_carry_adder(A, B, Cin, S, Cout, C7);
  input [7:0] A, B;
  input Cin;
  output wire [7:0] S;
  output wire Cout, C7;
  
  wire temp1, temp2, temp3, temp4, temp5, temp6;
  
  full_adder inst1(A[0], B[0], Cin, S[0], temp1);
  full_adder inst2(A[1], B[1], temp1, S[1], temp2);
  full_adder inst3(A[2], B[2], temp2, S[2], temp3);
  full_adder inst4(A[3], B[3], temp3, S[3], temp4);
  full_adder inst5(A[4], B[4], temp4, S[4], temp5);
  full_adder inst6(A[5], B[5], temp5, S[5], temp6);
  full_adder inst7(A[6], B[6], temp6, S[6], C7);
  full_adder inst8(A[7], B[7], C7, S[7], Cout);
  
endmodule

// Structural modelling_05 //
module adder_subtractor(A, B, M, S, Cout, Overflow);
  input [7:0] A, B;
  input M;
  output wire [7:0] S;
  output wire Cout, Overflow;
  
  wire [7:0] tempB;
  wire C7;
  
  xor inst0(tempB[0], B[0], M);
  xor inst1(tempB[1], B[1], M);
  xor inst2(tempB[2], B[2], M);
  xor inst3(tempB[3], B[3], M);
  xor inst4(tempB[4], B[4], M);
  xor inst5(tempB[5], B[5], M);
  xor inst6(tempB[6], B[6], M);
  xor inst7(tempB[7], B[7], M);
  
  ripple_carry_adder inst8(A, tempB, M, S, Cout, C7);
  xor inst10(Overflow, Cout, C7);
  
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