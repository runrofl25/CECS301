`timescale 1ns / 1ps

module mem32k(a, d,clk, we,spo);

input [14:0] a;
input [15:0] d;
input clk;
input we;

output [15:0] spo;

// memory m1 (.a(a), .d(d), .we(we), .clk(clk), .spo(spo));
//dist_mem_gen_0 m2 (.a(a), .d(d), .we(we), .clk(clk), .spo(spo));

reg [15:0] memory [0:32767]; //This is a two dimensional array called memory 
reg [15:0] spo;

always @(*) spo = memory[a]; //asynchronous

//writing synchronous
always @(posedge clk)
if(we) memory [a] <= d;
endmodule
