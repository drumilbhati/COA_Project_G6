module Mux_2to1(I0,I1,Sel,Y);
input [7:0] I1;
input[7:0] I0; 
input Sel;
output[7:0] Y;
always @(*)begin
    case(Sel)
    1'b1: Y=I1;
    1'b0: Y=I0;
    default: Y=8'b0;
    endcase
end
endmodule
