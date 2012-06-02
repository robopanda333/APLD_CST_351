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
//
//-----------------------------------------------------------------------------

module KP_Latch(
	input				ena,
	input		[7:0]	d,
	output	reg	[3:0]	k_out
);
reg [7:0] d_l;
always@(posedge ena)
	d_l = d;
	
always@(d_l)
begin
	casex({d_l[7:4]})
		4'b0xxx:k_out[3:2] = 2'b00;
		4'b10xx:k_out[3:2] = 2'b01;
		4'b110x:k_out[3:2] = 2'b10;
		4'b1110:k_out[3:2] = 2'b11;
		default:k_out[3:2] = 2'b11;
	endcase
	casex({d_l[3:0]})
		4'b0xxx:k_out[1:0] = 2'b11;
		4'b10xx:k_out[1:0] = 2'b10;
		4'b110x:k_out[1:0] = 2'b01;
		4'b1110:k_out[1:0] = 2'b00;
		default:k_out[1:0] = 2'b00;
	endcase
end

endmodule

