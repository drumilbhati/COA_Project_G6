module Program_Counter(Enable_PC,Reset, Update_PC, clk, New_Address, PC, PC_D2);
input Enable_PC, Update_PC, clk;
input[7:0] New_Address;
output[7:0] PC;
output[7:0] PC_D2;
wire cout,c7;
wire[7:0] mux1_out;
wire[7:0] adder_out;
Mux_2to1 inst1(8'b00000000,8'b00000001,Enable_PC,mux1_out);
ripple_carry_adder inst2(mux1_out,PC, 1'b0,adder_out,cout,c7);
wire[7:0] mux2_out;
Mux_2to1 inst3(adder_out,New_Address,Update_PC,mux2_out);
RegisterSynW inst4(clk,Reset,1'b1,mux2_out,PC);
wire[7:0] PC_D1;
RegisterSynW inst5(clk,Reset,1'b1,PC,PC_D1);
RegisterSynW inst6(clk,Reset,1'b1,PC_D1,PC_D2);
endmodule