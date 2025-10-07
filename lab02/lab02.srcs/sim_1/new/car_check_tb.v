`timescale 1ns/1ps

module car_check_tb;

    reg clk;
    reg [2:0]btn;
    wire [3:0]led;

    // Instantiate DUT (Device Under Test)
    car_check dut (
        .clk(clk),
        .btn(btn),
        .led(led)
    );

    // Clock generation: 10ns period
//    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        btn[2] = 1;
        btn[1] = 0;
        btn[0] = 0;
        
        #12;
        btn[2] = 0;
             
        repeat (5) begin        
            #10 btn[0] = 1; btn[1] = 0;
            #10 btn[0] = 1; btn[1] = 1;  // should go to sensab
            #10 btn[0] = 0; btn[1] = 1;  // should reach enter -> out asserted
            #10 btn[0] = 0; btn[1] = 0;  // return to idle
        end

        #10;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | clk=%b | btn2=%b btn1=%b btn0=%b | led=%b", 
                 $time, clk, btn[2], btn[1], btn[0], led);
    end

endmodule