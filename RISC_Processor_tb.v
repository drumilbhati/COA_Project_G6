`timescale 1ns / 1ps

module RISCprocessor_tb;

    // Testbench signals
    reg clk;
    reg Reset;
    reg [7:0] InpExtWorld1, InpExtWorld2, InpExtWorld3, InpExtWorld4;
    wire [7:0] OutExtWorld1, OutExtWorld2, OutExtWorld3, OutExtWorld4;

    // Instantiate the DUT (Device Under Test)
    RISCprocessor uut (
        .clk(clk),
        .Reset(Reset),
        .InpExtWorld1(InpExtWorld1),
        .InpExtWorld2(InpExtWorld2),
        .InpExtWorld3(InpExtWorld3),
        .InpExtWorld4(InpExtWorld4),
        .OutExtWorld1(OutExtWorld1),
        .OutExtWorld2(OutExtWorld2),
        .OutExtWorld3(OutExtWorld3),
        .OutExtWorld4(OutExtWorld4)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        // Initialize inputs
        clk = 0;
        Reset = 1;
        InpExtWorld1 = 8'b00000000;
        InpExtWorld2 = 8'b00000000;
        InpExtWorld3 = 8'b00000000;
        InpExtWorld4 = 8'b00000000;
        
        // Reset pulse
        #10 Reset = 0;
        #10 Reset = 1;
        #10 Reset = 0;
        
        // Apply test stimulus
        #20 InpExtWorld1 = 8'b10101010;
        #20 InpExtWorld2 = 8'b11001100;
        #20 InpExtWorld3 = 8'b11110000;
        #20 InpExtWorld4 = 8'b00001111;
        
        // Observe the outputs
        #100;

        // Finish simulation
        $stop;
    end
    
    // Monitor outputs
    initial begin
        $monitor("Time=%0t | OutExtWorld1=%b OutExtWorld2=%b OutExtWorld3=%b OutExtWorld4=%b", 
                 $time, OutExtWorld1, OutExtWorld2, OutExtWorld3, OutExtWorld4);
    end

endmodule
