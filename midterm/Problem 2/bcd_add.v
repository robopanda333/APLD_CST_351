//kehnin dyer
//cst 351
//Midterm Exam Problem 1

module bcd_add(
input	wire	[7:0]	A,
						B,
output	reg		[7:0]	C,
output	reg				co
);

reg	[8:0]	tempC;

always@ (*)
begin
	tempC = A+B;
end

assign test1 =(A[3:0]>tempC[3:0] || B[3:0]>tempC[3:0] || tempC[3:0] > 9);
assign test2 =(test1?(tempC > 8'h8F):(tempC > 8'h9F));
always@ (*)
begin
	case({test1, test2})
	2'b11:
		{co, C[7:0]} = tempC + 8'h66;
	2'b10:
		{co, C[7:0]} = tempC + 8'h6;
	2'b01:
		{co, C[7:0]} = tempC + 8'h60;
	2'b00:
		{co, C[7:0]} = tempC;
	endcase
end


endmodule
