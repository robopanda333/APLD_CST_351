//kehnin Dyer
//homework 3

`timescale 10ns / 100ps
module test_ClkDiv;
reg	clk;
wire	scan,
    	pwm,    
	   baud;

ClkDiv dut(clk, scan, pwm, baud);
always #2 clk = ~clk;
	
initial
begin
clk = 0;

#1000000000
	
$stop;
	
end



endmodule
