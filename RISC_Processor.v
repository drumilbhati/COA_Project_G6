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
    wire [7:0] RegDataout1, RegDataout2, RegDatain;
    // * instruction memory
    wire [4:0] Opcode;
    wire [3:0] Source1, Source2, Destin;
    wire [7:0] Imm;
    wire [24:0] currentInstruction;

    // * SRAM
    wire [7:0] SRAMAddress, SRAMDataout;

    // * Stack
    wire [7:0] StackAddress, StackDatain, StackDataout;

    // * ALU
    wire [7:0] Operand1, Operand2, ALUout;

    // * timing phases
    wire T0, T1, T2, T3, T4;

    // * PC
    wire [7:0] PCAddress, PC, PC_D2;

    // * In Ports
    wire [7:0] InAddress, InDataout;

    // * Out Ports
    wire [7:0] OutAddress, OutDatain;

    // * Control Logic
    wire PCupdate, ALUSave, ZflagSave, CflagSave;
    wire SRAMRead, SRAMWrite, StackRead, StackWrite, INportRead, OUTportWrite, RegFileRead, RegFileWrite;

    // * flags
    wire Zflag, Cflag;;
     TimingGen TimingGenInst(
        clk,
        Reset,
        T0,
        T1,
        T2,
        T3,
        T4
    );

        // * Program Counter:
    Mux32to1_8bitRP Mux32to1_8bit_PCInst(
        Opcode,
        PC,
        PC,
        PC,
        ALUout,
        ALUout,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        Imm,
        Imm,
        Imm,
        Imm,
        Imm,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PC,
        PCAddress
    );
    
    // Instantiate modules
    Program_Counter PC_Module(
        .clk(clk),
        .Reset(Reset),
        .Enable_PC(T0),
        .Update_PC(PCupdate),
        .New_Address(PCAddress),
        .PC(PC),
        .PC_D2(PC_D2)
    );
    
    Instruction_Memory Inst_Memory(
        .clk(clk),
        .Reset(Reset),
        .Address(PC),
        .instRead(T0),
        .Dataout(currentInstruction),
        .opcode(Opcode),
        .Destin(Destin),
        .Source1(Source1),
        .Source2(Source2),
        .Imm(Imm)
    );
    // * Register File
    Mux32to1_8bitRP Mux32to1_8bit_RegInst(
        Opcode,
        RegDatain,
        RegDatain,
        RegDatain,
        RegDatain,
        RegDatain,
        ALUout,
        ALUout,
        ALUout,
        RegDatain,
        SRAMDataout,
        RegDatain,
        InDataout,
        StackDataout,
        RegDatain,
        RegDatain,
        RegDatain,
        RegDatain,
        RegDatain,
        RegDatain,
        RegDatain,
        SRAMDataout,
        ALUout,
        ALUout,
        ALUout,
        ALUout,
        ALUout,
        ALUout,
        ALUout,
        ALUout,
        ALUout,
        ALUout,
        RegDatain,
        RegDatain
    );
    
    
    registerfile Reg_File(
        .clk(clk),
        .Rst(Reset),
        .R(RegfileRead),
        .W(Regfilewrite),
        .Datain(RegDatain),
        .AddressR1(Source1),
        .AddressR2(Source2),
        .AddressW(Destin),
        .Dataout1(RegDataout1),
        .Dataout2(RegDataout2)
    );
     // * ALU
    Mux32to1_8bitRP Mux32to1_8bit_ALU_OP1Inst(
        Opcode,
        8'b0,
        8'b0,
        8'b0,
        PC_D2,
        PC_D2,
        RegDataout1,
        RegDataout1,
        RegDataout1,
        8'b0,
        8'b0,
        RegDataout1,
        8'b0,
        8'b0,
        RegDataout1,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        RegDataout1,
        8'b0,
        8'b0,
        RegDataout1,
        RegDataout1,
        RegDataout1,
        RegDataout1,
        RegDataout1,
        RegDataout1,
        RegDataout1,
        RegDataout1,
        RegDataout1,
        8'b0,
        Operand1
    );
    Mux32to1_8bitRP Mux32to1_8bit_ALU_OP2Inst(
        Opcode,
        8'b0,
        8'b0,
        8'b0,
        {1'b0, Imm[6:0]},
        {1'b0, Imm[6:0]},
        RegDataout2,
        RegDataout2,
        RegDataout2,
        RegDataout2,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        8'b0,
        Imm,
        8'b0,
        Imm,
        Imm,
        Imm,
        Imm,
        RegDataout2,
        RegDataout2,
        RegDataout2,
        RegDataout2,
        8'b0,
        Operand2
    );
   
    ALU ALU_Module(
        .clk(clk),
        .Reset(Reset),
        .Imm7(Imm[7]),
        .Op1(RegDataout1),
        .Op2(RegDataout2),
        .OpCode(Opcode),
        .ZFlag_Save(ZflagSave),
        .CFlag_Save(CflagSave),
        .ALU_Save(ALUout)
    );
    
     // * SRAM
    Mux32to1_8bitRP Mux32to1_8bit_SRAMInst(
        Opcode,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        RegDataout1,
        RegDataout1,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        Imm,
        Imm,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress,
        SRAMAddress
    );
    SRAM SRAM_Inst(
        clk, 
        Reset, 
        SRAMAddress, 
        SRAMRead, 
        SRAMWrite, 
        ALUout, 
        SRAMDataout
    );
   
    Control_Logic Ctrl_Logic(
        .clk(clk),
        .Reset(Reset),
        .T1(1'b1), .T2(1'b1), .T3(1'b1), .T4(1'b1),
        .Zflag(Zflag),
        .Cflag(Cflag),
        .opcode(Opcode),
        .PC_Update(PC_Update),
        .SRam_R(SRamRead),
        .SRam_W(SRAMWrite),
        .StackRead(StackRead),
        .StackWrite(StackWrite),
        .ALU_Save(ALUSave),
        .ZFlag_Save(ZflagSave),
        .CFlag_Save(CflagSave),
        .INportRead(INportRead),
        .OutportWrite(OutportWrite),
        .RegfileRead(RegfileRead),
        .Regfilewrite(Regfilewrite)
    );
    
    INPort Input_Module(
        .clk(clk),
        .Reset(Reset),
        .INPortRead(INportRead),
        .InpExtWorld1(InpExtWorld1),
        .InpExtWorld2(InpExtWorld2),
        .InpExtWorld3(InpExtWorld3),
        .InpExtWorld4(InpExtWorld4)
    );
    
    OUTPort Output_Module(
        .clk(clk),
        .Reset(Reset),
        .OUTportWrite(OutPortWrite),
        .Datain(ALUout),
        .OutExtWorld1(OutExtWorld1),
        .OutExtWorld2(OutExtWorld2),
        .OutExtWorld3(OutExtWorld3),
        .OutExtWorld4(OutExtWorld4)
    );
     Stack Stack(
        clk, 
        Reset, 
        StackRead, 
        StackWrite, 
        ALUout, 
        StackDataout
    );

endmodule