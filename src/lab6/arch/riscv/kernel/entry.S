    .extern trap_handler
    .section .text.entry
    .align 2
    .globl _traps 
_traps:
    csrr t0, sscratch
    li t1, 0
    beq t0, t1, _ssp
    csrw sscratch, sp
    addi sp, t0, 0          # change sp to kernel_sp if it's a user thread
_ssp:
    addi sp, sp, -264
    sd ra, 0(sp)
    sd gp, 8(sp)
    sd tp, 16(sp)
    sd t0, 24(sp)
    sd t1, 32(sp)
    sd t2, 40(sp)
    sd s0, 48(sp)
    sd s1, 56(sp)
    sd a0, 64(sp)
    sd a1, 72(sp)
    sd a2, 80(sp)
    sd a3, 88(sp)
    sd a4, 96(sp)
    sd a5, 104(sp)
    sd a6, 112(sp)
    sd a7, 120(sp)
    sd s2, 128(sp)
    sd s3, 136(sp)
    sd s4, 144(sp)
    sd s5, 152(sp)
    sd s6, 160(sp)
    sd s7, 168(sp)
    sd s8, 176(sp)
    sd s9, 184(sp)
    sd s10, 192(sp)
    sd s11, 200(sp)
    sd t3, 208(sp)
    sd t4, 216(sp)
    sd t5, 224(sp)
    sd t6, 232(sp)
    csrr a0, scause
    # sd a0, 240(sp)
    csrr a1, sepc
    sd a1, 240(sp)
    csrr a2, sstatus
    sd a2, 248(sp)
    addi a2, sp, 0

    jal x1, trap_handler
    .globl __ret_from_fork
__ret_from_fork:
    ld a2, 248(sp)
    csrw sstatus, a2
    ld a1, 240(sp)
    csrw sepc, a1
    # ld a0, 240(sp)
    # csrw scause, a0
    ld t6, 232(sp)
    ld t5, 224(sp)
    ld t4, 216(sp)
    ld t3, 208(sp)
    ld s11, 200(sp)
    ld s10, 192(sp)
    ld s9, 184(sp)
    ld s8, 176(sp)
    ld s7, 168(sp)
    ld s6, 160(sp)
    ld s5, 152(sp)
    ld s4, 144(sp)
    ld s3, 136(sp)
    ld s2, 128(sp)
    ld a7, 120(sp)
    ld a6, 112(sp)
    ld a5, 104(sp)
    ld a4, 96(sp)
    ld a3, 88(sp)
    ld a2, 80(sp)
    ld a1, 72(sp)
    ld a0, 64(sp)
    ld s1, 56(sp)
    ld s0, 48(sp)
    ld t2, 40(sp)
    ld t1, 32(sp)
    ld t0, 24(sp)
    ld tp, 16(sp)
    ld gp, 8(sp)
    ld ra, 0(sp)
    addi sp, sp, 264

    csrr t0, sscratch
    li t1, 0
    beq t0, t1, _esp
    csrw sscratch, sp
    addi sp, t0, 0
_esp:
    sret
    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # 4. return from trap

    .extern dummy
    .globl __dummy
__dummy:
    csrr a0, sscratch
    csrw sscratch, sp
    addi sp, a0, 0          # change sp from kernel to user
    sret

    .globl __switch_to
__switch_to:

    sd ra, 32(a0)   # addr of ra_prev
    sd sp, 40(a0)   # addr of sp_prev
    sd s0, 48(a0)   # addr of s0_prev to s11_prev
    sd s1, 56(a0)
    sd s2, 64(a0)
    sd s3, 72(a0)
    sd s4, 80(a0)
    sd s5, 88(a0)
    sd s6, 96(a0)
    sd s7, 104(a0)
    sd s8, 112(a0)
    sd s9, 120(a0)
    sd s10, 128(a0)
    sd s11, 136(a0)
    csrr a2, sepc
    sd a2, 144(a0)
    csrr a2, sstatus
    sd a2, 152(a0)
    csrr a2, sscratch
    sd a2, 160(a0)

    ld ra, 32(a1)   # addr of ra_next
    ld sp, 40(a1)   # addr of sp_next
    ld s0, 48(a1)   # addr of s0_next to s11_next
    ld s1, 56(a1)
    ld s2, 64(a1)
    ld s3, 72(a1)
    ld s4, 80(a1)
    ld s5, 88(a1)
    ld s6, 96(a1)
    ld s7, 104(a1)
    ld s8, 112(a1)
    ld s9, 120(a1)
    ld s10, 128(a1)
    ld s11, 136(a1)
    ld a2, 144(a1)
    csrw sepc, a2
    ld a2, 152(a1)
    csrw sstatus, a2
    ld a2, 160(a1)
    csrw sscratch, a2
    ld a2, 168(a1)

    li a3, 0xffffffdf80000000
    sub a2, a2, a3
    srli a2, a2, 12
    li a3, 0x8000000000000000
    or a2, a2, a3 
    csrw satp, a2
    sfence.vma zero, zero

    # save state to prev process
    # restore state from next process

    ret
