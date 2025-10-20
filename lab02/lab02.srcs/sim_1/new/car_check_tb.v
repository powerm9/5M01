`timescale 1ns/1ps

module car_check_tb;

    wire clk;
    wire a;
    wire b;
    wire rst;
    wire [3:0]led;
    wire inc_exp;
    wire dec_exp;
        
    car_check uut (
        .clk(clk),
        .btn_a(a),
        .btn_b(b),
        .btn_rst(rst),
        .led(led)
    );  
    
    stim_gen gen_unit (
        .clk(clk), 
        .a(a), 
        .b(b), 
        .rst(rst),
        .inc_exp(inc_exp),
        .dec_exp(dec_exp)
    );
           
    scoreboard mon_unit (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .inc_exp(inc_exp),
        .dec_exp(dec_exp),
        .out(led)
    );
    

endmodule