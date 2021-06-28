.globl __start

__start:
######################################################
#     Occur WB forwarding on each ALU instructions   #
######################################################
    ld t0, 0(x0)
    ld t1, 8(x0)
    add a0, t0, t1      # add
    ld t0, 16(x0)
    ld t1, 24(x0)
    sub a1, t0, t1      # sub
    sd a0, 96(x0)
    sd a1, 104(x0)
    ld t0, 32(x0)
    addi a0, t0, 127	# addi a0
    ld t1, 40(x0)
    xori a1, t1, 127	# xori a1
    ld t2, 48(x0)
    slli a2, t2, 63	    # slli a2
    ld t3, 56(x0)
    sll a3, t2, t3  	# sll a3
    ld t4, 64(x0)
    ld t5, 72(x0)
    xor a4, t4, t5	    # xor a4
    ld t6, 48(x0)
    and a5, t6, t6	    # and a5
    andi a6, t6, -1	    # andi a6
    ld t0, 32(x0)
    ori a7, t0, 127	    # ori a7
    ld t0, 48(x0)
    ld t1, 56(x0)
    srl s0, t0, t3	    # srl s0
    ld t0, 64(x0)
    ld t1, 72(x0)
    or s1, t0, t1	    # or s1
    ld t0, 48(x0)
    srli s2, t0, 63	    # srli s2
    ld t0, 48(x0)
    srai s3, t0, 63	    # srai s3
    ld t0, 48(x0)
    ld t1, 56(x0)
    sra s4, t0, t1	    # sra s4
    ld t0, 80(x0)
    slti s5, t0, -1	    # slti s5
    ld t1, 88(x0)
    slt s6, t0, t1      # slt s6
    sd a0, 112(x0)
    sd a1, 120(x0)
    sd a2, 128(x0)
    sd a3, 136(x0)
    sd a4, 144(x0)
    sd a5, 152(x0)
    sd a6, 160(x0)
    sd a7, 168(x0)
    sd s0, 176(x0)
    sd s1, 184(x0)
    sd s2, 192(x0)
    sd s3, 200(x0)
    sd s4, 208(x0)
    sd s5, 216(x0)
    sd s6, 224(x0)
######################################################
#    Occur MEM forwarding on each ALU instructions   #
######################################################
    ld t0, 0(x0)
    ld t1, 8(x0)
    addi t0, t0, -1
    addi t0, t0, 1
    add a0, t0, t1      # add a0
    ld t0, 16(x0)
    ld t1, 24(x0)
    addi t0, t0, -1
    addi t0, t0, 1
    sub a1, t0, t1      # sub a1
    sd a0, 232(x0)
    sd a1, 240(x0)
    ld t0, 32(x0)
    addi t0, t0, -1
    addi t0, t0, 1
    addi a0, t0, 127	# addi a0
    ld t0, 48(x0)
    ld t1, 56(x0)
    addi t0, t0, -1
    addi t0, t0, 1
    sll a3, t0, t1	    # sll a3
    ld t0, 64(x0)
    ld t1, 72(x0)
    addi t0, t0, -1
    addi t0, t0, 1
    xor a4, t0, t1	    # xor a4
    ld t0, 48(x0)
    ld t1, 56(x0)
    addi t0, t0, -1
    addi t0, t0, 1
    srl s0, t0, t1	    # srl s0
    ld t0, 48(x0)
    ld t1, 56(x0)
    addi t0, t0, -1
    addi t0, t0, 1
    sra s4, t0, t1	    # sra s4
    ld t0, 80(x0)
    ld t1, 88(x0)
    addi t0, t0, -1
    addi t0, t0, 1
    slt s6, t0, t1      # slt s6
    sd a0, 248(x0)
    sd a3, 256(x0)
    sd a4, 264(x0)
    sd s0, 272(x0)
    sd s4, 280(x0)
    sd s6, 288(x0)
######################################################
#             Branch (beq, bne) testing              #
######################################################
    ld t0, 32(x0)
    ld t1, 40(x0)
    bne t0, t1, out
cont1:
    addi t0, t0, -8
    bne t0, t1, out
cont2:
    ld t0, 16(x0)
    beq t0, t0, out
cont3:
    ld t0, 32(x0)
    ld t1, 40(x0)
    addi t1, t1, 1
    beq t0, t1, out
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
out:
    addi t1, t1, 1
    beq t0, t1, cont1
    addi t0, t0, 9
    beq t0, t1, cont2
    ld t1, 16(x0)
    addi t1, t1, 9
    beq t0, t1, cont3
    sd t0, 296(x0)
    sd t1, 304(x0)
