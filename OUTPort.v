module OUTPort (
    input clk,
    input Reset,
    input [7:0] Address,
    input [7:0] Datain,
    output reg [7:0] OUTPortWire
);

    wire isAddress1, isAddress2, isAddress3, isAddress4;
    wire temp1, temp2;

    // Comparators to check specific address matches
    comparator_unsigned comp1(Address, 8'b1111_01000, temp1, temp2, isAddress1);
    comparator_unsigned comp2(Address, 8'b1111_01001, temp1, temp2, isAddress2);
    comparator_unsigned comp3(Address, 8'b1111_01010, temp1, temp2, isAddress3);
    comparator_unsigned comp4(Address, 8'b1111_01011, temp1, temp2, isAddress4);

    always @(posedge clk or posedge Reset) begin
        if (Reset)
            OUTPortWire <= 8'b0; // Reset output to zero
        else if (isAddress1)
            OUTPortWire <= Datain; // Update output when Address matches
        else if (isAddress2)
            OUTPortWire <= Datain;
        else if (isAddress3)
            OUTPortWire <= Datain;
        else if (isAddress4)
            OUTPortWire <= Datain;
    end

endmodule
