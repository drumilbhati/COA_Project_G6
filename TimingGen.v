module TimingGen(
    input clk,
    input Reset,
    output reg T0, T1, T2, T3, T4
);
    reg [2:0] state;

    always @(posedge clk or posedge Reset) begin
        if (Reset)
            state <= 3'b000;
        else
            state <= state + 1;
    end

    always @(*) begin
        T0 = (state == 3'b000);
        T1 = (state == 3'b001);
        T2 = (state == 3'b010);
        T3 = (state == 3'b011);
        T4 = (state == 3'b100);
    end
endmodule