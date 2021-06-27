`timescale 1ns/1ps

`ifndef CYCLE
  `define CYCLE  10.0  // a default cycle time
`endif

`ifndef SPP_END_RATIO
  // max window after layout: `define SPP_END_RATIO 2.55
  `define SPP_END_RATIO 0.2
`endif

`ifndef PATTERN
  `define PATTERN 1
`endif

`include "../rtl/memory.v"

`ifdef EDAC
`define SDFFILE    "../synthesis/RISCV_syn_edac.sdf"
`else
`define SDFFILE    "../synthesis/RISCV_syn.sdf"
`endif

`define End_CYCLE  500          // Modify cycle times once your design need more cycle times!

module testfixture;

	reg        	clk;
	reg         rst;
    reg  [63:0] mem_data_ans [0:255];

	wire        mem_wen_D  ;
    wire [31:2] mem_addr_D ;
    wire [63:0] mem_wdata_D;
    wire [63:0] mem_rdata_D; 
    wire [31:2] mem_addr_I ;
    wire [31:0] mem_rdata_I;
    
	integer      pattern_switch;
    integer i,j;
    
    integer eof;
    reg eof_find;
	integer error_num;

	`ifdef SDF
	initial $sdf_annotate(`SDFFILE, chip0);
	`endif

	initial begin
	`ifdef VCD
	  	`ifdef SDF
	  	`define WAVEFORMFILE  "RISCV_syn.vcd"
	  	`else
	  	`define WAVEFORMFILE  "RISCV.vcd"
	  	`endif
	  	$dumpfile(`WAVEFORMFILE);
	  	$dumpvars;
	`endif

	`ifdef FSDB
	  	`ifdef SDF
	  	`define WAVEFORMFILE  "RISCV_syn.fsdb"
	  	`else
	  	`define WAVEFORMFILE  "RISCV.fsdb"
	  	`endif
	  	$fsdbDumpfile(`WAVEFORMFILE);
	  	$fsdbDumpvars(0,testfixture,"+mda"); //This command is for dumping 2D array
	`endif
	end

	`ifdef EDAC
	real err_cnt;
	wire [268:0] err;
	wire err_or, err_sdl;
	assign err_or = |err;
	RISCV chip0(
		.clk(clk),
		.rst(rst),
		// for mem_D
		.mem_wen_D_o(mem_wen_D),
		.mem_addr_D_o(mem_addr_D),
		.mem_wdata_D_o(mem_wdata_D),
		.mem_rdata_D(mem_rdata_D),
		// for mem_I
		.mem_addr_I_o(mem_addr_I),
		.mem_rdata_I(mem_rdata_I),
		.err_o(err));

	memory_I mem_I(
		.clk(clk),
		.wen(1'b0),
		.a(mem_addr_I[9:2]),
		.d(32'd0),
		.q(mem_rdata_I));

	memory_D mem_D(
		.clk(clk),
		.wen(mem_wen_D),
		.a(mem_addr_D[10:3]),
		.d(mem_wdata_D),
		.q(mem_rdata_D));
	SDLHQD1BWP30P140HVT sdl(.D(err_or), .E(clk), .Q(err_sdl));
	always@(posedge clk or posedge rst) begin
		if (rst) err_cnt <= 0.0;
		else if (err_sdl) err_cnt <= err_cnt + 1.0;
	end
	// FIR DUT(.data_valid_i(en), .data_i(data), .clk(clk), .rst(reset), .fir_d_o(fir_d), .fir_valid_o(fir_valid));
	`else
	RISCV chip0(
		.clk(clk),
		.rst(rst),
		// for mem_D
		.mem_wen_D_o(mem_wen_D),
		.mem_addr_D_o(mem_addr_D),
		.mem_wdata_D_o(mem_wdata_D),
		.mem_rdata_D(mem_rdata_D),
		// for mem_I
		.mem_addr_I_o(mem_addr_I),
		.mem_rdata_I(mem_rdata_I));

	memory_I mem_I(
		.clk(clk),
		.wen(1'b0),
		.a(mem_addr_I[9:2]),
		.d(32'd0),
		.q(mem_rdata_I));

	memory_D mem_D(
		.clk(clk),
		.wen(mem_wen_D),
		.a(mem_addr_D[10:3]),
		.d(mem_wdata_D),
		.q(mem_rdata_D));
	`endif
	
	initial begin
		rst     = 0;
		clk 	= 1;
		#(`CYCLE*0.1)   rst = 1'b1; 
	  	#(`CYCLE*2);    rst = 1'b0;
		for (i=0; i<256; i=i+1) mem_D.mem[i]    = 64'h00_00_00_00_00_00_00_00; // reset data in mem_D
		for (i=0; i<256; i=i+1) mem_data_ans[i] = 64'h00_00_00_00_00_00_00_00;
	  	pattern_switch = `PATTERN;
	  	case (pattern_switch)
	    	1: begin 
				$readmemh("./pattern/data_1.txt", mem_D.mem);
				$readmemh("./pattern/ans_1.txt", mem_data_ans);
				$readmemh("./pattern/inst_RV64I_1.txt", mem_I.mem);
			end
	    	2: begin 
				$readmemh("./pattern/data_2.txt", mem_D.mem);
				$readmemh("./pattern/ans_2.txt", mem_data_ans);
				$readmemh("./pattern/inst_RV64I_2.txt", mem_I.mem);
			end
			3: begin 
				$readmemh("./pattern/data_3.txt", mem_D.mem);
				$readmemh("./pattern/ans_3.txt", mem_data_ans);
				$readmemh("./pattern/inst_RV64I_3.txt", mem_I.mem);
			end
			4: begin 
				$readmemh("./pattern/data_benchmark.txt", mem_D.mem);
				$readmemh("./pattern/ans_benchmark.txt", mem_data_ans);
				$readmemh("./pattern/inst_RV64I_benchmark.txt", mem_I.mem);
			end
			5: begin 
				$readmemh("./pattern/data_5.txt", mem_D.mem);
				$readmemh("./pattern/ans_5.txt", mem_data_ans);
				$readmemh("./pattern/inst_RV64I_5.txt", mem_I.mem);
			end
	    	default: begin 
				$readmemh("./pattern/data_1.txt", mem_D.mem);
				$readmemh("./pattern/ans_1.txt", mem_data_ans);
				$readmemh("./pattern/inst_RV64I_1.txt", mem_I.mem);
			end
	  	endcase
	  	eof_find = 0;
        for (i=0; i<256; i=i+1) begin
            if (mem_I.mem[i] === 32'bx) begin
                if (eof_find == 0) begin
                    eof_find = 1;
                    eof = i+4;
                end
                mem_I.mem[i] = 32'h33_00_00_00;
            end
        end
	end

	//============================================================================================================
	//============================================================================================================
	//============================================================================================================
	// RISCV data output verify
	always @(negedge clk) begin
        if (mem_addr_I >= eof) begin
            error_num = 0;
            for (i=0; i<256; i=i+1) begin
                if (mem_D.mem[i] !== mem_data_ans[i]) begin
                    if (error_num == 0)
                        $display("Error!");
                    error_num = error_num + 1;
                    $display("  Addr = 0x%2h  Correct ans: 0x%h  Your ans: 0x%h", 8*i, mem_data_ans[i], mem_D.mem[i]);
                end
            end
			`ifdef EDAC
	  		$display("You get %3d timing error(s)" ,err_cnt);
	  		// $display("Timing error rate = " , err_cnt/1024);
	  		`endif
	  		if ( error_num == 0 ) begin
	    		$display("-----------------------------------------------------\n");
	    		$display("Congratulations! All data have been generated successfully!\n");
	    		$display("-------------------------PASS------------------------\n");
	  		#(`CYCLE/2); $finish;
	  		end
	  		else begin
	    		$display("-----------------------------------------------------\n");
	    		$display("Fail!! There are some error with your code!\n");
	    		$display("-------------------------FAIL------------------------\n");
	  		#(`CYCLE/2); $finish;
	  		end
		end
	end

	//============================================================================================================
	//============================================================================================================
	//============================================================================================================

	// Terminate the simulation, FAIL
	initial  begin
	  	#(`CYCLE * `End_CYCLE);
	  	$display("============================================================\n");
    	$display("Simulation time is longer than expected.");
    	$display("The test result is .....FAIL :(\n");
    	$display("============================================================\n");
	  	$finish;
	end
	
	always begin
		#(`SPP_END_RATIO * `CYCLE) clk = 0;
		#(`CYCLE - `SPP_END_RATIO * `CYCLE) clk = 1;
	end

endmodule
