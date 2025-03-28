module RegisterSynW_25bit (
    clk,
    Reset,
    W,
    Datain,
    Dataout
);
    input clk, Reset, W;
    input [24:0] Datain;
    output reg [24:0] Dataout;

    always @(posedge clk) begin
        if (Reset)
            Dataout <= 24'b0000_0000_0000_0000_0000_0000;
        else if (W)
            Dataout <= Datain;
    end
endmodule