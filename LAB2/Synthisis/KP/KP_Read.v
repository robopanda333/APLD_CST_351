//-----------------------------------------------------------------------------
//University: OIT - CSET
//Class: CST 231
//Lab:Lab 5
//Project: keypad controller
//
//Author: Kehnin Dyer
//Date: 2012 03 15
//Dependancies: none
//-----------------------------------------------------------------------------
// inverted priority decoder.
//-----------------------------------------------------------------------------

module KP_Read(
	input		[3:0]	K_I,
	output	reg	[1:0]	COL
);
always@(K_I)
begin
	casex(K_I)
		4'b0XXX:COL = 3;
		4'b10XX:COL = 2;
		4'b110X:COL = 1;
		default:COL = 0;
		//we don't really care about an all 1 case because
		//we don't look at this until ena goes high(meaning &K_I was low)
	endcase
end

endmodule
