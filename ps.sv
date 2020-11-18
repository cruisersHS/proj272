
// interface NOCI(input reg clk, input reg reset);
// logic noc_to_dev_ctl;
// logic [7:0] noc_to_dev_data;
// logic noc_from_dev_ctl;
// logic [7:0] noc_from_dev_data;
// modport FI(input clk, input reset, input noc_from_dev_ctl, input noc_from_dev_data) ;
// modport FO(input clk, input reset, output noc_from_dev_ctl, output noc_from_dev_data) ;
// modport TI(input clk, input reset,input noc_to_dev_ctl,input noc_to_dev_data);
// modport TO(input clk, input reset,output noc_to_dev_ctl,output noc_to_dev_data);


//`include "tb_intf.sv"
`include "perm.sv"
`include "nochw2.sv"

module PS(NOCI.TI t, NOCI.FO f);
	//assign f.clk = t.clk;
	//assign f.reset = t.reset;
	//??????????????????????????????????????????????????????
	assign f.noc_from_dev_ctl = t.noc_from_dev_ctl;
	assign f.noc_from_dev_data = t.noc_from_dev_data;
	
	enum [3:0] {
		IDLE,
		R1,
		R2
	}cs, ns;
	
	always_comb begin
		ns = cs;
		case(cs)
			IDLE: begin
				ns = IDLE;
				//...
			end
			
			default: ns = IDLE;
		endcase
	end

	//select device and pass data to the directions

	//cs, ns
	always_ff @(posedge NOCI.clk or posedge NOCI.reset) begin
		if(NOCI.reset) cs <= #1 0;
		else cs <= #1 ns;
	end
	
	
endmodule: PS










