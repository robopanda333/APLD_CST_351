


module KP_top(
input			CLK,
input	[3:0]	K_I,
output	[3:0]	K_O,
output	[4:0]	BCD,
output			d_rdy
);

wire			load,
				ena,
				latchena;
wire	[3:0]	Key;


assign ena = &K_I;

KP_Scan sc(CLK, ena, K_O); //posedge clk change outputs.
KP_sMachine stm(CLK, ena, load, latchena);
KP_Latch lc(latchena, {K_O,K_I}, Key); //negedge latch
KP_Key_BCD as(CLK, load, Key, BCD, d_rdy);

endmodule

