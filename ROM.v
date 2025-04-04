module ROM(
    input [7:0] Address,
    output reg [24:0] Dataout,
    output reg [4:0] Opcode,
    output reg [3:0] Destin,
    output reg [3:0] Source1,
    output reg [3:0] Source2,
    output reg [8:0] Imm
);
    
    reg [24:0] memory [0:255];
    
    initial begin
        $readmemb("ROM.txt", memory);
    end
    
    always @(*) begin
        Dataout = memory[Address];
        Opcode  = Dataout[24:20];  // First 5 bits (MSB) for Opcode
        Destin  = Dataout[19:16];  // Next 4 bits for Destination Register
        Source1 = Dataout[15:12];  // Next 4 bits for Source Register 1
        Source2 = Dataout[11:8];   // Next 4 bits for Source Register 2
        Imm     = Dataout[8:0];    // Last 9 bits for Immediate value
    end
endmodule
