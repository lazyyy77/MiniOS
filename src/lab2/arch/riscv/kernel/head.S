    .section .bss.stack
    .globl boot_stack   
boot_stack:
    .space 4096
    .globl boot_stack_top
boot_stack_top:    
    .extern start_kernel
    .section .text.init
    .globl _start
_start:

    la a0, _traps
    csrw stvec, a0

    li a0, (1 << 5) # according to the brochure, STIE of SIE is on bit 5
    csrs sie, a0

    li a7, 0x54494D45
    li a6, 0
    rdtime a0
    li a1, 10000000
    add a0, a0, a1
    li a1, 0
    li a2, 0
    li a3, 0
    li a4, 0
    li a5, 0
    ecall

    li a0, (1 << 1) # according to the brochure, SIE of SSTATUS is on bit 1
    csrs sstatus, a0

    la sp, boot_stack_top # initialize the stack_pointer
    jal x1, start_kernel # jump to the start_kernel function


