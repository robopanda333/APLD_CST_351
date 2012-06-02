//kehnin dyer
//homework 4
//pwm clock


module top(
input			clk,
input			LSB,
input			MSB,
input	[7:0]	ctrl,
output	[1:0]	com,
output	[6:0]	seg
);
wire		clk_pwm;
wire [1:0]	com_t;
clkdiv_10k			u1(clk, clk10k);

pwm					u2(ctrl, clk_10k, pwm);
MultiplexedDisplay	u3(clk_10k, LSB, MSB, seg, com_t);
assign com = com_t & clk_pmw;
endmodule
