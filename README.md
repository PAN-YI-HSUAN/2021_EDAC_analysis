# 2021_EDAC_analysis
```
2021_EDAC_analysis
   ├── README.md
   ├── doc
   │   ├── 3/30_meeting.pptx
   │   ├── 4/13_meeting.pptx
   │   └── ...
   ├── rtl
   │   ├── RISCV.v
   │   └── memory.v
   ├── sim
   │   ├── Makefile
   |   ├── RISCV_testfixture.v
   │   └── pattern(including benchmark)
   ├── analyze_slack_time
   │   ├── analyze_padding.scrpt
   │   └── transfer_to_csv.py
   └── benchmark_design
       ├── pattern_gen_benchamark.s
       ├── inst_RV64I_benchmark.txt
       ├── data_benchmark.txt
       └── ans_benchmark.txt

```
## EDAC tech on processor
### How to choose flip-flop to be replaced?
1. Observe the slack time of endpoints and select proper ratio of flip-flops.
2. Avoid choosing the slack time with too much endpoints. (replaceing too much FF may result in  padding failed)
3. Can't replace the flip-flop related to memory.
### Ways to analyze endpoints with slack time.
1. Open dc_shell.
2. Read .ddc file, which is the result of synthesis.
3. Run instruction to dump file containing slack time of every endpoint.
```
report_timing -to [get_pins -filter {full_name =~ "*/Q"}] -path_type end -delay_type max -significant_digits 6 -nosplit > max_delay.rpt
```
4. Exit dc_shell and run script to select useful info.
```
source analyze_padding.script
```
5. Run python file to transfer file type to .csv .
```
python3.7 transfer_to_csv.py --input path --output path --time cycletime
```
## Design benchmark for processor
### Analyze flow
1. Select cycle time to synthesis.
2. Open dc_shell.
3. Observe critical path.
```
report_timing
```
4. Observe all endpoint slack time.
```
report_timing –path end
```
5. Check cell architecture.
```
report_resources
```
6. Collect then information and design
7. Gate-level simulation
### Design flow
1. Load data.
2. Occur load-use hazard : MEM forwarding.
3. Occur data hazard : WB forwarding.
4. Run over every instruction.
5. Make ALU path longer.
6. Take control of next instruction address (branch).
