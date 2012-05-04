//-----------------------------------------------------------------------------
//University: OIT - CSET
//Class: CST 231
//Lab:Lab 1
//Project: Keypad Controller
//
//Author: Kehnin Dyer
//Date: 2012 04 17
//Dependancies: none
//-----------------------------------------------------------------------------
//DISCRIPTION:
// Divides the clk down
//-----------------------------------------------------------------------------


module CLKDIV(
input CLK,
output reg CLK_1k
);

reg[14:0] count;

always@(posedge CLK)
begin
	if(count == 25000)
		count = 0;
	else
		count = count + 15'd1;
end

always@(negedge CLK)
begin
	if(count == 25000)
		CLK_1k = ~CLK_1k;
	else
		CLK_1k = CLK_1k;
end


endmodule
