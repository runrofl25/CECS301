module SuppLogic(clk, rst, pass, loadA, loadD, state, wdata,adrs,rdata, finish, done, error);

input               clk; // system clock
input               rst; // system reset
input loadA; // load address register
input loadD; // load data register
input [2:0] pass; // memory test passes (4)
input [15:0] rdata; // read data from memory
input [2:0] state; // current state for error checking

output [15:0] wdata; //write data
output [14:0] adrs; // address bus 32k x 16
output finish; // complete
output error; // data mismatch
output done; // pass complete

// declare required data types for supplemental logic

reg [14:0] adreg; // address register
reg [15:0] dtreg; // data output register
reg [15:0] muxdat; // current pattern for memory
wire [2:0] pass; // four w/r passes
wire finish; // finsihed testing the memory
wire done; // done with particular pass
wire [15:0] wdata; // data written to memory;
wire [14:0] adrs; //address to the memory
wire errorD; // detected error during test
reg error; // hold error for led display
wire [2:0] state; // current state for error reporting

//supplemental logic derived signals

assign finish = pass == 3'b100;
assign done = adreg == 15'h7FFF;
assign adrs = adreg;
assign wdata = dtreg;
assign errorD = (state == 3'b100) & (dtreg !== rdata) & (!done);

//supplemental logic functions

always @(posedge clk, posedge rst)
    if (rst) adreg <= 15'h7fff; else
    if (loadA) adreg <= adreg + 15'b1;

always @(posedge clk, posedge rst)
    if(rst) dtreg <= 16'b0; else
    if(loadD) dtreg <= muxdat;
    
always @(*)
    case(pass)
        3'b011: muxdat = 16'hAAAA;
        3'b010: muxdat = 16'h5555;
        3'b001: muxdat = {1'b0,adreg};
        3'b000: muxdat = ~adreg;
        default: muxdat = 16'h1234;
    endcase
always @(posedge clk, posedge rst)
    if(rst) error <= 1'b0; else
    if(errorD) error <= 1'b1;
    else error <= error;
endmodule
    