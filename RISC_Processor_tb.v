`timescale 1ns/1ps

module RISCprocessor_tb;
    // Testbench signals
    reg clk;
    reg Reset;
    reg [7:0] InpExtWorld1, InpExtWorld2, InpExtWorld3, InpExtWorld4;
    wire [7:0] OutExtWorld1, OutExtWorld2, OutExtWorld3, OutExtWorld4;

    // Debug signals
    wire [7:0] PC;
    wire [24:0] Instruction;
    wire [4:0] Opcode;

    // Instantiate the DUT
    RISCprocessor processor (
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
    always begin
        #10 clk = ~clk;
    end

    // Initialize and monitor
    initial begin
        // Initialize signals
        clk = 1'b0;
        Reset = 1'b1;
        InpExtWorld1 = 8'h8B;
        InpExtWorld2 = 8'h00;
        InpExtWorld3 = 8'h00;
        InpExtWorld4 = 8'h00;

        // Set up waveform dumping
        $dumpfile("Wavedump.vcd");
        $dumpvars(0, RISCprocessor_tb);

        // Hold reset for 50ns
        #50 Reset = 1'b0;

        // Run until timeout or completion
        #5000;
        
        $display("Simulation completed");
        $finish;
    end

    // Timeout checker
    integer cycle_count = 0;
    always @(posedge clk) begin
        cycle_count <= cycle_count + 1;
        if (cycle_count >= 500) begin  // Adjust timeout as needed
            $display("\nTimeout after %d cycles", cycle_count);
            $finish;
        end
    end

endmodule
