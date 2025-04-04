module inst_mem(
    input clk,
    input Reset,
    input [7:0] Address,
    input instRead,
    output reg [24:0] Dataout,
    output reg [4:0] opcode,
    output reg [3:0] Destin, Source1, Source2,
    output reg [8:0] Imm
);

    wire [24:0] rom_out;
    wire [4:0] rom_opcode;
    wire [3:0] rom_Destin, rom_Source1, rom_Source2;
    wire [8:0] rom_Imm;
    
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
        end else if (instRead) begin
            Dataout <= rom_out;
            opcode  <= rom_opcode;
            Destin  <= rom_Destin;
            Source1 <= rom_Source1;
            Source2 <= rom_Source2;
            Imm     <= rom_Imm;
        end
    end

endmodule