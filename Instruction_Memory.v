module inst_mem(
clk,
Reset,
Address,
instRead
Dataout,
opcode,
Destin,
Source1,
Source2,
Imm
);
input clk, Reset, instRead;
input [7:0] Address;
output [24:0] Dataout;
output [4:0] opcode, ;
output [3:0] Destin, Source1, Source2;
output [7:0] Imm;
wire rom_out [24:0];
ROM inst1(Address, rom_out);
RegisterSynW_25bit inst2(clk, Reset, instRead, rom_out, Dataout);
assign opcode = Dataout[4:0];
assign Destin = Dataout[8:5];
assign Source1 = Dataout[12:9];
assign Source2 = Dataout[16:13];
assign Imm = Dataout[24:17];
wire [24:0] Data_1, Data_2, Data3;
wire [4:0] opcode_1, opcode_2, opcode_3;
wire [3:0] Destin_1, Destin_2, Destin_3;
wire [3:0] Source1_1, Source1_2, Source1_3;
wire [3:0] Source2_1, Source2_2, Source2_3;
wire [7:0] Imm_1, Imm_2, Imm_3;
RegisterSynW_25bit inst3(clk, Reset, 1'b0, Dataout, Data_1);
assign opcode_1 = Data_1[4:0];
assign Destin_1 = Data_1[8:5];
assign Source1_1 = Data_1[12:9];
assign Source2_1 = Data_1[16:13];
assign Imm_1 = Data_1[24:17];
RegisterSynW_25bit inst4(clk, Reset, 1'b0, Data_1, Data_2);
assign opcode_2 = Data_2[4:0];
assign Destin_2 = Data_2[8:5];
assign Source1_2 = Data_2[12:9];
assign Source2_2 = Data_2[16:13];
assign Imm_2 = Data_2[24:17];
RegisterSynW_25bit inst5(clk, Reset, 1'b0, Data_2, Data_3);
assign opcode_3 = Data_3[4:0];
assign Destin_3 = Data_3[8:5];
assign Source1_3 = Data_3[12:9];
assign Source2_3 = Data_3[16:13];
assign Imm_3 = Data_3[24:17];
endmodule