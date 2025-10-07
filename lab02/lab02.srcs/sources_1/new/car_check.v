`timescale 1ns / 1ps

module car_check(
    input clk,
    input [2:0] btn,
    output [3:0] led
    );
    
    parameter enter =    3'b101, exit = 3'b110;
    
    wire [2:0] fsm_out;
    wire [3:0] count;
    wire [2:0] btn_db;
    
    reg inc, dec;
    wire a, b, rst;
   
    assign led = count;
    
    assign a = btn_db[0];
    assign b = btn_db[1];
    assign rst = btn[2];
    
    
    fsm fsm(.clk(clk), .rst(btn[2]), .a(btn[0]), .b(btn[1]), .out(fsm_out));
    counter cnt(.clk(clk), .rst(rst), .inc(inc), .dec(dec), .out(count));
    debouncer dbcer(.clk(sysclk), .reset(rst), .button(btn), .button_db(btn_db)); 
    
    always @(posedge clk) begin
        if (fsm_out == enter) begin
            inc <= 1'b1;
            dec <= 1'b0;
        end
       else if (fsm_out == exit) begin
            inc <= 1'b0;
            dec <= 1'b1;
       end
        else begin
            inc <= 1'b0;
            dec <= 1'b0;
        end
        
    end
    
endmodule