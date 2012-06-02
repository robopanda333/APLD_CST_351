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
wire test;

assign en = (count >= 25000);

always@(posedge CLK)
begin
	if(en)
		count = 0;
	else
		count = count + 15'd1;
end

always@(posedge CLK)
begin
	if(en)
		CLK_1k = ~CLK_1k;
	else
		CLK_1k = CLK_1k;
end


endmodule
