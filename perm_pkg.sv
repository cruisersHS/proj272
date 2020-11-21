`include "m55.sv"
`include "perm.sv"
`include "nochw2.sv"

module perm_pkg (NOCI.TI t, NOCI.FO f);

	wire pushin, stopin, firstin, pushout, stopout, firstout;
	wire [63:0] din, dout;
	wire m1wr, m2wr, m3wr, m4wr;
	wire [2:0] m1rx, m1ry, m2rx, m2ry, m3rx, m3ry, m4rx, m4ry;
	wire [2:0] m1wx, m1wy, m2wx, m2wy, m3wx, m3wy, m4wx, m4wy;
	wire [63:0] m1rd, m2rd, m3rd, m4rd;
	wire [63:0] m1wd, m2wd, m3wd, m4wd;
	
	perm_blk p (
		.clk(t.clk), .rst(t.reset), .pushin(pushin), .stopin(stopin), .firstin(firstin), .din(din),
		.m1rx(m1rx), .m1ry(m1ry), .m1rd(m1rd), .m1wx(m1wx), .m1wy(m1wy), .m1wr(m1wr), .m1wd(m1wd), 
		.m2rx(m2rx), .m1ry(m2ry), .m2rd(m2rd), .m2wx(m2wx), .m2wy(m2wy), .m2wr(m2wr), .m2wd(m2wd), 
		.m3rx(m3rx), .m1ry(m3ry), .m3rd(m3rd), .m3wx(m3wx), .m3wy(m3wy), .m3wr(m3wr), .m3wd(m3wd), 
		.m4rx(m4rx), .m1ry(m4ry), .m4rd(m4rd), .m4wx(m4wx), .m4wy(m4wy), .m4wr(m4wr), .m4wd(m4wd), 
		.pushout(pushout), .stopout(stopout), .firstout(firstout), .dout(dout)
	);
	
	m55 m1 (.clk(t.clk), .rst(t.reset), .rx(m1rx), .ry(m1ry), .rd(m1rd), .wx(m1wx), .wy(m1wy), .wr(m1wr), .wd(m1wd));
	m55 m2 (.clk(t.clk), .rst(t.reset), .rx(m2rx), .ry(m2ry), .rd(m2rd), .wx(m2wx), .wy(m2wy), .wr(m2wr), .wd(m2wd));
	m55 m3 (.clk(t.clk), .rst(t.reset), .rx(m3rx), .ry(m3ry), .rd(m3rd), .wx(m3wx), .wy(m3wy), .wr(m3wr), .wd(m3wd));
	m55 m4 (.clk(t.clk), .rst(t.reset), .rx(m4rx), .ry(m4ry), .rd(m4rd), .wx(m4wx), .wy(m4wy), .wr(m4wr), .wd(m4wd));
	
	noc_intf n (
		.clk(t.clk), .rst(t.reset), 
		.noc_to_dev_ctl(t.noc_to_dev_ctl),
		.noc_to_dev_data(t.noc_to_dev_data),
		.noc_from_dev_ctl(f.noc_from_dev_ctl),
		.noc_from_dev_data(f.noc_from_dev_data),
		.pushin(pushin), .stopin(stopin), .firstin(firstin), .din(din),
		.pushout(pushout), .firstout(firstout), .stopout(stopout),  .dout(dout)
	);
	
	
endmodule























