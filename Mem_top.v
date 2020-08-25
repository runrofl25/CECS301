`timescale 1ns / 1ps


module Mem_top(clk, rst, start, finish, error);

input clk;
input rst;
input start; // begin the memory test

output finish; //memory test finished
output error; // indication of an error

//signal connecting state machine to memory

wire [15:0] rdata; //read data
wire write; //write strobe to memory
wire [14:0] adrs; // adress bus 32K x 16
wire [15:0] wdata; //write data
wire error; // indication of an error

wire done; //one pass complete
wire finish; // testing complete
wire loadA; // load address register
wire loadD; // load data register
wire [2:0] pass; // control the 4 passes
wire [2:0] state; //present state - error checking

// instantiate the memory controller state machine
// my part

MemControl Mem_SM(
.clk    (clk),
.rst    (rst),
.start  (start),
.done   (done),
.finish (finish),
.write  (write),
.loadA  (loadA),
.loadD  (loadD),
.pass   (pass)
//.state  (state)
);

// suplemental logic
//second part deals with inner workings of the memory

SuppLogic supl (
.clk    (clk),
.rst    (rst),
.pass   (pass),
.loadA  (loadA),
.loadD  (loadD),
.wdata   (wdata),
.state  (state),

.adrs   (adrs),
.rdata  (rdata),
.finish (finish),
.error  (error),
.done   (done)
);

//instantiate the memory 32K x 16
//3rd part implemented

dist_mem_gen_0 mem(
.a (adrs),
.d(wdata),
.we(write),
.clk(clk),
.spo(rdata)
);


endmodule
