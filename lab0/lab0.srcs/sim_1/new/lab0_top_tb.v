`timescale 1ns / 1ps

module tb_lab0_top;

    // Testbench signals
    reg [3:0] btn;
    wire [3:0] led;

    // Instantiate the DUT (Device Under Test)
    lab0_top dut (
        .btn(btn),
        .led(led)
    );

    // Apply test patterns
    initial begin
        // Initialize inputs
        btn = 4'b0000;

        // Wait 10 ns
        #10;
        
        // Test pattern 1
        btn = 4'b0001;
        #10;
        
        // Test pattern 2
        btn = 4'b0011;
        #10;
        
        // Test pattern 3
        btn = 4'b0110;
        #10;
        
        // Test pattern 4
        btn = 4'b1111;
        #10;

        // Finish simulation
        $finish;
    end

    // Optional: monitor the signals
    initial begin
        $monitor("Time=%0t | btn=%b | led=%b", $time, btn, led);
    end

endmodule
