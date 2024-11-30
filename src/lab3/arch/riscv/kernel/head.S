    .section .bss.stack
    .globl boot_stack   
boot_stack:
    .space 4096
    .globl boot_stack_top
boot_stack_top:    
    .extern start_kernel
    .extern mm_init             # add in lab2
    .extern task_init           # add in lab2
    .extern setup_vm            # add in lab3
    .extern setup_vm_final      # add in lab3
    .section .text.init
    .globl _start
_start:

    la sp, boot_stack_top # initialize the stack_pointer
    call setup_vm
    call relocate
    jal x1, mm_init
    call setup_vm_final
    jal x1, task_init
    
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

    jal x1, start_kernel # jump to the start_kernel function

    # .extern PA2VA_OFFSET
    .extern early_pgtbl
relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)

    # ld a0, PA2VA_OFFSET
    li a0, 0xffffffdf80000000
    add ra, ra, a0
    add sp, sp, a0

	# la a1, jump_to_here
	# add a1, a1, a0
	# csrw stvec, a1

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero


    # set satp with early_pgtbl
    la a0, early_pgtbl
    srli a0, a0, 12
    li a1, 0x8000000000000000
    or a0, a0, a1
    csrw satp, a0
# jump_to_here:
    sfence.vma zero, zero

    ret
