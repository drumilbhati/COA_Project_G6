module RISCprocessor(
    input clk,
    input Reset,
    input [7:0] InpExtWorld1,
    input [7:0] InpExtWorld2,
    input [7:0] InpExtWorld3,
    input [7:0] InpExtWorld4,
    output [7:0] OutExtWorld1,
    output [7:0] OutExtWorld2,
    output [7:0] OutExtWorld3,
    output [7:0] OutExtWorld4
);

    // Internal signals
    wire [7:0] PC, PC_D2, CAddress;
    wire [24:0] InstOut;
    wire [4:0] Opcode;
    wire [3:0] Destin, Source1, Source2;
    wire [7:0] Imm;
    wire [7:0] Dataout1, Dataout2;
    wire [7:0] ALUout;
    wire ALUSave, ZflagSave, CflagSave, Zflag, Cflag;
    wire SRAMRead, SRAMWrite, StackRead, StackWrite;
    wire RegFileRead, RegFileWrite, INportRead, OUTportWrite;
    
    // Instantiate modules
    ProgCounter PC_Module(
        .clk(clk),
        .Reset(Reset),
        .PCenable(1'b1),
        .PCupdate(PCupdate),
        .CAddress(CAddress),
        .PC(PC),
        .PC_D2(PC_D2)
    );
    
    InstMEM Inst_Memory(
        .clk(clk),
        .Reset(Reset),
        .Address(PC),
        .InstRead(1'b1),
        .Dataout(InstOut),
        .Opcode(Opcode),
        .Destin(Destin),
        .Source1(Source1),
        .Source2(Source2),
        .Imm(Imm)
    );
    
    RegisterFile Reg_File(
        .clk(clk),
        .Reset(Reset),
        .RegFileRead(RegFileRead),
        .RegFileWrite(RegFileWrite),
        .Datain(ALUout),
        .Source1(Source1),
        .Source2(Source2),
        .Destin(Destin),
        .Dataout1(Dataout1),
        .Dataout2(Dataout2)
    );
    
    ALU ALU_Module(
        .clk(clk),
        .Reset(Reset),
        .Imm7(Imm),
        .Operand1(Dataout1),
        .Operand2(Dataout2),
        .Opcode(Opcode),
        .ALUSave(ALUSave),
        .ZflagSave(ZflagSave),
        .CflagSave(CflagSave),
        .Zflag(Zflag),
        .Cflag(Cflag),
        .ALUout(ALUout)
    );
    
    ControlLogic Ctrl_Logic(
        .clk(clk),
        .Reset(Reset),
        .Opcode(Opcode),
        .Zflag(Zflag),
        .Cflag(Cflag),
        .RegFileRead(RegFileRead),
        .RegFileWrite(RegFileWrite),
        .SRAMRead(SRAMRead),
        .SRAMWrite(SRAMWrite),
        .StackRead(StackRead),
        .StackWrite(StackWrite),
        .INportRead(INportRead),
        .OUTportWrite(OUTportWrite)
    );
    
    INport Input_Module(
        .clk(clk),
        .Reset(Reset),
        .INportRead(INportRead),
        .InpExtWorld1(InpExtWorld1),
        .InpExtWorld2(InpExtWorld2),
        .InpExtWorld3(InpExtWorld3),
        .InpExtWorld4(InpExtWorld4)
    );
    
    OUTport Output_Module(
        .clk(clk),
        .Reset(Reset),
        .OUTportWrite(OUTportWrite),
        .Datain(ALUout),
        .OutExtWorld1(OutExtWorld1),
        .OutExtWorld2(OutExtWorld2),
        .OutExtWorld3(OutExtWorld3),
        .OutExtWorld4(OutExtWorld4)
    );

endmodule