module INPort (
    clk,
    Reset,
    INPortRead,
    InpExtWorld1,
    InpExtWorld2,
    InpExtWorld3,
    InpExtWorld4,
    Address,
    Dataout
);
    input clk, Reset, INPortRead;
    input [7:0] InpExtWorld1, InpExtWorld2, InpExtWorld3, InpExtWorld4, Address;
    output wire [7:0] Dataout;

    wire [7:0] InPort1Dout, InPort2Dout, InPort3Dout, InPort4Dout;

    RegisterSynW inst1(clk, 1'b0, 1'b1, InpExtWorld1, InPort1Dout);
    RegisterSynW inst2(clk, 1'b0, 1'b1, InpExtWorld2, InPort2Dout);
    RegisterSynW inst3(clk, 1'b0, 1'b1, InpExtWorld3, InPort3Dout);
    RegisterSynW inst4(clk, 1'b0, 1'b1, InpExtWorld4, InPort4Dout);
    
    wire comp1, comp2, comp3, comp4;
    wire dummy;
    comparator_unsigned inst5(Address, 8'b1111_0001, dummy, dummy, comp1); 
    comparator_unsigned inst6(Address, 8'b1111_0010, dummy, dummy, comp2);
    comparator_unsigned inst7(Address, 8'b1111_0011, dummy, dummy, comp3);
    comparator_unsigned inst8(Address, 8'b1111_0100, dummy, dummy, comp4);

    reg [1:0] portSel_reg;

    if (comp4 == 1'b1) begin
        portSel_reg = 2'b11;
    end
    else if (comp3 == 1'b1) begin
        portSel_reg = 2'b10;
    end
    else if (comp2 == 1'b1) begin
        portSel_reg = 2'b01;
    end
    else if (comp1 == 1'b1) begin
        portSel_reg = 2'b00;
    end
    else begin
        portSel_reg = 2'b00;
    end

    Mux_4to1 inst9(InPort1Dout, InPort2Dout, InPort3Dout, InPort4Dout, portSel_reg, Dataout);
endmodule