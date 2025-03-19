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
  
  mux2to1_withoutE inst1(W, {Datain, Q1}, D1);
  DFFwithSynReset inst2(clk, D1, Rst, Q1);
  
  mux2to1_withoutE inst3(R, {Q1, Dataout}, D2);
  DFFwithSynReset inst4(clk, D2, Rst, Dataout);
  
endmodule

// Structural modelling_04 //
module eightbitregister(Datain, W, R, Rst, clk, Dataout);
  input [7:0] Datain;
  input W, R, Rst, clk;
  output wire [7:0] Dataout;
  
  onebitregister inst0(Datain[0], W, R, Rst, Clk, Dataout[0]);
  onebitregister inst1(Datain[1], W, R, Rst, Clk, Dataout[1]);
  onebitregister inst2(Datain[2], W, R, Rst, Clk, Dataout[2]);
  onebitregister inst3(Datain[3], W, R, Rst, Clk, Dataout[3]);
  onebitregister inst4(Datain[4], W, R, Rst, Clk, Dataout[4]);
  onebitregister inst5(Datain[5], W, R, Rst, Clk, Dataout[5]);
  onebitregister inst6(Datain[6], W, R, Rst, Clk, Dataout[6]);
  onebitregister inst7(Datain[7], W, R, Rst, Clk, Dataout[7]);
  
endmodule

// Structural modelling_05 //
module USReightbit(Datain, Rst, clk, Sel, Dataout);
  input [7:0] Datain;
  input Rst, clk;
  input [1:0] Sel;
  output wire [7:0] Dataout;
  
  wire D0, D1, D2, D3, D4, D5, D6, D7;
  
  mux4to1_withoutE inst0(Sel, {Datain[0], 1'b0, Dataout[1], Dataout[0]}, D0);
  DFFwithSynReset inst00(clk, D0, Rst, Dataout[0]);
  
  mux4to1_withoutE inst1(Sel, {Datain[1], Dataout[0], Dataout[2], Dataout[1]}, Dataout[1]);
  DFFwithSynReset inst11(clk, D1, Rst, Dataout[1]);
  
  mux4to1_withoutE inst2(Sel, {Datain[2], Dataout[1], Dataout[3], Dataout[2]}, Dataout[2]);
  DFFwithSynReset inst22(clk, D2, Rst, Dataout[2]);
  
  mux4to1_withoutE inst3(Sel, {Datain[3], Dataout[2], Dataout[4], Dataout[3]}, Dataout[3]);
  DFFwithSynReset inst33(clk, D3, Rst, Dataout[3]);
  
  mux4to1_withoutE inst4(Sel, {Datain[4], Dataout[3], Dataout[5], Dataout[4]}, Dataout[4]);
  DFFwithSynReset inst44(clk, D4, Rst, Dataout[4]);
  
  mux4to1_withoutE inst5(Sel, {Datain[5], Dataout[4], Dataout[6], Dataout[5]}, Dataout[5]);
  DFFwithSynReset inst55(clk, D5, Rst, Dataout[5]);
  
  mux4to1_withoutE inst6(Sel, {Datain[6], Dataout[5], Dataout[7], Dataout[6]}, Dataout[6]);
  DFFwithSynReset inst66(clk, D6, Rst, Dataout[6]);
  
  mux4to1_withoutE inst7(Sel, {Datain[7], Dataout[6], Dataout[0], Dataout[7]}, Dataout[7]);
  DFFwithSynReset inst77(clk, D7, Rst, Dataout[7]);
  
endmodule