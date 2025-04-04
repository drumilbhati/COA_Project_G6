module Stack (
    input clk,                
    input Reset,              // Synchronous Reset
    input StackRead,          
    input StackWrite,         
    input [7:0] Datain,       
    output reg [7:0] Dataout  
);

    // Declare 256 x 8-bit SRAM memory
    reg [7:0] datamem [0:255];

    // Stack Pointers
    reg [7:0] SPWritePTR;  // Pointing to top of stack for writing
    reg [7:0] SPReadPTR;   // Pointing to top of stack for reading

    // Stack Reset
    integer i;
    always @(posedge clk) begin
        if (Reset) begin
            for (i = 0; i < 256; i = i + 1)
                datamem[i] <= 8'b00000000; // Clear memory
            SPWritePTR <= 8'b00000000; // Reset write pointer
            SPReadPTR  <= 8'b11111111; // Reset read pointer (Empty stack)
        end 
        else if (StackWrite) begin
            datamem[SPWritePTR] <= Datain; // Push data onto stack
            SPReadPTR <= SPWritePTR; // Move read pointer to the last written location
            SPWritePTR <= SPWritePTR + 1; // Increment write pointer
        end
    end

    // Read operation
    always @(*) begin
        if (StackRead)
            Dataout = datamem[SPReadPTR]; // Read from top of stack
        else
            Dataout = 8'b00000000; //Returning 0 when not reading
    end

endmodule