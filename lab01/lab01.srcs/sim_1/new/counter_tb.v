`timescale 1ns / 1ps

module counter_tb;
    reg clk;
    reg rst;
    reg inc;
    reg dec;
    wire [3:0] out;
    
    counter dut (
        .clk(clk),
        .rst(rst),
        .inc(inc),
        .dec(dec),
        .out(out)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        inc = 0;
        dec = 0;
        
        #12; 
        rst = 0;
        
        inc = 1;
        #50;
        inc = 0;
        dec = 1;
        #10;
    
    $finish;
    end
    
    initial begin
    $monitor("Time=%0t | clk=%b rst=%b inc=%b dec=%b | out=%b", 
              $time, clk, rst, inc, dec, out);
    end

endmodule
