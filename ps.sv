//`include "m55.sv"
//`include "perm.sv"
//`include "nochw2.sv"
`include "perm_pkg.sv"  //perm_pkg.sv
`include "n2p_fifo.sv"  //n2p_fifo.sv

module ps (NOCI.TI t, NOCI.FO f);
	// Signal from and to TB
	wire noc_to_dev_ctl;
	wire [7:0] noc_to_dev_data;
	wire noc_from_dev_ctl;
	wire [7:0] noc_from_dev_data;
	assign noc_to_dev_ctl = t.noc_to_dev_ctl;
	assign noc_to_dev_data = t.noc_to_dev_data;
	assign noc_from_dev_ctl = f.noc_from_dev_ctl;
	assign noc_from_dev_data = f.noc_from_dev_data;

	NOCI s2p_1 (t.clk, t.reset);
	NOCI s2p_2 (t.clk, t.reset);
	NOCI s2p_3 (t.clk, t.reset);
	NOCI s2p_4 (t.clk, t.reset);
	perm_pkg p1(s2p_1.TI, s2p_1.FO);
	perm_pkg p2(s2p_2.TI, s2p_2.FO);
	perm_pkg p3(s2p_3.TI, s2p_3.FO);
	perm_pkg p4(s2p_4.TI, s2p_4.FO);
	 
	// Signal from and to perm intf 1
	assign s2p_1.noc_to_dev_ctl = t.noc_to_dev_ctl;
	assign s2p_1.noc_to_dev_data = t.noc_to_dev_data;
	assign f.noc_from_dev_ctl = s2p_1.noc_from_dev_ctl;
	assign f.noc_from_dev_data = s2p_1.noc_from_dev_data;

	logic [16:0] n2p_fifo_out;
	logic n2p_fifo_en_w; // Write Enable for FIFO
	logic n2p_fifo_en_r;
	logic [16:0] n2ps_temp; 
	logic [3:0] Alen;
	logic [9:0] Dlen;
	logic [7:0] cmd_Des; // Store the command DESTINATION
	logic [9:0] cmd_cnt;

	// FIFO receiving command from NOC
	n2p_fifo n2p_fifo(.clk(t.clk), .rst(t.reset), .data_in(n2ps_temp), .rd_en(n2p_fifo_en_r), .wr_en(n2p_fifo_en_w), .data_out(n2p_fifo_out), .empty(n2p_fifo_empty), .full(n2p_fifo_full));
	edge_det ctl_edge_r (.clk(t.clk), .rst(t.reset), .rising_or_falling(1'b1), .sig(t.noc_to_dev_ctl), .edge_detected(ctl_r));
	edge_det ctl_edge_f (.clk(t.clk), .rst(t.reset), .rising_or_falling(1'b0), .sig(t.noc_to_dev_ctl), .edge_detected(ctl_f));

	// Write/Read command
	always_ff @ (posedge t.clk or posedge t.reset) begin
		if (t.reset) begin
			Alen <= #1 0;
			Dlen <= #1 0;
			cmd_Des <= #1 0;
			cmd_cnt <= #1 0;
		end
		else begin
			if (ctl_f) begin
				Alen <= #1 (1 << n2ps_temp[15:14]);
				Dlen <= #1 (1 << n2ps_temp[13:11]);
				cmd_Des <= #1 t.noc_to_dev_data;
				cmd_cnt <= #1 (1<<n2ps_temp[15:14]) + (1<<n2ps_temp[13:11]) + 2;
			end
			else if (cmd_cnt)
				cmd_cnt <= #1 cmd_cnt - 1;
		end
	end
	
	// Store the input data before ctl -> 0
	always_ff @ (posedge t.clk or posedge t.reset) begin
		if (t.reset)
			n2ps_temp <= #1 0;
		else begin
			n2ps_temp <= #1 {t.noc_to_dev_ctl, t.noc_to_dev_data, cmd_Des};
		end
	end

	// Write Enable of FIFO
	assign n2p_fifo_en_w = ctl_f || cmd_cnt;
	// Read/PASS data from FIFO to perms
	always_ff @ (posedge t.clk or posedge t.reset) begin
		if (t.reset)
			n2p_fifo_en_r <= #1 0;
		else if (!n2p_fifo_empty) begin
			n2p_fifo_en_r <= #1 1;
		end
	end
endmodule


