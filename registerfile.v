// decoder
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
module eightbitRegwithLoad(clk, Datain, Rst, L, Dataout);
input clk, L, Rst;
input [7:0] Datain;
output reg [7:0] Dataout;

wire [7:0] Y;

assign Y = (L == 1'b1)? Datain: Dataout; //represents 2to1MUX_8-bit 

//////////with synchronous reset//////////////
always @(posedge clk)
	begin
			if(Rst == 1'b1)
				Dataout<=8'b0000_0000;
			else
				Dataout<=Y;
	end
endmodule
/////////////////////////////////////////////////////////////////////

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

module registerfile(Datain, AddressW, AddressR1, AddressR2, R, W, clk, Rst, Dataout1, Dataout2);
    input [7:0] Datain;
	input [3:0] AddressR1, AddressR2, AddressW;
	input R, W, clk, Rst;

	output wire [7:0] Dataout1, Dataout2;

	wire[15:0] write_address;
	decoder4to16_withE_method1 inst1(AddressW, W, write_address);

	wire [7:0] D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15;

	eightbitRegwithLoad inst00(clk, Datain, Rst, write_address[0], D0);
	eightbitRegwithLoad inst01(clk, Datain, Rst, write_address[1], D1);
	eightbitRegwithLoad inst02(clk, Datain, Rst, write_address[2], D2);
	eightbitRegwithLoad inst03(clk, Datain, Rst, write_address[3], D3);
	eightbitRegwithLoad inst04(clk, Datain, Rst, write_address[4], D4);
	eightbitRegwithLoad inst05(clk, Datain, Rst, write_address[5], D5);
	eightbitRegwithLoad inst06(clk, Datain, Rst, write_address[6], D6);
	eightbitRegwithLoad inst07(clk, Datain, Rst, write_address[7], D7);
	eightbitRegwithLoad inst08(clk, Datain, Rst, write_address[8], D8);
	eightbitRegwithLoad inst09(clk, Datain, Rst, write_address[9], D9);
	eightbitRegwithLoad inst10(clk, Datain, Rst, write_address[10], D10);
	eightbitRegwithLoad inst11(clk, Datain, Rst, write_address[11], D11);
	eightbitRegwithLoad inst12(clk, Datain, Rst, write_address[12], D12);
	eightbitRegwithLoad inst13(clk, Datain, Rst, write_address[13], D13);
	eightbitRegwithLoad inst14(clk, Datain, Rst, write_address[14], D14);
	eightbitRegwithLoad inst15(clk, Datain, Rst, write_address[15], D15);

	wire [7:0] read_data_1, read_data_2;

	mux16to1_8_bit_withoutE inst2(D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, AddressR1, read_data_1);
	mux16to1_8_bit_withoutE inst3(D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, AddressR2, read_data_2);

	eightbitRegwithLoad inst4(clk, read_data_1, Rst, R, Dataout1);
	eightbitRegwithLoad inst5(clk, read_data_2, Rst, R, Dataout2);
endmodule