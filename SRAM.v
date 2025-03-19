module SRAM (
    input clk,                 
    input Reset,                // Synchronous Reset
    input [7:0] Address,        // 8-bit Address input
    input SRAMRead,             // Read Enable
    input SRAMWrite,            // Write Enable
    input [7:0] Datain,         // 8-bit Data input
    output reg [7:0] Dataout    // 8-bit Data output
);

    // Declaring 256 x 8-bit memory array
    reg [7:0] datamem [0:255];

    // Synchronous reset (clears memory)
    integer i;
    always @(posedge clk) begin
        if (Reset) begin
            for (i = 0; i < 256; i = i + 1)
                datamem[i] <= 8'b00000000; // Clearing memory on reset
        end 
        else if (SRAMWrite) begin
            datamem[Address] <= Datain; // Writing operation
        end
    end

    // Read operation (Combinational)
    always @(*) begin
        if (SRAMRead)
            Dataout = datamem[Address]; // Reading from memory
        else
            Dataout = 8'b00000000; // Giving output as 0 when not reading
    end

endmodule
