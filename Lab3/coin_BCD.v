
module coin_BCD
(
input	[5:0]	coinval,
output	[3:0]	ones,
output	[3:0]	tens,
output	[3:0]	hund
)

reg	[11:0] nickelrom [0:63];
initial
	$readmemh("nickelval.rom", nickelrom);

always@ (*)
{hund,tens,ones} = nickelrom[coinval];

endmodule

