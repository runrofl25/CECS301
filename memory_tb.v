`timescale 1ns / 1ps

module memory_tb();

reg clk;
reg we; //write enable
reg [14:0] a; // address
reg [15:0] d; //data in
wire [15:0] spo; // data out

integer i; // index to refer back towards

mem32k mem(
.clk(clk),
.a (a),
.d (d),
.we (we),
.spo (spo)
);

always #5 clk = ~clk;

initial begin
clk = 0;
a = 0; 
we = 0;
d = 0; 
#100 
for (i = 0; i < 32769; i = i + 1)
    begin 
    @(posedge clk)
    we = 1;
    a = i;
    d = i;
    @(posedge clk)
    we = 0;
    repeat (5) @(posedge clk);
    end
    
#100
for (i = 0; i <32769; i = i +1)
    begin
    @(posedge clk)
    a = i;
    @(posedge clk)
    #5
    if (spo !== i[15:0]) $display("Error");
    repeat (5) @(posedge clk); 
    end
end

endmodule
