module ROM(Address, Dataout);
input [7:0] Address;
output [24:0] Dataout;
reg[24:0] memory [0:255];
initial begin
$readmemb("ROM.txt", memory);
end
assign Dataout = memory[Address];
endmodule


