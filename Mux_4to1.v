module Mux_4to1 (
    input [7:0] I0, I1, I2, I3,
    input [1:0] Sel,  
    output reg [7:0] Y           
);
    
    always @(*) begin
        case(Sel)
            2'b00: Y = I0;
            2'b01: Y = I1;
            2'b10: Y = I2;
            2'b11: Y = I3;
            default: Y = 8'b0; 
        endcase
    end

endmodule