`timescale 1ns / 1ps

module scoreboard (
     input wire clk, rst, inc_exp, dec_exp, out
    );
    
    reg inc_exp_old, dec_exp_old, rst_old, out_old, gold;
    reg [39:0] err_msg;
    
    initial
    $display("time inc dec out err ");
    
    always @(posedge clk)
    begin
        inc_exp_old <= inc_exp;
        dec_exp_old <= dec_exp;
        rst_old <= rst;
        out_old <= out;
    
    // get expected value from sending enter and exit in stim gen
        if (rst_old)
            gold = 0;
        else if (inc_exp_old)
            gold = out_old + 1;
        else if (dec_exp_old)
            gold = out_old - 1;
        else 
            gold = out_old;
         
        // error message
        if (out == gold)
            err_msg = "     "; 
        else 
            err_msg = "ERROR";
    
        $display("%5d, %b%b %d, %s",
                 $time, inc_exp, dec_exp, out, err_msg);
    end
    
endmodule
