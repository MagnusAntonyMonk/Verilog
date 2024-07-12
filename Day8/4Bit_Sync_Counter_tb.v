module tb;
  reg clk, rst_n;
  reg up;
  wire [3:0] cnt;
  synchronous_counter(.clk(clk),.rst_n(rst_n),.up(up),.cnt(cnt));
  
  initial begin
    clk = 0; rst_n = 0; 
    up = 1;
    #4; rst_n = 1;
    #80;
    rst_n = 0;
    #4; rst_n = 1; up = 0;
    #50;
    $finish;
  end
  always #2 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end

endmodule
