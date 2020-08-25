`timescale 1ns / 1ps


module MemControl(clk,   
rst,   
start, 
done,  
finish,
write, 
loadA, 
loadD, 
pass);
input clk, rst;
input start;
output reg done;
output reg finish;
output reg write;
output reg [14:0]loadA;
output reg [14:0] loadD;
output reg [3:0]pass;
reg [2:0] state;
reg [3:0] present,next;
parameter
          s0 = 8'b0000_0001,
          s1 = 8'b0000_0010,
          s2 = 8'b0000_0100,
          s3 = 8'b0000_1000,
          s4 = 8'b0001_0000,
          s5 = 8'b0010_0000,
          s6 = 8'b0100_0000,
          s7 = 8'b1000_0000;
 always @(posedge clk)
 begin
    if(rst)
        present <=s0;
    else
        present <= next;
    end
always @(present, start)
    begin
        next = s0;
        case (present)
        s0: begin if (~start) next = s0; end // problem?
        s0  : begin if (start)
         next = s1; end   //just the begining
        s1  : begin if (start)
         loadA = 1'b1;
         next = s2; end // loadA
         
        s2  : begin if(start) 
        loadD = 1'b1;
        next = s3;end  //LoadD
        
        s3  : begin if(done) next = s1;
        
        else if(done) 
         write = 1'b1;
         next = s4; end // write == 1 and done 
        
        s4: begin if(start)
        loadA = 1'b1; 
            next = s5; end //LoadA ==1 
        s5: begin if(start)
        loadD = 1'b1; 
        next = s6; end // LoadD == 1
        
        s6: begin if (done)  
        next = s7; // nothing loaded two dones 
        else if (done) next = s4; end
        
        s7: begin if(loadA == 1) next = s1; //++pass preincrement?
        else if (pass == 0 && finish) next = s1; end
        
        
        
        
    endcase
end

endmodule








//    input clk, 
//    input rst_n, // reset button input
//    output reg [7: 0] led // output to 8 LEDs on card
//    );
//reg [25: 0] count; // create records for counter
//reg clk2;
//reg [2: 0] state = 0; // create 8 records for states
//wire rst = ~ rst_n; // connect reset button to rst register
//always @ (posedge clk)
//        if (count == 26'd25000000) 
//    begin
//            count <= 0;
//            clk2 <= ~ clk2;
//          end
//     else
//            begin
//            count <= count + 1; // increase counter
//            end
//// start of state machine
//always @ (posedge clk2) // machine changes to 1Hz
// begin 
//  if (rst) 
//   state <= 3'd0; // return to state 0 if rst is pressed
//  else //
//   begin // start state machine sequence
//    case (state)
//     3'd0: begin
//            led [7: 0] <= 8'b0000_0001; // only led [1] on
//            state <= 3'd1; // jump to state 3'd1
//           end
//     3'd1: begin
//            led [7: 0] <= 8'b0000_0010;
//            state <= 3'd2;
//           end
//     3'd2: begin
//            led [7: 0] <= 8'b0000_0100;
//            state <= 3'd3;
//           end
//     3'd3: begin
//            led [7: 0] <= 8'b0000_1000;
//            state <= 3'd4;
//           end
//     3'd4: begin
//            led [7: 0] <= 8'b0001_0000;
//            state <= 3'd5;
//           end
//     3'd5: begin
//            led [7: 0] <= 8'b0010_0000;
//            state <= 3'd6;
//           end
//     3'd6: begin
//            led [7: 0] <= 8'b0100_0000;
//            state <= 3'd7;
//           end
//     3'd7: begin
//            led [7: 0] <= 8'b1000_0000;
//            state <= 3'd0; // return to state 0
//           end
//     default: state <= 3'b0;
//    endcase
//   end
//  end
//endmodule

//// Test fixture 
//module LED_State_machine();
//reg rst_n;
//reg clk;
//reg [25:0] count;     
//reg        clk2;
//reg  [2:0] state=0;   
//wire rst = ~rst_n;     
//wire led;
////wire led [6:0];
//LED_state_machine TB(
//.rst_n(rst_n),
//.clk(clk),
//.led(led)
//);
//always #5 clk = ~clk;
//initial begin
//    rst_n = 1;
//    //sel = 1;
//    clk = 0;
//    //i=0;
//    #5
//    rst_n = 0;
//end
//endmodule

