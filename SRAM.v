module SRAM (
    input clk,                 
    input Reset,               
    input [7:0] Address,        
    input SRAMRead,             
    input SRAMWrite,            
    input [7:0] Datain,         
    output reg [7:0] Dataout    
);

    reg [7:0] datamem [0:255];


    integer i;
    always @(posedge clk) begin
        if (Reset) begin
            for (i = 0; i < 256; i = i + 1)
                datamem[i] <= 8'b00000000; 
        end 
        else if (SRAMWrite) begin
            datamem[Address] <= Datain; 
        end
    end

    always @(*) begin
        if (SRAMRead)
            Dataout = datamem[Address]; 
        else
            Dataout = 8'b00000000; 
    end

endmodule
