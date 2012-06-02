//kehnin dyer
//cst 351
//problem 2


`timescale 1 ns / 100 ps
module bcd_add_test;

reg		[7:0]	A,
				B;
wire	[7:0]	C;
wire			cout;

bcd_add dut(
	.A(A),
	.B(B),
	.C(C),
	.co(cout)
);
integer	i,
		j;

initial
begin
	A=0;
	B=0;
	i = 0;
	j = 0;
	#10;
	for(i = 0; i <= 9; i = i + 1)
	begin
		A = i;
		for(j = 0; j <= 9; j = j + 1)
		begin
			B = j;
			#30;
			$display("A(%h)+B(%h) =C(%h) with a carry of %h",A,B,C, cout);
		end
	end
	#10;
	for(i = 144; i <= 153; i = i + 1)
	begin
		A = i;
		for(j = 0; j <= 9; j = j + 1)
		begin
			B = j;
			#30;
			$display("A(%h)+B(%h) =C(%h) with a carry of %h",A,B,C, cout);
		end

	end
#50 $finish;
end

endmodule
