`timescale 1ns / 1ps

module debouncer_tb;

    reg clk;
    reg reset;
    reg button;
    wire button_db;

    // Instantiate the debouncer with small threshold for simulation
    debouncer #(.threshold(0)) uut (
        .clk(clk),
        .reset(reset),
        .button(button),
        .button_db(button_db)
    );

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        reset = 1;
        button = 0;

        // Hold reset for a few clock cycles
        #20;
        reset = 0;

        // Simulate a short button press (debounced)
        #10 button = 1;   // press button
        #50 button = 0;   // release button
        #30 button = 1;   // press again
        #20 button = 0;   // release again
        #50;

        // Finish simulation
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | clk=%b | reset=%b | button=%b | button_db=%b",
                 $time, clk, reset, button, button_db);
    end

endmodule
