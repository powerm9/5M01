`timescale 1ns / 1ps

module scoreboard (
     input wire clk, a, b, rst, inc_exp, dec_exp,
     input wire [3:0] out
    );
    
    reg inc_exp_old, dec_exp_old, rst_old;
    reg [3:0] out_old, gold;
    reg [39:0] err_msg;
    integer log_file;
    
    initial $display("  time   a   b   rst   inc   dec   gold   out   err ");
    
    initial
    begin
        log_file = $fopen("car_test.txt");
        if (log_file == 0)
            $display("failed to open log_file");
        $fdisplay(log_file, "  time     a      b      rst    inc     dec    gold     out     err ");
    end 
    
    always @(posedge clk)
    begin        
        rst_old <= rst;
        inc_exp_old <= inc_exp;
        dec_exp_old <= dec_exp;
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
        if (out == gold & inc_exp)
            err_msg = "ENTER";
            
        else if (out == gold & dec_exp)
            err_msg = "EXIT";
            
        else if (out == gold)
            err_msg = "     "; 
            
        else 
            err_msg = "ERROR";
    
        $display("%5d,      %b      %b      %d      %d,     %s",
            $time, inc_exp, dec_exp, gold, out, err_msg);
    end
    
    always @(posedge clk) 
    begin
     $fdisplay(log_file, "____________________________________________________________________________");     
     $fdisplay(log_file, "%5d      %b      %b       %b      %b      %b      %d      %d      %s",
        $time, a, b, rst, inc_exp, dec_exp, gold, out, err_msg);
    end    
        
endmodule
