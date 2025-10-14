`timescale 1ns/1ps

module car_check_tb;

    reg clk;
    reg btn_a;
    reg btn_b;
    reg btn_rst;
    wire [3:0]led;

    // Instantiate DUT (Device Under Test)
    car_check dut (
        .clk(clk),
        .btn_a(btn_a),
        .btn_b(btn_b),
        .btn_rst(btn_rst),
        .led(led)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        btn_rst = 1;
        btn_a   = 0;
        btn_b   = 0;
        
        #50;
        btn_rst = 0;
        #50
        
        repeat (15) begin        
            #50 btn_a = 1; btn_b = 0;
            #50 btn_a = 1; btn_b = 1;  // should go to sensab
            #50 btn_a = 0; btn_b = 1;  // should reach enter -> out asserted
            #50 btn_a = 0; btn_b = 0;  // return to idle
        end
        
        repeat (16) begin        
            #10 btn[0] = 0; btn[1] = 1;
            #10 btn[0] = 1; btn[1] = 1;  // should go to sensab
            #10 btn[0] = 1; btn[1] = 0;  // should reach enter -> out asserted
            #10 btn[0] = 0; btn[1] = 0;  // return to idle
        end

        #10;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | clk=%b | btn2=%b btn1=%b btn0=%b | led=%b", 
                 $time, clk, btn_rst, btn_b, btn_a, led);
    end

endmodule