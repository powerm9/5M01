`timescale 1ns / 1ps

module stim_gen #(parameter EN = 9, EX = 3)
  ( 
   output reg clk,    
   output reg a,  
   output reg b,    
   output reg rst,
   output reg inc_exp,
   output reg dec_exp
   );
   
    integer log_file;
    
    initial clk = 0;
    always #5 clk = ~clk;
       
    initial
    begin
        log_file = $fopen("car_test.txt");
        if (log_file == 0)
            $display("failed to open log_file");
        $fdisplay(log_file, "       time     a      b     rst     inc    dec    gold    out    err_msg");

        init();
        #100
        enter(EN);
        #100
        exit(EX);
        $fclose(log_file);
        $stop;
    end
     
    task init();
    // initialize the car detector
    begin 
        rst = 1;  //set to 1 initially
        a   = 0;
        b   = 0;
        inc_exp = 0;
        dec_exp = 0;
        #50
        rst = 0;
    end
    endtask 
    
    //repeat for C cycles
    task enter(input integer C);
    begin  
        repeat(C) @(posedge clk) begin
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;  // should go to sensab
        #10 a = 0; b = 1;  // should reach enter -> out asserted
        #10;
        #10 inc_exp = 1;
        #10 inc_exp = 0;
        #10 a = 0; b = 0;  // return to idle
        end
    end
    endtask  
    
    task exit(input integer C);
    begin  
        repeat(C) @(posedge clk) begin
        #10 a = 0; b = 1;
        #10 a = 1; b = 1;  // should go to sensab
        #10 a = 1; b = 0;  // should reach enter -> out asserted
        #10;
        #10 dec_exp = 1;
        #10 dec_exp = 0;
        #10 a = 0; b = 0;  // return to 
        end
    end
    endtask    
    
    always @(posedge clk) 
    begin
        $fdisplay (log_file, "%10d      %b      %b      %b",
                                   $time,   a, b, rst);
    end
        
endmodule
