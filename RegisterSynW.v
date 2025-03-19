module RegisterSynW (
    clk,
    Reset,
    W,
    Datain,
    Dataout
);
    input clk, Reset, W;
    input [7:0] Datain;
    output reg [7:0] Dataout;

    always @(posedge clk) begin
        if (Reset)
            Dataout <= 8'b0000_0000;
        else if (W)
            Dataout <= Datain;
    end
endmodule