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
   
    //setup log file
    integer log_file;
    
    //create clock for sim
    initial clk = 0;
    always #5 clk = ~clk;
       
    initial
    begin
        log_file = $fopen("car_test.txt"); //open log file here as well because we want to close it after our stimulus generation
        init(); //init inputs to 0 and rst to 1 (see task block)
        #10
        enter(15);
        #10
        exit(15);
        #10
        enter(5);
        set_rst(); // synchronous reset
        #10
        set_inc(); //randomoly send increment signal to test fsm
        enter(10);
        #10
        set_dec(); //randomly send decrement signal to test fsm
        exit(15); //see what happens if exit goes to 0 and further (integer overflow)
        set_inc(); //more random inc's
        set_inc();
        set_inc();
        set_rst();
        #10
        
        //some random inputs for testing fsm
        anotb(5);
        anotb(1);
        aandb(3);
        bnota(3);
        notaorb(3);
        
        anotb(10);
        
        
        $fclose(log_file); //close the log file after stimulus generation
        $stop;
    end
     
    task init();
    // initialize the car detector
    begin 
        rst = 1;  //set reset to 1 initially, all other var's to 0 then evenetuall reset as well
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
        #10 a = 0; b = 0;  // return to 0 state for both inputs
        #10 inc_exp = 1;   // set increment exp signal for monitor
        #10 inc_exp = 0;
        end
    end
    endtask  
    
    task exit(input integer C);
    begin  
        repeat(C) @(posedge clk) begin
        #10 a = 0; b = 1;
        #10 a = 1; b = 1;  // should go to sensab
        #10 a = 1; b = 0;  // should reach exit in fsm -> out asserted
        #10 a = 0; b = 0;  // return to a is 0 b is 0
        #10 dec_exp = 1;   // set decrement exp signal for monitor
        #10 dec_exp = 0;
 
        end
    end
    endtask    
    
    task anotb(input integer C);
    begin 
        repeat(C) @(posedge clk) begin
        #10 a = 1; b =0;
        end
    end
    endtask
    
    task aandb(input integer C);
    begin 
        repeat(C) @(posedge clk) begin
        #10 a = 1; b =1;
        end
    end
    endtask
    
    task bnota(input integer C);
    begin 
        repeat(C) @(posedge clk) begin
        #10 a = 0; b =1;
        end
    end
    endtask
    
    task notaorb(input integer C);
    begin 
        repeat(C) @(posedge clk) begin
        #10 a = 0; b =0;
        end
    end
    endtask
    
    
    task set_rst();     //set reset function 
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
