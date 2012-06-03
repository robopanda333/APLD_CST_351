



module coinSync(
input	clk,
input	n,
input	di,
input	q,
input	do,
output	n_s,
output	di_s,
output	q_s,
output	do_s
);
inputSync  un(clk,  n,  n_s);
inputSync udi(clk, di, di_s);
inputSync  uq(clk,  q,  q_s);
inputSync udo(clk, do, do_s);
endmodule


//posedge
//async signal trigers high for 1 clk on negedge of async
module inputSync(
input clk,
input async,
output reg sync
);
reg	t1;

always@ (negedge async or posedge sync)
	if (sync)
		t1 = 0;
	else
		t1 = 1;

always@ (negedge clk)
	sync = t1;

endmodule
