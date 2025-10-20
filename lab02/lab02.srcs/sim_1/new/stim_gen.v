`timescale 1ns / 1ps

module stim_gen
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
        init();
        #10
        enter(15);
        #10
        exit(15);
        #10
        enter(5);
        set_rst();
        #10
        set_inc();
        enter(10);
        #10
        set_dec();
        exit(15);
        set_inc();
        set_inc();
        set_inc();
        set_rst();
        #10
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
        #10 a = 0; b = 0;  // return to 
        #10 inc_exp = 1;
        #10 inc_exp = 0;
        end
    end
    endtask  
    
    task exit(input integer C);
    begin  
        repeat(C) @(posedge clk) begin
        #10 a = 0; b = 1;
        #10 a = 1; b = 1;  // should go to sensab
        #10 a = 1; b = 0;  // should reach enter -> out asserted
        #10 a = 0; b = 0;  // return to 
        #10 dec_exp = 1;
        #10 dec_exp = 0;
 
        end
    end
    endtask    
    
    task set_rst();
    begin
        rst = 1'b1;
        #2;
        rst = 1'b0;
    end
    endtask
    
    task set_inc();
    begin
        inc_exp = 1'b1;
        #10;
        inc_exp = 1'b0;
    end
    endtask
    
    task set_dec();
    begin 
        dec_exp = 1'b1;
        #10;
        dec_exp = 1'b0;
    end
    endtask
        
endmodule
