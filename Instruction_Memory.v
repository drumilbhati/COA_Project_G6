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
always @(posedge clk or posedge Reset) begin
    if (Reset) begin
        Dataout <= 25'b0;
        Data_1 <= 25'b0;
        Data_2 <= 25'b0;
        Data_3 <= 25'b0;
    end else if (instRead) begin
        Dataout <= rom_out;
        Data_1 <= rom_out[24:20];
        Data_2 <= rom_out[19:16];
        Data_3 <= rom_out[15:12];
    end
end
always @(posedge clk) begin
    opcode <= Dataout[24:20];
    Destin <= Dataout[19:16];
    Source1 <= Dataout[15:12];
    Source2 <= Dataout[11:8];
    Imm <= Dataout[7:0];
endmodule