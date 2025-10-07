`timescale 1ns / 1ps

module car_check(
    input clk,
    input rst,
    input a,
    input b,
    output [3:0] out
    );
    
    parameter enter = 3'b101, exit = 3'b110;
    
    wire [2:0] fsm_out;
    wire [3:0] count;
    reg inc, dec;
    
    assign out = count;
    
    fsm fsm(.clk(clk), .rst(rst), .a(a), .b(b), .out(fsm_out));
    counter cnt(.clk(clk), .rst(rst), .inc(inc), .dec(dec), .out(count));
    
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
