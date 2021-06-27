// Your code

module RISCV(clk,
            rst,
            // for mem_D
            mem_wen_D_o,
            mem_addr_D_o,
            mem_wdata_D_o,
            mem_rdata_D,
            // for mem_I
            mem_addr_I_o,
            mem_rdata_I);

    input               clk, rst;
    input       [31:0]  mem_rdata_I;
    input       [63:0]  mem_rdata_D;
    output              mem_wen_D_o;
    output reg  [31:2]  mem_addr_I_o;
    output      [31:2]  mem_addr_D_o;
    output      [63:0]  mem_wdata_D_o;

    // 1
    wire    [31:0]  instruction_1;
    // 2
    reg     [31:0]  instruction_2;
    wire    [31:0]  immediate_2;
    wire            Jal_2;
    wire            Jalr_2;
    wire            MemWrite_2;
    wire            MemtoReg_2;
    wire            RegWrite_2;
    wire            ALUSrc_2;
    wire            ALUOP_2;
    wire    [63:0]  r_data1_2, r_data2_2;
    wire            pre_WB_data1, pre_WB_data2;
    wire            MEM_forwd_in1_2, MEM_forwd_in2_2;
    wire            WB_forwd_in1_2, WB_forwd_in2_2;
    wire            no_forwd_in1_2;
    wire            no_forwd_in2_2;
    // 3
    reg     [31:0]  instruction_3;
    reg     [31:0]  immediate_3;
    reg             Jal_3;
    reg             Jalr_3;
    reg             MemWrite_3;
    reg             MemtoReg_3;
    reg             RegWrite_3;
    reg             ALUSrc_3;
    reg             ALUOP_3;
    reg     [63:0]  r_data1_3, r_data2_3;
    reg             MEM_forwd_in1_3, MEM_forwd_in2_3;
    reg             WB_forwd_in1_3, WB_forwd_in2_3;
    reg             no_forwd_in1_3;
    reg             no_forwd_in2_3;
    wire            load_use_hazd_in1, load_use_hazd_in2;
    wire    [63:0]  f_data1_3, f_data2_3;
    wire    [63:0]  PC_4_out_3, PC_imm_out, Jalr_adder_out;
    wire            Branch;
    wire    [63:0]  ALU_in2, ALU_result_3;
    wire    [63:0]  nxt_mem_addr_I;
    wire            flush;
    wire            stall;
    // 4
    reg     [31:0]  instruction_4;
    reg     [63:0]  PC_4_out_4;
    reg     [63:0]  ALU_result_4;
    reg     [63:0]  f_data2_4;
    reg             Jal_4;
    reg             Jalr_4;
    reg             MemtoReg_4;
    reg             MemWrite_4;
    reg             RegWrite_4;
    wire    [63:0]  mem_data_4;
    wire    [63:0]  forwd_data_4;
    // 5
    reg     [31:0]  instruction_5;
    reg     [63:0]  mem_data_5;
    reg     [63:0]  PC_4_out_5;
    reg     [63:0]  ALU_result_5;
    reg             Jal_5;
    reg             Jalr_5;
    reg             MemtoReg_5;
    reg             RegWrite_5;
    wire    [63:0]  Reg_write_data;
    wire    [63:0]  forwd_data_5;

    // First stage start
    assign instruction_1 = {mem_rdata_I[7:0], mem_rdata_I[15:8],
                            mem_rdata_I[23:16], mem_rdata_I[31:24]};

    always @(posedge clk or posedge rst) begin
        if (rst) instruction_2 <= 0;
        else begin
            if (flush) instruction_2 <= 0; 
            else instruction_2 <= instruction_1;
        end
    end
    // First stage end

    // Second stage start
    CONTROL control(
        .clk(clk), .rst(rst), .opcode(instruction_2[6:2]),
        .Jal(Jal_2), .Jalr(Jalr_2), .MemWrite(MemWrite_2),
        .MemtoReg(MemtoReg_2), .RegWrite(RegWrite_2),
        .ALUSrc(ALUSrc_2), .ALUOP(ALUOP_2)
    );

    Imm_Gen imm_gen(
        .immediate(immediate_2), .instruction(instruction_2)
    );

    REGISTERS registers(
        .clk(clk), .rst(rst), .instruction({instruction_2[31:12],instruction_5[11:7],instruction_2[6:0]}),
        .Regwrite(RegWrite_5), .Writedata(Reg_write_data),
        .reg_data1(r_data1_2), .reg_data2(r_data2_2)
    );
    
    assign  pre_WB_data1 = RegWrite_5&(instruction_5[11:7]==instruction_2[19:15])&(instruction_5[11:7]!=5'b0);
    assign  pre_WB_data2 = RegWrite_5&(instruction_5[11:7]==instruction_2[24:20])&(instruction_5[11:7]!=5'b0);
    assign  MEM_forwd_in1_2   = (instruction_3[11:7]==instruction_2[19:15])&RegWrite_3&(instruction_3[11:7]!=5'b0);
    assign  MEM_forwd_in2_2   = (instruction_3[11:7]==instruction_2[24:20])&RegWrite_3&(instruction_3[11:7]!=5'b0);
    assign  WB_forwd_in1_2    = (instruction_4[11:7]==instruction_2[19:15])&RegWrite_4&(instruction_4[11:7]!=5'b0);
    assign  WB_forwd_in2_2    = (instruction_4[11:7]==instruction_2[24:20])&RegWrite_4&(instruction_4[11:7]!=5'b0);
    //assign  no_forwd_in1_2    = !((MEM_forwd_in1_2)|(WB_forwd_in1_2));
    //assign  no_forwd_in2_2    = !((MEM_forwd_in2_2)|(WB_forwd_in2_2));
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Jal_3           <= 0;
            Jalr_3          <= 0;
            MemWrite_3      <= 0;
            MemtoReg_3      <= 0;
            RegWrite_3      <= 0;
            ALUSrc_3        <= 0;
            ALUOP_3         <= 0;
            instruction_3   <= 0;
            immediate_3     <= 0;
            r_data1_3       <= 0;
            r_data2_3       <= 0;
            MEM_forwd_in1_3 <= 0;
            MEM_forwd_in2_3 <= 0;
            WB_forwd_in1_3  <= 0;
            WB_forwd_in2_3  <= 0;
            //no_forwd_in1_3  <= 0;
            //no_forwd_in2_3  <= 0;
        end
        else begin
            if (flush|stall) begin
                Jal_3           <= 0;
                Jalr_3          <= 0;
                MemWrite_3      <= 0;
                MemtoReg_3      <= 0;
                RegWrite_3      <= 0;
                ALUSrc_3        <= 0;
                ALUOP_3         <= 0;
                instruction_3   <= 0;
                immediate_3     <= 0;
                r_data1_3       <= 0;
                r_data2_3       <= 0;
                MEM_forwd_in1_3 <= 0;
                MEM_forwd_in2_3 <= 0;
                WB_forwd_in1_3  <= 0;
                WB_forwd_in2_3  <= 0;
                //no_forwd_in1_3  <= 0;
                //no_forwd_in2_3  <= 0;
            end
            else begin
            Jal_3           <= Jal_2;
            Jalr_3          <= Jalr_2;
            MemWrite_3      <= MemWrite_2;
            MemtoReg_3      <= MemtoReg_2;
            RegWrite_3      <= RegWrite_2;
            ALUSrc_3        <= ALUSrc_2;
            ALUOP_3         <= ALUOP_2;
            instruction_3   <= instruction_2;
            immediate_3     <= immediate_2;
            MEM_forwd_in1_3 <= MEM_forwd_in1_2;
            MEM_forwd_in2_3 <= MEM_forwd_in2_2;
            WB_forwd_in1_3  <= WB_forwd_in1_2;
            WB_forwd_in2_3  <= WB_forwd_in2_2;
            //no_forwd_in1_3  <= no_forwd_in1_2;
            //no_forwd_in2_3  <= no_forwd_in2_2;
            if (pre_WB_data1)   r_data1_3 <= Reg_write_data;
            else                r_data1_3 <= r_data1_2;
            if (pre_WB_data2)   r_data2_3 <= Reg_write_data;
            else                r_data2_3 <= r_data2_2;
            end
        end
    end
    // Second stage end

    // Third stage start
    assign  load_use_hazd_in1   = (instruction_5[6:0]==7'b11)&(instruction_5[14:12]==3'b11)&(instruction_5[11:7]==instruction_3[19:15])&(instruction_5[11:7]!=5'b0);
    assign  load_use_hazd_in2   = (instruction_5[6:0]==7'b11)&(instruction_5[14:12]==3'b11)&(instruction_5[11:7]==instruction_3[24:20])&(instruction_5[11:7]!=5'b0);
    //assign  MEM_forwd_in1_3       = (instruction_4[11:7]==instruction_3[19:15])&RegWrite_4&(instruction_4[11:7]!=5'b0);
    //assign  MEM_forwd_in2_3       = (instruction_4[11:7]==instruction_3[24:20])&RegWrite_4&(instruction_4[11:7]!=5'b0);
    //assign  WB_forwd_in1_3        = (instruction_5[11:7]==instruction_3[19:15])&RegWrite_5&(instruction_5[11:7]!=5'b0);
    //assign  WB_forwd_in2_3        = (instruction_5[11:7]==instruction_3[24:20])&RegWrite_5&(instruction_5[11:7]!=5'b0);
    assign  flush               = Branch|Jal_3|Jalr_3;
    assign  stall               = ((instruction_3[6:0]==7'b11)&(instruction_3[14:12]==3'b11)
            &((instruction_3[11:7]==instruction_2[19:15])|(instruction_3[11:7]==instruction_2[24:20])));

    assign  f_data1_3   = (MEM_forwd_in1_3)? forwd_data_4 : (WB_forwd_in1_3)?forwd_data_5 : r_data1_3;
    assign  f_data2_3   = (MEM_forwd_in2_3)? forwd_data_4 : (WB_forwd_in2_3)?forwd_data_5 : r_data2_3;
    
    // FORWD_UNIT  forwd_unit(
    //     .f_data1(f_data1_3), .f_data2(f_data2_3), .data1(r_data1_3), .data2(r_data2_3),
    //     .MEM_data1(forwd_data_4), .MEM_data2(forwd_data_4),
    //     .WB_data1(forwd_data_5), .WB_data2(forwd_data_5),
    //     .ctrl1({MEM_forwd_in1_3,WB_forwd_in1_3}), .ctrl2({MEM_forwd_in2_3,WB_forwd_in2_3})
    // );

    assign  ALU_in2 = (ALUSrc_3)? {{32{immediate_3[31]}},immediate_3} : f_data2_3;
    assign  PC_4_out_3 = {32'b0,mem_addr_I_o, 2'b0} + 4;
    assign  PC_imm_out = {32'b0,mem_addr_I_o, 2'b0} + {{32{immediate_3[31]}},immediate_3};
    assign  Jalr_adder_out = f_data1_3 + {{32{immediate_3[31]}},immediate_3};
    assign  nxt_mem_addr_I = (Branch || Jal_3)? (PC_imm_out-8) : (Jalr_3) ? Jalr_adder_out : PC_4_out_3;

    Branch_Unit BRANCH(
        .Branch(Branch), .opcode(instruction_3[6:0]), .funct3(instruction_3[14:12]),
        .r_data_1(f_data1_3), .r_data_2(f_data2_3)
    );

    ALU alu(
        .Z(ALU_result_3), .A(f_data1_3), .B(ALU_in2),
        .inst({instruction_3[5],instruction_3[30],instruction_3[14:12]}), .ALUOP(ALUOP_3)
    );
        
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_addr_I_o      <= 0;
            instruction_4   <= 0;
            PC_4_out_4      <= 0;
            ALU_result_4    <= 0;
            f_data2_4       <= 0;
            Jal_4           <= 0;
            Jalr_4          <= 0;
            MemtoReg_4      <= 0;
            MemWrite_4      <= 0;
            RegWrite_4      <= 0;
        end
        else begin
            // load-use hazard
            if ((instruction_2[6:0]==7'b11)&(instruction_2[14:12]==3'b11)
                &((instruction_2[11:7]==instruction_1[19:15])|(instruction_2[11:7]==instruction_1[24:20])))
                mem_addr_I_o <= nxt_mem_addr_I[31:2]-1;
            else mem_addr_I_o <= nxt_mem_addr_I[31:2];
            instruction_4   <= instruction_3;
            PC_4_out_4      <= PC_4_out_3;
            ALU_result_4    <= ALU_result_3;
            f_data2_4       <= f_data2_3;
            Jal_4           <= Jal_3;
            Jalr_4          <= Jalr_3;
            MemtoReg_4      <= MemtoReg_3;
            MemWrite_4      <= MemWrite_3;
            RegWrite_4      <= RegWrite_3;
        end
    end
    // Third stage end

    // Fourth stage start
    assign mem_addr_D_o = ALU_result_4[31:2];
    assign mem_wen_D_o = MemWrite_4;
    assign mem_data_4 = {mem_rdata_D[7:0],mem_rdata_D[15:8],mem_rdata_D[23:16],mem_rdata_D[31:24],
                            mem_rdata_D[39:32],mem_rdata_D[47:40],mem_rdata_D[55:48],mem_rdata_D[63:56]};
    assign mem_wdata_D_o = {f_data2_4[7:0],f_data2_4[15:8],f_data2_4[23:16],f_data2_4[31:24],
                            f_data2_4[39:32],f_data2_4[47:40],f_data2_4[55:48],f_data2_4[63:56]};
    assign forwd_data_4 = ALU_result_4;
    always @(posedge clk or posedge rst)begin
        if (rst) begin
            instruction_5 <= 0;
            mem_data_5  <= 0;
            Jal_5       <= 0;
            Jalr_5      <= 0;
            MemtoReg_5  <= 0;
            RegWrite_5  <= 0;
            PC_4_out_5  <= 0;
            ALU_result_5 <= 0;
        end
        else begin
            instruction_5 <= instruction_4;
            mem_data_5  <= mem_data_4;
            Jal_5       <= Jal_4;
            Jalr_5      <= Jalr_4;
            MemtoReg_5  <= MemtoReg_4;
            RegWrite_5  <= RegWrite_4;
            PC_4_out_5  <= PC_4_out_4;
            ALU_result_5 <= ALU_result_4;
        end
    end
    // Fourth stage end

    // Fifth stage start
    assign Reg_write_data = (Jalr_5 || Jal_5)? (PC_4_out_5-8) : (MemtoReg_5)? mem_data_5 : ALU_result_5;
    assign forwd_data_5 = (MemtoReg_5)? mem_data_5 : ALU_result_5;

    //Fifth stage end
endmodule

module FORWD_UNIT(f_data1,
                f_data2,
                data1,
                data2,
                MEM_data1,
                MEM_data2,
                WB_data1,
                WB_data2,
                ctrl1,
                ctrl2);
    input       [63:0]  data1, data2;
    input       [63:0]  MEM_data1, MEM_data2;
    input       [63:0]  WB_data1, WB_data2;
    input       [1:0]   ctrl1, ctrl2;
    output reg  [63:0]  f_data1, f_data2;

    always @(*) begin
        case (ctrl1)
            2'b10 : f_data1 = MEM_data1;
            2'b01 : f_data1 = WB_data1;
            default : f_data1 = data1;
        endcase
        case (ctrl2)
            2'b10 : f_data2 = MEM_data2;
            2'b01 : f_data2 = WB_data2;
            default : f_data2 = data2;
        endcase
    end
endmodule

module ALU(Z,A,B,inst,ALUOP);
    input  [63:0]   A,B;
    input  [4:0]    inst;
    input           ALUOP;
    output [63:0]   Z;

    reg    [63:0]   Z;
    wire   [3:0]    ctrl;
    assign ctrl = (ALUOP) ? inst[3:0] : 4'b0000;

    always @(*) begin
        case (ctrl)
            4'b0000 : Z = A + B;        //ADD
            4'b0001 : Z = A << B;       //SLL
            4'b1001 : Z = A << B;       //SLLI
            4'b0010 : Z = (A<B)?1:0;    //SLT
            4'b1010 : Z = (A<B)?1:0;    //SLTI
            4'b0100 : Z = A^B;          //XOR
            4'b1100 : Z = A^B;          //XORI
            4'b0101 : Z = A >> B;       //SRL
            4'b0110 : Z = A | B;        //OR
            4'b1110 : Z = A | B;        //ORI
            4'b0111 : Z = A & B;        //AND
            4'b1111 : Z = A & B;        //ANDI
            4'b1000 : Z = (inst[4])? (A - B) : (A+B);        //SUB
            4'b1101 : Z = A >>> B;      //SRA
            default : Z = A;
        endcase
    end
endmodule

module CONTROL(clk,
            rst,
            opcode,
            Jal,
            Jalr,
            MemWrite,
            MemtoReg,
            RegWrite,
            ALUSrc,
            ALUOP
			);
    input           clk, rst;
    input   [6:2]   opcode;
	output          Jal, Jalr, MemWrite, MemtoReg, RegWrite, ALUSrc, ALUOP;
    // local parameter
    localparam JAL      = 5'b11011;
    localparam JALR     = 5'b11001;
    localparam LD       = 5'b00000;
    localparam SD       = 5'b01000;
    localparam R_TYPE   = 5'b01100;
    localparam SB       = 5'b11000;
	// wire/reg
	assign Jal       = (opcode == JAL)? 1 : 0;
    assign Jalr      = (opcode == JALR)? 1 : 0;
    assign MemWrite  = (opcode == SD)? 1 : 0;
    assign MemtoReg  = (opcode == LD)? 1 : 0;
    assign RegWrite  = (opcode == SD)? 0 : 1; 
    assign ALUSrc    = (opcode == R_TYPE || opcode == JAL || opcode == SB)? 0 : 1;
    assign ALUOP     = (opcode == SD || opcode == LD)? 0 : 1;
endmodule

module Branch_Unit(
                Branch,
                opcode,
                funct3,
                r_data_1,
                r_data_2
);
    input   [6:0]   opcode;
    input   [14:12] funct3;
    input   [63:0]  r_data_1, r_data_2;
    output          Branch;

    localparam SB = 7'b1100011;
    localparam BEQ = 3'b0;
    localparam BNE = 3'b1;

    wire equal, beq, bne;

    assign equal = ~|(r_data_1 ^ r_data_2);
    assign beq = (opcode == SB && funct3 == BEQ)? 1 : 0;
    assign bne = (opcode == SB && funct3 == BNE)? 1 : 0;
    assign Branch = ((beq && equal) || (bne && !equal))? 1 : 0;
endmodule

module Imm_Gen (
            immediate,
            instruction
);
    input      [31:0] instruction;
    output reg [31:0] immediate;

    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always @(*) begin
        // I_type
        immediate[11:0]  = instruction[31:20];
        immediate[31:12] = { 20{instruction[31]} };
        case (opcode)
            7'b0100011: begin // S_type
                immediate[11:5]  = instruction[31:25];
                immediate[4:0]   = instruction[11:7];
                immediate[31:12] = { 20{instruction[31]} };
            end
            7'b1100011: begin // B_type
                immediate[12]    = instruction[31];
                immediate[10:5]  = instruction[30:25];
                immediate[4:1]   = instruction[11:8];
                immediate[11]    = instruction[7];
                immediate[31:13] = { 19{instruction[31]} };
                immediate[0]     = 0;
            end
            7'b1101111: begin // J_type
                immediate[20]    = instruction[31];
                immediate[10:1]  = instruction[30:21];
                immediate[11]    = instruction[20];
                immediate[19:12] = instruction[19:12];
                immediate[31:21] = { 11{instruction[31]} };
                immediate[0]     = 0;
            end
            7'b0010011: begin // I:slli,srli,srai
                if (instruction[13:12] == 2'b01) begin
                    immediate[5:0]  = instruction[25:20];
                    immediate[31:6] = { 26{instruction[25]} };
                end
            end
        endcase
    end

endmodule

module REGISTERS(clk,
                rst,
                instruction,
                Regwrite,
                Writedata,
                reg_data1,
                reg_data2);

    input   [31:0]  instruction;
    input           Regwrite,rst,clk;
    input   [63:0]  Writedata;
    output  [63:0]  reg_data1, reg_data2;

    reg     [63:0]  x[0:31];
    reg     [63:0]  nxt_x[0:31];

    wire    [4:0]   read_1, read_2, write_1;

    assign read_1 = instruction[19:15];
    assign read_2 = instruction[24:20];
    assign write_1 = instruction[11:7];

    assign reg_data1 = x[read_1];
    assign reg_data2 = x[read_2];
    
    integer i;

    always @(*) begin
        nxt_x[0] = x[0];
        for (i=1; i<32; i=i+1)
            nxt_x[i] = (Regwrite && (write_1 == i)) ? Writedata : x[i];
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i=0; i<32; i=i+1)
                x[i] <= 0;
        end
        else begin
            for (i=0; i<32; i=i+1)
                x[i] <= nxt_x[i];
        end
    end
endmodule
