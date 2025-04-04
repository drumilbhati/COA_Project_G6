module Stack (
    input clk,                
    input Reset,
    input StackRead,          
    input StackWrite,         
    input [7:0] Datain,       
    output reg [7:0] Dataout  
);

    
    reg [7:0] datamem [0:255];

    
    reg [7:0] SPWritePTR;  
    reg [7:0] SPReadPTR;   

    
    integer i;
    always @(posedge clk) begin
        if (Reset) begin
            for (i = 0; i < 256; i = i + 1)
                datamem[i] <= 8'b00000000; 
            SPWritePTR <= 8'b00000000; 
            SPReadPTR  <= 8'b11111111; 
        end 
        else if (StackWrite) begin
            datamem[SPWritePTR] <= Datain; 
            SPReadPTR <= SPWritePTR; 
            SPWritePTR <= SPWritePTR + 1; 
        end
    end

    always @(*) begin
        if (StackRead)
            Dataout = datamem[SPReadPTR]; 
        else
            Dataout = 8'b00000000; 
    end

endmodule