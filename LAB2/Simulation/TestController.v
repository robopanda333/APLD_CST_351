//testbench for the main controller


module TestController();

Controller c(
	.clk(),		// <-
	.Data(),	// ->
	.Data_rdy(),// ->
	.transEna(),// <-
	.Ascii(),	// <-
	.Ascii_rdy()// <-
	);
reg			clk,
			transEna,
			Ascii_Rdy;
reg	[7:0]	Ascii;

wire			Data_rdy;
wire	[7:0]	Data;

endmodule
