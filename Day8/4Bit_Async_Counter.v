module JK_flipflop (
  input clk, rst_n,
  input j,k,
  output reg q, q_bar
  );
  
  always@(posedge clk or negedge rst_n) begin // for asynchronous reset
    if(!rst_n) q <= 0;
    else begin
      case({j,k})
        2'b00: q <= q;    // No change
        2'b01: q <= 1'b0; // reset
        2'b10: q <= 1'b1; // set
        2'b11: q <= ~q;   // Toggle
      endcase
    end
  end
  assign q_bar = ~q;
endmodule
module updown_selector(input q, q_bar, bit up, output nclk);  
  assign nclk = up ? q_bar : q;
endmodule
module asynchronous_counter #(parameter SIZE=4)(
  input clk, rst_n,
  input j, k,
  input up,
  output [3:0] q, q_bar
);
  wire [3:0] nclk;
  genvar g;
  
  JK_flipflop jk0(clk, rst_n, j, k, q[0], q_bar[0]);
  generate
    for(g = 1; g<SIZE; g++) begin
      updown_selector ud1(q[g-1], q_bar[g-1], up, nclk[g-1]);
      JK_flipflop jk1(nclk[g-1], rst_n, j, k, q[g], q_bar[g]);
    end
  endgenerate
endmodule


