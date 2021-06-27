design = RISCV.v
pattern = 1 # 4 = benchmark
cycletime = 10.0
corner = max

DW_path = /usr/cad/synopsys/synthesis/2019.03/dw/sim_ver/
libVerilogFile = /usr/cad/designkit/T28/HE_20160707/TSMCHOME/digital/Front_End/verilog/tcbn28hpcplusbwp30p140hvt_110a/tcbn28hpcplusbwp30p140hvt.v
libVerilogFileEDFF = ../EDFF/Front_End/verilog/ERRDF.v

rtlsim:
	ncverilog RISCV_testfixture.v ../rtl/$(design) -y $(DW_path) +libext+.v +incdir+$(DW_path) +define+PATTERN=$(pattern) +define+CYCLE=$(cycletime) +nc64bit
rtlsim-vcd:
	ncverilog RISCV_testfixture.v ../rtl/$(design) -y $(DW_path) +libext+.v +incdir+$(DW_path) +define+PATTERN=$(pattern) +define+VCD +define+CYCLE=$(cycletime) +access+r +nc64bit
rtlsim-fsdb:
	ncverilog RISCV_testfixture.v ../rtl/$(design) -y $(DW_path) +libext+.v +incdir+$(DW_path) +define+PATTERN=$(pattern) +define+FSDB +define+CYCLE=$(cycletime) +access+r
gatesim:
	ncverilog RISCV_testfixture.v ../synthesis/$(design) -v $(libVerilogFile) +define+PATTERN=$(pattern) +define+SDF +define+CYCLE=$(cycletime) +nc64bit +ncsdfnowarn +nc$(corner)delays
gatesim-vcd:
	ncverilog RISCV_testfixture.v ../synthesis/$(design) -v $(libVerilogFile) +define+PATTERN=$(pattern) +define+SDF +define+CYCLE=$(cycletime) +define+VCD +access+r +nc64bit +ncsdfnowarn +nc$(corner)delays
gatesim-fsdb:
	ncverilog RISCV_testfixture.v ../synthesis/$(design) -v $(libVerilogFile) +define+PATTERN=$(pattern) +define+SDF +define+CYCLE=$(cycletime) +define+FSDB +access+r +ncsdfnowarn +nc$(corner)delays
gatesim-edac:
	ncverilog RISCV_testfixture.v ../synthesis/$(design) -v $(libVerilogFile) -v $(libVerilogFileEDFF) +define+PATTERN=$(pattern) +define+SDF +define+CYCLE=$(cycletime) +define+EDAC +nc64bit +ncsdfnowarn +nc$(corner)delays +no_tchk_msg
gatesim-edac-fsdb:
	ncverilog RISCV_testfixture.v ../synthesis/$(design) -v $(libVerilogFile) -v $(libVerilogFileEDFF) +define+PATTERN=$(pattern) +define+SDF +define+CYCLE=$(cycletime) +define+FSDB +define+EDAC +access+r +ncsdfnowarn +nc$(corner)delays +no_tchk_msg
gatesim-edac-vcd:
	ncverilog RISCV_testfixture.v ../synthesis/$(design) -v $(libVerilogFile) -v $(libVerilogFileEDFF) +define+PATTERN=$(pattern) +define+SDF +define+CYCLE=$(cycletime) +define+VCD +define+EDAC +access+r +nc64bit +ncsdfnowarn +nc$(corner)delays +no_tchk_msg
clean:
	rm -rf ./INCA_libs