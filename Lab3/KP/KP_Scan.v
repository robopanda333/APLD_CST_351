//-----------------------------------------------------------------------------
//University: OIT - CSET
//Class: CST 231
//Lab:Lab 5
//Project: keypad controller
//
//Author: Kehnin Dyer
//Date: 2012 03 14
//Dependancies: none
//-----------------------------------------------------------------------------
//DISCRIPTION:
// if enabled moves to the next scan position.
//-----------------------------------------------------------------------------

module KP_Scan(
	input				CLK,
	input				EN,
	output	reg	[3:0]	K_O
);

reg [1:0] count;
always@(posedge CLK)
begin
	if(EN)
		count = count + 2'd1;
	else
		count = count;
end
always@(count)
	case(count)
	//if i have this go contrary to my better sences, i can 
	//make the reset better... but then this will be the other way
	//around... and the lsb == 0 will be count == 4... er....
		//0:SCAN = 4'b1110;
		//1:SCAN = 4'b1101;
		//2:SCAN = 4'b1011;
		//default:SCAN = 4'b0111;
		//fine... it will make the logic later cleaner.
		0:		K_O = 4'b0111;
		1:		K_O = 4'b1011;
		2:		K_O = 4'b1101;
		default:K_O = 4'b1110;
endcase
endmodule
