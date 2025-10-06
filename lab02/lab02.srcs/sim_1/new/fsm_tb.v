`timescale 1ns/1ps

module fsm_tb;

    reg clk;
    reg rst;
    reg a;
    reg b;
    wire out;

    // Instantiate DUT (Device Under Test)
    fsm dut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .out(out)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        a = 0;
        b = 0;

        // Apply reset
        #12; 
        rst = 0;

        // === Test Sequences ===
        // 1. Apply 'a' then 'b'
        #10 a = 0; b = 1;
        #10 a = 1; b = 1;  // should go to sensab
        #10 a = 1; b = 0;  // should reach enter -> out asserted
        #10 a = 0; b = 0;  // should reach enter -> out asserted

        
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;  // should go to sensab
        #10 a = 0; b = 1;  // should reach enter -> out asserted
        #10 a = 0; b = 0;  // should reach enter -> out asserted


        // Finish simulation
        #50;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | clk=%b rst=%b a=%b b=%b | out=%b", 
                  $time, clk, rst, a, b, out);
    end

endmodule
