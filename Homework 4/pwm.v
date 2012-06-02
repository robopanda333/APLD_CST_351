//kehnin dyer
//homework 4
//pwm clk

module pwm(
input	[7:0]	ctrl,
input			clk,
output			clk_pwm
);

reg	[7:0]	counter;
assign clk_pwm = counter < ctrl;

always@ (posedge clk)
counter = counter + 1;

endmodule

