
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_skernel>:
    .extern setup_vm_final      # add in lab3
    .section .text.init
    .globl _start
_start:

    la sp, boot_stack_top   # initialize the stack_pointer
ffffffe000200000:	00009117          	auipc	sp,0x9
ffffffe000200004:	00010113          	mv	sp,sp
    call setup_vm
ffffffe000200008:	1ec020ef          	jal	ffffffe0002021f4 <setup_vm>
    call relocate
ffffffe00020000c:	05c000ef          	jal	ffffffe000200068 <relocate>
    jal x1, mm_init
ffffffe000200010:	2d9000ef          	jal	ffffffe000200ae8 <mm_init>
    call setup_vm_final
ffffffe000200014:	36c020ef          	jal	ffffffe000202380 <setup_vm_final>
    jal x1, task_init
ffffffe000200018:	569000ef          	jal	ffffffe000200d80 <task_init>
    
    la a0, _traps
ffffffe00020001c:	00000517          	auipc	a0,0x0
ffffffe000200020:	08450513          	addi	a0,a0,132 # ffffffe0002000a0 <_traps>
    csrw stvec, a0
ffffffe000200024:	10551073          	csrw	stvec,a0

    li a0, (1 << 5)   # according to the brochure, STIE of SIE is on bit 5
ffffffe000200028:	02000513          	li	a0,32
    csrs sie, a0
ffffffe00020002c:	10452073          	csrs	sie,a0


    li a7, 0x54494D45
ffffffe000200030:	544958b7          	lui	a7,0x54495
ffffffe000200034:	d458889b          	addiw	a7,a7,-699 # 54494d45 <PHY_SIZE+0x4c494d45>
    li a6, 0
ffffffe000200038:	00000813          	li	a6,0
    rdtime a0
ffffffe00020003c:	c0102573          	rdtime	a0
    li a1, 10000000
ffffffe000200040:	009895b7          	lui	a1,0x989
ffffffe000200044:	6805859b          	addiw	a1,a1,1664 # 989680 <OPENSBI_SIZE+0x789680>
    add a0, a0, a1
ffffffe000200048:	00b50533          	add	a0,a0,a1
    li a1, 0
ffffffe00020004c:	00000593          	li	a1,0
    li a2, 0
ffffffe000200050:	00000613          	li	a2,0
    li a3, 0
ffffffe000200054:	00000693          	li	a3,0
    li a4, 0
ffffffe000200058:	00000713          	li	a4,0
    li a5, 0
ffffffe00020005c:	00000793          	li	a5,0
    ecall
ffffffe000200060:	00000073          	ecall

    # li a0, (1 << 1) # according to the brochure, SIE of SSTATUS is on bit 1
    # csrs sstatus, a0

    jal x1, start_kernel # jump to the start_kernel function
ffffffe000200064:	760020ef          	jal	ffffffe0002027c4 <start_kernel>

ffffffe000200068 <relocate>:
relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)

    # ld a0, PA2VA_OFFSET
    li a0, 0xffffffdf80000000
ffffffe000200068:	fbf0051b          	addiw	a0,zero,-65
ffffffe00020006c:	01f51513          	slli	a0,a0,0x1f
    add ra, ra, a0
ffffffe000200070:	00a080b3          	add	ra,ra,a0
    add sp, sp, a0
ffffffe000200074:	00a10133          	add	sp,sp,a0
	# la a1, jump_to_here
	# add a1, a1, a0
	# csrw stvec, a1

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero
ffffffe000200078:	12000073          	sfence.vma


    # set satp with early_pgtbl
    la a0, early_pgtbl
ffffffe00020007c:	0000a517          	auipc	a0,0xa
ffffffe000200080:	f8450513          	addi	a0,a0,-124 # ffffffe00020a000 <early_pgtbl>
    srli a0, a0, 12
ffffffe000200084:	00c55513          	srli	a0,a0,0xc
    li a1, 0x8000000000000000
ffffffe000200088:	fff0059b          	addiw	a1,zero,-1
ffffffe00020008c:	03f59593          	slli	a1,a1,0x3f
    or a0, a0, a1
ffffffe000200090:	00b56533          	or	a0,a0,a1
    csrw satp, a0
ffffffe000200094:	18051073          	csrw	satp,a0
# jump_to_here:
    sfence.vma zero, zero
ffffffe000200098:	12000073          	sfence.vma

    ret
ffffffe00020009c:	00008067          	ret

ffffffe0002000a0 <_traps>:
    .extern trap_handler
    .section .text.entry
    .align 2
    .globl _traps 
_traps:
    csrr t0, sscratch
ffffffe0002000a0:	140022f3          	csrr	t0,sscratch
    li t1, 0
ffffffe0002000a4:	00000313          	li	t1,0
    beq t0, t1, _ssp
ffffffe0002000a8:	00628663          	beq	t0,t1,ffffffe0002000b4 <_ssp>
    csrw sscratch, sp
ffffffe0002000ac:	14011073          	csrw	sscratch,sp
    addi sp, t0, 0          # change sp to kernel_sp if it's a user thread
ffffffe0002000b0:	00028113          	mv	sp,t0

ffffffe0002000b4 <_ssp>:
_ssp:
    addi sp, sp, -264
ffffffe0002000b4:	ef810113          	addi	sp,sp,-264 # ffffffe000208ef8 <_sbss+0xef8>
    sd ra, 0(sp)
ffffffe0002000b8:	00113023          	sd	ra,0(sp)
    sd gp, 8(sp)
ffffffe0002000bc:	00313423          	sd	gp,8(sp)
    sd tp, 16(sp)
ffffffe0002000c0:	00413823          	sd	tp,16(sp)
    sd t0, 24(sp)
ffffffe0002000c4:	00513c23          	sd	t0,24(sp)
    sd t1, 32(sp)
ffffffe0002000c8:	02613023          	sd	t1,32(sp)
    sd t2, 40(sp)
ffffffe0002000cc:	02713423          	sd	t2,40(sp)
    sd s0, 48(sp)
ffffffe0002000d0:	02813823          	sd	s0,48(sp)
    sd s1, 56(sp)
ffffffe0002000d4:	02913c23          	sd	s1,56(sp)
    sd a0, 64(sp)
ffffffe0002000d8:	04a13023          	sd	a0,64(sp)
    sd a1, 72(sp)
ffffffe0002000dc:	04b13423          	sd	a1,72(sp)
    sd a2, 80(sp)
ffffffe0002000e0:	04c13823          	sd	a2,80(sp)
    sd a3, 88(sp)
ffffffe0002000e4:	04d13c23          	sd	a3,88(sp)
    sd a4, 96(sp)
ffffffe0002000e8:	06e13023          	sd	a4,96(sp)
    sd a5, 104(sp)
ffffffe0002000ec:	06f13423          	sd	a5,104(sp)
    sd a6, 112(sp)
ffffffe0002000f0:	07013823          	sd	a6,112(sp)
    sd a7, 120(sp)
ffffffe0002000f4:	07113c23          	sd	a7,120(sp)
    sd s2, 128(sp)
ffffffe0002000f8:	09213023          	sd	s2,128(sp)
    sd s3, 136(sp)
ffffffe0002000fc:	09313423          	sd	s3,136(sp)
    sd s4, 144(sp)
ffffffe000200100:	09413823          	sd	s4,144(sp)
    sd s5, 152(sp)
ffffffe000200104:	09513c23          	sd	s5,152(sp)
    sd s6, 160(sp)
ffffffe000200108:	0b613023          	sd	s6,160(sp)
    sd s7, 168(sp)
ffffffe00020010c:	0b713423          	sd	s7,168(sp)
    sd s8, 176(sp)
ffffffe000200110:	0b813823          	sd	s8,176(sp)
    sd s9, 184(sp)
ffffffe000200114:	0b913c23          	sd	s9,184(sp)
    sd s10, 192(sp)
ffffffe000200118:	0da13023          	sd	s10,192(sp)
    sd s11, 200(sp)
ffffffe00020011c:	0db13423          	sd	s11,200(sp)
    sd t3, 208(sp)
ffffffe000200120:	0dc13823          	sd	t3,208(sp)
    sd t4, 216(sp)
ffffffe000200124:	0dd13c23          	sd	t4,216(sp)
    sd t5, 224(sp)
ffffffe000200128:	0fe13023          	sd	t5,224(sp)
    sd t6, 232(sp)
ffffffe00020012c:	0ff13423          	sd	t6,232(sp)
    csrr a0, scause
ffffffe000200130:	14202573          	csrr	a0,scause
    # sd a0, 240(sp)
    csrr a1, sepc
ffffffe000200134:	141025f3          	csrr	a1,sepc
    sd a1, 240(sp)
ffffffe000200138:	0eb13823          	sd	a1,240(sp)
    csrr a2, sstatus
ffffffe00020013c:	10002673          	csrr	a2,sstatus
    sd a2, 248(sp)
ffffffe000200140:	0ec13c23          	sd	a2,248(sp)
    addi a2, sp, 0
ffffffe000200144:	00010613          	mv	a2,sp

    jal x1, trap_handler
ffffffe000200148:	349010ef          	jal	ffffffe000201c90 <trap_handler>

ffffffe00020014c <__ret_from_fork>:
    .globl __ret_from_fork
__ret_from_fork:
    ld a2, 248(sp)
ffffffe00020014c:	0f813603          	ld	a2,248(sp)
    csrw sstatus, a2
ffffffe000200150:	10061073          	csrw	sstatus,a2
    ld a1, 240(sp)
ffffffe000200154:	0f013583          	ld	a1,240(sp)
    csrw sepc, a1
ffffffe000200158:	14159073          	csrw	sepc,a1
    # ld a0, 240(sp)
    # csrw scause, a0
    ld t6, 232(sp)
ffffffe00020015c:	0e813f83          	ld	t6,232(sp)
    ld t5, 224(sp)
ffffffe000200160:	0e013f03          	ld	t5,224(sp)
    ld t4, 216(sp)
ffffffe000200164:	0d813e83          	ld	t4,216(sp)
    ld t3, 208(sp)
ffffffe000200168:	0d013e03          	ld	t3,208(sp)
    ld s11, 200(sp)
ffffffe00020016c:	0c813d83          	ld	s11,200(sp)
    ld s10, 192(sp)
ffffffe000200170:	0c013d03          	ld	s10,192(sp)
    ld s9, 184(sp)
ffffffe000200174:	0b813c83          	ld	s9,184(sp)
    ld s8, 176(sp)
ffffffe000200178:	0b013c03          	ld	s8,176(sp)
    ld s7, 168(sp)
ffffffe00020017c:	0a813b83          	ld	s7,168(sp)
    ld s6, 160(sp)
ffffffe000200180:	0a013b03          	ld	s6,160(sp)
    ld s5, 152(sp)
ffffffe000200184:	09813a83          	ld	s5,152(sp)
    ld s4, 144(sp)
ffffffe000200188:	09013a03          	ld	s4,144(sp)
    ld s3, 136(sp)
ffffffe00020018c:	08813983          	ld	s3,136(sp)
    ld s2, 128(sp)
ffffffe000200190:	08013903          	ld	s2,128(sp)
    ld a7, 120(sp)
ffffffe000200194:	07813883          	ld	a7,120(sp)
    ld a6, 112(sp)
ffffffe000200198:	07013803          	ld	a6,112(sp)
    ld a5, 104(sp)
ffffffe00020019c:	06813783          	ld	a5,104(sp)
    ld a4, 96(sp)
ffffffe0002001a0:	06013703          	ld	a4,96(sp)
    ld a3, 88(sp)
ffffffe0002001a4:	05813683          	ld	a3,88(sp)
    ld a2, 80(sp)
ffffffe0002001a8:	05013603          	ld	a2,80(sp)
    ld a1, 72(sp)
ffffffe0002001ac:	04813583          	ld	a1,72(sp)
    ld a0, 64(sp)
ffffffe0002001b0:	04013503          	ld	a0,64(sp)
    ld s1, 56(sp)
ffffffe0002001b4:	03813483          	ld	s1,56(sp)
    ld s0, 48(sp)
ffffffe0002001b8:	03013403          	ld	s0,48(sp)
    ld t2, 40(sp)
ffffffe0002001bc:	02813383          	ld	t2,40(sp)
    ld t1, 32(sp)
ffffffe0002001c0:	02013303          	ld	t1,32(sp)
    ld t0, 24(sp)
ffffffe0002001c4:	01813283          	ld	t0,24(sp)
    ld tp, 16(sp)
ffffffe0002001c8:	01013203          	ld	tp,16(sp)
    ld gp, 8(sp)
ffffffe0002001cc:	00813183          	ld	gp,8(sp)
    ld ra, 0(sp)
ffffffe0002001d0:	00013083          	ld	ra,0(sp)
    addi sp, sp, 264
ffffffe0002001d4:	10810113          	addi	sp,sp,264

    csrr t0, sscratch
ffffffe0002001d8:	140022f3          	csrr	t0,sscratch
    li t1, 0
ffffffe0002001dc:	00000313          	li	t1,0
    beq t0, t1, _esp
ffffffe0002001e0:	00628663          	beq	t0,t1,ffffffe0002001ec <_esp>
    csrw sscratch, sp
ffffffe0002001e4:	14011073          	csrw	sscratch,sp
    addi sp, t0, 0
ffffffe0002001e8:	00028113          	mv	sp,t0

ffffffe0002001ec <_esp>:
_esp:
    sret
ffffffe0002001ec:	10200073          	sret

ffffffe0002001f0 <__dummy>:
    # 4. return from trap

    .extern dummy
    .globl __dummy
__dummy:
    csrr a0, sscratch
ffffffe0002001f0:	14002573          	csrr	a0,sscratch
    csrw sscratch, sp
ffffffe0002001f4:	14011073          	csrw	sscratch,sp
    addi sp, a0, 0          # change sp from kernel to user
ffffffe0002001f8:	00050113          	mv	sp,a0
    sret
ffffffe0002001fc:	10200073          	sret

ffffffe000200200 <__switch_to>:

    .globl __switch_to
__switch_to:

    sd ra, 32(a0)   # addr of ra_prev
ffffffe000200200:	02153023          	sd	ra,32(a0)
    sd sp, 40(a0)   # addr of sp_prev
ffffffe000200204:	02253423          	sd	sp,40(a0)
    sd s0, 48(a0)   # addr of s0_prev to s11_prev
ffffffe000200208:	02853823          	sd	s0,48(a0)
    sd s1, 56(a0)
ffffffe00020020c:	02953c23          	sd	s1,56(a0)
    sd s2, 64(a0)
ffffffe000200210:	05253023          	sd	s2,64(a0)
    sd s3, 72(a0)
ffffffe000200214:	05353423          	sd	s3,72(a0)
    sd s4, 80(a0)
ffffffe000200218:	05453823          	sd	s4,80(a0)
    sd s5, 88(a0)
ffffffe00020021c:	05553c23          	sd	s5,88(a0)
    sd s6, 96(a0)
ffffffe000200220:	07653023          	sd	s6,96(a0)
    sd s7, 104(a0)
ffffffe000200224:	07753423          	sd	s7,104(a0)
    sd s8, 112(a0)
ffffffe000200228:	07853823          	sd	s8,112(a0)
    sd s9, 120(a0)
ffffffe00020022c:	07953c23          	sd	s9,120(a0)
    sd s10, 128(a0)
ffffffe000200230:	09a53023          	sd	s10,128(a0)
    sd s11, 136(a0)
ffffffe000200234:	09b53423          	sd	s11,136(a0)
    csrr a2, sepc
ffffffe000200238:	14102673          	csrr	a2,sepc
    sd a2, 144(a0)
ffffffe00020023c:	08c53823          	sd	a2,144(a0)
    csrr a2, sstatus
ffffffe000200240:	10002673          	csrr	a2,sstatus
    sd a2, 152(a0)
ffffffe000200244:	08c53c23          	sd	a2,152(a0)
    csrr a2, sscratch
ffffffe000200248:	14002673          	csrr	a2,sscratch
    sd a2, 160(a0)
ffffffe00020024c:	0ac53023          	sd	a2,160(a0)

    ld ra, 32(a1)   # addr of ra_next
ffffffe000200250:	0205b083          	ld	ra,32(a1)
    ld sp, 40(a1)   # addr of sp_next
ffffffe000200254:	0285b103          	ld	sp,40(a1)
    ld s0, 48(a1)   # addr of s0_next to s11_next
ffffffe000200258:	0305b403          	ld	s0,48(a1)
    ld s1, 56(a1)
ffffffe00020025c:	0385b483          	ld	s1,56(a1)
    ld s2, 64(a1)
ffffffe000200260:	0405b903          	ld	s2,64(a1)
    ld s3, 72(a1)
ffffffe000200264:	0485b983          	ld	s3,72(a1)
    ld s4, 80(a1)
ffffffe000200268:	0505ba03          	ld	s4,80(a1)
    ld s5, 88(a1)
ffffffe00020026c:	0585ba83          	ld	s5,88(a1)
    ld s6, 96(a1)
ffffffe000200270:	0605bb03          	ld	s6,96(a1)
    ld s7, 104(a1)
ffffffe000200274:	0685bb83          	ld	s7,104(a1)
    ld s8, 112(a1)
ffffffe000200278:	0705bc03          	ld	s8,112(a1)
    ld s9, 120(a1)
ffffffe00020027c:	0785bc83          	ld	s9,120(a1)
    ld s10, 128(a1)
ffffffe000200280:	0805bd03          	ld	s10,128(a1)
    ld s11, 136(a1)
ffffffe000200284:	0885bd83          	ld	s11,136(a1)
    ld a2, 144(a1)
ffffffe000200288:	0905b603          	ld	a2,144(a1)
    csrw sepc, a2
ffffffe00020028c:	14161073          	csrw	sepc,a2
    ld a2, 152(a1)
ffffffe000200290:	0985b603          	ld	a2,152(a1)
    csrw sstatus, a2
ffffffe000200294:	10061073          	csrw	sstatus,a2
    ld a2, 160(a1)
ffffffe000200298:	0a05b603          	ld	a2,160(a1)
    csrw sscratch, a2
ffffffe00020029c:	14061073          	csrw	sscratch,a2
    ld a2, 168(a1)
ffffffe0002002a0:	0a85b603          	ld	a2,168(a1)

    li a3, 0xffffffdf80000000
ffffffe0002002a4:	fbf0069b          	addiw	a3,zero,-65
ffffffe0002002a8:	01f69693          	slli	a3,a3,0x1f
    sub a2, a2, a3
ffffffe0002002ac:	40d60633          	sub	a2,a2,a3
    srli a2, a2, 12
ffffffe0002002b0:	00c65613          	srli	a2,a2,0xc
    li a3, 0x8000000000000000
ffffffe0002002b4:	fff0069b          	addiw	a3,zero,-1
ffffffe0002002b8:	03f69693          	slli	a3,a3,0x3f
    or a2, a2, a3 
ffffffe0002002bc:	00d66633          	or	a2,a2,a3
    csrw satp, a2
ffffffe0002002c0:	18061073          	csrw	satp,a2
    sfence.vma zero, zero
ffffffe0002002c4:	12000073          	sfence.vma

    # save state to prev process
    # restore state from next process

    ret
ffffffe0002002c8:	00008067          	ret

ffffffe0002002cc <get_cycles>:
#include "sbi.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
ffffffe0002002cc:	fe010113          	addi	sp,sp,-32
ffffffe0002002d0:	00113c23          	sd	ra,24(sp)
ffffffe0002002d4:	00813823          	sd	s0,16(sp)
ffffffe0002002d8:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t mtime = 0;
ffffffe0002002dc:	fe043423          	sd	zero,-24(s0)
    asm volatile (
ffffffe0002002e0:	c01027f3          	rdtime	a5
ffffffe0002002e4:	fef43423          	sd	a5,-24(s0)
        "rdtime %[mtime]\n"
        : [mtime] "=r"(mtime)
        :
        : "memory"
    );
    return mtime;
ffffffe0002002e8:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002002ec:	00078513          	mv	a0,a5
ffffffe0002002f0:	01813083          	ld	ra,24(sp)
ffffffe0002002f4:	01013403          	ld	s0,16(sp)
ffffffe0002002f8:	02010113          	addi	sp,sp,32
ffffffe0002002fc:	00008067          	ret

ffffffe000200300 <clock_set_next_event>:

void clock_set_next_event() {
ffffffe000200300:	fd010113          	addi	sp,sp,-48
ffffffe000200304:	02113423          	sd	ra,40(sp)
ffffffe000200308:	02813023          	sd	s0,32(sp)
ffffffe00020030c:	03010413          	addi	s0,sp,48

    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe000200310:	fbdff0ef          	jal	ffffffe0002002cc <get_cycles>
ffffffe000200314:	00050713          	mv	a4,a0
ffffffe000200318:	00005797          	auipc	a5,0x5
ffffffe00020031c:	ce878793          	addi	a5,a5,-792 # ffffffe000205000 <TIMECLOCK>
ffffffe000200320:	0007b783          	ld	a5,0(a5)
ffffffe000200324:	00f707b3          	add	a5,a4,a5
ffffffe000200328:	fef43423          	sd	a5,-24(s0)
    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    struct sbiret res;
    res = sbi_set_timer(next);
ffffffe00020032c:	fe843503          	ld	a0,-24(s0)
ffffffe000200330:	2d8010ef          	jal	ffffffe000201608 <sbi_set_timer>
ffffffe000200334:	00050713          	mv	a4,a0
ffffffe000200338:	00058793          	mv	a5,a1
ffffffe00020033c:	fce43c23          	sd	a4,-40(s0)
ffffffe000200340:	fef43023          	sd	a5,-32(s0)
    if (res.error)
ffffffe000200344:	fd843783          	ld	a5,-40(s0)
ffffffe000200348:	00078a63          	beqz	a5,ffffffe00020035c <clock_set_next_event+0x5c>
        printk("bad\n");
ffffffe00020034c:	00004517          	auipc	a0,0x4
ffffffe000200350:	cb450513          	addi	a0,a0,-844 # ffffffe000204000 <_srodata>
ffffffe000200354:	3f0030ef          	jal	ffffffe000203744 <printk>
    return;
ffffffe000200358:	00000013          	nop
ffffffe00020035c:	00000013          	nop
    //     :
    //     :
    //     : "memory"
    // );

ffffffe000200360:	02813083          	ld	ra,40(sp)
ffffffe000200364:	02013403          	ld	s0,32(sp)
ffffffe000200368:	03010113          	addi	sp,sp,48
ffffffe00020036c:	00008067          	ret

ffffffe000200370 <fixsize>:
#define MAX(a, b) ((a) > (b) ? (a) : (b))

void *free_page_start = &_ekernel;
struct buddy buddy;

static uint64_t fixsize(uint64_t size) {
ffffffe000200370:	fe010113          	addi	sp,sp,-32
ffffffe000200374:	00113c23          	sd	ra,24(sp)
ffffffe000200378:	00813823          	sd	s0,16(sp)
ffffffe00020037c:	02010413          	addi	s0,sp,32
ffffffe000200380:	fea43423          	sd	a0,-24(s0)
    size --;
ffffffe000200384:	fe843783          	ld	a5,-24(s0)
ffffffe000200388:	fff78793          	addi	a5,a5,-1
ffffffe00020038c:	fef43423          	sd	a5,-24(s0)
    size |= size >> 1;
ffffffe000200390:	fe843783          	ld	a5,-24(s0)
ffffffe000200394:	0017d793          	srli	a5,a5,0x1
ffffffe000200398:	fe843703          	ld	a4,-24(s0)
ffffffe00020039c:	00f767b3          	or	a5,a4,a5
ffffffe0002003a0:	fef43423          	sd	a5,-24(s0)
    size |= size >> 2;
ffffffe0002003a4:	fe843783          	ld	a5,-24(s0)
ffffffe0002003a8:	0027d793          	srli	a5,a5,0x2
ffffffe0002003ac:	fe843703          	ld	a4,-24(s0)
ffffffe0002003b0:	00f767b3          	or	a5,a4,a5
ffffffe0002003b4:	fef43423          	sd	a5,-24(s0)
    size |= size >> 4;
ffffffe0002003b8:	fe843783          	ld	a5,-24(s0)
ffffffe0002003bc:	0047d793          	srli	a5,a5,0x4
ffffffe0002003c0:	fe843703          	ld	a4,-24(s0)
ffffffe0002003c4:	00f767b3          	or	a5,a4,a5
ffffffe0002003c8:	fef43423          	sd	a5,-24(s0)
    size |= size >> 8;
ffffffe0002003cc:	fe843783          	ld	a5,-24(s0)
ffffffe0002003d0:	0087d793          	srli	a5,a5,0x8
ffffffe0002003d4:	fe843703          	ld	a4,-24(s0)
ffffffe0002003d8:	00f767b3          	or	a5,a4,a5
ffffffe0002003dc:	fef43423          	sd	a5,-24(s0)
    size |= size >> 16;
ffffffe0002003e0:	fe843783          	ld	a5,-24(s0)
ffffffe0002003e4:	0107d793          	srli	a5,a5,0x10
ffffffe0002003e8:	fe843703          	ld	a4,-24(s0)
ffffffe0002003ec:	00f767b3          	or	a5,a4,a5
ffffffe0002003f0:	fef43423          	sd	a5,-24(s0)
    size |= size >> 32;
ffffffe0002003f4:	fe843783          	ld	a5,-24(s0)
ffffffe0002003f8:	0207d793          	srli	a5,a5,0x20
ffffffe0002003fc:	fe843703          	ld	a4,-24(s0)
ffffffe000200400:	00f767b3          	or	a5,a4,a5
ffffffe000200404:	fef43423          	sd	a5,-24(s0)
    return size + 1;
ffffffe000200408:	fe843783          	ld	a5,-24(s0)
ffffffe00020040c:	00178793          	addi	a5,a5,1
}
ffffffe000200410:	00078513          	mv	a0,a5
ffffffe000200414:	01813083          	ld	ra,24(sp)
ffffffe000200418:	01013403          	ld	s0,16(sp)
ffffffe00020041c:	02010113          	addi	sp,sp,32
ffffffe000200420:	00008067          	ret

ffffffe000200424 <buddy_init>:

void buddy_init() {
ffffffe000200424:	fd010113          	addi	sp,sp,-48
ffffffe000200428:	02113423          	sd	ra,40(sp)
ffffffe00020042c:	02813023          	sd	s0,32(sp)
ffffffe000200430:	03010413          	addi	s0,sp,48
    uint64_t buddy_size = (uint64_t)PHY_SIZE / PGSIZE;
ffffffe000200434:	000087b7          	lui	a5,0x8
ffffffe000200438:	fef43423          	sd	a5,-24(s0)

    if (!IS_POWER_OF_2(buddy_size))
ffffffe00020043c:	fe843783          	ld	a5,-24(s0)
ffffffe000200440:	fff78713          	addi	a4,a5,-1 # 7fff <PGSIZE+0x6fff>
ffffffe000200444:	fe843783          	ld	a5,-24(s0)
ffffffe000200448:	00f777b3          	and	a5,a4,a5
ffffffe00020044c:	00078863          	beqz	a5,ffffffe00020045c <buddy_init+0x38>
        buddy_size = fixsize(buddy_size);
ffffffe000200450:	fe843503          	ld	a0,-24(s0)
ffffffe000200454:	f1dff0ef          	jal	ffffffe000200370 <fixsize>
ffffffe000200458:	fea43423          	sd	a0,-24(s0)

    buddy.size = buddy_size;
ffffffe00020045c:	00009797          	auipc	a5,0x9
ffffffe000200460:	bcc78793          	addi	a5,a5,-1076 # ffffffe000209028 <buddy>
ffffffe000200464:	fe843703          	ld	a4,-24(s0)
ffffffe000200468:	00e7b023          	sd	a4,0(a5)
    buddy.bitmap = free_page_start;
ffffffe00020046c:	00005797          	auipc	a5,0x5
ffffffe000200470:	b9c78793          	addi	a5,a5,-1124 # ffffffe000205008 <free_page_start>
ffffffe000200474:	0007b703          	ld	a4,0(a5)
ffffffe000200478:	00009797          	auipc	a5,0x9
ffffffe00020047c:	bb078793          	addi	a5,a5,-1104 # ffffffe000209028 <buddy>
ffffffe000200480:	00e7b423          	sd	a4,8(a5)
    free_page_start += 2 * buddy.size * sizeof(*buddy.bitmap);
ffffffe000200484:	00005797          	auipc	a5,0x5
ffffffe000200488:	b8478793          	addi	a5,a5,-1148 # ffffffe000205008 <free_page_start>
ffffffe00020048c:	0007b703          	ld	a4,0(a5)
ffffffe000200490:	00009797          	auipc	a5,0x9
ffffffe000200494:	b9878793          	addi	a5,a5,-1128 # ffffffe000209028 <buddy>
ffffffe000200498:	0007b783          	ld	a5,0(a5)
ffffffe00020049c:	00479793          	slli	a5,a5,0x4
ffffffe0002004a0:	00f70733          	add	a4,a4,a5
ffffffe0002004a4:	00005797          	auipc	a5,0x5
ffffffe0002004a8:	b6478793          	addi	a5,a5,-1180 # ffffffe000205008 <free_page_start>
ffffffe0002004ac:	00e7b023          	sd	a4,0(a5)
    memset(buddy.bitmap, 0, 2 * buddy.size * sizeof(*buddy.bitmap));
ffffffe0002004b0:	00009797          	auipc	a5,0x9
ffffffe0002004b4:	b7878793          	addi	a5,a5,-1160 # ffffffe000209028 <buddy>
ffffffe0002004b8:	0087b703          	ld	a4,8(a5)
ffffffe0002004bc:	00009797          	auipc	a5,0x9
ffffffe0002004c0:	b6c78793          	addi	a5,a5,-1172 # ffffffe000209028 <buddy>
ffffffe0002004c4:	0007b783          	ld	a5,0(a5)
ffffffe0002004c8:	00479793          	slli	a5,a5,0x4
ffffffe0002004cc:	00078613          	mv	a2,a5
ffffffe0002004d0:	00000593          	li	a1,0
ffffffe0002004d4:	00070513          	mv	a0,a4
ffffffe0002004d8:	39c030ef          	jal	ffffffe000203874 <memset>

    uint64_t node_size = buddy.size * 2;
ffffffe0002004dc:	00009797          	auipc	a5,0x9
ffffffe0002004e0:	b4c78793          	addi	a5,a5,-1204 # ffffffe000209028 <buddy>
ffffffe0002004e4:	0007b783          	ld	a5,0(a5)
ffffffe0002004e8:	00179793          	slli	a5,a5,0x1
ffffffe0002004ec:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe0002004f0:	fc043c23          	sd	zero,-40(s0)
ffffffe0002004f4:	0500006f          	j	ffffffe000200544 <buddy_init+0x120>
        if (IS_POWER_OF_2(i + 1))
ffffffe0002004f8:	fd843783          	ld	a5,-40(s0)
ffffffe0002004fc:	00178713          	addi	a4,a5,1
ffffffe000200500:	fd843783          	ld	a5,-40(s0)
ffffffe000200504:	00f777b3          	and	a5,a4,a5
ffffffe000200508:	00079863          	bnez	a5,ffffffe000200518 <buddy_init+0xf4>
            node_size /= 2;
ffffffe00020050c:	fe043783          	ld	a5,-32(s0)
ffffffe000200510:	0017d793          	srli	a5,a5,0x1
ffffffe000200514:	fef43023          	sd	a5,-32(s0)
        buddy.bitmap[i] = node_size;
ffffffe000200518:	00009797          	auipc	a5,0x9
ffffffe00020051c:	b1078793          	addi	a5,a5,-1264 # ffffffe000209028 <buddy>
ffffffe000200520:	0087b703          	ld	a4,8(a5)
ffffffe000200524:	fd843783          	ld	a5,-40(s0)
ffffffe000200528:	00379793          	slli	a5,a5,0x3
ffffffe00020052c:	00f707b3          	add	a5,a4,a5
ffffffe000200530:	fe043703          	ld	a4,-32(s0)
ffffffe000200534:	00e7b023          	sd	a4,0(a5)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe000200538:	fd843783          	ld	a5,-40(s0)
ffffffe00020053c:	00178793          	addi	a5,a5,1
ffffffe000200540:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200544:	00009797          	auipc	a5,0x9
ffffffe000200548:	ae478793          	addi	a5,a5,-1308 # ffffffe000209028 <buddy>
ffffffe00020054c:	0007b783          	ld	a5,0(a5)
ffffffe000200550:	00179793          	slli	a5,a5,0x1
ffffffe000200554:	fff78793          	addi	a5,a5,-1
ffffffe000200558:	fd843703          	ld	a4,-40(s0)
ffffffe00020055c:	f8f76ee3          	bltu	a4,a5,ffffffe0002004f8 <buddy_init+0xd4>
    }

    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe000200560:	fc043823          	sd	zero,-48(s0)
ffffffe000200564:	0180006f          	j	ffffffe00020057c <buddy_init+0x158>
        buddy_alloc(1);
ffffffe000200568:	00100513          	li	a0,1
ffffffe00020056c:	204000ef          	jal	ffffffe000200770 <buddy_alloc>
    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe000200570:	fd043783          	ld	a5,-48(s0)
ffffffe000200574:	00178793          	addi	a5,a5,1
ffffffe000200578:	fcf43823          	sd	a5,-48(s0)
ffffffe00020057c:	fd043783          	ld	a5,-48(s0)
ffffffe000200580:	00c79713          	slli	a4,a5,0xc
ffffffe000200584:	00100793          	li	a5,1
ffffffe000200588:	01f79793          	slli	a5,a5,0x1f
ffffffe00020058c:	00f70733          	add	a4,a4,a5
ffffffe000200590:	00005797          	auipc	a5,0x5
ffffffe000200594:	a7878793          	addi	a5,a5,-1416 # ffffffe000205008 <free_page_start>
ffffffe000200598:	0007b783          	ld	a5,0(a5)
ffffffe00020059c:	00078693          	mv	a3,a5
ffffffe0002005a0:	04100793          	li	a5,65
ffffffe0002005a4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002005a8:	00f687b3          	add	a5,a3,a5
ffffffe0002005ac:	faf76ee3          	bltu	a4,a5,ffffffe000200568 <buddy_init+0x144>
    }

    printk("...buddy_init done!\n");
ffffffe0002005b0:	00004517          	auipc	a0,0x4
ffffffe0002005b4:	a5850513          	addi	a0,a0,-1448 # ffffffe000204008 <_srodata+0x8>
ffffffe0002005b8:	18c030ef          	jal	ffffffe000203744 <printk>
    return;
ffffffe0002005bc:	00000013          	nop
}
ffffffe0002005c0:	02813083          	ld	ra,40(sp)
ffffffe0002005c4:	02013403          	ld	s0,32(sp)
ffffffe0002005c8:	03010113          	addi	sp,sp,48
ffffffe0002005cc:	00008067          	ret

ffffffe0002005d0 <buddy_free>:

void buddy_free(uint64_t pfn) {
ffffffe0002005d0:	fc010113          	addi	sp,sp,-64
ffffffe0002005d4:	02113c23          	sd	ra,56(sp)
ffffffe0002005d8:	02813823          	sd	s0,48(sp)
ffffffe0002005dc:	04010413          	addi	s0,sp,64
ffffffe0002005e0:	fca43423          	sd	a0,-56(s0)
    uint64_t node_size, index = 0;
ffffffe0002005e4:	fe043023          	sd	zero,-32(s0)
    uint64_t left_longest, right_longest;

    node_size = 1;
ffffffe0002005e8:	00100793          	li	a5,1
ffffffe0002005ec:	fef43423          	sd	a5,-24(s0)
    index = pfn + buddy.size - 1;
ffffffe0002005f0:	00009797          	auipc	a5,0x9
ffffffe0002005f4:	a3878793          	addi	a5,a5,-1480 # ffffffe000209028 <buddy>
ffffffe0002005f8:	0007b703          	ld	a4,0(a5)
ffffffe0002005fc:	fc843783          	ld	a5,-56(s0)
ffffffe000200600:	00f707b3          	add	a5,a4,a5
ffffffe000200604:	fff78793          	addi	a5,a5,-1
ffffffe000200608:	fef43023          	sd	a5,-32(s0)

    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe00020060c:	02c0006f          	j	ffffffe000200638 <buddy_free+0x68>
        node_size *= 2;
ffffffe000200610:	fe843783          	ld	a5,-24(s0)
ffffffe000200614:	00179793          	slli	a5,a5,0x1
ffffffe000200618:	fef43423          	sd	a5,-24(s0)
        if (index == 0)
ffffffe00020061c:	fe043783          	ld	a5,-32(s0)
ffffffe000200620:	02078e63          	beqz	a5,ffffffe00020065c <buddy_free+0x8c>
    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe000200624:	fe043783          	ld	a5,-32(s0)
ffffffe000200628:	00178793          	addi	a5,a5,1
ffffffe00020062c:	0017d793          	srli	a5,a5,0x1
ffffffe000200630:	fff78793          	addi	a5,a5,-1
ffffffe000200634:	fef43023          	sd	a5,-32(s0)
ffffffe000200638:	00009797          	auipc	a5,0x9
ffffffe00020063c:	9f078793          	addi	a5,a5,-1552 # ffffffe000209028 <buddy>
ffffffe000200640:	0087b703          	ld	a4,8(a5)
ffffffe000200644:	fe043783          	ld	a5,-32(s0)
ffffffe000200648:	00379793          	slli	a5,a5,0x3
ffffffe00020064c:	00f707b3          	add	a5,a4,a5
ffffffe000200650:	0007b783          	ld	a5,0(a5)
ffffffe000200654:	fa079ee3          	bnez	a5,ffffffe000200610 <buddy_free+0x40>
ffffffe000200658:	0080006f          	j	ffffffe000200660 <buddy_free+0x90>
            break;
ffffffe00020065c:	00000013          	nop
    }

    buddy.bitmap[index] = node_size;
ffffffe000200660:	00009797          	auipc	a5,0x9
ffffffe000200664:	9c878793          	addi	a5,a5,-1592 # ffffffe000209028 <buddy>
ffffffe000200668:	0087b703          	ld	a4,8(a5)
ffffffe00020066c:	fe043783          	ld	a5,-32(s0)
ffffffe000200670:	00379793          	slli	a5,a5,0x3
ffffffe000200674:	00f707b3          	add	a5,a4,a5
ffffffe000200678:	fe843703          	ld	a4,-24(s0)
ffffffe00020067c:	00e7b023          	sd	a4,0(a5)

    while (index) {
ffffffe000200680:	0d00006f          	j	ffffffe000200750 <buddy_free+0x180>
        index = PARENT(index);
ffffffe000200684:	fe043783          	ld	a5,-32(s0)
ffffffe000200688:	00178793          	addi	a5,a5,1
ffffffe00020068c:	0017d793          	srli	a5,a5,0x1
ffffffe000200690:	fff78793          	addi	a5,a5,-1
ffffffe000200694:	fef43023          	sd	a5,-32(s0)
        node_size *= 2;
ffffffe000200698:	fe843783          	ld	a5,-24(s0)
ffffffe00020069c:	00179793          	slli	a5,a5,0x1
ffffffe0002006a0:	fef43423          	sd	a5,-24(s0)

        left_longest = buddy.bitmap[LEFT_LEAF(index)];
ffffffe0002006a4:	00009797          	auipc	a5,0x9
ffffffe0002006a8:	98478793          	addi	a5,a5,-1660 # ffffffe000209028 <buddy>
ffffffe0002006ac:	0087b703          	ld	a4,8(a5)
ffffffe0002006b0:	fe043783          	ld	a5,-32(s0)
ffffffe0002006b4:	00479793          	slli	a5,a5,0x4
ffffffe0002006b8:	00878793          	addi	a5,a5,8
ffffffe0002006bc:	00f707b3          	add	a5,a4,a5
ffffffe0002006c0:	0007b783          	ld	a5,0(a5)
ffffffe0002006c4:	fcf43c23          	sd	a5,-40(s0)
        right_longest = buddy.bitmap[RIGHT_LEAF(index)];
ffffffe0002006c8:	00009797          	auipc	a5,0x9
ffffffe0002006cc:	96078793          	addi	a5,a5,-1696 # ffffffe000209028 <buddy>
ffffffe0002006d0:	0087b703          	ld	a4,8(a5)
ffffffe0002006d4:	fe043783          	ld	a5,-32(s0)
ffffffe0002006d8:	00178793          	addi	a5,a5,1
ffffffe0002006dc:	00479793          	slli	a5,a5,0x4
ffffffe0002006e0:	00f707b3          	add	a5,a4,a5
ffffffe0002006e4:	0007b783          	ld	a5,0(a5)
ffffffe0002006e8:	fcf43823          	sd	a5,-48(s0)

        if (left_longest + right_longest == node_size) 
ffffffe0002006ec:	fd843703          	ld	a4,-40(s0)
ffffffe0002006f0:	fd043783          	ld	a5,-48(s0)
ffffffe0002006f4:	00f707b3          	add	a5,a4,a5
ffffffe0002006f8:	fe843703          	ld	a4,-24(s0)
ffffffe0002006fc:	02f71463          	bne	a4,a5,ffffffe000200724 <buddy_free+0x154>
            buddy.bitmap[index] = node_size;
ffffffe000200700:	00009797          	auipc	a5,0x9
ffffffe000200704:	92878793          	addi	a5,a5,-1752 # ffffffe000209028 <buddy>
ffffffe000200708:	0087b703          	ld	a4,8(a5)
ffffffe00020070c:	fe043783          	ld	a5,-32(s0)
ffffffe000200710:	00379793          	slli	a5,a5,0x3
ffffffe000200714:	00f707b3          	add	a5,a4,a5
ffffffe000200718:	fe843703          	ld	a4,-24(s0)
ffffffe00020071c:	00e7b023          	sd	a4,0(a5)
ffffffe000200720:	0300006f          	j	ffffffe000200750 <buddy_free+0x180>
        else
            buddy.bitmap[index] = MAX(left_longest, right_longest);
ffffffe000200724:	00009797          	auipc	a5,0x9
ffffffe000200728:	90478793          	addi	a5,a5,-1788 # ffffffe000209028 <buddy>
ffffffe00020072c:	0087b703          	ld	a4,8(a5)
ffffffe000200730:	fe043783          	ld	a5,-32(s0)
ffffffe000200734:	00379793          	slli	a5,a5,0x3
ffffffe000200738:	00f706b3          	add	a3,a4,a5
ffffffe00020073c:	fd843703          	ld	a4,-40(s0)
ffffffe000200740:	fd043783          	ld	a5,-48(s0)
ffffffe000200744:	00e7f463          	bgeu	a5,a4,ffffffe00020074c <buddy_free+0x17c>
ffffffe000200748:	00070793          	mv	a5,a4
ffffffe00020074c:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe000200750:	fe043783          	ld	a5,-32(s0)
ffffffe000200754:	f20798e3          	bnez	a5,ffffffe000200684 <buddy_free+0xb4>
    }
}
ffffffe000200758:	00000013          	nop
ffffffe00020075c:	00000013          	nop
ffffffe000200760:	03813083          	ld	ra,56(sp)
ffffffe000200764:	03013403          	ld	s0,48(sp)
ffffffe000200768:	04010113          	addi	sp,sp,64
ffffffe00020076c:	00008067          	ret

ffffffe000200770 <buddy_alloc>:

uint64_t buddy_alloc(uint64_t nrpages) {
ffffffe000200770:	fc010113          	addi	sp,sp,-64
ffffffe000200774:	02113c23          	sd	ra,56(sp)
ffffffe000200778:	02813823          	sd	s0,48(sp)
ffffffe00020077c:	04010413          	addi	s0,sp,64
ffffffe000200780:	fca43423          	sd	a0,-56(s0)
    uint64_t index = 0;
ffffffe000200784:	fe043423          	sd	zero,-24(s0)
    uint64_t node_size;
    uint64_t pfn = 0;
ffffffe000200788:	fc043c23          	sd	zero,-40(s0)

    if (nrpages <= 0)
ffffffe00020078c:	fc843783          	ld	a5,-56(s0)
ffffffe000200790:	00079863          	bnez	a5,ffffffe0002007a0 <buddy_alloc+0x30>
        nrpages = 1;
ffffffe000200794:	00100793          	li	a5,1
ffffffe000200798:	fcf43423          	sd	a5,-56(s0)
ffffffe00020079c:	0240006f          	j	ffffffe0002007c0 <buddy_alloc+0x50>
    else if (!IS_POWER_OF_2(nrpages))
ffffffe0002007a0:	fc843783          	ld	a5,-56(s0)
ffffffe0002007a4:	fff78713          	addi	a4,a5,-1
ffffffe0002007a8:	fc843783          	ld	a5,-56(s0)
ffffffe0002007ac:	00f777b3          	and	a5,a4,a5
ffffffe0002007b0:	00078863          	beqz	a5,ffffffe0002007c0 <buddy_alloc+0x50>
        nrpages = fixsize(nrpages);
ffffffe0002007b4:	fc843503          	ld	a0,-56(s0)
ffffffe0002007b8:	bb9ff0ef          	jal	ffffffe000200370 <fixsize>
ffffffe0002007bc:	fca43423          	sd	a0,-56(s0)

    if (buddy.bitmap[index] < nrpages)
ffffffe0002007c0:	00009797          	auipc	a5,0x9
ffffffe0002007c4:	86878793          	addi	a5,a5,-1944 # ffffffe000209028 <buddy>
ffffffe0002007c8:	0087b703          	ld	a4,8(a5)
ffffffe0002007cc:	fe843783          	ld	a5,-24(s0)
ffffffe0002007d0:	00379793          	slli	a5,a5,0x3
ffffffe0002007d4:	00f707b3          	add	a5,a4,a5
ffffffe0002007d8:	0007b783          	ld	a5,0(a5)
ffffffe0002007dc:	fc843703          	ld	a4,-56(s0)
ffffffe0002007e0:	00e7f663          	bgeu	a5,a4,ffffffe0002007ec <buddy_alloc+0x7c>
        return 0;
ffffffe0002007e4:	00000793          	li	a5,0
ffffffe0002007e8:	1480006f          	j	ffffffe000200930 <buddy_alloc+0x1c0>

    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe0002007ec:	00009797          	auipc	a5,0x9
ffffffe0002007f0:	83c78793          	addi	a5,a5,-1988 # ffffffe000209028 <buddy>
ffffffe0002007f4:	0007b783          	ld	a5,0(a5)
ffffffe0002007f8:	fef43023          	sd	a5,-32(s0)
ffffffe0002007fc:	05c0006f          	j	ffffffe000200858 <buddy_alloc+0xe8>
        if (buddy.bitmap[LEFT_LEAF(index)] >= nrpages)
ffffffe000200800:	00009797          	auipc	a5,0x9
ffffffe000200804:	82878793          	addi	a5,a5,-2008 # ffffffe000209028 <buddy>
ffffffe000200808:	0087b703          	ld	a4,8(a5)
ffffffe00020080c:	fe843783          	ld	a5,-24(s0)
ffffffe000200810:	00479793          	slli	a5,a5,0x4
ffffffe000200814:	00878793          	addi	a5,a5,8
ffffffe000200818:	00f707b3          	add	a5,a4,a5
ffffffe00020081c:	0007b783          	ld	a5,0(a5)
ffffffe000200820:	fc843703          	ld	a4,-56(s0)
ffffffe000200824:	00e7ec63          	bltu	a5,a4,ffffffe00020083c <buddy_alloc+0xcc>
            index = LEFT_LEAF(index);
ffffffe000200828:	fe843783          	ld	a5,-24(s0)
ffffffe00020082c:	00179793          	slli	a5,a5,0x1
ffffffe000200830:	00178793          	addi	a5,a5,1
ffffffe000200834:	fef43423          	sd	a5,-24(s0)
ffffffe000200838:	0140006f          	j	ffffffe00020084c <buddy_alloc+0xdc>
        else
            index = RIGHT_LEAF(index);
ffffffe00020083c:	fe843783          	ld	a5,-24(s0)
ffffffe000200840:	00178793          	addi	a5,a5,1
ffffffe000200844:	00179793          	slli	a5,a5,0x1
ffffffe000200848:	fef43423          	sd	a5,-24(s0)
    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe00020084c:	fe043783          	ld	a5,-32(s0)
ffffffe000200850:	0017d793          	srli	a5,a5,0x1
ffffffe000200854:	fef43023          	sd	a5,-32(s0)
ffffffe000200858:	fe043703          	ld	a4,-32(s0)
ffffffe00020085c:	fc843783          	ld	a5,-56(s0)
ffffffe000200860:	faf710e3          	bne	a4,a5,ffffffe000200800 <buddy_alloc+0x90>
    }

    buddy.bitmap[index] = 0;
ffffffe000200864:	00008797          	auipc	a5,0x8
ffffffe000200868:	7c478793          	addi	a5,a5,1988 # ffffffe000209028 <buddy>
ffffffe00020086c:	0087b703          	ld	a4,8(a5)
ffffffe000200870:	fe843783          	ld	a5,-24(s0)
ffffffe000200874:	00379793          	slli	a5,a5,0x3
ffffffe000200878:	00f707b3          	add	a5,a4,a5
ffffffe00020087c:	0007b023          	sd	zero,0(a5)
    pfn = (index + 1) * node_size - buddy.size;
ffffffe000200880:	fe843783          	ld	a5,-24(s0)
ffffffe000200884:	00178713          	addi	a4,a5,1
ffffffe000200888:	fe043783          	ld	a5,-32(s0)
ffffffe00020088c:	02f70733          	mul	a4,a4,a5
ffffffe000200890:	00008797          	auipc	a5,0x8
ffffffe000200894:	79878793          	addi	a5,a5,1944 # ffffffe000209028 <buddy>
ffffffe000200898:	0007b783          	ld	a5,0(a5)
ffffffe00020089c:	40f707b3          	sub	a5,a4,a5
ffffffe0002008a0:	fcf43c23          	sd	a5,-40(s0)

    while (index) {
ffffffe0002008a4:	0800006f          	j	ffffffe000200924 <buddy_alloc+0x1b4>
        index = PARENT(index);
ffffffe0002008a8:	fe843783          	ld	a5,-24(s0)
ffffffe0002008ac:	00178793          	addi	a5,a5,1
ffffffe0002008b0:	0017d793          	srli	a5,a5,0x1
ffffffe0002008b4:	fff78793          	addi	a5,a5,-1
ffffffe0002008b8:	fef43423          	sd	a5,-24(s0)
        buddy.bitmap[index] = 
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe0002008bc:	00008797          	auipc	a5,0x8
ffffffe0002008c0:	76c78793          	addi	a5,a5,1900 # ffffffe000209028 <buddy>
ffffffe0002008c4:	0087b703          	ld	a4,8(a5)
ffffffe0002008c8:	fe843783          	ld	a5,-24(s0)
ffffffe0002008cc:	00178793          	addi	a5,a5,1
ffffffe0002008d0:	00479793          	slli	a5,a5,0x4
ffffffe0002008d4:	00f707b3          	add	a5,a4,a5
ffffffe0002008d8:	0007b603          	ld	a2,0(a5)
ffffffe0002008dc:	00008797          	auipc	a5,0x8
ffffffe0002008e0:	74c78793          	addi	a5,a5,1868 # ffffffe000209028 <buddy>
ffffffe0002008e4:	0087b703          	ld	a4,8(a5)
ffffffe0002008e8:	fe843783          	ld	a5,-24(s0)
ffffffe0002008ec:	00479793          	slli	a5,a5,0x4
ffffffe0002008f0:	00878793          	addi	a5,a5,8
ffffffe0002008f4:	00f707b3          	add	a5,a4,a5
ffffffe0002008f8:	0007b703          	ld	a4,0(a5)
        buddy.bitmap[index] = 
ffffffe0002008fc:	00008797          	auipc	a5,0x8
ffffffe000200900:	72c78793          	addi	a5,a5,1836 # ffffffe000209028 <buddy>
ffffffe000200904:	0087b683          	ld	a3,8(a5)
ffffffe000200908:	fe843783          	ld	a5,-24(s0)
ffffffe00020090c:	00379793          	slli	a5,a5,0x3
ffffffe000200910:	00f686b3          	add	a3,a3,a5
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe000200914:	00060793          	mv	a5,a2
ffffffe000200918:	00e7f463          	bgeu	a5,a4,ffffffe000200920 <buddy_alloc+0x1b0>
ffffffe00020091c:	00070793          	mv	a5,a4
        buddy.bitmap[index] = 
ffffffe000200920:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe000200924:	fe843783          	ld	a5,-24(s0)
ffffffe000200928:	f80790e3          	bnez	a5,ffffffe0002008a8 <buddy_alloc+0x138>
    }
    
    return pfn;
ffffffe00020092c:	fd843783          	ld	a5,-40(s0)
}
ffffffe000200930:	00078513          	mv	a0,a5
ffffffe000200934:	03813083          	ld	ra,56(sp)
ffffffe000200938:	03013403          	ld	s0,48(sp)
ffffffe00020093c:	04010113          	addi	sp,sp,64
ffffffe000200940:	00008067          	ret

ffffffe000200944 <alloc_pages>:


void *alloc_pages(uint64_t nrpages) {
ffffffe000200944:	fd010113          	addi	sp,sp,-48
ffffffe000200948:	02113423          	sd	ra,40(sp)
ffffffe00020094c:	02813023          	sd	s0,32(sp)
ffffffe000200950:	03010413          	addi	s0,sp,48
ffffffe000200954:	fca43c23          	sd	a0,-40(s0)
    uint64_t pfn = buddy_alloc(nrpages);
ffffffe000200958:	fd843503          	ld	a0,-40(s0)
ffffffe00020095c:	e15ff0ef          	jal	ffffffe000200770 <buddy_alloc>
ffffffe000200960:	fea43423          	sd	a0,-24(s0)
    if (pfn == 0)
ffffffe000200964:	fe843783          	ld	a5,-24(s0)
ffffffe000200968:	00079663          	bnez	a5,ffffffe000200974 <alloc_pages+0x30>
        return 0;
ffffffe00020096c:	00000793          	li	a5,0
ffffffe000200970:	0180006f          	j	ffffffe000200988 <alloc_pages+0x44>
    return (void *)(PA2VA(PFN2PHYS(pfn)));
ffffffe000200974:	fe843783          	ld	a5,-24(s0)
ffffffe000200978:	00c79713          	slli	a4,a5,0xc
ffffffe00020097c:	fff00793          	li	a5,-1
ffffffe000200980:	02579793          	slli	a5,a5,0x25
ffffffe000200984:	00f707b3          	add	a5,a4,a5
}
ffffffe000200988:	00078513          	mv	a0,a5
ffffffe00020098c:	02813083          	ld	ra,40(sp)
ffffffe000200990:	02013403          	ld	s0,32(sp)
ffffffe000200994:	03010113          	addi	sp,sp,48
ffffffe000200998:	00008067          	ret

ffffffe00020099c <alloc_page>:

void *alloc_page() {
ffffffe00020099c:	ff010113          	addi	sp,sp,-16
ffffffe0002009a0:	00113423          	sd	ra,8(sp)
ffffffe0002009a4:	00813023          	sd	s0,0(sp)
ffffffe0002009a8:	01010413          	addi	s0,sp,16
    return alloc_pages(1);
ffffffe0002009ac:	00100513          	li	a0,1
ffffffe0002009b0:	f95ff0ef          	jal	ffffffe000200944 <alloc_pages>
ffffffe0002009b4:	00050793          	mv	a5,a0
}
ffffffe0002009b8:	00078513          	mv	a0,a5
ffffffe0002009bc:	00813083          	ld	ra,8(sp)
ffffffe0002009c0:	00013403          	ld	s0,0(sp)
ffffffe0002009c4:	01010113          	addi	sp,sp,16
ffffffe0002009c8:	00008067          	ret

ffffffe0002009cc <free_pages>:

void free_pages(void *va) {
ffffffe0002009cc:	fe010113          	addi	sp,sp,-32
ffffffe0002009d0:	00113c23          	sd	ra,24(sp)
ffffffe0002009d4:	00813823          	sd	s0,16(sp)
ffffffe0002009d8:	02010413          	addi	s0,sp,32
ffffffe0002009dc:	fea43423          	sd	a0,-24(s0)
    buddy_free(PHYS2PFN(VA2PA((uint64_t)va)));
ffffffe0002009e0:	fe843703          	ld	a4,-24(s0)
ffffffe0002009e4:	00100793          	li	a5,1
ffffffe0002009e8:	02579793          	slli	a5,a5,0x25
ffffffe0002009ec:	00f707b3          	add	a5,a4,a5
ffffffe0002009f0:	00c7d793          	srli	a5,a5,0xc
ffffffe0002009f4:	00078513          	mv	a0,a5
ffffffe0002009f8:	bd9ff0ef          	jal	ffffffe0002005d0 <buddy_free>
}
ffffffe0002009fc:	00000013          	nop
ffffffe000200a00:	01813083          	ld	ra,24(sp)
ffffffe000200a04:	01013403          	ld	s0,16(sp)
ffffffe000200a08:	02010113          	addi	sp,sp,32
ffffffe000200a0c:	00008067          	ret

ffffffe000200a10 <kalloc>:

void *kalloc() {
ffffffe000200a10:	ff010113          	addi	sp,sp,-16
ffffffe000200a14:	00113423          	sd	ra,8(sp)
ffffffe000200a18:	00813023          	sd	s0,0(sp)
ffffffe000200a1c:	01010413          	addi	s0,sp,16
    // r = kmem.freelist;
    // kmem.freelist = r->next;
    
    // memset((void *)r, 0x0, PGSIZE);
    // return (void *)r;
    return alloc_page();
ffffffe000200a20:	f7dff0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000200a24:	00050793          	mv	a5,a0
}
ffffffe000200a28:	00078513          	mv	a0,a5
ffffffe000200a2c:	00813083          	ld	ra,8(sp)
ffffffe000200a30:	00013403          	ld	s0,0(sp)
ffffffe000200a34:	01010113          	addi	sp,sp,16
ffffffe000200a38:	00008067          	ret

ffffffe000200a3c <kfree>:

void kfree(void *addr) {
ffffffe000200a3c:	fe010113          	addi	sp,sp,-32
ffffffe000200a40:	00113c23          	sd	ra,24(sp)
ffffffe000200a44:	00813823          	sd	s0,16(sp)
ffffffe000200a48:	02010413          	addi	s0,sp,32
ffffffe000200a4c:	fea43423          	sd	a0,-24(s0)
    // memset(addr, 0x0, (uint64_t)PGSIZE);

    // r = (struct run *)addr;
    // r->next = kmem.freelist;
    // kmem.freelist = r;
    free_pages(addr);
ffffffe000200a50:	fe843503          	ld	a0,-24(s0)
ffffffe000200a54:	f79ff0ef          	jal	ffffffe0002009cc <free_pages>

    return;
ffffffe000200a58:	00000013          	nop
}
ffffffe000200a5c:	01813083          	ld	ra,24(sp)
ffffffe000200a60:	01013403          	ld	s0,16(sp)
ffffffe000200a64:	02010113          	addi	sp,sp,32
ffffffe000200a68:	00008067          	ret

ffffffe000200a6c <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe000200a6c:	fd010113          	addi	sp,sp,-48
ffffffe000200a70:	02113423          	sd	ra,40(sp)
ffffffe000200a74:	02813023          	sd	s0,32(sp)
ffffffe000200a78:	03010413          	addi	s0,sp,48
ffffffe000200a7c:	fca43c23          	sd	a0,-40(s0)
ffffffe000200a80:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe000200a84:	fd843703          	ld	a4,-40(s0)
ffffffe000200a88:	000017b7          	lui	a5,0x1
ffffffe000200a8c:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200a90:	00f70733          	add	a4,a4,a5
ffffffe000200a94:	fffff7b7          	lui	a5,0xfffff
ffffffe000200a98:	00f777b3          	and	a5,a4,a5
ffffffe000200a9c:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200aa0:	01c0006f          	j	ffffffe000200abc <kfreerange+0x50>
        kfree((void *)addr);
ffffffe000200aa4:	fe843503          	ld	a0,-24(s0)
ffffffe000200aa8:	f95ff0ef          	jal	ffffffe000200a3c <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200aac:	fe843703          	ld	a4,-24(s0)
ffffffe000200ab0:	000017b7          	lui	a5,0x1
ffffffe000200ab4:	00f707b3          	add	a5,a4,a5
ffffffe000200ab8:	fef43423          	sd	a5,-24(s0)
ffffffe000200abc:	fe843703          	ld	a4,-24(s0)
ffffffe000200ac0:	000017b7          	lui	a5,0x1
ffffffe000200ac4:	00f70733          	add	a4,a4,a5
ffffffe000200ac8:	fd043783          	ld	a5,-48(s0)
ffffffe000200acc:	fce7fce3          	bgeu	a5,a4,ffffffe000200aa4 <kfreerange+0x38>
    }
}
ffffffe000200ad0:	00000013          	nop
ffffffe000200ad4:	00000013          	nop
ffffffe000200ad8:	02813083          	ld	ra,40(sp)
ffffffe000200adc:	02013403          	ld	s0,32(sp)
ffffffe000200ae0:	03010113          	addi	sp,sp,48
ffffffe000200ae4:	00008067          	ret

ffffffe000200ae8 <mm_init>:

void mm_init(void) {
ffffffe000200ae8:	ff010113          	addi	sp,sp,-16
ffffffe000200aec:	00113423          	sd	ra,8(sp)
ffffffe000200af0:	00813023          	sd	s0,0(sp)
ffffffe000200af4:	01010413          	addi	s0,sp,16
    // kfreerange(_ekernel, (char *)PHY_END+PA2VA_OFFSET);
    buddy_init();
ffffffe000200af8:	92dff0ef          	jal	ffffffe000200424 <buddy_init>
    printk("...mm_init done!\n");
ffffffe000200afc:	00003517          	auipc	a0,0x3
ffffffe000200b00:	52450513          	addi	a0,a0,1316 # ffffffe000204020 <_srodata+0x20>
ffffffe000200b04:	441020ef          	jal	ffffffe000203744 <printk>
}
ffffffe000200b08:	00000013          	nop
ffffffe000200b0c:	00813083          	ld	ra,8(sp)
ffffffe000200b10:	00013403          	ld	s0,0(sp)
ffffffe000200b14:	01010113          	addi	sp,sp,16
ffffffe000200b18:	00008067          	ret

ffffffe000200b1c <find_vma>:
uint64_t nr_tasks = 1+1;
struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr){
ffffffe000200b1c:	fd010113          	addi	sp,sp,-48
ffffffe000200b20:	02113423          	sd	ra,40(sp)
ffffffe000200b24:	02813023          	sd	s0,32(sp)
ffffffe000200b28:	03010413          	addi	s0,sp,48
ffffffe000200b2c:	fca43c23          	sd	a0,-40(s0)
ffffffe000200b30:	fcb43823          	sd	a1,-48(s0)
    struct vm_area_struct *tmp_vas = mm->mmap;
ffffffe000200b34:	fd843783          	ld	a5,-40(s0)
ffffffe000200b38:	0007b783          	ld	a5,0(a5) # 1000 <PGSIZE>
ffffffe000200b3c:	fef43423          	sd	a5,-24(s0)
    while(tmp_vas != NULL){
ffffffe000200b40:	0380006f          	j	ffffffe000200b78 <find_vma+0x5c>
        if (tmp_vas->vm_start <= addr && addr <= VM_END)
ffffffe000200b44:	fe843783          	ld	a5,-24(s0)
ffffffe000200b48:	0087b783          	ld	a5,8(a5)
ffffffe000200b4c:	fd043703          	ld	a4,-48(s0)
ffffffe000200b50:	00f76e63          	bltu	a4,a5,ffffffe000200b6c <find_vma+0x50>
ffffffe000200b54:	fd043703          	ld	a4,-48(s0)
ffffffe000200b58:	fff00793          	li	a5,-1
ffffffe000200b5c:	02079793          	slli	a5,a5,0x20
ffffffe000200b60:	00e7e663          	bltu	a5,a4,ffffffe000200b6c <find_vma+0x50>
            return tmp_vas;
ffffffe000200b64:	fe843783          	ld	a5,-24(s0)
ffffffe000200b68:	01c0006f          	j	ffffffe000200b84 <find_vma+0x68>
        else
            tmp_vas = tmp_vas->vm_next;
ffffffe000200b6c:	fe843783          	ld	a5,-24(s0)
ffffffe000200b70:	0187b783          	ld	a5,24(a5)
ffffffe000200b74:	fef43423          	sd	a5,-24(s0)
    while(tmp_vas != NULL){
ffffffe000200b78:	fe843783          	ld	a5,-24(s0)
ffffffe000200b7c:	fc0794e3          	bnez	a5,ffffffe000200b44 <find_vma+0x28>
    }
    return NULL;
ffffffe000200b80:	00000793          	li	a5,0
}
ffffffe000200b84:	00078513          	mv	a0,a5
ffffffe000200b88:	02813083          	ld	ra,40(sp)
ffffffe000200b8c:	02013403          	ld	s0,32(sp)
ffffffe000200b90:	03010113          	addi	sp,sp,48
ffffffe000200b94:	00008067          	ret

ffffffe000200b98 <do_mmap>:

uint64_t do_mmap(struct mm_struct *mm, uint64_t addr, uint64_t len, uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags){
ffffffe000200b98:	fb010113          	addi	sp,sp,-80
ffffffe000200b9c:	04113423          	sd	ra,72(sp)
ffffffe000200ba0:	04813023          	sd	s0,64(sp)
ffffffe000200ba4:	05010413          	addi	s0,sp,80
ffffffe000200ba8:	fca43c23          	sd	a0,-40(s0)
ffffffe000200bac:	fcb43823          	sd	a1,-48(s0)
ffffffe000200bb0:	fcc43423          	sd	a2,-56(s0)
ffffffe000200bb4:	fcd43023          	sd	a3,-64(s0)
ffffffe000200bb8:	fae43c23          	sd	a4,-72(s0)
ffffffe000200bbc:	faf43823          	sd	a5,-80(s0)
    struct vm_area_struct *new_vas = alloc_page();
ffffffe000200bc0:	dddff0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000200bc4:	fea43423          	sd	a0,-24(s0)
    memset(new_vas, 0, PGSIZE);
ffffffe000200bc8:	00001637          	lui	a2,0x1
ffffffe000200bcc:	00000593          	li	a1,0
ffffffe000200bd0:	fe843503          	ld	a0,-24(s0)
ffffffe000200bd4:	4a1020ef          	jal	ffffffe000203874 <memset>
    // for (uint64_t i = 0; i < PGSIZE; i++)   *((char*)new_vas + i) = 0; 
    new_vas->vm_mm = mm;
ffffffe000200bd8:	fe843783          	ld	a5,-24(s0)
ffffffe000200bdc:	fd843703          	ld	a4,-40(s0)
ffffffe000200be0:	00e7b023          	sd	a4,0(a5)
    new_vas->vm_start = addr;
ffffffe000200be4:	fe843783          	ld	a5,-24(s0)
ffffffe000200be8:	fd043703          	ld	a4,-48(s0)
ffffffe000200bec:	00e7b423          	sd	a4,8(a5)
    new_vas->vm_end = addr + len;
ffffffe000200bf0:	fd043703          	ld	a4,-48(s0)
ffffffe000200bf4:	fc843783          	ld	a5,-56(s0)
ffffffe000200bf8:	00f70733          	add	a4,a4,a5
ffffffe000200bfc:	fe843783          	ld	a5,-24(s0)
ffffffe000200c00:	00e7b823          	sd	a4,16(a5)
    new_vas->vm_pgoff = vm_pgoff;
ffffffe000200c04:	fe843783          	ld	a5,-24(s0)
ffffffe000200c08:	fc043703          	ld	a4,-64(s0)
ffffffe000200c0c:	02e7b823          	sd	a4,48(a5)
    new_vas->vm_filesz = vm_filesz;
ffffffe000200c10:	fe843783          	ld	a5,-24(s0)
ffffffe000200c14:	fb843703          	ld	a4,-72(s0)
ffffffe000200c18:	02e7bc23          	sd	a4,56(a5)
    new_vas->vm_flags = flags;
ffffffe000200c1c:	fe843783          	ld	a5,-24(s0)
ffffffe000200c20:	fb043703          	ld	a4,-80(s0)
ffffffe000200c24:	02e7b423          	sd	a4,40(a5)
    new_vas->vm_prev = NULL;
ffffffe000200c28:	fe843783          	ld	a5,-24(s0)
ffffffe000200c2c:	0207b023          	sd	zero,32(a5)
    new_vas->vm_next = mm->mmap;
ffffffe000200c30:	fd843783          	ld	a5,-40(s0)
ffffffe000200c34:	0007b703          	ld	a4,0(a5)
ffffffe000200c38:	fe843783          	ld	a5,-24(s0)
ffffffe000200c3c:	00e7bc23          	sd	a4,24(a5)
    mm->mmap = new_vas;
ffffffe000200c40:	fd843783          	ld	a5,-40(s0)
ffffffe000200c44:	fe843703          	ld	a4,-24(s0)
ffffffe000200c48:	00e7b023          	sd	a4,0(a5)
    
    return new_vas->vm_start;
ffffffe000200c4c:	fe843783          	ld	a5,-24(s0)
ffffffe000200c50:	0087b783          	ld	a5,8(a5)
}
ffffffe000200c54:	00078513          	mv	a0,a5
ffffffe000200c58:	04813083          	ld	ra,72(sp)
ffffffe000200c5c:	04013403          	ld	s0,64(sp)
ffffffe000200c60:	05010113          	addi	sp,sp,80
ffffffe000200c64:	00008067          	ret

ffffffe000200c68 <load_program>:

void load_program(struct task_struct *task) {
ffffffe000200c68:	fc010113          	addi	sp,sp,-64
ffffffe000200c6c:	02113c23          	sd	ra,56(sp)
ffffffe000200c70:	02813823          	sd	s0,48(sp)
ffffffe000200c74:	04010413          	addi	s0,sp,64
ffffffe000200c78:	fca43423          	sd	a0,-56(s0)
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe000200c7c:	00005797          	auipc	a5,0x5
ffffffe000200c80:	38478793          	addi	a5,a5,900 # ffffffe000206000 <_sramdisk>
ffffffe000200c84:	fef43023          	sd	a5,-32(s0)
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000200c88:	fe043783          	ld	a5,-32(s0)
ffffffe000200c8c:	0207b703          	ld	a4,32(a5)
ffffffe000200c90:	00005797          	auipc	a5,0x5
ffffffe000200c94:	37078793          	addi	a5,a5,880 # ffffffe000206000 <_sramdisk>
ffffffe000200c98:	00f707b3          	add	a5,a4,a5
ffffffe000200c9c:	fcf43c23          	sd	a5,-40(s0)
    for (int i = 0; i < ehdr->e_phnum; ++i) {
ffffffe000200ca0:	fe042623          	sw	zero,-20(s0)
ffffffe000200ca4:	0a00006f          	j	ffffffe000200d44 <load_program+0xdc>
        Elf64_Phdr *phdr = phdrs + i;
ffffffe000200ca8:	fec42703          	lw	a4,-20(s0)
ffffffe000200cac:	00070793          	mv	a5,a4
ffffffe000200cb0:	00379793          	slli	a5,a5,0x3
ffffffe000200cb4:	40e787b3          	sub	a5,a5,a4
ffffffe000200cb8:	00379793          	slli	a5,a5,0x3
ffffffe000200cbc:	00078713          	mv	a4,a5
ffffffe000200cc0:	fd843783          	ld	a5,-40(s0)
ffffffe000200cc4:	00e787b3          	add	a5,a5,a4
ffffffe000200cc8:	fcf43823          	sd	a5,-48(s0)
        if (phdr->p_type == PT_LOAD) {
ffffffe000200ccc:	fd043783          	ld	a5,-48(s0)
ffffffe000200cd0:	0007a703          	lw	a4,0(a5)
ffffffe000200cd4:	00100793          	li	a5,1
ffffffe000200cd8:	06f71063          	bne	a4,a5,ffffffe000200d38 <load_program+0xd0>
            printk("entry: %lx, memsz: %lx, filesz: %lx\n", ehdr->e_entry, phdr->p_memsz, phdr->p_filesz);
ffffffe000200cdc:	fe043783          	ld	a5,-32(s0)
ffffffe000200ce0:	0187b703          	ld	a4,24(a5)
ffffffe000200ce4:	fd043783          	ld	a5,-48(s0)
ffffffe000200ce8:	0287b603          	ld	a2,40(a5)
ffffffe000200cec:	fd043783          	ld	a5,-48(s0)
ffffffe000200cf0:	0207b783          	ld	a5,32(a5)
ffffffe000200cf4:	00078693          	mv	a3,a5
ffffffe000200cf8:	00070593          	mv	a1,a4
ffffffe000200cfc:	00003517          	auipc	a0,0x3
ffffffe000200d00:	33c50513          	addi	a0,a0,828 # ffffffe000204038 <_srodata+0x38>
ffffffe000200d04:	241020ef          	jal	ffffffe000203744 <printk>
            do_mmap(&task->mm, ehdr->e_entry, phdr->p_memsz, phdr->p_offset, phdr->p_filesz, VM_EXEC | VM_READ | VM_WRITE);
ffffffe000200d08:	fc843783          	ld	a5,-56(s0)
ffffffe000200d0c:	0b078513          	addi	a0,a5,176
ffffffe000200d10:	fe043783          	ld	a5,-32(s0)
ffffffe000200d14:	0187b583          	ld	a1,24(a5)
ffffffe000200d18:	fd043783          	ld	a5,-48(s0)
ffffffe000200d1c:	0287b603          	ld	a2,40(a5)
ffffffe000200d20:	fd043783          	ld	a5,-48(s0)
ffffffe000200d24:	0087b683          	ld	a3,8(a5)
ffffffe000200d28:	fd043783          	ld	a5,-48(s0)
ffffffe000200d2c:	0207b703          	ld	a4,32(a5)
ffffffe000200d30:	00e00793          	li	a5,14
ffffffe000200d34:	e65ff0ef          	jal	ffffffe000200b98 <do_mmap>
    for (int i = 0; i < ehdr->e_phnum; ++i) {
ffffffe000200d38:	fec42783          	lw	a5,-20(s0)
ffffffe000200d3c:	0017879b          	addiw	a5,a5,1
ffffffe000200d40:	fef42623          	sw	a5,-20(s0)
ffffffe000200d44:	fe043783          	ld	a5,-32(s0)
ffffffe000200d48:	0387d783          	lhu	a5,56(a5)
ffffffe000200d4c:	0007879b          	sext.w	a5,a5
ffffffe000200d50:	fec42703          	lw	a4,-20(s0)
ffffffe000200d54:	0007071b          	sext.w	a4,a4
ffffffe000200d58:	f4f748e3          	blt	a4,a5,ffffffe000200ca8 <load_program+0x40>
        }
    }
    task->thread.sepc = ehdr->e_entry;
ffffffe000200d5c:	fe043783          	ld	a5,-32(s0)
ffffffe000200d60:	0187b703          	ld	a4,24(a5)
ffffffe000200d64:	fc843783          	ld	a5,-56(s0)
ffffffe000200d68:	08e7b823          	sd	a4,144(a5)
}
ffffffe000200d6c:	00000013          	nop
ffffffe000200d70:	03813083          	ld	ra,56(sp)
ffffffe000200d74:	03013403          	ld	s0,48(sp)
ffffffe000200d78:	04010113          	addi	sp,sp,64
ffffffe000200d7c:	00008067          	ret

ffffffe000200d80 <task_init>:

void task_init() {
ffffffe000200d80:	fc010113          	addi	sp,sp,-64
ffffffe000200d84:	02113c23          	sd	ra,56(sp)
ffffffe000200d88:	02813823          	sd	s0,48(sp)
ffffffe000200d8c:	02913423          	sd	s1,40(sp)
ffffffe000200d90:	04010413          	addi	s0,sp,64
    srand(2024);
ffffffe000200d94:	7e800513          	li	a0,2024
ffffffe000200d98:	22d020ef          	jal	ffffffe0002037c4 <srand>

    idle = kalloc();
ffffffe000200d9c:	c75ff0ef          	jal	ffffffe000200a10 <kalloc>
ffffffe000200da0:	00050713          	mv	a4,a0
ffffffe000200da4:	00008797          	auipc	a5,0x8
ffffffe000200da8:	26478793          	addi	a5,a5,612 # ffffffe000209008 <idle>
ffffffe000200dac:	00e7b023          	sd	a4,0(a5)
    // for (uint64_t i = 0; i < PGSIZE; i++)   *((char*)idle + i) = 0; 
    idle->state = TASK_RUNNING;
ffffffe000200db0:	00008797          	auipc	a5,0x8
ffffffe000200db4:	25878793          	addi	a5,a5,600 # ffffffe000209008 <idle>
ffffffe000200db8:	0007b783          	ld	a5,0(a5)
ffffffe000200dbc:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe000200dc0:	00008797          	auipc	a5,0x8
ffffffe000200dc4:	24878793          	addi	a5,a5,584 # ffffffe000209008 <idle>
ffffffe000200dc8:	0007b783          	ld	a5,0(a5)
ffffffe000200dcc:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe000200dd0:	00008797          	auipc	a5,0x8
ffffffe000200dd4:	23878793          	addi	a5,a5,568 # ffffffe000209008 <idle>
ffffffe000200dd8:	0007b783          	ld	a5,0(a5)
ffffffe000200ddc:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe000200de0:	00008797          	auipc	a5,0x8
ffffffe000200de4:	22878793          	addi	a5,a5,552 # ffffffe000209008 <idle>
ffffffe000200de8:	0007b783          	ld	a5,0(a5)
ffffffe000200dec:	0007bc23          	sd	zero,24(a5)

    current = idle;
ffffffe000200df0:	00008797          	auipc	a5,0x8
ffffffe000200df4:	21878793          	addi	a5,a5,536 # ffffffe000209008 <idle>
ffffffe000200df8:	0007b703          	ld	a4,0(a5)
ffffffe000200dfc:	00008797          	auipc	a5,0x8
ffffffe000200e00:	21478793          	addi	a5,a5,532 # ffffffe000209010 <current>
ffffffe000200e04:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe000200e08:	00008797          	auipc	a5,0x8
ffffffe000200e0c:	20078793          	addi	a5,a5,512 # ffffffe000209008 <idle>
ffffffe000200e10:	0007b703          	ld	a4,0(a5)
ffffffe000200e14:	00008797          	auipc	a5,0x8
ffffffe000200e18:	22478793          	addi	a5,a5,548 # ffffffe000209038 <task>
ffffffe000200e1c:	00e7b023          	sd	a4,0(a5)
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle


    for (int i = 1; i < nr_tasks; i++){
ffffffe000200e20:	00100793          	li	a5,1
ffffffe000200e24:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200e28:	2f00006f          	j	ffffffe000201118 <task_init+0x398>
        task[i] = kalloc();
ffffffe000200e2c:	be5ff0ef          	jal	ffffffe000200a10 <kalloc>
ffffffe000200e30:	00050693          	mv	a3,a0
ffffffe000200e34:	00008717          	auipc	a4,0x8
ffffffe000200e38:	20470713          	addi	a4,a4,516 # ffffffe000209038 <task>
ffffffe000200e3c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e40:	00379793          	slli	a5,a5,0x3
ffffffe000200e44:	00f707b3          	add	a5,a4,a5
ffffffe000200e48:	00d7b023          	sd	a3,0(a5)
        // for (uint64_t i = 0; i < PGSIZE; i++)   *((char*)task[i] + i) = 0; 
        task[i]->state = TASK_RUNNING;
ffffffe000200e4c:	00008717          	auipc	a4,0x8
ffffffe000200e50:	1ec70713          	addi	a4,a4,492 # ffffffe000209038 <task>
ffffffe000200e54:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e58:	00379793          	slli	a5,a5,0x3
ffffffe000200e5c:	00f707b3          	add	a5,a4,a5
ffffffe000200e60:	0007b783          	ld	a5,0(a5)
ffffffe000200e64:	0007b023          	sd	zero,0(a5)
        task[i]->pid = i;
ffffffe000200e68:	00008717          	auipc	a4,0x8
ffffffe000200e6c:	1d070713          	addi	a4,a4,464 # ffffffe000209038 <task>
ffffffe000200e70:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e74:	00379793          	slli	a5,a5,0x3
ffffffe000200e78:	00f707b3          	add	a5,a4,a5
ffffffe000200e7c:	0007b783          	ld	a5,0(a5)
ffffffe000200e80:	fdc42703          	lw	a4,-36(s0)
ffffffe000200e84:	00e7bc23          	sd	a4,24(a5)
        task[i]->counter = 0;
ffffffe000200e88:	00008717          	auipc	a4,0x8
ffffffe000200e8c:	1b070713          	addi	a4,a4,432 # ffffffe000209038 <task>
ffffffe000200e90:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e94:	00379793          	slli	a5,a5,0x3
ffffffe000200e98:	00f707b3          	add	a5,a4,a5
ffffffe000200e9c:	0007b783          	ld	a5,0(a5)
ffffffe000200ea0:	0007b423          	sd	zero,8(a5)
        task[i]->priority = (rand() % (PRIORITY_MAX - PRIORITY_MIN + 1)) + PRIORITY_MIN;
ffffffe000200ea4:	16d020ef          	jal	ffffffe000203810 <rand>
ffffffe000200ea8:	00050793          	mv	a5,a0
ffffffe000200eac:	00078713          	mv	a4,a5
ffffffe000200eb0:	0007069b          	sext.w	a3,a4
ffffffe000200eb4:	666667b7          	lui	a5,0x66666
ffffffe000200eb8:	66778793          	addi	a5,a5,1639 # 66666667 <PHY_SIZE+0x5e666667>
ffffffe000200ebc:	02f687b3          	mul	a5,a3,a5
ffffffe000200ec0:	0207d793          	srli	a5,a5,0x20
ffffffe000200ec4:	4027d79b          	sraiw	a5,a5,0x2
ffffffe000200ec8:	00078693          	mv	a3,a5
ffffffe000200ecc:	41f7579b          	sraiw	a5,a4,0x1f
ffffffe000200ed0:	40f687bb          	subw	a5,a3,a5
ffffffe000200ed4:	00078693          	mv	a3,a5
ffffffe000200ed8:	00068793          	mv	a5,a3
ffffffe000200edc:	0027979b          	slliw	a5,a5,0x2
ffffffe000200ee0:	00d787bb          	addw	a5,a5,a3
ffffffe000200ee4:	0017979b          	slliw	a5,a5,0x1
ffffffe000200ee8:	40f707bb          	subw	a5,a4,a5
ffffffe000200eec:	0007879b          	sext.w	a5,a5
ffffffe000200ef0:	0017879b          	addiw	a5,a5,1
ffffffe000200ef4:	0007869b          	sext.w	a3,a5
ffffffe000200ef8:	00008717          	auipc	a4,0x8
ffffffe000200efc:	14070713          	addi	a4,a4,320 # ffffffe000209038 <task>
ffffffe000200f00:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f04:	00379793          	slli	a5,a5,0x3
ffffffe000200f08:	00f707b3          	add	a5,a4,a5
ffffffe000200f0c:	0007b783          	ld	a5,0(a5)
ffffffe000200f10:	00068713          	mv	a4,a3
ffffffe000200f14:	00e7b823          	sd	a4,16(a5)
        task[i]->thread.sp = (uint64_t)((uint64_t)task[i] + PGSIZE);
ffffffe000200f18:	00008717          	auipc	a4,0x8
ffffffe000200f1c:	12070713          	addi	a4,a4,288 # ffffffe000209038 <task>
ffffffe000200f20:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f24:	00379793          	slli	a5,a5,0x3
ffffffe000200f28:	00f707b3          	add	a5,a4,a5
ffffffe000200f2c:	0007b783          	ld	a5,0(a5)
ffffffe000200f30:	00078693          	mv	a3,a5
ffffffe000200f34:	00008717          	auipc	a4,0x8
ffffffe000200f38:	10470713          	addi	a4,a4,260 # ffffffe000209038 <task>
ffffffe000200f3c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f40:	00379793          	slli	a5,a5,0x3
ffffffe000200f44:	00f707b3          	add	a5,a4,a5
ffffffe000200f48:	0007b783          	ld	a5,0(a5)
ffffffe000200f4c:	00001737          	lui	a4,0x1
ffffffe000200f50:	00e68733          	add	a4,a3,a4
ffffffe000200f54:	02e7b423          	sd	a4,40(a5)
        task[i]->thread.ra = (uint64_t)(__dummy);
ffffffe000200f58:	00008717          	auipc	a4,0x8
ffffffe000200f5c:	0e070713          	addi	a4,a4,224 # ffffffe000209038 <task>
ffffffe000200f60:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f64:	00379793          	slli	a5,a5,0x3
ffffffe000200f68:	00f707b3          	add	a5,a4,a5
ffffffe000200f6c:	0007b783          	ld	a5,0(a5)
ffffffe000200f70:	fffff717          	auipc	a4,0xfffff
ffffffe000200f74:	28070713          	addi	a4,a4,640 # ffffffe0002001f0 <__dummy>
ffffffe000200f78:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sepc = USER_START;
ffffffe000200f7c:	00008717          	auipc	a4,0x8
ffffffe000200f80:	0bc70713          	addi	a4,a4,188 # ffffffe000209038 <task>
ffffffe000200f84:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f88:	00379793          	slli	a5,a5,0x3
ffffffe000200f8c:	00f707b3          	add	a5,a4,a5
ffffffe000200f90:	0007b783          	ld	a5,0(a5)
ffffffe000200f94:	0807b823          	sd	zero,144(a5)
        task[i]->thread.sstatus = 1 << 18 | 1 << 5;
ffffffe000200f98:	00008717          	auipc	a4,0x8
ffffffe000200f9c:	0a070713          	addi	a4,a4,160 # ffffffe000209038 <task>
ffffffe000200fa0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200fa4:	00379793          	slli	a5,a5,0x3
ffffffe000200fa8:	00f707b3          	add	a5,a4,a5
ffffffe000200fac:	0007b783          	ld	a5,0(a5)
ffffffe000200fb0:	00040737          	lui	a4,0x40
ffffffe000200fb4:	02070713          	addi	a4,a4,32 # 40020 <PGSIZE+0x3f020>
ffffffe000200fb8:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sscratch = USER_END;
ffffffe000200fbc:	00008717          	auipc	a4,0x8
ffffffe000200fc0:	07c70713          	addi	a4,a4,124 # ffffffe000209038 <task>
ffffffe000200fc4:	fdc42783          	lw	a5,-36(s0)
ffffffe000200fc8:	00379793          	slli	a5,a5,0x3
ffffffe000200fcc:	00f707b3          	add	a5,a4,a5
ffffffe000200fd0:	0007b783          	ld	a5,0(a5)
ffffffe000200fd4:	00100713          	li	a4,1
ffffffe000200fd8:	02671713          	slli	a4,a4,0x26
ffffffe000200fdc:	0ae7b023          	sd	a4,160(a5)
        task[i]->pgd = alloc_page();
ffffffe000200fe0:	00008717          	auipc	a4,0x8
ffffffe000200fe4:	05870713          	addi	a4,a4,88 # ffffffe000209038 <task>
ffffffe000200fe8:	fdc42783          	lw	a5,-36(s0)
ffffffe000200fec:	00379793          	slli	a5,a5,0x3
ffffffe000200ff0:	00f707b3          	add	a5,a4,a5
ffffffe000200ff4:	0007b483          	ld	s1,0(a5)
ffffffe000200ff8:	9a5ff0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000200ffc:	00050793          	mv	a5,a0
ffffffe000201000:	0af4b423          	sd	a5,168(s1)
        printk("pgd is %lx\n", task[i]->pgd);
ffffffe000201004:	00008717          	auipc	a4,0x8
ffffffe000201008:	03470713          	addi	a4,a4,52 # ffffffe000209038 <task>
ffffffe00020100c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201010:	00379793          	slli	a5,a5,0x3
ffffffe000201014:	00f707b3          	add	a5,a4,a5
ffffffe000201018:	0007b783          	ld	a5,0(a5)
ffffffe00020101c:	0a87b783          	ld	a5,168(a5)
ffffffe000201020:	00078593          	mv	a1,a5
ffffffe000201024:	00003517          	auipc	a0,0x3
ffffffe000201028:	03c50513          	addi	a0,a0,60 # ffffffe000204060 <_srodata+0x60>
ffffffe00020102c:	718020ef          	jal	ffffffe000203744 <printk>
        // memcpy(task[i]->pgd, swapper_pg_dir, sizeof(swapper_pg_dir));
        uint64_t *a = task[i]->pgd;
ffffffe000201030:	00008717          	auipc	a4,0x8
ffffffe000201034:	00870713          	addi	a4,a4,8 # ffffffe000209038 <task>
ffffffe000201038:	fdc42783          	lw	a5,-36(s0)
ffffffe00020103c:	00379793          	slli	a5,a5,0x3
ffffffe000201040:	00f707b3          	add	a5,a4,a5
ffffffe000201044:	0007b783          	ld	a5,0(a5)
ffffffe000201048:	0a87b783          	ld	a5,168(a5)
ffffffe00020104c:	fcf43423          	sd	a5,-56(s0)
        for(uint64_t i = 0; i < 512;i++){
ffffffe000201050:	fc043823          	sd	zero,-48(s0)
ffffffe000201054:	03c0006f          	j	ffffffe000201090 <task_init+0x310>
            a[i] = swapper_pg_dir[i];
ffffffe000201058:	fd043783          	ld	a5,-48(s0)
ffffffe00020105c:	00379793          	slli	a5,a5,0x3
ffffffe000201060:	fc843703          	ld	a4,-56(s0)
ffffffe000201064:	00f707b3          	add	a5,a4,a5
ffffffe000201068:	0000a697          	auipc	a3,0xa
ffffffe00020106c:	f9868693          	addi	a3,a3,-104 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201070:	fd043703          	ld	a4,-48(s0)
ffffffe000201074:	00371713          	slli	a4,a4,0x3
ffffffe000201078:	00e68733          	add	a4,a3,a4
ffffffe00020107c:	00073703          	ld	a4,0(a4)
ffffffe000201080:	00e7b023          	sd	a4,0(a5)
        for(uint64_t i = 0; i < 512;i++){
ffffffe000201084:	fd043783          	ld	a5,-48(s0)
ffffffe000201088:	00178793          	addi	a5,a5,1
ffffffe00020108c:	fcf43823          	sd	a5,-48(s0)
ffffffe000201090:	fd043703          	ld	a4,-48(s0)
ffffffe000201094:	1ff00793          	li	a5,511
ffffffe000201098:	fce7f0e3          	bgeu	a5,a4,ffffffe000201058 <task_init+0x2d8>
            // printk("i is %lu, swapper is %lx\n", i, swapper_pg_dir[i]);
        }
        load_program(task[i]);
ffffffe00020109c:	00008717          	auipc	a4,0x8
ffffffe0002010a0:	f9c70713          	addi	a4,a4,-100 # ffffffe000209038 <task>
ffffffe0002010a4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002010a8:	00379793          	slli	a5,a5,0x3
ffffffe0002010ac:	00f707b3          	add	a5,a4,a5
ffffffe0002010b0:	0007b783          	ld	a5,0(a5)
ffffffe0002010b4:	00078513          	mv	a0,a5
ffffffe0002010b8:	bb1ff0ef          	jal	ffffffe000200c68 <load_program>
        do_mmap(&task[i]->mm, USER_END - PGSIZE, PGSIZE, -1, -1, VM_ANON | VM_READ | VM_WRITE);
ffffffe0002010bc:	00008717          	auipc	a4,0x8
ffffffe0002010c0:	f7c70713          	addi	a4,a4,-132 # ffffffe000209038 <task>
ffffffe0002010c4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002010c8:	00379793          	slli	a5,a5,0x3
ffffffe0002010cc:	00f707b3          	add	a5,a4,a5
ffffffe0002010d0:	0007b783          	ld	a5,0(a5)
ffffffe0002010d4:	0b078513          	addi	a0,a5,176
ffffffe0002010d8:	00700793          	li	a5,7
ffffffe0002010dc:	fff00713          	li	a4,-1
ffffffe0002010e0:	fff00693          	li	a3,-1
ffffffe0002010e4:	00001637          	lui	a2,0x1
ffffffe0002010e8:	040005b7          	lui	a1,0x4000
ffffffe0002010ec:	fff58593          	addi	a1,a1,-1 # 3ffffff <OPENSBI_SIZE+0x3dfffff>
ffffffe0002010f0:	00c59593          	slli	a1,a1,0xc
ffffffe0002010f4:	aa5ff0ef          	jal	ffffffe000200b98 <do_mmap>

        printk("after task[%lu] initialize\n", i);
ffffffe0002010f8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002010fc:	00078593          	mv	a1,a5
ffffffe000201100:	00003517          	auipc	a0,0x3
ffffffe000201104:	f7050513          	addi	a0,a0,-144 # ffffffe000204070 <_srodata+0x70>
ffffffe000201108:	63c020ef          	jal	ffffffe000203744 <printk>
    for (int i = 1; i < nr_tasks; i++){
ffffffe00020110c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201110:	0017879b          	addiw	a5,a5,1
ffffffe000201114:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201118:	fdc42703          	lw	a4,-36(s0)
ffffffe00020111c:	00004797          	auipc	a5,0x4
ffffffe000201120:	ef478793          	addi	a5,a5,-268 # ffffffe000205010 <nr_tasks>
ffffffe000201124:	0007b783          	ld	a5,0(a5)
ffffffe000201128:	d0f762e3          	bltu	a4,a5,ffffffe000200e2c <task_init+0xac>
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址


    printk("...task_init done!\n");
ffffffe00020112c:	00003517          	auipc	a0,0x3
ffffffe000201130:	f6450513          	addi	a0,a0,-156 # ffffffe000204090 <_srodata+0x90>
ffffffe000201134:	610020ef          	jal	ffffffe000203744 <printk>
}
ffffffe000201138:	00000013          	nop
ffffffe00020113c:	03813083          	ld	ra,56(sp)
ffffffe000201140:	03013403          	ld	s0,48(sp)
ffffffe000201144:	02813483          	ld	s1,40(sp)
ffffffe000201148:	04010113          	addi	sp,sp,64
ffffffe00020114c:	00008067          	ret

ffffffe000201150 <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
ffffffe000201150:	fd010113          	addi	sp,sp,-48
ffffffe000201154:	02113423          	sd	ra,40(sp)
ffffffe000201158:	02813023          	sd	s0,32(sp)
ffffffe00020115c:	03010413          	addi	s0,sp,48
    // printk("in dummy\n");
    uint64_t MOD = 1000000007;
ffffffe000201160:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe000201164:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe000201168:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe00020116c:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe000201170:	fff00793          	li	a5,-1
ffffffe000201174:	fef42223          	sw	a5,-28(s0)
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000201178:	fe442783          	lw	a5,-28(s0)
ffffffe00020117c:	0007871b          	sext.w	a4,a5
ffffffe000201180:	fff00793          	li	a5,-1
ffffffe000201184:	00f70e63          	beq	a4,a5,ffffffe0002011a0 <dummy+0x50>
ffffffe000201188:	00008797          	auipc	a5,0x8
ffffffe00020118c:	e8878793          	addi	a5,a5,-376 # ffffffe000209010 <current>
ffffffe000201190:	0007b783          	ld	a5,0(a5)
ffffffe000201194:	0087b703          	ld	a4,8(a5)
ffffffe000201198:	fe442783          	lw	a5,-28(s0)
ffffffe00020119c:	fcf70ee3          	beq	a4,a5,ffffffe000201178 <dummy+0x28>
ffffffe0002011a0:	00008797          	auipc	a5,0x8
ffffffe0002011a4:	e7078793          	addi	a5,a5,-400 # ffffffe000209010 <current>
ffffffe0002011a8:	0007b783          	ld	a5,0(a5)
ffffffe0002011ac:	0087b783          	ld	a5,8(a5)
ffffffe0002011b0:	fc0784e3          	beqz	a5,ffffffe000201178 <dummy+0x28>
            if (current->counter == 1) {
ffffffe0002011b4:	00008797          	auipc	a5,0x8
ffffffe0002011b8:	e5c78793          	addi	a5,a5,-420 # ffffffe000209010 <current>
ffffffe0002011bc:	0007b783          	ld	a5,0(a5)
ffffffe0002011c0:	0087b703          	ld	a4,8(a5)
ffffffe0002011c4:	00100793          	li	a5,1
ffffffe0002011c8:	00f71e63          	bne	a4,a5,ffffffe0002011e4 <dummy+0x94>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002011cc:	00008797          	auipc	a5,0x8
ffffffe0002011d0:	e4478793          	addi	a5,a5,-444 # ffffffe000209010 <current>
ffffffe0002011d4:	0007b783          	ld	a5,0(a5)
ffffffe0002011d8:	0087b703          	ld	a4,8(a5)
ffffffe0002011dc:	fff70713          	addi	a4,a4,-1
ffffffe0002011e0:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe0002011e4:	00008797          	auipc	a5,0x8
ffffffe0002011e8:	e2c78793          	addi	a5,a5,-468 # ffffffe000209010 <current>
ffffffe0002011ec:	0007b783          	ld	a5,0(a5)
ffffffe0002011f0:	0087b783          	ld	a5,8(a5)
ffffffe0002011f4:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe0002011f8:	fe843783          	ld	a5,-24(s0)
ffffffe0002011fc:	00178713          	addi	a4,a5,1
ffffffe000201200:	fd843783          	ld	a5,-40(s0)
ffffffe000201204:	02f777b3          	remu	a5,a4,a5
ffffffe000201208:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe00020120c:	00008797          	auipc	a5,0x8
ffffffe000201210:	e0478793          	addi	a5,a5,-508 # ffffffe000209010 <current>
ffffffe000201214:	0007b783          	ld	a5,0(a5)
ffffffe000201218:	0187b783          	ld	a5,24(a5)
ffffffe00020121c:	fe843603          	ld	a2,-24(s0)
ffffffe000201220:	00078593          	mv	a1,a5
ffffffe000201224:	00003517          	auipc	a0,0x3
ffffffe000201228:	e8450513          	addi	a0,a0,-380 # ffffffe0002040a8 <_srodata+0xa8>
ffffffe00020122c:	518020ef          	jal	ffffffe000203744 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000201230:	f49ff06f          	j	ffffffe000201178 <dummy+0x28>

ffffffe000201234 <switch_to>:
            #endif
        }
    }
}

void switch_to(struct task_struct *next) {
ffffffe000201234:	fd010113          	addi	sp,sp,-48
ffffffe000201238:	02113423          	sd	ra,40(sp)
ffffffe00020123c:	02813023          	sd	s0,32(sp)
ffffffe000201240:	03010413          	addi	s0,sp,48
ffffffe000201244:	fca43c23          	sd	a0,-40(s0)
    // printk("in switch_to\n");
    if(current->pid != next->pid){
ffffffe000201248:	00008797          	auipc	a5,0x8
ffffffe00020124c:	dc878793          	addi	a5,a5,-568 # ffffffe000209010 <current>
ffffffe000201250:	0007b783          	ld	a5,0(a5)
ffffffe000201254:	0187b703          	ld	a4,24(a5)
ffffffe000201258:	fd843783          	ld	a5,-40(s0)
ffffffe00020125c:	0187b783          	ld	a5,24(a5)
ffffffe000201260:	06f70063          	beq	a4,a5,ffffffe0002012c0 <switch_to+0x8c>
        printk(PURPLE "switch to [pid = %d, priority = %d, priority = %d]\n" CLEAR, next->pid, next->priority, next->counter);
ffffffe000201264:	fd843783          	ld	a5,-40(s0)
ffffffe000201268:	0187b703          	ld	a4,24(a5)
ffffffe00020126c:	fd843783          	ld	a5,-40(s0)
ffffffe000201270:	0107b603          	ld	a2,16(a5)
ffffffe000201274:	fd843783          	ld	a5,-40(s0)
ffffffe000201278:	0087b783          	ld	a5,8(a5)
ffffffe00020127c:	00078693          	mv	a3,a5
ffffffe000201280:	00070593          	mv	a1,a4
ffffffe000201284:	00003517          	auipc	a0,0x3
ffffffe000201288:	e5450513          	addi	a0,a0,-428 # ffffffe0002040d8 <_srodata+0xd8>
ffffffe00020128c:	4b8020ef          	jal	ffffffe000203744 <printk>
        struct task_struct *tmp = current;
ffffffe000201290:	00008797          	auipc	a5,0x8
ffffffe000201294:	d8078793          	addi	a5,a5,-640 # ffffffe000209010 <current>
ffffffe000201298:	0007b783          	ld	a5,0(a5)
ffffffe00020129c:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe0002012a0:	00008797          	auipc	a5,0x8
ffffffe0002012a4:	d7078793          	addi	a5,a5,-656 # ffffffe000209010 <current>
ffffffe0002012a8:	fd843703          	ld	a4,-40(s0)
ffffffe0002012ac:	00e7b023          	sd	a4,0(a5)
        __switch_to(tmp, next);
ffffffe0002012b0:	fd843583          	ld	a1,-40(s0)
ffffffe0002012b4:	fe843503          	ld	a0,-24(s0)
ffffffe0002012b8:	f49fe0ef          	jal	ffffffe000200200 <__switch_to>
    }
        
    return;
ffffffe0002012bc:	00000013          	nop
ffffffe0002012c0:	00000013          	nop
}
ffffffe0002012c4:	02813083          	ld	ra,40(sp)
ffffffe0002012c8:	02013403          	ld	s0,32(sp)
ffffffe0002012cc:	03010113          	addi	sp,sp,48
ffffffe0002012d0:	00008067          	ret

ffffffe0002012d4 <do_timer>:

void do_timer() {
ffffffe0002012d4:	ff010113          	addi	sp,sp,-16
ffffffe0002012d8:	00113423          	sd	ra,8(sp)
ffffffe0002012dc:	00813023          	sd	s0,0(sp)
ffffffe0002012e0:	01010413          	addi	s0,sp,16
    // printk("in do_timer\n");
    // printk("in do_timer, current pid is %ld, current counter is %ld\n", current->pid, current->counter);

    if(current->pid == 0 || current->counter == 0)  schedule();
ffffffe0002012e4:	00008797          	auipc	a5,0x8
ffffffe0002012e8:	d2c78793          	addi	a5,a5,-724 # ffffffe000209010 <current>
ffffffe0002012ec:	0007b783          	ld	a5,0(a5)
ffffffe0002012f0:	0187b783          	ld	a5,24(a5)
ffffffe0002012f4:	00078c63          	beqz	a5,ffffffe00020130c <do_timer+0x38>
ffffffe0002012f8:	00008797          	auipc	a5,0x8
ffffffe0002012fc:	d1878793          	addi	a5,a5,-744 # ffffffe000209010 <current>
ffffffe000201300:	0007b783          	ld	a5,0(a5)
ffffffe000201304:	0087b783          	ld	a5,8(a5)
ffffffe000201308:	00079663          	bnez	a5,ffffffe000201314 <do_timer+0x40>
ffffffe00020130c:	05c000ef          	jal	ffffffe000201368 <schedule>
    else {
        current->counter -= 1;
        if(current->counter > 0)    return;
        else    schedule();
    }
    return;
ffffffe000201310:	0480006f          	j	ffffffe000201358 <do_timer+0x84>
        current->counter -= 1;
ffffffe000201314:	00008797          	auipc	a5,0x8
ffffffe000201318:	cfc78793          	addi	a5,a5,-772 # ffffffe000209010 <current>
ffffffe00020131c:	0007b783          	ld	a5,0(a5)
ffffffe000201320:	0087b703          	ld	a4,8(a5)
ffffffe000201324:	00008797          	auipc	a5,0x8
ffffffe000201328:	cec78793          	addi	a5,a5,-788 # ffffffe000209010 <current>
ffffffe00020132c:	0007b783          	ld	a5,0(a5)
ffffffe000201330:	fff70713          	addi	a4,a4,-1
ffffffe000201334:	00e7b423          	sd	a4,8(a5)
        if(current->counter > 0)    return;
ffffffe000201338:	00008797          	auipc	a5,0x8
ffffffe00020133c:	cd878793          	addi	a5,a5,-808 # ffffffe000209010 <current>
ffffffe000201340:	0007b783          	ld	a5,0(a5)
ffffffe000201344:	0087b783          	ld	a5,8(a5)
ffffffe000201348:	00079663          	bnez	a5,ffffffe000201354 <do_timer+0x80>
        else    schedule();
ffffffe00020134c:	01c000ef          	jal	ffffffe000201368 <schedule>
    return;
ffffffe000201350:	0080006f          	j	ffffffe000201358 <do_timer+0x84>
        if(current->counter > 0)    return;
ffffffe000201354:	00000013          	nop
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
}
ffffffe000201358:	00813083          	ld	ra,8(sp)
ffffffe00020135c:	00013403          	ld	s0,0(sp)
ffffffe000201360:	01010113          	addi	sp,sp,16
ffffffe000201364:	00008067          	ret

ffffffe000201368 <schedule>:

void schedule() {
ffffffe000201368:	fd010113          	addi	sp,sp,-48
ffffffe00020136c:	02113423          	sd	ra,40(sp)
ffffffe000201370:	02813023          	sd	s0,32(sp)
ffffffe000201374:	03010413          	addi	s0,sp,48
    // printk("in schedule\n");

    int i = nr_tasks;
ffffffe000201378:	00004797          	auipc	a5,0x4
ffffffe00020137c:	c9878793          	addi	a5,a5,-872 # ffffffe000205010 <nr_tasks>
ffffffe000201380:	0007b783          	ld	a5,0(a5)
ffffffe000201384:	fef42623          	sw	a5,-20(s0)
    int max_counter = -1, chosen_p;
ffffffe000201388:	fff00793          	li	a5,-1
ffffffe00020138c:	fef42423          	sw	a5,-24(s0)
    struct task_struct *p = task[nr_tasks];
ffffffe000201390:	00004797          	auipc	a5,0x4
ffffffe000201394:	c8078793          	addi	a5,a5,-896 # ffffffe000205010 <nr_tasks>
ffffffe000201398:	0007b783          	ld	a5,0(a5)
ffffffe00020139c:	00008717          	auipc	a4,0x8
ffffffe0002013a0:	c9c70713          	addi	a4,a4,-868 # ffffffe000209038 <task>
ffffffe0002013a4:	00379793          	slli	a5,a5,0x3
ffffffe0002013a8:	00f707b3          	add	a5,a4,a5
ffffffe0002013ac:	0007b783          	ld	a5,0(a5)
ffffffe0002013b0:	fcf43c23          	sd	a5,-40(s0)
    
    while(--i){
ffffffe0002013b4:	06c0006f          	j	ffffffe000201420 <schedule+0xb8>
        // if(*--p == NULL)    continue;
        p = task[i];
ffffffe0002013b8:	00008717          	auipc	a4,0x8
ffffffe0002013bc:	c8070713          	addi	a4,a4,-896 # ffffffe000209038 <task>
ffffffe0002013c0:	fec42783          	lw	a5,-20(s0)
ffffffe0002013c4:	00379793          	slli	a5,a5,0x3
ffffffe0002013c8:	00f707b3          	add	a5,a4,a5
ffffffe0002013cc:	0007b783          	ld	a5,0(a5)
ffffffe0002013d0:	fcf43c23          	sd	a5,-40(s0)
        if(!p) continue;
ffffffe0002013d4:	fd843783          	ld	a5,-40(s0)
ffffffe0002013d8:	04078263          	beqz	a5,ffffffe00020141c <schedule+0xb4>
        // printk("p pid is %ld, p counter is %ld\n", p->pid, p->counter);
        int pct = p->counter;
ffffffe0002013dc:	fd843783          	ld	a5,-40(s0)
ffffffe0002013e0:	0087b783          	ld	a5,8(a5)
ffffffe0002013e4:	fcf42a23          	sw	a5,-44(s0)
        if(pct > max_counter){
ffffffe0002013e8:	fd442783          	lw	a5,-44(s0)
ffffffe0002013ec:	00078713          	mv	a4,a5
ffffffe0002013f0:	fe842783          	lw	a5,-24(s0)
ffffffe0002013f4:	0007071b          	sext.w	a4,a4
ffffffe0002013f8:	0007879b          	sext.w	a5,a5
ffffffe0002013fc:	02e7d263          	bge	a5,a4,ffffffe000201420 <schedule+0xb8>
            // printk("%ld\n", pct);
            max_counter = p->counter;
ffffffe000201400:	fd843783          	ld	a5,-40(s0)
ffffffe000201404:	0087b783          	ld	a5,8(a5)
ffffffe000201408:	fef42423          	sw	a5,-24(s0)
            chosen_p = p->pid;
ffffffe00020140c:	fd843783          	ld	a5,-40(s0)
ffffffe000201410:	0187b783          	ld	a5,24(a5)
ffffffe000201414:	fef42223          	sw	a5,-28(s0)
ffffffe000201418:	0080006f          	j	ffffffe000201420 <schedule+0xb8>
        if(!p) continue;
ffffffe00020141c:	00000013          	nop
    while(--i){
ffffffe000201420:	fec42783          	lw	a5,-20(s0)
ffffffe000201424:	fff7879b          	addiw	a5,a5,-1
ffffffe000201428:	fef42623          	sw	a5,-20(s0)
ffffffe00020142c:	fec42783          	lw	a5,-20(s0)
ffffffe000201430:	0007879b          	sext.w	a5,a5
ffffffe000201434:	f80792e3          	bnez	a5,ffffffe0002013b8 <schedule+0x50>
        }
    }
    // printk("maxcounter is %ld\n", max_counter);
    if(max_counter <= 0) {
ffffffe000201438:	fe842783          	lw	a5,-24(s0)
ffffffe00020143c:	0007879b          	sext.w	a5,a5
ffffffe000201440:	0cf04063          	bgtz	a5,ffffffe000201500 <schedule+0x198>
        i = nr_tasks;
ffffffe000201444:	00004797          	auipc	a5,0x4
ffffffe000201448:	bcc78793          	addi	a5,a5,-1076 # ffffffe000205010 <nr_tasks>
ffffffe00020144c:	0007b783          	ld	a5,0(a5)
ffffffe000201450:	fef42623          	sw	a5,-20(s0)
        p = task[nr_tasks];
ffffffe000201454:	00004797          	auipc	a5,0x4
ffffffe000201458:	bbc78793          	addi	a5,a5,-1092 # ffffffe000205010 <nr_tasks>
ffffffe00020145c:	0007b783          	ld	a5,0(a5)
ffffffe000201460:	00008717          	auipc	a4,0x8
ffffffe000201464:	bd870713          	addi	a4,a4,-1064 # ffffffe000209038 <task>
ffffffe000201468:	00379793          	slli	a5,a5,0x3
ffffffe00020146c:	00f707b3          	add	a5,a4,a5
ffffffe000201470:	0007b783          	ld	a5,0(a5)
ffffffe000201474:	fcf43c23          	sd	a5,-40(s0)
        while(--i){
ffffffe000201478:	06c0006f          	j	ffffffe0002014e4 <schedule+0x17c>
            // if(*--p == NULL)   continue;
            p = task[i];
ffffffe00020147c:	00008717          	auipc	a4,0x8
ffffffe000201480:	bbc70713          	addi	a4,a4,-1092 # ffffffe000209038 <task>
ffffffe000201484:	fec42783          	lw	a5,-20(s0)
ffffffe000201488:	00379793          	slli	a5,a5,0x3
ffffffe00020148c:	00f707b3          	add	a5,a4,a5
ffffffe000201490:	0007b783          	ld	a5,0(a5)
ffffffe000201494:	fcf43c23          	sd	a5,-40(s0)
            if(!p)  continue;
ffffffe000201498:	fd843783          	ld	a5,-40(s0)
ffffffe00020149c:	04078263          	beqz	a5,ffffffe0002014e0 <schedule+0x178>
            p->counter = p->priority;
ffffffe0002014a0:	fd843783          	ld	a5,-40(s0)
ffffffe0002014a4:	0107b703          	ld	a4,16(a5)
ffffffe0002014a8:	fd843783          	ld	a5,-40(s0)
ffffffe0002014ac:	00e7b423          	sd	a4,8(a5)
            printk(GREEN "SET [PID = %ld PRIORITY = %ld COUNTER = %ld]\n" CLEAR, p->pid, p->priority, p->counter);
ffffffe0002014b0:	fd843783          	ld	a5,-40(s0)
ffffffe0002014b4:	0187b703          	ld	a4,24(a5)
ffffffe0002014b8:	fd843783          	ld	a5,-40(s0)
ffffffe0002014bc:	0107b603          	ld	a2,16(a5)
ffffffe0002014c0:	fd843783          	ld	a5,-40(s0)
ffffffe0002014c4:	0087b783          	ld	a5,8(a5)
ffffffe0002014c8:	00078693          	mv	a3,a5
ffffffe0002014cc:	00070593          	mv	a1,a4
ffffffe0002014d0:	00003517          	auipc	a0,0x3
ffffffe0002014d4:	c4850513          	addi	a0,a0,-952 # ffffffe000204118 <_srodata+0x118>
ffffffe0002014d8:	26c020ef          	jal	ffffffe000203744 <printk>
ffffffe0002014dc:	0080006f          	j	ffffffe0002014e4 <schedule+0x17c>
            if(!p)  continue;
ffffffe0002014e0:	00000013          	nop
        while(--i){
ffffffe0002014e4:	fec42783          	lw	a5,-20(s0)
ffffffe0002014e8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002014ec:	fef42623          	sw	a5,-20(s0)
ffffffe0002014f0:	fec42783          	lw	a5,-20(s0)
ffffffe0002014f4:	0007879b          	sext.w	a5,a5
ffffffe0002014f8:	f80792e3          	bnez	a5,ffffffe00020147c <schedule+0x114>
        }
        schedule();
ffffffe0002014fc:	e6dff0ef          	jal	ffffffe000201368 <schedule>
    }
    switch_to(task[chosen_p]);
ffffffe000201500:	00008717          	auipc	a4,0x8
ffffffe000201504:	b3870713          	addi	a4,a4,-1224 # ffffffe000209038 <task>
ffffffe000201508:	fe442783          	lw	a5,-28(s0)
ffffffe00020150c:	00379793          	slli	a5,a5,0x3
ffffffe000201510:	00f707b3          	add	a5,a4,a5
ffffffe000201514:	0007b783          	ld	a5,0(a5)
ffffffe000201518:	00078513          	mv	a0,a5
ffffffe00020151c:	d19ff0ef          	jal	ffffffe000201234 <switch_to>
    return;
ffffffe000201520:	00000013          	nop
ffffffe000201524:	02813083          	ld	ra,40(sp)
ffffffe000201528:	02013403          	ld	s0,32(sp)
ffffffe00020152c:	03010113          	addi	sp,sp,48
ffffffe000201530:	00008067          	ret

ffffffe000201534 <sbi_ecall>:
#include "sbi.h"
#define write_csr(reg, val) ({ asm volatile ( "csrw " #reg ", %0" :: "r"(val)); })
#define read_csr(csr) ({ uint64_t __v; asm volatile("csrr %0, " #csr : "=r"(__v) : : "memory"); __v;                                \})
struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe000201534:	f8010113          	addi	sp,sp,-128
ffffffe000201538:	06113c23          	sd	ra,120(sp)
ffffffe00020153c:	06813823          	sd	s0,112(sp)
ffffffe000201540:	08010413          	addi	s0,sp,128
ffffffe000201544:	faa43c23          	sd	a0,-72(s0)
ffffffe000201548:	fab43823          	sd	a1,-80(s0)
ffffffe00020154c:	fac43423          	sd	a2,-88(s0)
ffffffe000201550:	fad43023          	sd	a3,-96(s0)
ffffffe000201554:	f8e43c23          	sd	a4,-104(s0)
ffffffe000201558:	f8f43823          	sd	a5,-112(s0)
ffffffe00020155c:	f9043423          	sd	a6,-120(s0)
ffffffe000201560:	f9143023          	sd	a7,-128(s0)
    struct sbiret res;
    long error;
    long value;
    asm volatile (
ffffffe000201564:	fb843783          	ld	a5,-72(s0)
ffffffe000201568:	fb043703          	ld	a4,-80(s0)
ffffffe00020156c:	fa843683          	ld	a3,-88(s0)
ffffffe000201570:	fa043603          	ld	a2,-96(s0)
ffffffe000201574:	f9843583          	ld	a1,-104(s0)
ffffffe000201578:	f9043503          	ld	a0,-112(s0)
ffffffe00020157c:	f8843803          	ld	a6,-120(s0)
ffffffe000201580:	f8043883          	ld	a7,-128(s0)
ffffffe000201584:	00078893          	mv	a7,a5
ffffffe000201588:	00070813          	mv	a6,a4
ffffffe00020158c:	00068513          	mv	a0,a3
ffffffe000201590:	00060593          	mv	a1,a2
ffffffe000201594:	00058613          	mv	a2,a1
ffffffe000201598:	00050693          	mv	a3,a0
ffffffe00020159c:	00080713          	mv	a4,a6
ffffffe0002015a0:	00088793          	mv	a5,a7
ffffffe0002015a4:	00000073          	ecall
ffffffe0002015a8:	00050713          	mv	a4,a0
ffffffe0002015ac:	00058793          	mv	a5,a1
ffffffe0002015b0:	fee43423          	sd	a4,-24(s0)
ffffffe0002015b4:	fef43023          	sd	a5,-32(s0)
        : [error] "=r"(error),[value] "=r"(value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory"
    );
    //顺序问题 -- 绑定依然需要顺序 -- 为什么倒序不行
    res.error = error;
ffffffe0002015b8:	fe843783          	ld	a5,-24(s0)
ffffffe0002015bc:	fcf43023          	sd	a5,-64(s0)
    res.value = value;
ffffffe0002015c0:	fe043783          	ld	a5,-32(s0)
ffffffe0002015c4:	fcf43423          	sd	a5,-56(s0)
    return res;
ffffffe0002015c8:	fc043783          	ld	a5,-64(s0)
ffffffe0002015cc:	fcf43823          	sd	a5,-48(s0)
ffffffe0002015d0:	fc843783          	ld	a5,-56(s0)
ffffffe0002015d4:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002015d8:	fd043703          	ld	a4,-48(s0)
ffffffe0002015dc:	fd843783          	ld	a5,-40(s0)
ffffffe0002015e0:	00070313          	mv	t1,a4
ffffffe0002015e4:	00078393          	mv	t2,a5
ffffffe0002015e8:	00030713          	mv	a4,t1
ffffffe0002015ec:	00038793          	mv	a5,t2
}
ffffffe0002015f0:	00070513          	mv	a0,a4
ffffffe0002015f4:	00078593          	mv	a1,a5
ffffffe0002015f8:	07813083          	ld	ra,120(sp)
ffffffe0002015fc:	07013403          	ld	s0,112(sp)
ffffffe000201600:	08010113          	addi	sp,sp,128
ffffffe000201604:	00008067          	ret

ffffffe000201608 <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime) {
ffffffe000201608:	fc010113          	addi	sp,sp,-64
ffffffe00020160c:	02113c23          	sd	ra,56(sp)
ffffffe000201610:	02813823          	sd	s0,48(sp)
ffffffe000201614:	03213423          	sd	s2,40(sp)
ffffffe000201618:	03313023          	sd	s3,32(sp)
ffffffe00020161c:	04010413          	addi	s0,sp,64
ffffffe000201620:	fca43423          	sd	a0,-56(s0)
    return sbi_ecall(0x54494D45, 0x0, stime, 0, 0, 0, 0, 0);
ffffffe000201624:	00000893          	li	a7,0
ffffffe000201628:	00000813          	li	a6,0
ffffffe00020162c:	00000793          	li	a5,0
ffffffe000201630:	00000713          	li	a4,0
ffffffe000201634:	00000693          	li	a3,0
ffffffe000201638:	fc843603          	ld	a2,-56(s0)
ffffffe00020163c:	00000593          	li	a1,0
ffffffe000201640:	54495537          	lui	a0,0x54495
ffffffe000201644:	d4550513          	addi	a0,a0,-699 # 54494d45 <PHY_SIZE+0x4c494d45>
ffffffe000201648:	eedff0ef          	jal	ffffffe000201534 <sbi_ecall>
ffffffe00020164c:	00050713          	mv	a4,a0
ffffffe000201650:	00058793          	mv	a5,a1
ffffffe000201654:	fce43823          	sd	a4,-48(s0)
ffffffe000201658:	fcf43c23          	sd	a5,-40(s0)
ffffffe00020165c:	fd043703          	ld	a4,-48(s0)
ffffffe000201660:	fd843783          	ld	a5,-40(s0)
ffffffe000201664:	00070913          	mv	s2,a4
ffffffe000201668:	00078993          	mv	s3,a5
ffffffe00020166c:	00090713          	mv	a4,s2
ffffffe000201670:	00098793          	mv	a5,s3
}
ffffffe000201674:	00070513          	mv	a0,a4
ffffffe000201678:	00078593          	mv	a1,a5
ffffffe00020167c:	03813083          	ld	ra,56(sp)
ffffffe000201680:	03013403          	ld	s0,48(sp)
ffffffe000201684:	02813903          	ld	s2,40(sp)
ffffffe000201688:	02013983          	ld	s3,32(sp)
ffffffe00020168c:	04010113          	addi	sp,sp,64
ffffffe000201690:	00008067          	ret

ffffffe000201694 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000201694:	fc010113          	addi	sp,sp,-64
ffffffe000201698:	02113c23          	sd	ra,56(sp)
ffffffe00020169c:	02813823          	sd	s0,48(sp)
ffffffe0002016a0:	03213423          	sd	s2,40(sp)
ffffffe0002016a4:	03313023          	sd	s3,32(sp)
ffffffe0002016a8:	04010413          	addi	s0,sp,64
ffffffe0002016ac:	00050793          	mv	a5,a0
ffffffe0002016b0:	fcf407a3          	sb	a5,-49(s0)
    return sbi_ecall(0x4442434E, 0x2, byte, 0, 0, 0, 0, 0);
ffffffe0002016b4:	fcf44603          	lbu	a2,-49(s0)
ffffffe0002016b8:	00000893          	li	a7,0
ffffffe0002016bc:	00000813          	li	a6,0
ffffffe0002016c0:	00000793          	li	a5,0
ffffffe0002016c4:	00000713          	li	a4,0
ffffffe0002016c8:	00000693          	li	a3,0
ffffffe0002016cc:	00200593          	li	a1,2
ffffffe0002016d0:	44424537          	lui	a0,0x44424
ffffffe0002016d4:	34e50513          	addi	a0,a0,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe0002016d8:	e5dff0ef          	jal	ffffffe000201534 <sbi_ecall>
ffffffe0002016dc:	00050713          	mv	a4,a0
ffffffe0002016e0:	00058793          	mv	a5,a1
ffffffe0002016e4:	fce43823          	sd	a4,-48(s0)
ffffffe0002016e8:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002016ec:	fd043703          	ld	a4,-48(s0)
ffffffe0002016f0:	fd843783          	ld	a5,-40(s0)
ffffffe0002016f4:	00070913          	mv	s2,a4
ffffffe0002016f8:	00078993          	mv	s3,a5
ffffffe0002016fc:	00090713          	mv	a4,s2
ffffffe000201700:	00098793          	mv	a5,s3
}
ffffffe000201704:	00070513          	mv	a0,a4
ffffffe000201708:	00078593          	mv	a1,a5
ffffffe00020170c:	03813083          	ld	ra,56(sp)
ffffffe000201710:	03013403          	ld	s0,48(sp)
ffffffe000201714:	02813903          	ld	s2,40(sp)
ffffffe000201718:	02013983          	ld	s3,32(sp)
ffffffe00020171c:	04010113          	addi	sp,sp,64
ffffffe000201720:	00008067          	ret

ffffffe000201724 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe000201724:	fc010113          	addi	sp,sp,-64
ffffffe000201728:	02113c23          	sd	ra,56(sp)
ffffffe00020172c:	02813823          	sd	s0,48(sp)
ffffffe000201730:	03213423          	sd	s2,40(sp)
ffffffe000201734:	03313023          	sd	s3,32(sp)
ffffffe000201738:	04010413          	addi	s0,sp,64
ffffffe00020173c:	00050793          	mv	a5,a0
ffffffe000201740:	00058713          	mv	a4,a1
ffffffe000201744:	fcf42623          	sw	a5,-52(s0)
ffffffe000201748:	00070793          	mv	a5,a4
ffffffe00020174c:	fcf42423          	sw	a5,-56(s0)
    return sbi_ecall(0x53525354, 0x0, 0, 0, 0, 0, 0, 0);
ffffffe000201750:	00000893          	li	a7,0
ffffffe000201754:	00000813          	li	a6,0
ffffffe000201758:	00000793          	li	a5,0
ffffffe00020175c:	00000713          	li	a4,0
ffffffe000201760:	00000693          	li	a3,0
ffffffe000201764:	00000613          	li	a2,0
ffffffe000201768:	00000593          	li	a1,0
ffffffe00020176c:	53525537          	lui	a0,0x53525
ffffffe000201770:	35450513          	addi	a0,a0,852 # 53525354 <PHY_SIZE+0x4b525354>
ffffffe000201774:	dc1ff0ef          	jal	ffffffe000201534 <sbi_ecall>
ffffffe000201778:	00050713          	mv	a4,a0
ffffffe00020177c:	00058793          	mv	a5,a1
ffffffe000201780:	fce43823          	sd	a4,-48(s0)
ffffffe000201784:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201788:	fd043703          	ld	a4,-48(s0)
ffffffe00020178c:	fd843783          	ld	a5,-40(s0)
ffffffe000201790:	00070913          	mv	s2,a4
ffffffe000201794:	00078993          	mv	s3,a5
ffffffe000201798:	00090713          	mv	a4,s2
ffffffe00020179c:	00098793          	mv	a5,s3
ffffffe0002017a0:	00070513          	mv	a0,a4
ffffffe0002017a4:	00078593          	mv	a1,a5
ffffffe0002017a8:	03813083          	ld	ra,56(sp)
ffffffe0002017ac:	03013403          	ld	s0,48(sp)
ffffffe0002017b0:	02813903          	ld	s2,40(sp)
ffffffe0002017b4:	02013983          	ld	s3,32(sp)
ffffffe0002017b8:	04010113          	addi	sp,sp,64
ffffffe0002017bc:	00008067          	ret

ffffffe0002017c0 <sys_write>:

extern struct sbiret sbi_debug_console_write_byte(uint8_t byte);
extern void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);


uint64_t sys_write(unsigned int fd, const char* buf, size_t count){
ffffffe0002017c0:	fc010113          	addi	sp,sp,-64
ffffffe0002017c4:	02113c23          	sd	ra,56(sp)
ffffffe0002017c8:	02813823          	sd	s0,48(sp)
ffffffe0002017cc:	04010413          	addi	s0,sp,64
ffffffe0002017d0:	00050793          	mv	a5,a0
ffffffe0002017d4:	fcb43823          	sd	a1,-48(s0)
ffffffe0002017d8:	fcc43423          	sd	a2,-56(s0)
ffffffe0002017dc:	fcf42e23          	sw	a5,-36(s0)
    uint64_t cnt = 0;
ffffffe0002017e0:	fe043423          	sd	zero,-24(s0)
    while (cnt < count){
ffffffe0002017e4:	0340006f          	j	ffffffe000201818 <sys_write+0x58>
        printk("%c", buf[cnt]);
ffffffe0002017e8:	fd043703          	ld	a4,-48(s0)
ffffffe0002017ec:	fe843783          	ld	a5,-24(s0)
ffffffe0002017f0:	00f707b3          	add	a5,a4,a5
ffffffe0002017f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002017f8:	0007879b          	sext.w	a5,a5
ffffffe0002017fc:	00078593          	mv	a1,a5
ffffffe000201800:	00003517          	auipc	a0,0x3
ffffffe000201804:	95050513          	addi	a0,a0,-1712 # ffffffe000204150 <_srodata+0x150>
ffffffe000201808:	73d010ef          	jal	ffffffe000203744 <printk>
        cnt++;
ffffffe00020180c:	fe843783          	ld	a5,-24(s0)
ffffffe000201810:	00178793          	addi	a5,a5,1
ffffffe000201814:	fef43423          	sd	a5,-24(s0)
    while (cnt < count){
ffffffe000201818:	fe843703          	ld	a4,-24(s0)
ffffffe00020181c:	fc843783          	ld	a5,-56(s0)
ffffffe000201820:	fcf764e3          	bltu	a4,a5,ffffffe0002017e8 <sys_write+0x28>
    }
    return cnt;
ffffffe000201824:	fe843783          	ld	a5,-24(s0)
}
ffffffe000201828:	00078513          	mv	a0,a5
ffffffe00020182c:	03813083          	ld	ra,56(sp)
ffffffe000201830:	03013403          	ld	s0,48(sp)
ffffffe000201834:	04010113          	addi	sp,sp,64
ffffffe000201838:	00008067          	ret

ffffffe00020183c <sys_getpid>:

uint64_t sys_getpid(){
ffffffe00020183c:	ff010113          	addi	sp,sp,-16
ffffffe000201840:	00113423          	sd	ra,8(sp)
ffffffe000201844:	00813023          	sd	s0,0(sp)
ffffffe000201848:	01010413          	addi	s0,sp,16
    return current->pid;
ffffffe00020184c:	00007797          	auipc	a5,0x7
ffffffe000201850:	7c478793          	addi	a5,a5,1988 # ffffffe000209010 <current>
ffffffe000201854:	0007b783          	ld	a5,0(a5)
ffffffe000201858:	0187b783          	ld	a5,24(a5)
}
ffffffe00020185c:	00078513          	mv	a0,a5
ffffffe000201860:	00813083          	ld	ra,8(sp)
ffffffe000201864:	00013403          	ld	s0,0(sp)
ffffffe000201868:	01010113          	addi	sp,sp,16
ffffffe00020186c:	00008067          	ret

ffffffe000201870 <do_fork>:

uint64_t do_fork(struct pt_regs *regs){
ffffffe000201870:	f6010113          	addi	sp,sp,-160
ffffffe000201874:	08113c23          	sd	ra,152(sp)
ffffffe000201878:	08813823          	sd	s0,144(sp)
ffffffe00020187c:	0a010413          	addi	s0,sp,160
ffffffe000201880:	f6a43423          	sd	a0,-152(s0)
    printk("addr of reg/sp: %lx\n", regs);
ffffffe000201884:	f6843583          	ld	a1,-152(s0)
ffffffe000201888:	00003517          	auipc	a0,0x3
ffffffe00020188c:	8d050513          	addi	a0,a0,-1840 # ffffffe000204158 <_srodata+0x158>
ffffffe000201890:	6b5010ef          	jal	ffffffe000203744 <printk>
    // Err("unfinished\n");
    nr_tasks++;
ffffffe000201894:	00003797          	auipc	a5,0x3
ffffffe000201898:	77c78793          	addi	a5,a5,1916 # ffffffe000205010 <nr_tasks>
ffffffe00020189c:	0007b783          	ld	a5,0(a5)
ffffffe0002018a0:	00178713          	addi	a4,a5,1
ffffffe0002018a4:	00003797          	auipc	a5,0x3
ffffffe0002018a8:	76c78793          	addi	a5,a5,1900 # ffffffe000205010 <nr_tasks>
ffffffe0002018ac:	00e7b023          	sd	a4,0(a5)
    printk("now nrtasks: %lu\n", nr_tasks);
ffffffe0002018b0:	00003797          	auipc	a5,0x3
ffffffe0002018b4:	76078793          	addi	a5,a5,1888 # ffffffe000205010 <nr_tasks>
ffffffe0002018b8:	0007b783          	ld	a5,0(a5)
ffffffe0002018bc:	00078593          	mv	a1,a5
ffffffe0002018c0:	00003517          	auipc	a0,0x3
ffffffe0002018c4:	8b050513          	addi	a0,a0,-1872 # ffffffe000204170 <_srodata+0x170>
ffffffe0002018c8:	67d010ef          	jal	ffffffe000203744 <printk>
    struct task_struct *_task = alloc_page();
ffffffe0002018cc:	8d0ff0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe0002018d0:	fca43823          	sd	a0,-48(s0)
    memcpy(_task, current, PGSIZE);
ffffffe0002018d4:	00007797          	auipc	a5,0x7
ffffffe0002018d8:	73c78793          	addi	a5,a5,1852 # ffffffe000209010 <current>
ffffffe0002018dc:	0007b783          	ld	a5,0(a5)
ffffffe0002018e0:	00001637          	lui	a2,0x1
ffffffe0002018e4:	00078593          	mv	a1,a5
ffffffe0002018e8:	fd043503          	ld	a0,-48(s0)
ffffffe0002018ec:	000020ef          	jal	ffffffe0002038ec <memcpy>
    task[nr_tasks-1] = _task;
ffffffe0002018f0:	00003797          	auipc	a5,0x3
ffffffe0002018f4:	72078793          	addi	a5,a5,1824 # ffffffe000205010 <nr_tasks>
ffffffe0002018f8:	0007b783          	ld	a5,0(a5)
ffffffe0002018fc:	fff78793          	addi	a5,a5,-1
ffffffe000201900:	00007717          	auipc	a4,0x7
ffffffe000201904:	73870713          	addi	a4,a4,1848 # ffffffe000209038 <task>
ffffffe000201908:	00379793          	slli	a5,a5,0x3
ffffffe00020190c:	00f707b3          	add	a5,a4,a5
ffffffe000201910:	fd043703          	ld	a4,-48(s0)
ffffffe000201914:	00e7b023          	sd	a4,0(a5)
    uint64_t *_pgd = alloc_page();
ffffffe000201918:	884ff0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe00020191c:	fca43423          	sd	a0,-56(s0)
    memset(_pgd, 0, PGSIZE);
ffffffe000201920:	00001637          	lui	a2,0x1
ffffffe000201924:	00000593          	li	a1,0
ffffffe000201928:	fc843503          	ld	a0,-56(s0)
ffffffe00020192c:	749010ef          	jal	ffffffe000203874 <memset>
    _task->pid = nr_tasks - 1;
ffffffe000201930:	00003797          	auipc	a5,0x3
ffffffe000201934:	6e078793          	addi	a5,a5,1760 # ffffffe000205010 <nr_tasks>
ffffffe000201938:	0007b783          	ld	a5,0(a5)
ffffffe00020193c:	fff78713          	addi	a4,a5,-1
ffffffe000201940:	fd043783          	ld	a5,-48(s0)
ffffffe000201944:	00e7bc23          	sd	a4,24(a5)
    _task->pgd = _pgd;
ffffffe000201948:	fd043783          	ld	a5,-48(s0)
ffffffe00020194c:	fc843703          	ld	a4,-56(s0)
ffffffe000201950:	0ae7b423          	sd	a4,168(a5)
    _task->thread.ra = (uint64_t)__ret_from_fork;
ffffffe000201954:	ffffe717          	auipc	a4,0xffffe
ffffffe000201958:	7f870713          	addi	a4,a4,2040 # ffffffe00020014c <__ret_from_fork>
ffffffe00020195c:	fd043783          	ld	a5,-48(s0)
ffffffe000201960:	02e7b023          	sd	a4,32(a5)
    _task->mm.mmap = NULL;
ffffffe000201964:	fd043783          	ld	a5,-48(s0)
ffffffe000201968:	0a07b823          	sd	zero,176(a5)
    for(uint64_t i = 0; i < 512;i++){
ffffffe00020196c:	fe043423          	sd	zero,-24(s0)
ffffffe000201970:	03c0006f          	j	ffffffe0002019ac <do_fork+0x13c>
        _pgd[i] = swapper_pg_dir[i];
ffffffe000201974:	fe843783          	ld	a5,-24(s0)
ffffffe000201978:	00379793          	slli	a5,a5,0x3
ffffffe00020197c:	fc843703          	ld	a4,-56(s0)
ffffffe000201980:	00f707b3          	add	a5,a4,a5
ffffffe000201984:	00009697          	auipc	a3,0x9
ffffffe000201988:	67c68693          	addi	a3,a3,1660 # ffffffe00020b000 <swapper_pg_dir>
ffffffe00020198c:	fe843703          	ld	a4,-24(s0)
ffffffe000201990:	00371713          	slli	a4,a4,0x3
ffffffe000201994:	00e68733          	add	a4,a3,a4
ffffffe000201998:	00073703          	ld	a4,0(a4)
ffffffe00020199c:	00e7b023          	sd	a4,0(a5)
    for(uint64_t i = 0; i < 512;i++){
ffffffe0002019a0:	fe843783          	ld	a5,-24(s0)
ffffffe0002019a4:	00178793          	addi	a5,a5,1
ffffffe0002019a8:	fef43423          	sd	a5,-24(s0)
ffffffe0002019ac:	fe843703          	ld	a4,-24(s0)
ffffffe0002019b0:	1ff00793          	li	a5,511
ffffffe0002019b4:	fce7f0e3          	bgeu	a5,a4,ffffffe000201974 <do_fork+0x104>
    }

    struct vm_area_struct *tmp_vma = current->mm.mmap;
ffffffe0002019b8:	00007797          	auipc	a5,0x7
ffffffe0002019bc:	65878793          	addi	a5,a5,1624 # ffffffe000209010 <current>
ffffffe0002019c0:	0007b783          	ld	a5,0(a5)
ffffffe0002019c4:	0b07b783          	ld	a5,176(a5)
ffffffe0002019c8:	fef43023          	sd	a5,-32(s0)
    while(tmp_vma != NULL){
ffffffe0002019cc:	2380006f          	j	ffffffe000201c04 <do_fork+0x394>
        struct vm_area_struct *new_vma = alloc_page();
ffffffe0002019d0:	fcdfe0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe0002019d4:	faa43823          	sd	a0,-80(s0)
        memcpy(new_vma, tmp_vma, PGSIZE);
ffffffe0002019d8:	00001637          	lui	a2,0x1
ffffffe0002019dc:	fe043583          	ld	a1,-32(s0)
ffffffe0002019e0:	fb043503          	ld	a0,-80(s0)
ffffffe0002019e4:	709010ef          	jal	ffffffe0002038ec <memcpy>
        new_vma->vm_next = _task->mm.mmap;
ffffffe0002019e8:	fd043783          	ld	a5,-48(s0)
ffffffe0002019ec:	0b07b703          	ld	a4,176(a5)
ffffffe0002019f0:	fb043783          	ld	a5,-80(s0)
ffffffe0002019f4:	00e7bc23          	sd	a4,24(a5)
        new_vma->vm_prev = NULL;
ffffffe0002019f8:	fb043783          	ld	a5,-80(s0)
ffffffe0002019fc:	0207b023          	sd	zero,32(a5)
        _task->mm.mmap = new_vma;
ffffffe000201a00:	fd043783          	ld	a5,-48(s0)
ffffffe000201a04:	fb043703          	ld	a4,-80(s0)
ffffffe000201a08:	0ae7b823          	sd	a4,176(a5)
        //read and map
        uint64_t page_addr = new_vma->vm_start;
ffffffe000201a0c:	fb043783          	ld	a5,-80(s0)
ffffffe000201a10:	0087b783          	ld	a5,8(a5)
ffffffe000201a14:	fcf43c23          	sd	a5,-40(s0)
        for(;page_addr < new_vma->vm_end;){
ffffffe000201a18:	1d00006f          	j	ffffffe000201be8 <do_fork+0x378>
            uint64_t *tmptbl = current->pgd;
ffffffe000201a1c:	00007797          	auipc	a5,0x7
ffffffe000201a20:	5f478793          	addi	a5,a5,1524 # ffffffe000209010 <current>
ffffffe000201a24:	0007b783          	ld	a5,0(a5)
ffffffe000201a28:	0a87b783          	ld	a5,168(a5)
ffffffe000201a2c:	faf43423          	sd	a5,-88(s0)
            uint64_t vpn2 = (page_addr >> 30) & 0x1ff;
ffffffe000201a30:	fd843783          	ld	a5,-40(s0)
ffffffe000201a34:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201a38:	1ff7f793          	andi	a5,a5,511
ffffffe000201a3c:	faf43023          	sd	a5,-96(s0)
            uint64_t vpn1 = (page_addr >> 21) & 0x1ff;
ffffffe000201a40:	fd843783          	ld	a5,-40(s0)
ffffffe000201a44:	0157d793          	srli	a5,a5,0x15
ffffffe000201a48:	1ff7f793          	andi	a5,a5,511
ffffffe000201a4c:	f8f43c23          	sd	a5,-104(s0)
            uint64_t vpn0 = (page_addr >> 12) & 0x1ff;
ffffffe000201a50:	fd843783          	ld	a5,-40(s0)
ffffffe000201a54:	00c7d793          	srli	a5,a5,0xc
ffffffe000201a58:	1ff7f793          	andi	a5,a5,511
ffffffe000201a5c:	f8f43823          	sd	a5,-112(s0)
            uint64_t pte = tmptbl[vpn2];
ffffffe000201a60:	fa043783          	ld	a5,-96(s0)
ffffffe000201a64:	00379793          	slli	a5,a5,0x3
ffffffe000201a68:	fa843703          	ld	a4,-88(s0)
ffffffe000201a6c:	00f707b3          	add	a5,a4,a5
ffffffe000201a70:	0007b783          	ld	a5,0(a5)
ffffffe000201a74:	f8f43423          	sd	a5,-120(s0)
            if ((pte & 0x1) == 0){
ffffffe000201a78:	f8843783          	ld	a5,-120(s0)
ffffffe000201a7c:	0017f793          	andi	a5,a5,1
ffffffe000201a80:	02079063          	bnez	a5,ffffffe000201aa0 <do_fork+0x230>
                page_addr = PGROUNDDOWN(page_addr + PGSIZE);       
ffffffe000201a84:	fd843703          	ld	a4,-40(s0)
ffffffe000201a88:	000017b7          	lui	a5,0x1
ffffffe000201a8c:	00f70733          	add	a4,a4,a5
ffffffe000201a90:	fffff7b7          	lui	a5,0xfffff
ffffffe000201a94:	00f777b3          	and	a5,a4,a5
ffffffe000201a98:	fcf43c23          	sd	a5,-40(s0)
                continue;
ffffffe000201a9c:	14c0006f          	j	ffffffe000201be8 <do_fork+0x378>
            }
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
ffffffe000201aa0:	f8843783          	ld	a5,-120(s0)
ffffffe000201aa4:	00a7d793          	srli	a5,a5,0xa
ffffffe000201aa8:	00c79713          	slli	a4,a5,0xc
ffffffe000201aac:	fbf00793          	li	a5,-65
ffffffe000201ab0:	01f79793          	slli	a5,a5,0x1f
ffffffe000201ab4:	00f707b3          	add	a5,a4,a5
ffffffe000201ab8:	faf43423          	sd	a5,-88(s0)
            pte = tmptbl[vpn1];
ffffffe000201abc:	f9843783          	ld	a5,-104(s0)
ffffffe000201ac0:	00379793          	slli	a5,a5,0x3
ffffffe000201ac4:	fa843703          	ld	a4,-88(s0)
ffffffe000201ac8:	00f707b3          	add	a5,a4,a5
ffffffe000201acc:	0007b783          	ld	a5,0(a5) # fffffffffffff000 <VM_END+0xfffff000>
ffffffe000201ad0:	f8f43423          	sd	a5,-120(s0)
            if ((pte & 0x1) == 0){
ffffffe000201ad4:	f8843783          	ld	a5,-120(s0)
ffffffe000201ad8:	0017f793          	andi	a5,a5,1
ffffffe000201adc:	02079063          	bnez	a5,ffffffe000201afc <do_fork+0x28c>
                page_addr = PGROUNDDOWN(page_addr + PGSIZE);       
ffffffe000201ae0:	fd843703          	ld	a4,-40(s0)
ffffffe000201ae4:	000017b7          	lui	a5,0x1
ffffffe000201ae8:	00f70733          	add	a4,a4,a5
ffffffe000201aec:	fffff7b7          	lui	a5,0xfffff
ffffffe000201af0:	00f777b3          	and	a5,a4,a5
ffffffe000201af4:	fcf43c23          	sd	a5,-40(s0)
                continue;
ffffffe000201af8:	0f00006f          	j	ffffffe000201be8 <do_fork+0x378>
            }
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
ffffffe000201afc:	f8843783          	ld	a5,-120(s0)
ffffffe000201b00:	00a7d793          	srli	a5,a5,0xa
ffffffe000201b04:	00c79713          	slli	a4,a5,0xc
ffffffe000201b08:	fbf00793          	li	a5,-65
ffffffe000201b0c:	01f79793          	slli	a5,a5,0x1f
ffffffe000201b10:	00f707b3          	add	a5,a4,a5
ffffffe000201b14:	faf43423          	sd	a5,-88(s0)
            pte = tmptbl[vpn0];
ffffffe000201b18:	f9043783          	ld	a5,-112(s0)
ffffffe000201b1c:	00379793          	slli	a5,a5,0x3
ffffffe000201b20:	fa843703          	ld	a4,-88(s0)
ffffffe000201b24:	00f707b3          	add	a5,a4,a5
ffffffe000201b28:	0007b783          	ld	a5,0(a5) # fffffffffffff000 <VM_END+0xfffff000>
ffffffe000201b2c:	f8f43423          	sd	a5,-120(s0)
            if ((pte & 0x1) == 0){
ffffffe000201b30:	f8843783          	ld	a5,-120(s0)
ffffffe000201b34:	0017f793          	andi	a5,a5,1
ffffffe000201b38:	02079063          	bnez	a5,ffffffe000201b58 <do_fork+0x2e8>
                page_addr = PGROUNDDOWN(page_addr + PGSIZE);       
ffffffe000201b3c:	fd843703          	ld	a4,-40(s0)
ffffffe000201b40:	000017b7          	lui	a5,0x1
ffffffe000201b44:	00f70733          	add	a4,a4,a5
ffffffe000201b48:	fffff7b7          	lui	a5,0xfffff
ffffffe000201b4c:	00f777b3          	and	a5,a4,a5
ffffffe000201b50:	fcf43c23          	sd	a5,-40(s0)
                continue;
ffffffe000201b54:	0940006f          	j	ffffffe000201be8 <do_fork+0x378>
            }
            uint64_t *copy_addr = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
ffffffe000201b58:	f8843783          	ld	a5,-120(s0)
ffffffe000201b5c:	00a7d793          	srli	a5,a5,0xa
ffffffe000201b60:	00c79713          	slli	a4,a5,0xc
ffffffe000201b64:	fbf00793          	li	a5,-65
ffffffe000201b68:	01f79793          	slli	a5,a5,0x1f
ffffffe000201b6c:	00f707b3          	add	a5,a4,a5
ffffffe000201b70:	f8f43023          	sd	a5,-128(s0)
            uint64_t *phy_addr = alloc_page();
ffffffe000201b74:	e29fe0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000201b78:	f6a43c23          	sd	a0,-136(s0)
            memset(phy_addr, 0, PGSIZE);
ffffffe000201b7c:	00001637          	lui	a2,0x1
ffffffe000201b80:	00000593          	li	a1,0
ffffffe000201b84:	f7843503          	ld	a0,-136(s0)
ffffffe000201b88:	4ed010ef          	jal	ffffffe000203874 <memset>
            memcpy(phy_addr, copy_addr, PGSIZE);
ffffffe000201b8c:	00001637          	lui	a2,0x1
ffffffe000201b90:	f8043583          	ld	a1,-128(s0)
ffffffe000201b94:	f7843503          	ld	a0,-136(s0)
ffffffe000201b98:	555010ef          	jal	ffffffe0002038ec <memcpy>
            create_mapping(_task->pgd, PGROUNDDOWN(page_addr), (uint64_t)phy_addr - PA2VA_OFFSET, PGSIZE, 0x1f);
ffffffe000201b9c:	fd043783          	ld	a5,-48(s0)
ffffffe000201ba0:	0a87b503          	ld	a0,168(a5) # fffffffffffff0a8 <VM_END+0xfffff0a8>
ffffffe000201ba4:	fd843703          	ld	a4,-40(s0)
ffffffe000201ba8:	fffff7b7          	lui	a5,0xfffff
ffffffe000201bac:	00f775b3          	and	a1,a4,a5
ffffffe000201bb0:	f7843703          	ld	a4,-136(s0)
ffffffe000201bb4:	04100793          	li	a5,65
ffffffe000201bb8:	01f79793          	slli	a5,a5,0x1f
ffffffe000201bbc:	00f707b3          	add	a5,a4,a5
ffffffe000201bc0:	01f00713          	li	a4,31
ffffffe000201bc4:	000016b7          	lui	a3,0x1
ffffffe000201bc8:	00078613          	mv	a2,a5
ffffffe000201bcc:	189000ef          	jal	ffffffe000202554 <create_mapping>

            page_addr = PGROUNDDOWN(page_addr + PGSIZE);       
ffffffe000201bd0:	fd843703          	ld	a4,-40(s0)
ffffffe000201bd4:	000017b7          	lui	a5,0x1
ffffffe000201bd8:	00f70733          	add	a4,a4,a5
ffffffe000201bdc:	fffff7b7          	lui	a5,0xfffff
ffffffe000201be0:	00f777b3          	and	a5,a4,a5
ffffffe000201be4:	fcf43c23          	sd	a5,-40(s0)
        for(;page_addr < new_vma->vm_end;){
ffffffe000201be8:	fb043783          	ld	a5,-80(s0)
ffffffe000201bec:	0107b783          	ld	a5,16(a5) # fffffffffffff010 <VM_END+0xfffff010>
ffffffe000201bf0:	fd843703          	ld	a4,-40(s0)
ffffffe000201bf4:	e2f764e3          	bltu	a4,a5,ffffffe000201a1c <do_fork+0x1ac>
        }

        tmp_vma = tmp_vma->vm_next;
ffffffe000201bf8:	fe043783          	ld	a5,-32(s0)
ffffffe000201bfc:	0187b783          	ld	a5,24(a5)
ffffffe000201c00:	fef43023          	sd	a5,-32(s0)
    while(tmp_vma != NULL){
ffffffe000201c04:	fe043783          	ld	a5,-32(s0)
ffffffe000201c08:	dc0794e3          	bnez	a5,ffffffe0002019d0 <do_fork+0x160>
    }
    _task->thread.sp = ((uint64_t)regs & 0xfff) + (uint64_t)_task;
ffffffe000201c0c:	f6843703          	ld	a4,-152(s0)
ffffffe000201c10:	000017b7          	lui	a5,0x1
ffffffe000201c14:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201c18:	00f77733          	and	a4,a4,a5
ffffffe000201c1c:	fd043783          	ld	a5,-48(s0)
ffffffe000201c20:	00f70733          	add	a4,a4,a5
ffffffe000201c24:	fd043783          	ld	a5,-48(s0)
ffffffe000201c28:	02e7b423          	sd	a4,40(a5)
    struct pt_regs *child_regs = (struct pt_regs*)_task->thread.sp;
ffffffe000201c2c:	fd043783          	ld	a5,-48(s0)
ffffffe000201c30:	0287b783          	ld	a5,40(a5)
ffffffe000201c34:	fcf43023          	sd	a5,-64(s0)
    _task->thread.sepc = _task->thread.sepc + 4;
ffffffe000201c38:	fd043783          	ld	a5,-48(s0)
ffffffe000201c3c:	0907b783          	ld	a5,144(a5)
ffffffe000201c40:	00478713          	addi	a4,a5,4
ffffffe000201c44:	fd043783          	ld	a5,-48(s0)
ffffffe000201c48:	08e7b823          	sd	a4,144(a5)
    child_regs->sepc = _task->thread.sepc;
ffffffe000201c4c:	fd043783          	ld	a5,-48(s0)
ffffffe000201c50:	0907b703          	ld	a4,144(a5)
ffffffe000201c54:	fc043783          	ld	a5,-64(s0)
ffffffe000201c58:	0ee7b823          	sd	a4,240(a5)
    _task->thread.sscratch = csr_read(sscratch);
ffffffe000201c5c:	140027f3          	csrr	a5,sscratch
ffffffe000201c60:	faf43c23          	sd	a5,-72(s0)
ffffffe000201c64:	fb843703          	ld	a4,-72(s0)
ffffffe000201c68:	fd043783          	ld	a5,-48(s0)
ffffffe000201c6c:	0ae7b023          	sd	a4,160(a5)
    
    return nr_tasks;
ffffffe000201c70:	00003797          	auipc	a5,0x3
ffffffe000201c74:	3a078793          	addi	a5,a5,928 # ffffffe000205010 <nr_tasks>
ffffffe000201c78:	0007b783          	ld	a5,0(a5)
}
ffffffe000201c7c:	00078513          	mv	a0,a5
ffffffe000201c80:	09813083          	ld	ra,152(sp)
ffffffe000201c84:	09013403          	ld	s0,144(sp)
ffffffe000201c88:	0a010113          	addi	sp,sp,160
ffffffe000201c8c:	00008067          	ret

ffffffe000201c90 <trap_handler>:
extern uint64_t sys_write(unsigned int fd, const char* buf, size_t count);
extern uint64_t do_fork(struct pt_regs *regs);
extern uint64_t sys_getpid();
void do_page_fault(struct pt_regs *regs, uint64_t scause);

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs) {
ffffffe000201c90:	fd010113          	addi	sp,sp,-48
ffffffe000201c94:	02113423          	sd	ra,40(sp)
ffffffe000201c98:	02813023          	sd	s0,32(sp)
ffffffe000201c9c:	03010413          	addi	s0,sp,48
ffffffe000201ca0:	fea43423          	sd	a0,-24(s0)
ffffffe000201ca4:	feb43023          	sd	a1,-32(s0)
ffffffe000201ca8:	fcc43c23          	sd	a2,-40(s0)

    // Log("[S] the scause is %lx\n", scause);
    if (scause & (0x8000000000000000)) {
ffffffe000201cac:	fe843783          	ld	a5,-24(s0)
ffffffe000201cb0:	0207da63          	bgez	a5,ffffffe000201ce4 <trap_handler+0x54>
        if (scause == 0x8000000000000005) {
ffffffe000201cb4:	fe843703          	ld	a4,-24(s0)
ffffffe000201cb8:	fff00793          	li	a5,-1
ffffffe000201cbc:	03f79793          	slli	a5,a5,0x3f
ffffffe000201cc0:	00578793          	addi	a5,a5,5
ffffffe000201cc4:	00f71863          	bne	a4,a5,ffffffe000201cd4 <trap_handler+0x44>
            // printk("[S] is time interrupt\n");
            clock_set_next_event();
ffffffe000201cc8:	e38fe0ef          	jal	ffffffe000200300 <clock_set_next_event>
            do_timer();
ffffffe000201ccc:	e08ff0ef          	jal	ffffffe0002012d4 <do_timer>
            // uint64_t ss = csr_read(sstatus);
            // printk("sstatus is: %ld", ss);
            // csr_write(sscratch, 0x0001001001001000);
            return;
ffffffe000201cd0:	1a00006f          	j	ffffffe000201e70 <trap_handler+0x1e0>
        } else {
            printk("not time interrupt\n");
ffffffe000201cd4:	00002517          	auipc	a0,0x2
ffffffe000201cd8:	4b450513          	addi	a0,a0,1204 # ffffffe000204188 <_srodata+0x188>
ffffffe000201cdc:	269010ef          	jal	ffffffe000203744 <printk>
            return;
ffffffe000201ce0:	1900006f          	j	ffffffe000201e70 <trap_handler+0x1e0>
        }
    } else {
        // printk("[S] not interrupt\n");
        if (scause == 0x8) {
ffffffe000201ce4:	fe843703          	ld	a4,-24(s0)
ffffffe000201ce8:	00800793          	li	a5,8
ffffffe000201cec:	10f71263          	bne	a4,a5,ffffffe000201df0 <trap_handler+0x160>
            // printk("[S] is ecall from U-mode\n");
            if (regs->a7 == SYS_GETPID){
ffffffe000201cf0:	fd843783          	ld	a5,-40(s0)
ffffffe000201cf4:	0787b703          	ld	a4,120(a5)
ffffffe000201cf8:	0ac00793          	li	a5,172
ffffffe000201cfc:	02f71663          	bne	a4,a5,ffffffe000201d28 <trap_handler+0x98>
                regs->a0 = sys_getpid();
ffffffe000201d00:	b3dff0ef          	jal	ffffffe00020183c <sys_getpid>
ffffffe000201d04:	00050713          	mv	a4,a0
ffffffe000201d08:	fd843783          	ld	a5,-40(s0)
ffffffe000201d0c:	04e7b023          	sd	a4,64(a5)
                // printk("return of sys_getpid: %lx\n", regs->a0);
                regs->sepc += 4;
ffffffe000201d10:	fd843783          	ld	a5,-40(s0)
ffffffe000201d14:	0f07b783          	ld	a5,240(a5)
ffffffe000201d18:	00478713          	addi	a4,a5,4
ffffffe000201d1c:	fd843783          	ld	a5,-40(s0)
ffffffe000201d20:	0ee7b823          	sd	a4,240(a5)
            // Err("Unhandled Exception, scause=%d", myscause);
            do_page_fault(regs, scause);
        } else {
            Err("Other Unhandled Exception, scause=%d", scause);
        }
        return;
ffffffe000201d24:	14c0006f          	j	ffffffe000201e70 <trap_handler+0x1e0>
            } else if (regs->a7 == SYS_WRITE){
ffffffe000201d28:	fd843783          	ld	a5,-40(s0)
ffffffe000201d2c:	0787b703          	ld	a4,120(a5)
ffffffe000201d30:	04000793          	li	a5,64
ffffffe000201d34:	04f71c63          	bne	a4,a5,ffffffe000201d8c <trap_handler+0xfc>
                regs->a0 = sys_write((uint64_t)regs->a0, (char*)regs->a1, (uint64_t)regs->a2);
ffffffe000201d38:	fd843783          	ld	a5,-40(s0)
ffffffe000201d3c:	0407b783          	ld	a5,64(a5)
ffffffe000201d40:	0007871b          	sext.w	a4,a5
ffffffe000201d44:	fd843783          	ld	a5,-40(s0)
ffffffe000201d48:	0487b783          	ld	a5,72(a5)
ffffffe000201d4c:	00078693          	mv	a3,a5
ffffffe000201d50:	fd843783          	ld	a5,-40(s0)
ffffffe000201d54:	0507b783          	ld	a5,80(a5)
ffffffe000201d58:	00078613          	mv	a2,a5
ffffffe000201d5c:	00068593          	mv	a1,a3
ffffffe000201d60:	00070513          	mv	a0,a4
ffffffe000201d64:	a5dff0ef          	jal	ffffffe0002017c0 <sys_write>
ffffffe000201d68:	00050713          	mv	a4,a0
ffffffe000201d6c:	fd843783          	ld	a5,-40(s0)
ffffffe000201d70:	04e7b023          	sd	a4,64(a5)
                regs->sepc += 4;
ffffffe000201d74:	fd843783          	ld	a5,-40(s0)
ffffffe000201d78:	0f07b783          	ld	a5,240(a5)
ffffffe000201d7c:	00478713          	addi	a4,a5,4
ffffffe000201d80:	fd843783          	ld	a5,-40(s0)
ffffffe000201d84:	0ee7b823          	sd	a4,240(a5)
        return;
ffffffe000201d88:	0e80006f          	j	ffffffe000201e70 <trap_handler+0x1e0>
            } else if (regs->a7 == SYS_CLONE){
ffffffe000201d8c:	fd843783          	ld	a5,-40(s0)
ffffffe000201d90:	0787b703          	ld	a4,120(a5)
ffffffe000201d94:	0dc00793          	li	a5,220
ffffffe000201d98:	02f71863          	bne	a4,a5,ffffffe000201dc8 <trap_handler+0x138>
                regs->a0 = do_fork(regs);
ffffffe000201d9c:	fd843503          	ld	a0,-40(s0)
ffffffe000201da0:	ad1ff0ef          	jal	ffffffe000201870 <do_fork>
ffffffe000201da4:	00050713          	mv	a4,a0
ffffffe000201da8:	fd843783          	ld	a5,-40(s0)
ffffffe000201dac:	04e7b023          	sd	a4,64(a5)
                regs->sepc += 4;
ffffffe000201db0:	fd843783          	ld	a5,-40(s0)
ffffffe000201db4:	0f07b783          	ld	a5,240(a5)
ffffffe000201db8:	00478713          	addi	a4,a5,4
ffffffe000201dbc:	fd843783          	ld	a5,-40(s0)
ffffffe000201dc0:	0ee7b823          	sd	a4,240(a5)
        return;
ffffffe000201dc4:	0ac0006f          	j	ffffffe000201e70 <trap_handler+0x1e0>
                Err("Unimplemented Syscall!\n");
ffffffe000201dc8:	00002697          	auipc	a3,0x2
ffffffe000201dcc:	54868693          	addi	a3,a3,1352 # ffffffe000204310 <__func__.1>
ffffffe000201dd0:	03400613          	li	a2,52
ffffffe000201dd4:	00002597          	auipc	a1,0x2
ffffffe000201dd8:	3cc58593          	addi	a1,a1,972 # ffffffe0002041a0 <_srodata+0x1a0>
ffffffe000201ddc:	00002517          	auipc	a0,0x2
ffffffe000201de0:	3cc50513          	addi	a0,a0,972 # ffffffe0002041a8 <_srodata+0x1a8>
ffffffe000201de4:	161010ef          	jal	ffffffe000203744 <printk>
ffffffe000201de8:	00000013          	nop
ffffffe000201dec:	ffdff06f          	j	ffffffe000201de8 <trap_handler+0x158>
        } else if (scause == 0xc){
ffffffe000201df0:	fe843703          	ld	a4,-24(s0)
ffffffe000201df4:	00c00793          	li	a5,12
ffffffe000201df8:	00f71a63          	bne	a4,a5,ffffffe000201e0c <trap_handler+0x17c>
            do_page_fault(regs, scause);
ffffffe000201dfc:	fe843583          	ld	a1,-24(s0)
ffffffe000201e00:	fd843503          	ld	a0,-40(s0)
ffffffe000201e04:	07c000ef          	jal	ffffffe000201e80 <do_page_fault>
        return;
ffffffe000201e08:	0680006f          	j	ffffffe000201e70 <trap_handler+0x1e0>
        } else if (scause == 0xd){
ffffffe000201e0c:	fe843703          	ld	a4,-24(s0)
ffffffe000201e10:	00d00793          	li	a5,13
ffffffe000201e14:	00f71a63          	bne	a4,a5,ffffffe000201e28 <trap_handler+0x198>
            do_page_fault(regs, scause);
ffffffe000201e18:	fe843583          	ld	a1,-24(s0)
ffffffe000201e1c:	fd843503          	ld	a0,-40(s0)
ffffffe000201e20:	060000ef          	jal	ffffffe000201e80 <do_page_fault>
        return;
ffffffe000201e24:	04c0006f          	j	ffffffe000201e70 <trap_handler+0x1e0>
        } else if (scause == 0xf){
ffffffe000201e28:	fe843703          	ld	a4,-24(s0)
ffffffe000201e2c:	00f00793          	li	a5,15
ffffffe000201e30:	00f71a63          	bne	a4,a5,ffffffe000201e44 <trap_handler+0x1b4>
            do_page_fault(regs, scause);
ffffffe000201e34:	fe843583          	ld	a1,-24(s0)
ffffffe000201e38:	fd843503          	ld	a0,-40(s0)
ffffffe000201e3c:	044000ef          	jal	ffffffe000201e80 <do_page_fault>
        return;
ffffffe000201e40:	0300006f          	j	ffffffe000201e70 <trap_handler+0x1e0>
            Err("Other Unhandled Exception, scause=%d", scause);
ffffffe000201e44:	fe843703          	ld	a4,-24(s0)
ffffffe000201e48:	00002697          	auipc	a3,0x2
ffffffe000201e4c:	4c868693          	addi	a3,a3,1224 # ffffffe000204310 <__func__.1>
ffffffe000201e50:	04000613          	li	a2,64
ffffffe000201e54:	00002597          	auipc	a1,0x2
ffffffe000201e58:	34c58593          	addi	a1,a1,844 # ffffffe0002041a0 <_srodata+0x1a0>
ffffffe000201e5c:	00002517          	auipc	a0,0x2
ffffffe000201e60:	37c50513          	addi	a0,a0,892 # ffffffe0002041d8 <_srodata+0x1d8>
ffffffe000201e64:	0e1010ef          	jal	ffffffe000203744 <printk>
ffffffe000201e68:	00000013          	nop
ffffffe000201e6c:	ffdff06f          	j	ffffffe000201e68 <trap_handler+0x1d8>
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试
    return;
}
ffffffe000201e70:	02813083          	ld	ra,40(sp)
ffffffe000201e74:	02013403          	ld	s0,32(sp)
ffffffe000201e78:	03010113          	addi	sp,sp,48
ffffffe000201e7c:	00008067          	ret

ffffffe000201e80 <do_page_fault>:

void do_page_fault(struct pt_regs *regs, uint64_t scause) {
ffffffe000201e80:	f7010113          	addi	sp,sp,-144
ffffffe000201e84:	08113423          	sd	ra,136(sp)
ffffffe000201e88:	08813023          	sd	s0,128(sp)
ffffffe000201e8c:	09010413          	addi	s0,sp,144
ffffffe000201e90:	f6a43c23          	sd	a0,-136(s0)
ffffffe000201e94:	f6b43823          	sd	a1,-144(s0)
    uint64_t stval = csr_read(stval);
ffffffe000201e98:	143027f3          	csrr	a5,stval
ffffffe000201e9c:	fef43423          	sd	a5,-24(s0)
ffffffe000201ea0:	fe843783          	ld	a5,-24(s0)
ffffffe000201ea4:	fef43023          	sd	a5,-32(s0)
    struct vm_area_struct* tmp_vma = find_vma(&(current->mm), stval);
ffffffe000201ea8:	00007797          	auipc	a5,0x7
ffffffe000201eac:	16878793          	addi	a5,a5,360 # ffffffe000209010 <current>
ffffffe000201eb0:	0007b783          	ld	a5,0(a5)
ffffffe000201eb4:	0b078793          	addi	a5,a5,176
ffffffe000201eb8:	fe043583          	ld	a1,-32(s0)
ffffffe000201ebc:	00078513          	mv	a0,a5
ffffffe000201ec0:	c5dfe0ef          	jal	ffffffe000200b1c <find_vma>
ffffffe000201ec4:	fca43c23          	sd	a0,-40(s0)
    if (tmp_vma == NULL){
ffffffe000201ec8:	fd843783          	ld	a5,-40(s0)
ffffffe000201ecc:	02079863          	bnez	a5,ffffffe000201efc <do_page_fault+0x7c>
        Err("Unexpected virtual address: %lx\n", stval);
ffffffe000201ed0:	fe043703          	ld	a4,-32(s0)
ffffffe000201ed4:	00002697          	auipc	a3,0x2
ffffffe000201ed8:	44c68693          	addi	a3,a3,1100 # ffffffe000204320 <__func__.0>
ffffffe000201edc:	05000613          	li	a2,80
ffffffe000201ee0:	00002597          	auipc	a1,0x2
ffffffe000201ee4:	2c058593          	addi	a1,a1,704 # ffffffe0002041a0 <_srodata+0x1a0>
ffffffe000201ee8:	00002517          	auipc	a0,0x2
ffffffe000201eec:	33050513          	addi	a0,a0,816 # ffffffe000204218 <_srodata+0x218>
ffffffe000201ef0:	055010ef          	jal	ffffffe000203744 <printk>
ffffffe000201ef4:	00000013          	nop
ffffffe000201ef8:	ffdff06f          	j	ffffffe000201ef4 <do_page_fault+0x74>
    } else {
        if (regs->a0 == 0xc && !(tmp_vma->vm_flags & VM_EXEC)){
ffffffe000201efc:	f7843783          	ld	a5,-136(s0)
ffffffe000201f00:	0407b703          	ld	a4,64(a5)
ffffffe000201f04:	00c00793          	li	a5,12
ffffffe000201f08:	02f71e63          	bne	a4,a5,ffffffe000201f44 <do_page_fault+0xc4>
ffffffe000201f0c:	fd843783          	ld	a5,-40(s0)
ffffffe000201f10:	0287b783          	ld	a5,40(a5)
ffffffe000201f14:	0087f793          	andi	a5,a5,8
ffffffe000201f18:	02079663          	bnez	a5,ffffffe000201f44 <do_page_fault+0xc4>
            Err("VMA doesn't support EXEC\n");
ffffffe000201f1c:	00002697          	auipc	a3,0x2
ffffffe000201f20:	40468693          	addi	a3,a3,1028 # ffffffe000204320 <__func__.0>
ffffffe000201f24:	05300613          	li	a2,83
ffffffe000201f28:	00002597          	auipc	a1,0x2
ffffffe000201f2c:	27858593          	addi	a1,a1,632 # ffffffe0002041a0 <_srodata+0x1a0>
ffffffe000201f30:	00002517          	auipc	a0,0x2
ffffffe000201f34:	32050513          	addi	a0,a0,800 # ffffffe000204250 <_srodata+0x250>
ffffffe000201f38:	00d010ef          	jal	ffffffe000203744 <printk>
ffffffe000201f3c:	00000013          	nop
ffffffe000201f40:	ffdff06f          	j	ffffffe000201f3c <do_page_fault+0xbc>
        }else {
            Log("[pid = %d, PC = %lx], valid page fault at '%lx' with scause %lx\n", current->pid, regs->sepc, stval, scause);
ffffffe000201f44:	00007797          	auipc	a5,0x7
ffffffe000201f48:	0cc78793          	addi	a5,a5,204 # ffffffe000209010 <current>
ffffffe000201f4c:	0007b783          	ld	a5,0(a5)
ffffffe000201f50:	0187b703          	ld	a4,24(a5)
ffffffe000201f54:	f7843783          	ld	a5,-136(s0)
ffffffe000201f58:	0f07b783          	ld	a5,240(a5)
ffffffe000201f5c:	f7043883          	ld	a7,-144(s0)
ffffffe000201f60:	fe043803          	ld	a6,-32(s0)
ffffffe000201f64:	00002697          	auipc	a3,0x2
ffffffe000201f68:	3bc68693          	addi	a3,a3,956 # ffffffe000204320 <__func__.0>
ffffffe000201f6c:	05500613          	li	a2,85
ffffffe000201f70:	00002597          	auipc	a1,0x2
ffffffe000201f74:	23058593          	addi	a1,a1,560 # ffffffe0002041a0 <_srodata+0x1a0>
ffffffe000201f78:	00002517          	auipc	a0,0x2
ffffffe000201f7c:	31050513          	addi	a0,a0,784 # ffffffe000204288 <_srodata+0x288>
ffffffe000201f80:	7c4010ef          	jal	ffffffe000203744 <printk>
            if (tmp_vma->vm_flags & VM_ANON){
ffffffe000201f84:	fd843783          	ld	a5,-40(s0)
ffffffe000201f88:	0287b783          	ld	a5,40(a5)
ffffffe000201f8c:	0017f793          	andi	a5,a5,1
ffffffe000201f90:	04078e63          	beqz	a5,ffffffe000201fec <do_page_fault+0x16c>
                uint64_t *tmp_page = alloc_page();
ffffffe000201f94:	a09fe0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000201f98:	f8a43023          	sd	a0,-128(s0)
                memset(tmp_page, 0, PGSIZE);
ffffffe000201f9c:	00001637          	lui	a2,0x1
ffffffe000201fa0:	00000593          	li	a1,0
ffffffe000201fa4:	f8043503          	ld	a0,-128(s0)
ffffffe000201fa8:	0cd010ef          	jal	ffffffe000203874 <memset>
                // for (uint64_t i = 0; i < PGSIZE; i++)   *((char*)tmp_page + i) = 0; 
                create_mapping(current->pgd, PGROUNDDOWN(stval), (uint64_t)tmp_page - PA2VA_OFFSET, PGSIZE, 0x17);
ffffffe000201fac:	00007797          	auipc	a5,0x7
ffffffe000201fb0:	06478793          	addi	a5,a5,100 # ffffffe000209010 <current>
ffffffe000201fb4:	0007b783          	ld	a5,0(a5)
ffffffe000201fb8:	0a87b503          	ld	a0,168(a5)
ffffffe000201fbc:	fe043703          	ld	a4,-32(s0)
ffffffe000201fc0:	fffff7b7          	lui	a5,0xfffff
ffffffe000201fc4:	00f775b3          	and	a1,a4,a5
ffffffe000201fc8:	f8043703          	ld	a4,-128(s0)
ffffffe000201fcc:	04100793          	li	a5,65
ffffffe000201fd0:	01f79793          	slli	a5,a5,0x1f
ffffffe000201fd4:	00f707b3          	add	a5,a4,a5
ffffffe000201fd8:	01700713          	li	a4,23
ffffffe000201fdc:	000016b7          	lui	a3,0x1
ffffffe000201fe0:	00078613          	mv	a2,a5
ffffffe000201fe4:	570000ef          	jal	ffffffe000202554 <create_mapping>
ffffffe000201fe8:	1f40006f          	j	ffffffe0002021dc <do_page_fault+0x35c>
            } else {

                uint64_t *paddr = alloc_page();
ffffffe000201fec:	9b1fe0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000201ff0:	fca43823          	sd	a0,-48(s0)
                memset(paddr, 0, PGSIZE);
ffffffe000201ff4:	00001637          	lui	a2,0x1
ffffffe000201ff8:	00000593          	li	a1,0
ffffffe000201ffc:	fd043503          	ld	a0,-48(s0)
ffffffe000202000:	075010ef          	jal	ffffffe000203874 <memset>

                uint64_t VUP = PGROUNDUP(stval);
ffffffe000202004:	fe043703          	ld	a4,-32(s0)
ffffffe000202008:	000017b7          	lui	a5,0x1
ffffffe00020200c:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000202010:	00f70733          	add	a4,a4,a5
ffffffe000202014:	fffff7b7          	lui	a5,0xfffff
ffffffe000202018:	00f777b3          	and	a5,a4,a5
ffffffe00020201c:	fcf43423          	sd	a5,-56(s0)
                uint64_t VDOWN = PGROUNDDOWN(stval);
ffffffe000202020:	fe043703          	ld	a4,-32(s0)
ffffffe000202024:	fffff7b7          	lui	a5,0xfffff
ffffffe000202028:	00f777b3          	and	a5,a4,a5
ffffffe00020202c:	fcf43023          	sd	a5,-64(s0)
                uint64_t badvaddr = stval;
ffffffe000202030:	fe043783          	ld	a5,-32(s0)
ffffffe000202034:	faf43c23          	sd	a5,-72(s0)
                struct vm_area_struct *vma = tmp_vma;
ffffffe000202038:	fd843783          	ld	a5,-40(s0)
ffffffe00020203c:	faf43823          	sd	a5,-80(s0)
                void *page = paddr;
ffffffe000202040:	fd043783          	ld	a5,-48(s0)
ffffffe000202044:	faf43423          	sd	a5,-88(s0)
                uint64_t page_start;
                uint64_t file_start;

                uint64_t map_start = MAX(vma->vm_start, PGROUNDDOWN(badvaddr));
ffffffe000202048:	fb843703          	ld	a4,-72(s0)
ffffffe00020204c:	fffff7b7          	lui	a5,0xfffff
ffffffe000202050:	00f776b3          	and	a3,a4,a5
ffffffe000202054:	fb043783          	ld	a5,-80(s0)
ffffffe000202058:	0087b703          	ld	a4,8(a5) # fffffffffffff008 <VM_END+0xfffff008>
ffffffe00020205c:	00068793          	mv	a5,a3
ffffffe000202060:	00e7f463          	bgeu	a5,a4,ffffffe000202068 <do_page_fault+0x1e8>
ffffffe000202064:	00070793          	mv	a5,a4
ffffffe000202068:	faf43023          	sd	a5,-96(s0)
                uint64_t map_end = MIN(vma->vm_start + vma->vm_filesz, PGROUNDDOWN(badvaddr)+PGSIZE);
ffffffe00020206c:	fb843703          	ld	a4,-72(s0)
ffffffe000202070:	fffff7b7          	lui	a5,0xfffff
ffffffe000202074:	00f77733          	and	a4,a4,a5
ffffffe000202078:	000017b7          	lui	a5,0x1
ffffffe00020207c:	00f706b3          	add	a3,a4,a5
ffffffe000202080:	fb043783          	ld	a5,-80(s0)
ffffffe000202084:	0087b703          	ld	a4,8(a5) # 1008 <PGSIZE+0x8>
ffffffe000202088:	fb043783          	ld	a5,-80(s0)
ffffffe00020208c:	0387b783          	ld	a5,56(a5)
ffffffe000202090:	00f70733          	add	a4,a4,a5
ffffffe000202094:	00068793          	mv	a5,a3
ffffffe000202098:	00f77463          	bgeu	a4,a5,ffffffe0002020a0 <do_page_fault+0x220>
ffffffe00020209c:	00070793          	mv	a5,a4
ffffffe0002020a0:	f8f43c23          	sd	a5,-104(s0)
                if (map_start < map_end) {
ffffffe0002020a4:	fa043703          	ld	a4,-96(s0)
ffffffe0002020a8:	f9843783          	ld	a5,-104(s0)
ffffffe0002020ac:	0af77863          	bgeu	a4,a5,ffffffe00020215c <do_page_fault+0x2dc>
                    page_start = map_start - PGROUNDDOWN(badvaddr);
ffffffe0002020b0:	fb843703          	ld	a4,-72(s0)
ffffffe0002020b4:	fffff7b7          	lui	a5,0xfffff
ffffffe0002020b8:	00f777b3          	and	a5,a4,a5
ffffffe0002020bc:	fa043703          	ld	a4,-96(s0)
ffffffe0002020c0:	40f707b3          	sub	a5,a4,a5
ffffffe0002020c4:	f8f43823          	sd	a5,-112(s0)
                    file_start = vma->vm_pgoff + map_start - vma->vm_start;
ffffffe0002020c8:	fb043783          	ld	a5,-80(s0)
ffffffe0002020cc:	0307b703          	ld	a4,48(a5) # fffffffffffff030 <VM_END+0xfffff030>
ffffffe0002020d0:	fa043783          	ld	a5,-96(s0)
ffffffe0002020d4:	00f70733          	add	a4,a4,a5
ffffffe0002020d8:	fb043783          	ld	a5,-80(s0)
ffffffe0002020dc:	0087b783          	ld	a5,8(a5)
ffffffe0002020e0:	40f707b3          	sub	a5,a4,a5
ffffffe0002020e4:	f8f43423          	sd	a5,-120(s0)
                    memcpy(page + page_start, _sramdisk + file_start, map_end - map_start);
ffffffe0002020e8:	fa843703          	ld	a4,-88(s0)
ffffffe0002020ec:	f9043783          	ld	a5,-112(s0)
ffffffe0002020f0:	00f706b3          	add	a3,a4,a5
ffffffe0002020f4:	f8843703          	ld	a4,-120(s0)
ffffffe0002020f8:	00004797          	auipc	a5,0x4
ffffffe0002020fc:	f0878793          	addi	a5,a5,-248 # ffffffe000206000 <_sramdisk>
ffffffe000202100:	00f705b3          	add	a1,a4,a5
ffffffe000202104:	f9843703          	ld	a4,-104(s0)
ffffffe000202108:	fa043783          	ld	a5,-96(s0)
ffffffe00020210c:	40f707b3          	sub	a5,a4,a5
ffffffe000202110:	00078613          	mv	a2,a5
ffffffe000202114:	00068513          	mv	a0,a3
ffffffe000202118:	7d4010ef          	jal	ffffffe0002038ec <memcpy>
                    create_mapping(current->pgd, PGROUNDDOWN(badvaddr), (uint64_t)(page - PA2VA_OFFSET), PGSIZE, 0x1f);
ffffffe00020211c:	00007797          	auipc	a5,0x7
ffffffe000202120:	ef478793          	addi	a5,a5,-268 # ffffffe000209010 <current>
ffffffe000202124:	0007b783          	ld	a5,0(a5)
ffffffe000202128:	0a87b503          	ld	a0,168(a5)
ffffffe00020212c:	fb843703          	ld	a4,-72(s0)
ffffffe000202130:	fffff7b7          	lui	a5,0xfffff
ffffffe000202134:	00f775b3          	and	a1,a4,a5
ffffffe000202138:	fa843703          	ld	a4,-88(s0)
ffffffe00020213c:	04100793          	li	a5,65
ffffffe000202140:	01f79793          	slli	a5,a5,0x1f
ffffffe000202144:	00f707b3          	add	a5,a4,a5
ffffffe000202148:	01f00713          	li	a4,31
ffffffe00020214c:	000016b7          	lui	a3,0x1
ffffffe000202150:	00078613          	mv	a2,a5
ffffffe000202154:	400000ef          	jal	ffffffe000202554 <create_mapping>
ffffffe000202158:	0840006f          	j	ffffffe0002021dc <do_page_fault+0x35c>
                } else {
                    if (vma->vm_end >= PGROUNDDOWN(stval))
ffffffe00020215c:	fb043783          	ld	a5,-80(s0)
ffffffe000202160:	0107b703          	ld	a4,16(a5) # fffffffffffff010 <VM_END+0xfffff010>
ffffffe000202164:	fe043683          	ld	a3,-32(s0)
ffffffe000202168:	fffff7b7          	lui	a5,0xfffff
ffffffe00020216c:	00f6f7b3          	and	a5,a3,a5
ffffffe000202170:	04f76263          	bltu	a4,a5,ffffffe0002021b4 <do_page_fault+0x334>
                        create_mapping(current->pgd, PGROUNDDOWN(badvaddr), (uint64_t)(page - PA2VA_OFFSET), PGSIZE, 0x1f);
ffffffe000202174:	00007797          	auipc	a5,0x7
ffffffe000202178:	e9c78793          	addi	a5,a5,-356 # ffffffe000209010 <current>
ffffffe00020217c:	0007b783          	ld	a5,0(a5)
ffffffe000202180:	0a87b503          	ld	a0,168(a5)
ffffffe000202184:	fb843703          	ld	a4,-72(s0)
ffffffe000202188:	fffff7b7          	lui	a5,0xfffff
ffffffe00020218c:	00f775b3          	and	a1,a4,a5
ffffffe000202190:	fa843703          	ld	a4,-88(s0)
ffffffe000202194:	04100793          	li	a5,65
ffffffe000202198:	01f79793          	slli	a5,a5,0x1f
ffffffe00020219c:	00f707b3          	add	a5,a4,a5
ffffffe0002021a0:	01f00713          	li	a4,31
ffffffe0002021a4:	000016b7          	lui	a3,0x1
ffffffe0002021a8:	00078613          	mv	a2,a5
ffffffe0002021ac:	3a8000ef          	jal	ffffffe000202554 <create_mapping>
ffffffe0002021b0:	02c0006f          	j	ffffffe0002021dc <do_page_fault+0x35c>
                    else 
                        Err("absolute wrong addr");
ffffffe0002021b4:	00002697          	auipc	a3,0x2
ffffffe0002021b8:	16c68693          	addi	a3,a3,364 # ffffffe000204320 <__func__.0>
ffffffe0002021bc:	07300613          	li	a2,115
ffffffe0002021c0:	00002597          	auipc	a1,0x2
ffffffe0002021c4:	fe058593          	addi	a1,a1,-32 # ffffffe0002041a0 <_srodata+0x1a0>
ffffffe0002021c8:	00002517          	auipc	a0,0x2
ffffffe0002021cc:	11850513          	addi	a0,a0,280 # ffffffe0002042e0 <_srodata+0x2e0>
ffffffe0002021d0:	574010ef          	jal	ffffffe000203744 <printk>
ffffffe0002021d4:	00000013          	nop
ffffffe0002021d8:	ffdff06f          	j	ffffffe0002021d4 <do_page_fault+0x354>
                //         for(uint64_t i = 0; i < PGSIZE; i++)  *((char*)paddr + i + offset) = *((char*)addr + i);
                //         create_mapping(current->pgd, VDOWN, (uint64_t)paddr - PA2VA_OFFSET, PGSIZE, 0x1f);                        
                //     }
                // }
            }
            asm volatile ("sfence.vma zero, zero");
ffffffe0002021dc:	12000073          	sfence.vma
        }
    }

    
ffffffe0002021e0:	00000013          	nop
ffffffe0002021e4:	08813083          	ld	ra,136(sp)
ffffffe0002021e8:	08013403          	ld	s0,128(sp)
ffffffe0002021ec:	09010113          	addi	sp,sp,144
ffffffe0002021f0:	00008067          	ret

ffffffe0002021f4 <setup_vm>:

uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);

void setup_vm() {
ffffffe0002021f4:	fc010113          	addi	sp,sp,-64
ffffffe0002021f8:	02113c23          	sd	ra,56(sp)
ffffffe0002021fc:	02813823          	sd	s0,48(sp)
ffffffe000202200:	04010413          	addi	s0,sp,64
     *     中间 9 bit 作为 early_pgtbl 的 index
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

    uint64_t spa = PHY_START;
ffffffe000202204:	00100793          	li	a5,1
ffffffe000202208:	01f79793          	slli	a5,a5,0x1f
ffffffe00020220c:	fef43023          	sd	a5,-32(s0)
    uint64_t sva = VM_START;
ffffffe000202210:	fff00793          	li	a5,-1
ffffffe000202214:	02579793          	slli	a5,a5,0x25
ffffffe000202218:	fcf43c23          	sd	a5,-40(s0)
    memset(early_pgtbl, 0, sizeof(early_pgtbl));
ffffffe00020221c:	00001637          	lui	a2,0x1
ffffffe000202220:	00000593          	li	a1,0
ffffffe000202224:	00008517          	auipc	a0,0x8
ffffffe000202228:	ddc50513          	addi	a0,a0,-548 # ffffffe00020a000 <early_pgtbl>
ffffffe00020222c:	648010ef          	jal	ffffffe000203874 <memset>
    printk("in setup vm\n");
ffffffe000202230:	00002517          	auipc	a0,0x2
ffffffe000202234:	10050513          	addi	a0,a0,256 # ffffffe000204330 <__func__.0+0x10>
ffffffe000202238:	50c010ef          	jal	ffffffe000203744 <printk>

    uint64_t addr, vaddr, index, test;
    addr = PHY_START;
ffffffe00020223c:	00100793          	li	a5,1
ffffffe000202240:	01f79793          	slli	a5,a5,0x1f
ffffffe000202244:	fcf43823          	sd	a5,-48(s0)
    vaddr = addr;
ffffffe000202248:	fd043783          	ld	a5,-48(s0)
ffffffe00020224c:	fcf43423          	sd	a5,-56(s0)
    index = (vaddr >> 30) & 0x1FF;
ffffffe000202250:	fc843783          	ld	a5,-56(s0)
ffffffe000202254:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202258:	1ff7f793          	andi	a5,a5,511
ffffffe00020225c:	fcf43023          	sd	a5,-64(s0)
    early_pgtbl[index] = (((addr >> 30) & 0x1ff) << 28) | PTE_V | PTE_R | PTE_W | PTE_X;
ffffffe000202260:	fd043783          	ld	a5,-48(s0)
ffffffe000202264:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202268:	01c79713          	slli	a4,a5,0x1c
ffffffe00020226c:	1ff00793          	li	a5,511
ffffffe000202270:	01c79793          	slli	a5,a5,0x1c
ffffffe000202274:	00f777b3          	and	a5,a4,a5
ffffffe000202278:	00f7e713          	ori	a4,a5,15
ffffffe00020227c:	00008697          	auipc	a3,0x8
ffffffe000202280:	d8468693          	addi	a3,a3,-636 # ffffffe00020a000 <early_pgtbl>
ffffffe000202284:	fc043783          	ld	a5,-64(s0)
ffffffe000202288:	00379793          	slli	a5,a5,0x3
ffffffe00020228c:	00f687b3          	add	a5,a3,a5
ffffffe000202290:	00e7b023          	sd	a4,0(a5) # fffffffffffff000 <VM_END+0xfffff000>
    vaddr = addr + PA2VA_OFFSET;
ffffffe000202294:	fd043703          	ld	a4,-48(s0)
ffffffe000202298:	fbf00793          	li	a5,-65
ffffffe00020229c:	01f79793          	slli	a5,a5,0x1f
ffffffe0002022a0:	00f707b3          	add	a5,a4,a5
ffffffe0002022a4:	fcf43423          	sd	a5,-56(s0)
    index = (vaddr >> 30) & 0x1FF;
ffffffe0002022a8:	fc843783          	ld	a5,-56(s0)
ffffffe0002022ac:	01e7d793          	srli	a5,a5,0x1e
ffffffe0002022b0:	1ff7f793          	andi	a5,a5,511
ffffffe0002022b4:	fcf43023          	sd	a5,-64(s0)
    early_pgtbl[index] = (((addr >> 30) & 0x1ff) << 28) | PTE_V | PTE_R | PTE_W | PTE_X; 
ffffffe0002022b8:	fd043783          	ld	a5,-48(s0)
ffffffe0002022bc:	01e7d793          	srli	a5,a5,0x1e
ffffffe0002022c0:	01c79713          	slli	a4,a5,0x1c
ffffffe0002022c4:	1ff00793          	li	a5,511
ffffffe0002022c8:	01c79793          	slli	a5,a5,0x1c
ffffffe0002022cc:	00f777b3          	and	a5,a4,a5
ffffffe0002022d0:	00f7e713          	ori	a4,a5,15
ffffffe0002022d4:	00008697          	auipc	a3,0x8
ffffffe0002022d8:	d2c68693          	addi	a3,a3,-724 # ffffffe00020a000 <early_pgtbl>
ffffffe0002022dc:	fc043783          	ld	a5,-64(s0)
ffffffe0002022e0:	00379793          	slli	a5,a5,0x3
ffffffe0002022e4:	00f687b3          	add	a5,a3,a5
ffffffe0002022e8:	00e7b023          	sd	a4,0(a5)

    for(uint64_t i = 0; i < 512; i++){
ffffffe0002022ec:	fe043423          	sd	zero,-24(s0)
ffffffe0002022f0:	0700006f          	j	ffffffe000202360 <setup_vm+0x16c>
        if(early_pgtbl[i])
ffffffe0002022f4:	00008717          	auipc	a4,0x8
ffffffe0002022f8:	d0c70713          	addi	a4,a4,-756 # ffffffe00020a000 <early_pgtbl>
ffffffe0002022fc:	fe843783          	ld	a5,-24(s0)
ffffffe000202300:	00379793          	slli	a5,a5,0x3
ffffffe000202304:	00f707b3          	add	a5,a4,a5
ffffffe000202308:	0007b783          	ld	a5,0(a5)
ffffffe00020230c:	04078463          	beqz	a5,ffffffe000202354 <setup_vm+0x160>
            printk("index: %u, pte: %llx, pte: %llu\n", i, early_pgtbl[i], early_pgtbl[i]);
ffffffe000202310:	00008717          	auipc	a4,0x8
ffffffe000202314:	cf070713          	addi	a4,a4,-784 # ffffffe00020a000 <early_pgtbl>
ffffffe000202318:	fe843783          	ld	a5,-24(s0)
ffffffe00020231c:	00379793          	slli	a5,a5,0x3
ffffffe000202320:	00f707b3          	add	a5,a4,a5
ffffffe000202324:	0007b603          	ld	a2,0(a5)
ffffffe000202328:	00008717          	auipc	a4,0x8
ffffffe00020232c:	cd870713          	addi	a4,a4,-808 # ffffffe00020a000 <early_pgtbl>
ffffffe000202330:	fe843783          	ld	a5,-24(s0)
ffffffe000202334:	00379793          	slli	a5,a5,0x3
ffffffe000202338:	00f707b3          	add	a5,a4,a5
ffffffe00020233c:	0007b783          	ld	a5,0(a5)
ffffffe000202340:	00078693          	mv	a3,a5
ffffffe000202344:	fe843583          	ld	a1,-24(s0)
ffffffe000202348:	00002517          	auipc	a0,0x2
ffffffe00020234c:	ff850513          	addi	a0,a0,-8 # ffffffe000204340 <__func__.0+0x20>
ffffffe000202350:	3f4010ef          	jal	ffffffe000203744 <printk>
    for(uint64_t i = 0; i < 512; i++){
ffffffe000202354:	fe843783          	ld	a5,-24(s0)
ffffffe000202358:	00178793          	addi	a5,a5,1
ffffffe00020235c:	fef43423          	sd	a5,-24(s0)
ffffffe000202360:	fe843703          	ld	a4,-24(s0)
ffffffe000202364:	1ff00793          	li	a5,511
ffffffe000202368:	f8e7f6e3          	bgeu	a5,a4,ffffffe0002022f4 <setup_vm+0x100>
    }
    return;
ffffffe00020236c:	00000013          	nop
}
ffffffe000202370:	03813083          	ld	ra,56(sp)
ffffffe000202374:	03013403          	ld	s0,48(sp)
ffffffe000202378:	04010113          	addi	sp,sp,64
ffffffe00020237c:	00008067          	ret

ffffffe000202380 <setup_vm_final>:

uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));
extern char _stext[], _etext[], _srodata[], _erodata[], _sdata[], _ebss[];
uint64_t phy_swapper_pg_dir;

void setup_vm_final() {
ffffffe000202380:	fa010113          	addi	sp,sp,-96
ffffffe000202384:	04113c23          	sd	ra,88(sp)
ffffffe000202388:	04813823          	sd	s0,80(sp)
ffffffe00020238c:	06010413          	addi	s0,sp,96
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000202390:	00001637          	lui	a2,0x1
ffffffe000202394:	00000593          	li	a1,0
ffffffe000202398:	00009517          	auipc	a0,0x9
ffffffe00020239c:	c6850513          	addi	a0,a0,-920 # ffffffe00020b000 <swapper_pg_dir>
ffffffe0002023a0:	4d4010ef          	jal	ffffffe000203874 <memset>

    // No OpenSBI mapping required
    uint64_t stext = (uint64_t)_stext - PA2VA_OFFSET;
ffffffe0002023a4:	ffffe717          	auipc	a4,0xffffe
ffffffe0002023a8:	c5c70713          	addi	a4,a4,-932 # ffffffe000200000 <_skernel>
ffffffe0002023ac:	04100793          	li	a5,65
ffffffe0002023b0:	01f79793          	slli	a5,a5,0x1f
ffffffe0002023b4:	00f707b3          	add	a5,a4,a5
ffffffe0002023b8:	fef43423          	sd	a5,-24(s0)
    uint64_t etext = (uint64_t)_etext - PA2VA_OFFSET;
ffffffe0002023bc:	00001717          	auipc	a4,0x1
ffffffe0002023c0:	5b470713          	addi	a4,a4,1460 # ffffffe000203970 <_etext>
ffffffe0002023c4:	04100793          	li	a5,65
ffffffe0002023c8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002023cc:	00f707b3          	add	a5,a4,a5
ffffffe0002023d0:	fef43023          	sd	a5,-32(s0)
    uint64_t srodata = (uint64_t)_srodata - PA2VA_OFFSET;
ffffffe0002023d4:	00002717          	auipc	a4,0x2
ffffffe0002023d8:	c2c70713          	addi	a4,a4,-980 # ffffffe000204000 <_srodata>
ffffffe0002023dc:	04100793          	li	a5,65
ffffffe0002023e0:	01f79793          	slli	a5,a5,0x1f
ffffffe0002023e4:	00f707b3          	add	a5,a4,a5
ffffffe0002023e8:	fcf43c23          	sd	a5,-40(s0)
    uint64_t erodata = (uint64_t)_erodata - PA2VA_OFFSET;
ffffffe0002023ec:	00002717          	auipc	a4,0x2
ffffffe0002023f0:	0cc70713          	addi	a4,a4,204 # ffffffe0002044b8 <_erodata>
ffffffe0002023f4:	04100793          	li	a5,65
ffffffe0002023f8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002023fc:	00f707b3          	add	a5,a4,a5
ffffffe000202400:	fcf43823          	sd	a5,-48(s0)
    uint64_t sdata = (uint64_t)_sdata - PA2VA_OFFSET;
ffffffe000202404:	00003717          	auipc	a4,0x3
ffffffe000202408:	bfc70713          	addi	a4,a4,-1028 # ffffffe000205000 <TIMECLOCK>
ffffffe00020240c:	04100793          	li	a5,65
ffffffe000202410:	01f79793          	slli	a5,a5,0x1f
ffffffe000202414:	00f707b3          	add	a5,a4,a5
ffffffe000202418:	fcf43423          	sd	a5,-56(s0)
    uint64_t ebss = (uint64_t)_ebss - PA2VA_OFFSET;
ffffffe00020241c:	0000a717          	auipc	a4,0xa
ffffffe000202420:	be470713          	addi	a4,a4,-1052 # ffffffe00020c000 <_ebss>
ffffffe000202424:	04100793          	li	a5,65
ffffffe000202428:	01f79793          	slli	a5,a5,0x1f
ffffffe00020242c:	00f707b3          	add	a5,a4,a5
ffffffe000202430:	fcf43023          	sd	a5,-64(s0)
    // printk("st: %lx\net: %lx\nsrod: %lx\nerod: %lx\nsd: %lx\neb: %lx\n", stext, etext, srodata, erodata, sdata, ebss);

    uint64_t text_size = etext - stext;
ffffffe000202434:	fe043703          	ld	a4,-32(s0)
ffffffe000202438:	fe843783          	ld	a5,-24(s0)
ffffffe00020243c:	40f707b3          	sub	a5,a4,a5
ffffffe000202440:	faf43c23          	sd	a5,-72(s0)
    uint64_t rodata_size = erodata - srodata;
ffffffe000202444:	fd043703          	ld	a4,-48(s0)
ffffffe000202448:	fd843783          	ld	a5,-40(s0)
ffffffe00020244c:	40f707b3          	sub	a5,a4,a5
ffffffe000202450:	faf43823          	sd	a5,-80(s0)
    uint64_t remain_size = stext + PHY_SIZE - sdata;
ffffffe000202454:	fe843703          	ld	a4,-24(s0)
ffffffe000202458:	fc843783          	ld	a5,-56(s0)
ffffffe00020245c:	40f70733          	sub	a4,a4,a5
ffffffe000202460:	080007b7          	lui	a5,0x8000
ffffffe000202464:	00f707b3          	add	a5,a4,a5
ffffffe000202468:	faf43423          	sd	a5,-88(s0)

    // mapping kernel text X|-|R|V
    phy_swapper_pg_dir = (uint64_t)swapper_pg_dir - PA2VA_OFFSET;
ffffffe00020246c:	00009717          	auipc	a4,0x9
ffffffe000202470:	b9470713          	addi	a4,a4,-1132 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000202474:	04100793          	li	a5,65
ffffffe000202478:	01f79793          	slli	a5,a5,0x1f
ffffffe00020247c:	00f70733          	add	a4,a4,a5
ffffffe000202480:	00007797          	auipc	a5,0x7
ffffffe000202484:	b9878793          	addi	a5,a5,-1128 # ffffffe000209018 <phy_swapper_pg_dir>
ffffffe000202488:	00e7b023          	sd	a4,0(a5)

    create_mapping(swapper_pg_dir, (uint64_t)_stext, stext, text_size, 0xb);
ffffffe00020248c:	ffffe797          	auipc	a5,0xffffe
ffffffe000202490:	b7478793          	addi	a5,a5,-1164 # ffffffe000200000 <_skernel>
ffffffe000202494:	00b00713          	li	a4,11
ffffffe000202498:	fb843683          	ld	a3,-72(s0)
ffffffe00020249c:	fe843603          	ld	a2,-24(s0)
ffffffe0002024a0:	00078593          	mv	a1,a5
ffffffe0002024a4:	00009517          	auipc	a0,0x9
ffffffe0002024a8:	b5c50513          	addi	a0,a0,-1188 # ffffffe00020b000 <swapper_pg_dir>
ffffffe0002024ac:	0a8000ef          	jal	ffffffe000202554 <create_mapping>
    printk("after first mapping\n");
ffffffe0002024b0:	00002517          	auipc	a0,0x2
ffffffe0002024b4:	eb850513          	addi	a0,a0,-328 # ffffffe000204368 <__func__.0+0x48>
ffffffe0002024b8:	28c010ef          	jal	ffffffe000203744 <printk>

    // mapping kernel rodata -|-|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_srodata, srodata, rodata_size, 0x3);
ffffffe0002024bc:	00002797          	auipc	a5,0x2
ffffffe0002024c0:	b4478793          	addi	a5,a5,-1212 # ffffffe000204000 <_srodata>
ffffffe0002024c4:	00300713          	li	a4,3
ffffffe0002024c8:	fb043683          	ld	a3,-80(s0)
ffffffe0002024cc:	fd843603          	ld	a2,-40(s0)
ffffffe0002024d0:	00078593          	mv	a1,a5
ffffffe0002024d4:	00009517          	auipc	a0,0x9
ffffffe0002024d8:	b2c50513          	addi	a0,a0,-1236 # ffffffe00020b000 <swapper_pg_dir>
ffffffe0002024dc:	078000ef          	jal	ffffffe000202554 <create_mapping>
    printk("after second mapping\n");
ffffffe0002024e0:	00002517          	auipc	a0,0x2
ffffffe0002024e4:	ea050513          	addi	a0,a0,-352 # ffffffe000204380 <__func__.0+0x60>
ffffffe0002024e8:	25c010ef          	jal	ffffffe000203744 <printk>
    // mapping other memory -|W|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_sdata, sdata, remain_size, 0x7);
ffffffe0002024ec:	00003797          	auipc	a5,0x3
ffffffe0002024f0:	b1478793          	addi	a5,a5,-1260 # ffffffe000205000 <TIMECLOCK>
ffffffe0002024f4:	00700713          	li	a4,7
ffffffe0002024f8:	fa843683          	ld	a3,-88(s0)
ffffffe0002024fc:	fc843603          	ld	a2,-56(s0)
ffffffe000202500:	00078593          	mv	a1,a5
ffffffe000202504:	00009517          	auipc	a0,0x9
ffffffe000202508:	afc50513          	addi	a0,a0,-1284 # ffffffe00020b000 <swapper_pg_dir>
ffffffe00020250c:	048000ef          	jal	ffffffe000202554 <create_mapping>
    printk("after third mapping\n");
ffffffe000202510:	00002517          	auipc	a0,0x2
ffffffe000202514:	e8850513          	addi	a0,a0,-376 # ffffffe000204398 <__func__.0+0x78>
ffffffe000202518:	22c010ef          	jal	ffffffe000203744 <printk>

    // set satp with swapper_pg_dir
    asm volatile(".extern phy_swapper_pg_dir");
    asm volatile("la a1, phy_swapper_pg_dir");
ffffffe00020251c:	00007597          	auipc	a1,0x7
ffffffe000202520:	afc58593          	addi	a1,a1,-1284 # ffffffe000209018 <phy_swapper_pg_dir>
    asm volatile("ld a0, 0(a1)");
ffffffe000202524:	0005b503          	ld	a0,0(a1)
    asm volatile("srli a0, a0, 12");
ffffffe000202528:	00c55513          	srli	a0,a0,0xc
    asm volatile("li a1, 0x8000000000000000");
ffffffe00020252c:	fff0059b          	addiw	a1,zero,-1
ffffffe000202530:	03f59593          	slli	a1,a1,0x3f
    asm volatile("or a0, a0, a1");
ffffffe000202534:	00b56533          	or	a0,a0,a1
    asm volatile("csrw satp, a0");
ffffffe000202538:	18051073          	csrw	satp,a0

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe00020253c:	12000073          	sfence.vma

    // // flush icache
    // asm volatile("fence.i");
    return;
ffffffe000202540:	00000013          	nop
}
ffffffe000202544:	05813083          	ld	ra,88(sp)
ffffffe000202548:	05013403          	ld	s0,80(sp)
ffffffe00020254c:	06010113          	addi	sp,sp,96
ffffffe000202550:	00008067          	ret

ffffffe000202554 <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000202554:	f5010113          	addi	sp,sp,-176
ffffffe000202558:	0a113423          	sd	ra,168(sp)
ffffffe00020255c:	0a813023          	sd	s0,160(sp)
ffffffe000202560:	0b010413          	addi	s0,sp,176
ffffffe000202564:	f8a43423          	sd	a0,-120(s0)
ffffffe000202568:	f8b43023          	sd	a1,-128(s0)
ffffffe00020256c:	f6c43c23          	sd	a2,-136(s0)
ffffffe000202570:	f6d43823          	sd	a3,-144(s0)
ffffffe000202574:	f6e43423          	sd	a4,-152(s0)
    **/
    uint64_t vpn2, vpn1, vpn0;
    uint64_t addr, vaddr;
    uint64_t pte;
    uint64_t *tmptbl, *p_pte;
    for(uint64_t addr_offset = 0; addr_offset < sz; addr_offset += PGSIZE){
ffffffe000202578:	fe043023          	sd	zero,-32(s0)
ffffffe00020257c:	1d40006f          	j	ffffffe000202750 <create_mapping+0x1fc>
        addr = pa + addr_offset;
ffffffe000202580:	f7843703          	ld	a4,-136(s0)
ffffffe000202584:	fe043783          	ld	a5,-32(s0)
ffffffe000202588:	00f707b3          	add	a5,a4,a5
ffffffe00020258c:	fcf43c23          	sd	a5,-40(s0)
        vaddr = va + addr_offset;
ffffffe000202590:	f8043703          	ld	a4,-128(s0)
ffffffe000202594:	fe043783          	ld	a5,-32(s0)
ffffffe000202598:	00f707b3          	add	a5,a4,a5
ffffffe00020259c:	fcf43823          	sd	a5,-48(s0)
        // printk("addr: %lx, vaddr: %lx\n", addr, vaddr);
        tmptbl = pgtbl;
ffffffe0002025a0:	f8843783          	ld	a5,-120(s0)
ffffffe0002025a4:	fef43423          	sd	a5,-24(s0)
        vpn2 = (vaddr >> 30) & 0x1ff;
ffffffe0002025a8:	fd043783          	ld	a5,-48(s0)
ffffffe0002025ac:	01e7d793          	srli	a5,a5,0x1e
ffffffe0002025b0:	1ff7f793          	andi	a5,a5,511
ffffffe0002025b4:	fcf43423          	sd	a5,-56(s0)
        vpn1 = (vaddr >> 21) & 0x1ff;
ffffffe0002025b8:	fd043783          	ld	a5,-48(s0)
ffffffe0002025bc:	0157d793          	srli	a5,a5,0x15
ffffffe0002025c0:	1ff7f793          	andi	a5,a5,511
ffffffe0002025c4:	fcf43023          	sd	a5,-64(s0)
        vpn0 = (vaddr >> 12) & 0x1ff;
ffffffe0002025c8:	fd043783          	ld	a5,-48(s0)
ffffffe0002025cc:	00c7d793          	srli	a5,a5,0xc
ffffffe0002025d0:	1ff7f793          	andi	a5,a5,511
ffffffe0002025d4:	faf43c23          	sd	a5,-72(s0)
        // printk("vpn2: %d, vpn1: %d, vpn0: %d\n", vpn2, vpn1, vpn0);
        p_pte = tmptbl + vpn2;
ffffffe0002025d8:	fc843783          	ld	a5,-56(s0)
ffffffe0002025dc:	00379793          	slli	a5,a5,0x3
ffffffe0002025e0:	fe843703          	ld	a4,-24(s0)
ffffffe0002025e4:	00f707b3          	add	a5,a4,a5
ffffffe0002025e8:	faf43823          	sd	a5,-80(s0)
        pte = tmptbl[vpn2];
ffffffe0002025ec:	fc843783          	ld	a5,-56(s0)
ffffffe0002025f0:	00379793          	slli	a5,a5,0x3
ffffffe0002025f4:	fe843703          	ld	a4,-24(s0)
ffffffe0002025f8:	00f707b3          	add	a5,a4,a5
ffffffe0002025fc:	0007b783          	ld	a5,0(a5)
ffffffe000202600:	faf43423          	sd	a5,-88(s0)
        // printk("tpmtbl: %lx, p_pte: %lx, pte: %lx\n", tmptbl, p_pte, pte);
        if(pte & 0x1){
ffffffe000202604:	fa843783          	ld	a5,-88(s0)
ffffffe000202608:	0017f793          	andi	a5,a5,1
ffffffe00020260c:	02078263          	beqz	a5,ffffffe000202630 <create_mapping+0xdc>
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
ffffffe000202610:	fa843783          	ld	a5,-88(s0)
ffffffe000202614:	00a7d793          	srli	a5,a5,0xa
ffffffe000202618:	00c79713          	slli	a4,a5,0xc
ffffffe00020261c:	fbf00793          	li	a5,-65
ffffffe000202620:	01f79793          	slli	a5,a5,0x1f
ffffffe000202624:	00f707b3          	add	a5,a4,a5
ffffffe000202628:	fef43423          	sd	a5,-24(s0)
ffffffe00020262c:	0480006f          	j	ffffffe000202674 <create_mapping+0x120>
        } else {
            tmptbl = (uint64_t*)alloc_page();
ffffffe000202630:	b6cfe0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000202634:	fea43423          	sd	a0,-24(s0)
            memset(tmptbl, 0, PGSIZE);
ffffffe000202638:	00001637          	lui	a2,0x1
ffffffe00020263c:	00000593          	li	a1,0
ffffffe000202640:	fe843503          	ld	a0,-24(s0)
ffffffe000202644:	230010ef          	jal	ffffffe000203874 <memset>
            // for (uint64_t i = 0; i < PGSIZE; i++)   *((char*)tmptbl + i) = 0; 
            // printk("kalloc: %lx\n", tmptbl);
            uint64_t* phy_tmptbl = (uint64_t*)((uint64_t)tmptbl - PA2VA_OFFSET);
ffffffe000202648:	fe843703          	ld	a4,-24(s0)
ffffffe00020264c:	04100793          	li	a5,65
ffffffe000202650:	01f79793          	slli	a5,a5,0x1f
ffffffe000202654:	00f707b3          	add	a5,a4,a5
ffffffe000202658:	faf43023          	sd	a5,-96(s0)
            *p_pte = (((uint64_t)phy_tmptbl >> 12) << 10) | 0x1;
ffffffe00020265c:	fa043783          	ld	a5,-96(s0)
ffffffe000202660:	00c7d793          	srli	a5,a5,0xc
ffffffe000202664:	00a79793          	slli	a5,a5,0xa
ffffffe000202668:	0017e713          	ori	a4,a5,1
ffffffe00020266c:	fb043783          	ld	a5,-80(s0)
ffffffe000202670:	00e7b023          	sd	a4,0(a5)
            // printk("new pte: %lx\n", *p_pte);
        }
        p_pte = tmptbl + vpn1;
ffffffe000202674:	fc043783          	ld	a5,-64(s0)
ffffffe000202678:	00379793          	slli	a5,a5,0x3
ffffffe00020267c:	fe843703          	ld	a4,-24(s0)
ffffffe000202680:	00f707b3          	add	a5,a4,a5
ffffffe000202684:	faf43823          	sd	a5,-80(s0)
        pte = tmptbl[vpn1];
ffffffe000202688:	fc043783          	ld	a5,-64(s0)
ffffffe00020268c:	00379793          	slli	a5,a5,0x3
ffffffe000202690:	fe843703          	ld	a4,-24(s0)
ffffffe000202694:	00f707b3          	add	a5,a4,a5
ffffffe000202698:	0007b783          	ld	a5,0(a5)
ffffffe00020269c:	faf43423          	sd	a5,-88(s0)
        // printk("tpmtbl: %lx, p_pte: %lx, pte: %lx\n", tmptbl, p_pte, pte);
        if(pte & 0x1){
ffffffe0002026a0:	fa843783          	ld	a5,-88(s0)
ffffffe0002026a4:	0017f793          	andi	a5,a5,1
ffffffe0002026a8:	02078263          	beqz	a5,ffffffe0002026cc <create_mapping+0x178>
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
ffffffe0002026ac:	fa843783          	ld	a5,-88(s0)
ffffffe0002026b0:	00a7d793          	srli	a5,a5,0xa
ffffffe0002026b4:	00c79713          	slli	a4,a5,0xc
ffffffe0002026b8:	fbf00793          	li	a5,-65
ffffffe0002026bc:	01f79793          	slli	a5,a5,0x1f
ffffffe0002026c0:	00f707b3          	add	a5,a4,a5
ffffffe0002026c4:	fef43423          	sd	a5,-24(s0)
ffffffe0002026c8:	0480006f          	j	ffffffe000202710 <create_mapping+0x1bc>
        } else {
            tmptbl = (uint64_t*)alloc_page();
ffffffe0002026cc:	ad0fe0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe0002026d0:	fea43423          	sd	a0,-24(s0)
            memset(tmptbl, 0, PGSIZE);
ffffffe0002026d4:	00001637          	lui	a2,0x1
ffffffe0002026d8:	00000593          	li	a1,0
ffffffe0002026dc:	fe843503          	ld	a0,-24(s0)
ffffffe0002026e0:	194010ef          	jal	ffffffe000203874 <memset>
            // for (uint64_t i = 0; i < PGSIZE; i++)   *((char*)tmptbl + i) = 0; 
            // printk("kalloc: %lx\n", tmptbl);
            uint64_t* phy_tmptbl = (uint64_t*)((uint64_t)tmptbl - PA2VA_OFFSET);
ffffffe0002026e4:	fe843703          	ld	a4,-24(s0)
ffffffe0002026e8:	04100793          	li	a5,65
ffffffe0002026ec:	01f79793          	slli	a5,a5,0x1f
ffffffe0002026f0:	00f707b3          	add	a5,a4,a5
ffffffe0002026f4:	f8f43c23          	sd	a5,-104(s0)
            *p_pte = (((uint64_t)phy_tmptbl >> 12) << 10) | 0x1;
ffffffe0002026f8:	f9843783          	ld	a5,-104(s0)
ffffffe0002026fc:	00c7d793          	srli	a5,a5,0xc
ffffffe000202700:	00a79793          	slli	a5,a5,0xa
ffffffe000202704:	0017e713          	ori	a4,a5,1
ffffffe000202708:	fb043783          	ld	a5,-80(s0)
ffffffe00020270c:	00e7b023          	sd	a4,0(a5)
            // printk("new pte: %lx\n", *p_pte);
        }
        p_pte = tmptbl + vpn0;
ffffffe000202710:	fb843783          	ld	a5,-72(s0)
ffffffe000202714:	00379793          	slli	a5,a5,0x3
ffffffe000202718:	fe843703          	ld	a4,-24(s0)
ffffffe00020271c:	00f707b3          	add	a5,a4,a5
ffffffe000202720:	faf43823          	sd	a5,-80(s0)
        *p_pte = ((addr >> 12) << 10) | perm;
ffffffe000202724:	fd843783          	ld	a5,-40(s0)
ffffffe000202728:	00c7d793          	srli	a5,a5,0xc
ffffffe00020272c:	00a79713          	slli	a4,a5,0xa
ffffffe000202730:	f6843783          	ld	a5,-152(s0)
ffffffe000202734:	00f76733          	or	a4,a4,a5
ffffffe000202738:	fb043783          	ld	a5,-80(s0)
ffffffe00020273c:	00e7b023          	sd	a4,0(a5)
    for(uint64_t addr_offset = 0; addr_offset < sz; addr_offset += PGSIZE){
ffffffe000202740:	fe043703          	ld	a4,-32(s0)
ffffffe000202744:	000017b7          	lui	a5,0x1
ffffffe000202748:	00f707b3          	add	a5,a4,a5
ffffffe00020274c:	fef43023          	sd	a5,-32(s0)
ffffffe000202750:	fe043703          	ld	a4,-32(s0)
ffffffe000202754:	f7043783          	ld	a5,-144(s0)
ffffffe000202758:	e2f764e3          	bltu	a4,a5,ffffffe000202580 <create_mapping+0x2c>
        // printk("tmptbl: %lx, p_pte: %lx, pte: %lx\n", tmptbl, p_pte, *p_pte);
    }
    Log("root: %lx, paddr: [%lx, %lx), vaddr: [%lx, %lx), perm: %lx\n", pgtbl, pa, pa+sz, va, va+sz, perm);
ffffffe00020275c:	f7843703          	ld	a4,-136(s0)
ffffffe000202760:	f7043783          	ld	a5,-144(s0)
ffffffe000202764:	00f706b3          	add	a3,a4,a5
ffffffe000202768:	f8043703          	ld	a4,-128(s0)
ffffffe00020276c:	f7043783          	ld	a5,-144(s0)
ffffffe000202770:	00f707b3          	add	a5,a4,a5
ffffffe000202774:	f6843703          	ld	a4,-152(s0)
ffffffe000202778:	00e13423          	sd	a4,8(sp)
ffffffe00020277c:	00f13023          	sd	a5,0(sp)
ffffffe000202780:	f8043883          	ld	a7,-128(s0)
ffffffe000202784:	00068813          	mv	a6,a3
ffffffe000202788:	f7843783          	ld	a5,-136(s0)
ffffffe00020278c:	f8843703          	ld	a4,-120(s0)
ffffffe000202790:	00002697          	auipc	a3,0x2
ffffffe000202794:	c8068693          	addi	a3,a3,-896 # ffffffe000204410 <__func__.0>
ffffffe000202798:	09500613          	li	a2,149
ffffffe00020279c:	00002597          	auipc	a1,0x2
ffffffe0002027a0:	c1458593          	addi	a1,a1,-1004 # ffffffe0002043b0 <__func__.0+0x90>
ffffffe0002027a4:	00002517          	auipc	a0,0x2
ffffffe0002027a8:	c1450513          	addi	a0,a0,-1004 # ffffffe0002043b8 <__func__.0+0x98>
ffffffe0002027ac:	799000ef          	jal	ffffffe000203744 <printk>
}
ffffffe0002027b0:	00000013          	nop
ffffffe0002027b4:	0a813083          	ld	ra,168(sp)
ffffffe0002027b8:	0a013403          	ld	s0,160(sp)
ffffffe0002027bc:	0b010113          	addi	sp,sp,176
ffffffe0002027c0:	00008067          	ret

ffffffe0002027c4 <start_kernel>:
#include "printk.h"

extern void test();
extern void schedule();

int start_kernel() {
ffffffe0002027c4:	ff010113          	addi	sp,sp,-16
ffffffe0002027c8:	00113423          	sd	ra,8(sp)
ffffffe0002027cc:	00813023          	sd	s0,0(sp)
ffffffe0002027d0:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe0002027d4:	00002517          	auipc	a0,0x2
ffffffe0002027d8:	c4c50513          	addi	a0,a0,-948 # ffffffe000204420 <__func__.0+0x10>
ffffffe0002027dc:	769000ef          	jal	ffffffe000203744 <printk>
    printk(" ZJU Operating System\n");
ffffffe0002027e0:	00002517          	auipc	a0,0x2
ffffffe0002027e4:	c4850513          	addi	a0,a0,-952 # ffffffe000204428 <__func__.0+0x18>
ffffffe0002027e8:	75d000ef          	jal	ffffffe000203744 <printk>
    schedule();
ffffffe0002027ec:	b7dfe0ef          	jal	ffffffe000201368 <schedule>
    test();
ffffffe0002027f0:	01c000ef          	jal	ffffffe00020280c <test>
    return 0;
ffffffe0002027f4:	00000793          	li	a5,0
}
ffffffe0002027f8:	00078513          	mv	a0,a5
ffffffe0002027fc:	00813083          	ld	ra,8(sp)
ffffffe000202800:	00013403          	ld	s0,0(sp)
ffffffe000202804:	01010113          	addi	sp,sp,16
ffffffe000202808:	00008067          	ret

ffffffe00020280c <test>:
#include "sbi.h"
#include "printk.h"

void test() {
ffffffe00020280c:	fe010113          	addi	sp,sp,-32
ffffffe000202810:	00113c23          	sd	ra,24(sp)
ffffffe000202814:	00813823          	sd	s0,16(sp)
ffffffe000202818:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe00020281c:	fe042623          	sw	zero,-20(s0)
    while (1) {
        if ((++i) % 100000000 == 0) {
ffffffe000202820:	fec42783          	lw	a5,-20(s0)
ffffffe000202824:	0017879b          	addiw	a5,a5,1 # 1001 <PGSIZE+0x1>
ffffffe000202828:	fef42623          	sw	a5,-20(s0)
ffffffe00020282c:	fec42783          	lw	a5,-20(s0)
ffffffe000202830:	0007869b          	sext.w	a3,a5
ffffffe000202834:	55e64737          	lui	a4,0x55e64
ffffffe000202838:	b8970713          	addi	a4,a4,-1143 # 55e63b89 <PHY_SIZE+0x4de63b89>
ffffffe00020283c:	02e68733          	mul	a4,a3,a4
ffffffe000202840:	02075713          	srli	a4,a4,0x20
ffffffe000202844:	4197571b          	sraiw	a4,a4,0x19
ffffffe000202848:	00070693          	mv	a3,a4
ffffffe00020284c:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffe000202850:	40e6873b          	subw	a4,a3,a4
ffffffe000202854:	00070693          	mv	a3,a4
ffffffe000202858:	05f5e737          	lui	a4,0x5f5e
ffffffe00020285c:	1007071b          	addiw	a4,a4,256 # 5f5e100 <OPENSBI_SIZE+0x5d5e100>
ffffffe000202860:	02e6873b          	mulw	a4,a3,a4
ffffffe000202864:	40e787bb          	subw	a5,a5,a4
ffffffe000202868:	0007879b          	sext.w	a5,a5
ffffffe00020286c:	fa079ae3          	bnez	a5,ffffffe000202820 <test+0x14>
            printk("kernel is running!\n");
ffffffe000202870:	00002517          	auipc	a0,0x2
ffffffe000202874:	bd050513          	addi	a0,a0,-1072 # ffffffe000204440 <__func__.0+0x30>
ffffffe000202878:	6cd000ef          	jal	ffffffe000203744 <printk>
            i = 0;
ffffffe00020287c:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0) {
ffffffe000202880:	fa1ff06f          	j	ffffffe000202820 <test+0x14>

ffffffe000202884 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe000202884:	fe010113          	addi	sp,sp,-32
ffffffe000202888:	00113c23          	sd	ra,24(sp)
ffffffe00020288c:	00813823          	sd	s0,16(sp)
ffffffe000202890:	02010413          	addi	s0,sp,32
ffffffe000202894:	00050793          	mv	a5,a0
ffffffe000202898:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe00020289c:	fec42783          	lw	a5,-20(s0)
ffffffe0002028a0:	0ff7f793          	zext.b	a5,a5
ffffffe0002028a4:	00078513          	mv	a0,a5
ffffffe0002028a8:	dedfe0ef          	jal	ffffffe000201694 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe0002028ac:	fec42783          	lw	a5,-20(s0)
ffffffe0002028b0:	0ff7f793          	zext.b	a5,a5
ffffffe0002028b4:	0007879b          	sext.w	a5,a5
}
ffffffe0002028b8:	00078513          	mv	a0,a5
ffffffe0002028bc:	01813083          	ld	ra,24(sp)
ffffffe0002028c0:	01013403          	ld	s0,16(sp)
ffffffe0002028c4:	02010113          	addi	sp,sp,32
ffffffe0002028c8:	00008067          	ret

ffffffe0002028cc <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe0002028cc:	fe010113          	addi	sp,sp,-32
ffffffe0002028d0:	00113c23          	sd	ra,24(sp)
ffffffe0002028d4:	00813823          	sd	s0,16(sp)
ffffffe0002028d8:	02010413          	addi	s0,sp,32
ffffffe0002028dc:	00050793          	mv	a5,a0
ffffffe0002028e0:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe0002028e4:	fec42783          	lw	a5,-20(s0)
ffffffe0002028e8:	0007871b          	sext.w	a4,a5
ffffffe0002028ec:	02000793          	li	a5,32
ffffffe0002028f0:	02f70263          	beq	a4,a5,ffffffe000202914 <isspace+0x48>
ffffffe0002028f4:	fec42783          	lw	a5,-20(s0)
ffffffe0002028f8:	0007871b          	sext.w	a4,a5
ffffffe0002028fc:	00800793          	li	a5,8
ffffffe000202900:	00e7de63          	bge	a5,a4,ffffffe00020291c <isspace+0x50>
ffffffe000202904:	fec42783          	lw	a5,-20(s0)
ffffffe000202908:	0007871b          	sext.w	a4,a5
ffffffe00020290c:	00d00793          	li	a5,13
ffffffe000202910:	00e7c663          	blt	a5,a4,ffffffe00020291c <isspace+0x50>
ffffffe000202914:	00100793          	li	a5,1
ffffffe000202918:	0080006f          	j	ffffffe000202920 <isspace+0x54>
ffffffe00020291c:	00000793          	li	a5,0
}
ffffffe000202920:	00078513          	mv	a0,a5
ffffffe000202924:	01813083          	ld	ra,24(sp)
ffffffe000202928:	01013403          	ld	s0,16(sp)
ffffffe00020292c:	02010113          	addi	sp,sp,32
ffffffe000202930:	00008067          	ret

ffffffe000202934 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000202934:	fb010113          	addi	sp,sp,-80
ffffffe000202938:	04113423          	sd	ra,72(sp)
ffffffe00020293c:	04813023          	sd	s0,64(sp)
ffffffe000202940:	05010413          	addi	s0,sp,80
ffffffe000202944:	fca43423          	sd	a0,-56(s0)
ffffffe000202948:	fcb43023          	sd	a1,-64(s0)
ffffffe00020294c:	00060793          	mv	a5,a2
ffffffe000202950:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe000202954:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000202958:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe00020295c:	fc843783          	ld	a5,-56(s0)
ffffffe000202960:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe000202964:	0100006f          	j	ffffffe000202974 <strtol+0x40>
        p++;
ffffffe000202968:	fd843783          	ld	a5,-40(s0)
ffffffe00020296c:	00178793          	addi	a5,a5,1
ffffffe000202970:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe000202974:	fd843783          	ld	a5,-40(s0)
ffffffe000202978:	0007c783          	lbu	a5,0(a5)
ffffffe00020297c:	0007879b          	sext.w	a5,a5
ffffffe000202980:	00078513          	mv	a0,a5
ffffffe000202984:	f49ff0ef          	jal	ffffffe0002028cc <isspace>
ffffffe000202988:	00050793          	mv	a5,a0
ffffffe00020298c:	fc079ee3          	bnez	a5,ffffffe000202968 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe000202990:	fd843783          	ld	a5,-40(s0)
ffffffe000202994:	0007c783          	lbu	a5,0(a5)
ffffffe000202998:	00078713          	mv	a4,a5
ffffffe00020299c:	02d00793          	li	a5,45
ffffffe0002029a0:	00f71e63          	bne	a4,a5,ffffffe0002029bc <strtol+0x88>
        neg = true;
ffffffe0002029a4:	00100793          	li	a5,1
ffffffe0002029a8:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe0002029ac:	fd843783          	ld	a5,-40(s0)
ffffffe0002029b0:	00178793          	addi	a5,a5,1
ffffffe0002029b4:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002029b8:	0240006f          	j	ffffffe0002029dc <strtol+0xa8>
    } else if (*p == '+') {
ffffffe0002029bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002029c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002029c4:	00078713          	mv	a4,a5
ffffffe0002029c8:	02b00793          	li	a5,43
ffffffe0002029cc:	00f71863          	bne	a4,a5,ffffffe0002029dc <strtol+0xa8>
        p++;
ffffffe0002029d0:	fd843783          	ld	a5,-40(s0)
ffffffe0002029d4:	00178793          	addi	a5,a5,1
ffffffe0002029d8:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe0002029dc:	fbc42783          	lw	a5,-68(s0)
ffffffe0002029e0:	0007879b          	sext.w	a5,a5
ffffffe0002029e4:	06079c63          	bnez	a5,ffffffe000202a5c <strtol+0x128>
        if (*p == '0') {
ffffffe0002029e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002029ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002029f0:	00078713          	mv	a4,a5
ffffffe0002029f4:	03000793          	li	a5,48
ffffffe0002029f8:	04f71e63          	bne	a4,a5,ffffffe000202a54 <strtol+0x120>
            p++;
ffffffe0002029fc:	fd843783          	ld	a5,-40(s0)
ffffffe000202a00:	00178793          	addi	a5,a5,1
ffffffe000202a04:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000202a08:	fd843783          	ld	a5,-40(s0)
ffffffe000202a0c:	0007c783          	lbu	a5,0(a5)
ffffffe000202a10:	00078713          	mv	a4,a5
ffffffe000202a14:	07800793          	li	a5,120
ffffffe000202a18:	00f70c63          	beq	a4,a5,ffffffe000202a30 <strtol+0xfc>
ffffffe000202a1c:	fd843783          	ld	a5,-40(s0)
ffffffe000202a20:	0007c783          	lbu	a5,0(a5)
ffffffe000202a24:	00078713          	mv	a4,a5
ffffffe000202a28:	05800793          	li	a5,88
ffffffe000202a2c:	00f71e63          	bne	a4,a5,ffffffe000202a48 <strtol+0x114>
                base = 16;
ffffffe000202a30:	01000793          	li	a5,16
ffffffe000202a34:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000202a38:	fd843783          	ld	a5,-40(s0)
ffffffe000202a3c:	00178793          	addi	a5,a5,1
ffffffe000202a40:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202a44:	0180006f          	j	ffffffe000202a5c <strtol+0x128>
            } else {
                base = 8;
ffffffe000202a48:	00800793          	li	a5,8
ffffffe000202a4c:	faf42e23          	sw	a5,-68(s0)
ffffffe000202a50:	00c0006f          	j	ffffffe000202a5c <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe000202a54:	00a00793          	li	a5,10
ffffffe000202a58:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe000202a5c:	fd843783          	ld	a5,-40(s0)
ffffffe000202a60:	0007c783          	lbu	a5,0(a5)
ffffffe000202a64:	00078713          	mv	a4,a5
ffffffe000202a68:	02f00793          	li	a5,47
ffffffe000202a6c:	02e7f863          	bgeu	a5,a4,ffffffe000202a9c <strtol+0x168>
ffffffe000202a70:	fd843783          	ld	a5,-40(s0)
ffffffe000202a74:	0007c783          	lbu	a5,0(a5)
ffffffe000202a78:	00078713          	mv	a4,a5
ffffffe000202a7c:	03900793          	li	a5,57
ffffffe000202a80:	00e7ee63          	bltu	a5,a4,ffffffe000202a9c <strtol+0x168>
            digit = *p - '0';
ffffffe000202a84:	fd843783          	ld	a5,-40(s0)
ffffffe000202a88:	0007c783          	lbu	a5,0(a5)
ffffffe000202a8c:	0007879b          	sext.w	a5,a5
ffffffe000202a90:	fd07879b          	addiw	a5,a5,-48
ffffffe000202a94:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202a98:	0800006f          	j	ffffffe000202b18 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe000202a9c:	fd843783          	ld	a5,-40(s0)
ffffffe000202aa0:	0007c783          	lbu	a5,0(a5)
ffffffe000202aa4:	00078713          	mv	a4,a5
ffffffe000202aa8:	06000793          	li	a5,96
ffffffe000202aac:	02e7f863          	bgeu	a5,a4,ffffffe000202adc <strtol+0x1a8>
ffffffe000202ab0:	fd843783          	ld	a5,-40(s0)
ffffffe000202ab4:	0007c783          	lbu	a5,0(a5)
ffffffe000202ab8:	00078713          	mv	a4,a5
ffffffe000202abc:	07a00793          	li	a5,122
ffffffe000202ac0:	00e7ee63          	bltu	a5,a4,ffffffe000202adc <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe000202ac4:	fd843783          	ld	a5,-40(s0)
ffffffe000202ac8:	0007c783          	lbu	a5,0(a5)
ffffffe000202acc:	0007879b          	sext.w	a5,a5
ffffffe000202ad0:	fa97879b          	addiw	a5,a5,-87
ffffffe000202ad4:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202ad8:	0400006f          	j	ffffffe000202b18 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe000202adc:	fd843783          	ld	a5,-40(s0)
ffffffe000202ae0:	0007c783          	lbu	a5,0(a5)
ffffffe000202ae4:	00078713          	mv	a4,a5
ffffffe000202ae8:	04000793          	li	a5,64
ffffffe000202aec:	06e7f863          	bgeu	a5,a4,ffffffe000202b5c <strtol+0x228>
ffffffe000202af0:	fd843783          	ld	a5,-40(s0)
ffffffe000202af4:	0007c783          	lbu	a5,0(a5)
ffffffe000202af8:	00078713          	mv	a4,a5
ffffffe000202afc:	05a00793          	li	a5,90
ffffffe000202b00:	04e7ee63          	bltu	a5,a4,ffffffe000202b5c <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe000202b04:	fd843783          	ld	a5,-40(s0)
ffffffe000202b08:	0007c783          	lbu	a5,0(a5)
ffffffe000202b0c:	0007879b          	sext.w	a5,a5
ffffffe000202b10:	fc97879b          	addiw	a5,a5,-55
ffffffe000202b14:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000202b18:	fd442783          	lw	a5,-44(s0)
ffffffe000202b1c:	00078713          	mv	a4,a5
ffffffe000202b20:	fbc42783          	lw	a5,-68(s0)
ffffffe000202b24:	0007071b          	sext.w	a4,a4
ffffffe000202b28:	0007879b          	sext.w	a5,a5
ffffffe000202b2c:	02f75663          	bge	a4,a5,ffffffe000202b58 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000202b30:	fbc42703          	lw	a4,-68(s0)
ffffffe000202b34:	fe843783          	ld	a5,-24(s0)
ffffffe000202b38:	02f70733          	mul	a4,a4,a5
ffffffe000202b3c:	fd442783          	lw	a5,-44(s0)
ffffffe000202b40:	00f707b3          	add	a5,a4,a5
ffffffe000202b44:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000202b48:	fd843783          	ld	a5,-40(s0)
ffffffe000202b4c:	00178793          	addi	a5,a5,1
ffffffe000202b50:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe000202b54:	f09ff06f          	j	ffffffe000202a5c <strtol+0x128>
            break;
ffffffe000202b58:	00000013          	nop
    }

    if (endptr) {
ffffffe000202b5c:	fc043783          	ld	a5,-64(s0)
ffffffe000202b60:	00078863          	beqz	a5,ffffffe000202b70 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe000202b64:	fc043783          	ld	a5,-64(s0)
ffffffe000202b68:	fd843703          	ld	a4,-40(s0)
ffffffe000202b6c:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe000202b70:	fe744783          	lbu	a5,-25(s0)
ffffffe000202b74:	0ff7f793          	zext.b	a5,a5
ffffffe000202b78:	00078863          	beqz	a5,ffffffe000202b88 <strtol+0x254>
ffffffe000202b7c:	fe843783          	ld	a5,-24(s0)
ffffffe000202b80:	40f007b3          	neg	a5,a5
ffffffe000202b84:	0080006f          	j	ffffffe000202b8c <strtol+0x258>
ffffffe000202b88:	fe843783          	ld	a5,-24(s0)
}
ffffffe000202b8c:	00078513          	mv	a0,a5
ffffffe000202b90:	04813083          	ld	ra,72(sp)
ffffffe000202b94:	04013403          	ld	s0,64(sp)
ffffffe000202b98:	05010113          	addi	sp,sp,80
ffffffe000202b9c:	00008067          	ret

ffffffe000202ba0 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe000202ba0:	fd010113          	addi	sp,sp,-48
ffffffe000202ba4:	02113423          	sd	ra,40(sp)
ffffffe000202ba8:	02813023          	sd	s0,32(sp)
ffffffe000202bac:	03010413          	addi	s0,sp,48
ffffffe000202bb0:	fca43c23          	sd	a0,-40(s0)
ffffffe000202bb4:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe000202bb8:	fd043783          	ld	a5,-48(s0)
ffffffe000202bbc:	00079863          	bnez	a5,ffffffe000202bcc <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe000202bc0:	00002797          	auipc	a5,0x2
ffffffe000202bc4:	89878793          	addi	a5,a5,-1896 # ffffffe000204458 <__func__.0+0x48>
ffffffe000202bc8:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe000202bcc:	fd043783          	ld	a5,-48(s0)
ffffffe000202bd0:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe000202bd4:	0240006f          	j	ffffffe000202bf8 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe000202bd8:	fe843783          	ld	a5,-24(s0)
ffffffe000202bdc:	00178713          	addi	a4,a5,1
ffffffe000202be0:	fee43423          	sd	a4,-24(s0)
ffffffe000202be4:	0007c783          	lbu	a5,0(a5)
ffffffe000202be8:	0007871b          	sext.w	a4,a5
ffffffe000202bec:	fd843783          	ld	a5,-40(s0)
ffffffe000202bf0:	00070513          	mv	a0,a4
ffffffe000202bf4:	000780e7          	jalr	a5
    while (*p) {
ffffffe000202bf8:	fe843783          	ld	a5,-24(s0)
ffffffe000202bfc:	0007c783          	lbu	a5,0(a5)
ffffffe000202c00:	fc079ce3          	bnez	a5,ffffffe000202bd8 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe000202c04:	fe843703          	ld	a4,-24(s0)
ffffffe000202c08:	fd043783          	ld	a5,-48(s0)
ffffffe000202c0c:	40f707b3          	sub	a5,a4,a5
ffffffe000202c10:	0007879b          	sext.w	a5,a5
}
ffffffe000202c14:	00078513          	mv	a0,a5
ffffffe000202c18:	02813083          	ld	ra,40(sp)
ffffffe000202c1c:	02013403          	ld	s0,32(sp)
ffffffe000202c20:	03010113          	addi	sp,sp,48
ffffffe000202c24:	00008067          	ret

ffffffe000202c28 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000202c28:	f9010113          	addi	sp,sp,-112
ffffffe000202c2c:	06113423          	sd	ra,104(sp)
ffffffe000202c30:	06813023          	sd	s0,96(sp)
ffffffe000202c34:	07010413          	addi	s0,sp,112
ffffffe000202c38:	faa43423          	sd	a0,-88(s0)
ffffffe000202c3c:	fab43023          	sd	a1,-96(s0)
ffffffe000202c40:	00060793          	mv	a5,a2
ffffffe000202c44:	f8d43823          	sd	a3,-112(s0)
ffffffe000202c48:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe000202c4c:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202c50:	0ff7f793          	zext.b	a5,a5
ffffffe000202c54:	02078663          	beqz	a5,ffffffe000202c80 <print_dec_int+0x58>
ffffffe000202c58:	fa043703          	ld	a4,-96(s0)
ffffffe000202c5c:	fff00793          	li	a5,-1
ffffffe000202c60:	03f79793          	slli	a5,a5,0x3f
ffffffe000202c64:	00f71e63          	bne	a4,a5,ffffffe000202c80 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000202c68:	00001597          	auipc	a1,0x1
ffffffe000202c6c:	7f858593          	addi	a1,a1,2040 # ffffffe000204460 <__func__.0+0x50>
ffffffe000202c70:	fa843503          	ld	a0,-88(s0)
ffffffe000202c74:	f2dff0ef          	jal	ffffffe000202ba0 <puts_wo_nl>
ffffffe000202c78:	00050793          	mv	a5,a0
ffffffe000202c7c:	2c80006f          	j	ffffffe000202f44 <print_dec_int+0x31c>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe000202c80:	f9043783          	ld	a5,-112(s0)
ffffffe000202c84:	00c7a783          	lw	a5,12(a5)
ffffffe000202c88:	00079a63          	bnez	a5,ffffffe000202c9c <print_dec_int+0x74>
ffffffe000202c8c:	fa043783          	ld	a5,-96(s0)
ffffffe000202c90:	00079663          	bnez	a5,ffffffe000202c9c <print_dec_int+0x74>
        return 0;
ffffffe000202c94:	00000793          	li	a5,0
ffffffe000202c98:	2ac0006f          	j	ffffffe000202f44 <print_dec_int+0x31c>
    }

    bool neg = false;
ffffffe000202c9c:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe000202ca0:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202ca4:	0ff7f793          	zext.b	a5,a5
ffffffe000202ca8:	02078063          	beqz	a5,ffffffe000202cc8 <print_dec_int+0xa0>
ffffffe000202cac:	fa043783          	ld	a5,-96(s0)
ffffffe000202cb0:	0007dc63          	bgez	a5,ffffffe000202cc8 <print_dec_int+0xa0>
        neg = true;
ffffffe000202cb4:	00100793          	li	a5,1
ffffffe000202cb8:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe000202cbc:	fa043783          	ld	a5,-96(s0)
ffffffe000202cc0:	40f007b3          	neg	a5,a5
ffffffe000202cc4:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe000202cc8:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe000202ccc:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202cd0:	0ff7f793          	zext.b	a5,a5
ffffffe000202cd4:	02078863          	beqz	a5,ffffffe000202d04 <print_dec_int+0xdc>
ffffffe000202cd8:	fef44783          	lbu	a5,-17(s0)
ffffffe000202cdc:	0ff7f793          	zext.b	a5,a5
ffffffe000202ce0:	00079e63          	bnez	a5,ffffffe000202cfc <print_dec_int+0xd4>
ffffffe000202ce4:	f9043783          	ld	a5,-112(s0)
ffffffe000202ce8:	0057c783          	lbu	a5,5(a5)
ffffffe000202cec:	00079863          	bnez	a5,ffffffe000202cfc <print_dec_int+0xd4>
ffffffe000202cf0:	f9043783          	ld	a5,-112(s0)
ffffffe000202cf4:	0047c783          	lbu	a5,4(a5)
ffffffe000202cf8:	00078663          	beqz	a5,ffffffe000202d04 <print_dec_int+0xdc>
ffffffe000202cfc:	00100793          	li	a5,1
ffffffe000202d00:	0080006f          	j	ffffffe000202d08 <print_dec_int+0xe0>
ffffffe000202d04:	00000793          	li	a5,0
ffffffe000202d08:	fcf40ba3          	sb	a5,-41(s0)
ffffffe000202d0c:	fd744783          	lbu	a5,-41(s0)
ffffffe000202d10:	0017f793          	andi	a5,a5,1
ffffffe000202d14:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000202d18:	fa043683          	ld	a3,-96(s0)
ffffffe000202d1c:	00001797          	auipc	a5,0x1
ffffffe000202d20:	75c78793          	addi	a5,a5,1884 # ffffffe000204478 <__func__.0+0x68>
ffffffe000202d24:	0007b783          	ld	a5,0(a5)
ffffffe000202d28:	02f6b7b3          	mulhu	a5,a3,a5
ffffffe000202d2c:	0037d713          	srli	a4,a5,0x3
ffffffe000202d30:	00070793          	mv	a5,a4
ffffffe000202d34:	00279793          	slli	a5,a5,0x2
ffffffe000202d38:	00e787b3          	add	a5,a5,a4
ffffffe000202d3c:	00179793          	slli	a5,a5,0x1
ffffffe000202d40:	40f68733          	sub	a4,a3,a5
ffffffe000202d44:	0ff77713          	zext.b	a4,a4
ffffffe000202d48:	fe842783          	lw	a5,-24(s0)
ffffffe000202d4c:	0017869b          	addiw	a3,a5,1
ffffffe000202d50:	fed42423          	sw	a3,-24(s0)
ffffffe000202d54:	0307071b          	addiw	a4,a4,48
ffffffe000202d58:	0ff77713          	zext.b	a4,a4
ffffffe000202d5c:	ff078793          	addi	a5,a5,-16
ffffffe000202d60:	008787b3          	add	a5,a5,s0
ffffffe000202d64:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000202d68:	fa043703          	ld	a4,-96(s0)
ffffffe000202d6c:	00001797          	auipc	a5,0x1
ffffffe000202d70:	70c78793          	addi	a5,a5,1804 # ffffffe000204478 <__func__.0+0x68>
ffffffe000202d74:	0007b783          	ld	a5,0(a5)
ffffffe000202d78:	02f737b3          	mulhu	a5,a4,a5
ffffffe000202d7c:	0037d793          	srli	a5,a5,0x3
ffffffe000202d80:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe000202d84:	fa043783          	ld	a5,-96(s0)
ffffffe000202d88:	f80798e3          	bnez	a5,ffffffe000202d18 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000202d8c:	f9043783          	ld	a5,-112(s0)
ffffffe000202d90:	00c7a703          	lw	a4,12(a5)
ffffffe000202d94:	fff00793          	li	a5,-1
ffffffe000202d98:	02f71063          	bne	a4,a5,ffffffe000202db8 <print_dec_int+0x190>
ffffffe000202d9c:	f9043783          	ld	a5,-112(s0)
ffffffe000202da0:	0037c783          	lbu	a5,3(a5)
ffffffe000202da4:	00078a63          	beqz	a5,ffffffe000202db8 <print_dec_int+0x190>
        flags->prec = flags->width;
ffffffe000202da8:	f9043783          	ld	a5,-112(s0)
ffffffe000202dac:	0087a703          	lw	a4,8(a5)
ffffffe000202db0:	f9043783          	ld	a5,-112(s0)
ffffffe000202db4:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe000202db8:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202dbc:	f9043783          	ld	a5,-112(s0)
ffffffe000202dc0:	0087a703          	lw	a4,8(a5)
ffffffe000202dc4:	fe842783          	lw	a5,-24(s0)
ffffffe000202dc8:	fcf42823          	sw	a5,-48(s0)
ffffffe000202dcc:	f9043783          	ld	a5,-112(s0)
ffffffe000202dd0:	00c7a783          	lw	a5,12(a5)
ffffffe000202dd4:	fcf42623          	sw	a5,-52(s0)
ffffffe000202dd8:	fd042783          	lw	a5,-48(s0)
ffffffe000202ddc:	00078593          	mv	a1,a5
ffffffe000202de0:	fcc42783          	lw	a5,-52(s0)
ffffffe000202de4:	00078613          	mv	a2,a5
ffffffe000202de8:	0006069b          	sext.w	a3,a2
ffffffe000202dec:	0005879b          	sext.w	a5,a1
ffffffe000202df0:	00f6d463          	bge	a3,a5,ffffffe000202df8 <print_dec_int+0x1d0>
ffffffe000202df4:	00058613          	mv	a2,a1
ffffffe000202df8:	0006079b          	sext.w	a5,a2
ffffffe000202dfc:	40f707bb          	subw	a5,a4,a5
ffffffe000202e00:	0007871b          	sext.w	a4,a5
ffffffe000202e04:	fd744783          	lbu	a5,-41(s0)
ffffffe000202e08:	0007879b          	sext.w	a5,a5
ffffffe000202e0c:	40f707bb          	subw	a5,a4,a5
ffffffe000202e10:	fef42023          	sw	a5,-32(s0)
ffffffe000202e14:	0280006f          	j	ffffffe000202e3c <print_dec_int+0x214>
        putch(' ');
ffffffe000202e18:	fa843783          	ld	a5,-88(s0)
ffffffe000202e1c:	02000513          	li	a0,32
ffffffe000202e20:	000780e7          	jalr	a5
        ++written;
ffffffe000202e24:	fe442783          	lw	a5,-28(s0)
ffffffe000202e28:	0017879b          	addiw	a5,a5,1
ffffffe000202e2c:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202e30:	fe042783          	lw	a5,-32(s0)
ffffffe000202e34:	fff7879b          	addiw	a5,a5,-1
ffffffe000202e38:	fef42023          	sw	a5,-32(s0)
ffffffe000202e3c:	fe042783          	lw	a5,-32(s0)
ffffffe000202e40:	0007879b          	sext.w	a5,a5
ffffffe000202e44:	fcf04ae3          	bgtz	a5,ffffffe000202e18 <print_dec_int+0x1f0>
    }

    if (has_sign_char) {
ffffffe000202e48:	fd744783          	lbu	a5,-41(s0)
ffffffe000202e4c:	0ff7f793          	zext.b	a5,a5
ffffffe000202e50:	04078463          	beqz	a5,ffffffe000202e98 <print_dec_int+0x270>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe000202e54:	fef44783          	lbu	a5,-17(s0)
ffffffe000202e58:	0ff7f793          	zext.b	a5,a5
ffffffe000202e5c:	00078663          	beqz	a5,ffffffe000202e68 <print_dec_int+0x240>
ffffffe000202e60:	02d00793          	li	a5,45
ffffffe000202e64:	01c0006f          	j	ffffffe000202e80 <print_dec_int+0x258>
ffffffe000202e68:	f9043783          	ld	a5,-112(s0)
ffffffe000202e6c:	0057c783          	lbu	a5,5(a5)
ffffffe000202e70:	00078663          	beqz	a5,ffffffe000202e7c <print_dec_int+0x254>
ffffffe000202e74:	02b00793          	li	a5,43
ffffffe000202e78:	0080006f          	j	ffffffe000202e80 <print_dec_int+0x258>
ffffffe000202e7c:	02000793          	li	a5,32
ffffffe000202e80:	fa843703          	ld	a4,-88(s0)
ffffffe000202e84:	00078513          	mv	a0,a5
ffffffe000202e88:	000700e7          	jalr	a4
        ++written;
ffffffe000202e8c:	fe442783          	lw	a5,-28(s0)
ffffffe000202e90:	0017879b          	addiw	a5,a5,1
ffffffe000202e94:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202e98:	fe842783          	lw	a5,-24(s0)
ffffffe000202e9c:	fcf42e23          	sw	a5,-36(s0)
ffffffe000202ea0:	0280006f          	j	ffffffe000202ec8 <print_dec_int+0x2a0>
        putch('0');
ffffffe000202ea4:	fa843783          	ld	a5,-88(s0)
ffffffe000202ea8:	03000513          	li	a0,48
ffffffe000202eac:	000780e7          	jalr	a5
        ++written;
ffffffe000202eb0:	fe442783          	lw	a5,-28(s0)
ffffffe000202eb4:	0017879b          	addiw	a5,a5,1
ffffffe000202eb8:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202ebc:	fdc42783          	lw	a5,-36(s0)
ffffffe000202ec0:	0017879b          	addiw	a5,a5,1
ffffffe000202ec4:	fcf42e23          	sw	a5,-36(s0)
ffffffe000202ec8:	f9043783          	ld	a5,-112(s0)
ffffffe000202ecc:	00c7a703          	lw	a4,12(a5)
ffffffe000202ed0:	fd744783          	lbu	a5,-41(s0)
ffffffe000202ed4:	0007879b          	sext.w	a5,a5
ffffffe000202ed8:	40f707bb          	subw	a5,a4,a5
ffffffe000202edc:	0007879b          	sext.w	a5,a5
ffffffe000202ee0:	fdc42703          	lw	a4,-36(s0)
ffffffe000202ee4:	0007071b          	sext.w	a4,a4
ffffffe000202ee8:	faf74ee3          	blt	a4,a5,ffffffe000202ea4 <print_dec_int+0x27c>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000202eec:	fe842783          	lw	a5,-24(s0)
ffffffe000202ef0:	fff7879b          	addiw	a5,a5,-1
ffffffe000202ef4:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202ef8:	03c0006f          	j	ffffffe000202f34 <print_dec_int+0x30c>
        putch(buf[i]);
ffffffe000202efc:	fd842783          	lw	a5,-40(s0)
ffffffe000202f00:	ff078793          	addi	a5,a5,-16
ffffffe000202f04:	008787b3          	add	a5,a5,s0
ffffffe000202f08:	fc87c783          	lbu	a5,-56(a5)
ffffffe000202f0c:	0007871b          	sext.w	a4,a5
ffffffe000202f10:	fa843783          	ld	a5,-88(s0)
ffffffe000202f14:	00070513          	mv	a0,a4
ffffffe000202f18:	000780e7          	jalr	a5
        ++written;
ffffffe000202f1c:	fe442783          	lw	a5,-28(s0)
ffffffe000202f20:	0017879b          	addiw	a5,a5,1
ffffffe000202f24:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000202f28:	fd842783          	lw	a5,-40(s0)
ffffffe000202f2c:	fff7879b          	addiw	a5,a5,-1
ffffffe000202f30:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202f34:	fd842783          	lw	a5,-40(s0)
ffffffe000202f38:	0007879b          	sext.w	a5,a5
ffffffe000202f3c:	fc07d0e3          	bgez	a5,ffffffe000202efc <print_dec_int+0x2d4>
    }

    return written;
ffffffe000202f40:	fe442783          	lw	a5,-28(s0)
}
ffffffe000202f44:	00078513          	mv	a0,a5
ffffffe000202f48:	06813083          	ld	ra,104(sp)
ffffffe000202f4c:	06013403          	ld	s0,96(sp)
ffffffe000202f50:	07010113          	addi	sp,sp,112
ffffffe000202f54:	00008067          	ret

ffffffe000202f58 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000202f58:	f4010113          	addi	sp,sp,-192
ffffffe000202f5c:	0a113c23          	sd	ra,184(sp)
ffffffe000202f60:	0a813823          	sd	s0,176(sp)
ffffffe000202f64:	0c010413          	addi	s0,sp,192
ffffffe000202f68:	f4a43c23          	sd	a0,-168(s0)
ffffffe000202f6c:	f4b43823          	sd	a1,-176(s0)
ffffffe000202f70:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe000202f74:	f8043023          	sd	zero,-128(s0)
ffffffe000202f78:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000202f7c:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000202f80:	7a00006f          	j	ffffffe000203720 <vprintfmt+0x7c8>
        if (flags.in_format) {
ffffffe000202f84:	f8044783          	lbu	a5,-128(s0)
ffffffe000202f88:	72078c63          	beqz	a5,ffffffe0002036c0 <vprintfmt+0x768>
            if (*fmt == '#') {
ffffffe000202f8c:	f5043783          	ld	a5,-176(s0)
ffffffe000202f90:	0007c783          	lbu	a5,0(a5)
ffffffe000202f94:	00078713          	mv	a4,a5
ffffffe000202f98:	02300793          	li	a5,35
ffffffe000202f9c:	00f71863          	bne	a4,a5,ffffffe000202fac <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe000202fa0:	00100793          	li	a5,1
ffffffe000202fa4:	f8f40123          	sb	a5,-126(s0)
ffffffe000202fa8:	76c0006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == '0') {
ffffffe000202fac:	f5043783          	ld	a5,-176(s0)
ffffffe000202fb0:	0007c783          	lbu	a5,0(a5)
ffffffe000202fb4:	00078713          	mv	a4,a5
ffffffe000202fb8:	03000793          	li	a5,48
ffffffe000202fbc:	00f71863          	bne	a4,a5,ffffffe000202fcc <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe000202fc0:	00100793          	li	a5,1
ffffffe000202fc4:	f8f401a3          	sb	a5,-125(s0)
ffffffe000202fc8:	74c0006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe000202fcc:	f5043783          	ld	a5,-176(s0)
ffffffe000202fd0:	0007c783          	lbu	a5,0(a5)
ffffffe000202fd4:	00078713          	mv	a4,a5
ffffffe000202fd8:	06c00793          	li	a5,108
ffffffe000202fdc:	04f70063          	beq	a4,a5,ffffffe00020301c <vprintfmt+0xc4>
ffffffe000202fe0:	f5043783          	ld	a5,-176(s0)
ffffffe000202fe4:	0007c783          	lbu	a5,0(a5)
ffffffe000202fe8:	00078713          	mv	a4,a5
ffffffe000202fec:	07a00793          	li	a5,122
ffffffe000202ff0:	02f70663          	beq	a4,a5,ffffffe00020301c <vprintfmt+0xc4>
ffffffe000202ff4:	f5043783          	ld	a5,-176(s0)
ffffffe000202ff8:	0007c783          	lbu	a5,0(a5)
ffffffe000202ffc:	00078713          	mv	a4,a5
ffffffe000203000:	07400793          	li	a5,116
ffffffe000203004:	00f70c63          	beq	a4,a5,ffffffe00020301c <vprintfmt+0xc4>
ffffffe000203008:	f5043783          	ld	a5,-176(s0)
ffffffe00020300c:	0007c783          	lbu	a5,0(a5)
ffffffe000203010:	00078713          	mv	a4,a5
ffffffe000203014:	06a00793          	li	a5,106
ffffffe000203018:	00f71863          	bne	a4,a5,ffffffe000203028 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe00020301c:	00100793          	li	a5,1
ffffffe000203020:	f8f400a3          	sb	a5,-127(s0)
ffffffe000203024:	6f00006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == '+') {
ffffffe000203028:	f5043783          	ld	a5,-176(s0)
ffffffe00020302c:	0007c783          	lbu	a5,0(a5)
ffffffe000203030:	00078713          	mv	a4,a5
ffffffe000203034:	02b00793          	li	a5,43
ffffffe000203038:	00f71863          	bne	a4,a5,ffffffe000203048 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe00020303c:	00100793          	li	a5,1
ffffffe000203040:	f8f402a3          	sb	a5,-123(s0)
ffffffe000203044:	6d00006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == ' ') {
ffffffe000203048:	f5043783          	ld	a5,-176(s0)
ffffffe00020304c:	0007c783          	lbu	a5,0(a5)
ffffffe000203050:	00078713          	mv	a4,a5
ffffffe000203054:	02000793          	li	a5,32
ffffffe000203058:	00f71863          	bne	a4,a5,ffffffe000203068 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe00020305c:	00100793          	li	a5,1
ffffffe000203060:	f8f40223          	sb	a5,-124(s0)
ffffffe000203064:	6b00006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == '*') {
ffffffe000203068:	f5043783          	ld	a5,-176(s0)
ffffffe00020306c:	0007c783          	lbu	a5,0(a5)
ffffffe000203070:	00078713          	mv	a4,a5
ffffffe000203074:	02a00793          	li	a5,42
ffffffe000203078:	00f71e63          	bne	a4,a5,ffffffe000203094 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe00020307c:	f4843783          	ld	a5,-184(s0)
ffffffe000203080:	00878713          	addi	a4,a5,8
ffffffe000203084:	f4e43423          	sd	a4,-184(s0)
ffffffe000203088:	0007a783          	lw	a5,0(a5)
ffffffe00020308c:	f8f42423          	sw	a5,-120(s0)
ffffffe000203090:	6840006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000203094:	f5043783          	ld	a5,-176(s0)
ffffffe000203098:	0007c783          	lbu	a5,0(a5)
ffffffe00020309c:	00078713          	mv	a4,a5
ffffffe0002030a0:	03000793          	li	a5,48
ffffffe0002030a4:	04e7f663          	bgeu	a5,a4,ffffffe0002030f0 <vprintfmt+0x198>
ffffffe0002030a8:	f5043783          	ld	a5,-176(s0)
ffffffe0002030ac:	0007c783          	lbu	a5,0(a5)
ffffffe0002030b0:	00078713          	mv	a4,a5
ffffffe0002030b4:	03900793          	li	a5,57
ffffffe0002030b8:	02e7ec63          	bltu	a5,a4,ffffffe0002030f0 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe0002030bc:	f5043783          	ld	a5,-176(s0)
ffffffe0002030c0:	f5040713          	addi	a4,s0,-176
ffffffe0002030c4:	00a00613          	li	a2,10
ffffffe0002030c8:	00070593          	mv	a1,a4
ffffffe0002030cc:	00078513          	mv	a0,a5
ffffffe0002030d0:	865ff0ef          	jal	ffffffe000202934 <strtol>
ffffffe0002030d4:	00050793          	mv	a5,a0
ffffffe0002030d8:	0007879b          	sext.w	a5,a5
ffffffe0002030dc:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe0002030e0:	f5043783          	ld	a5,-176(s0)
ffffffe0002030e4:	fff78793          	addi	a5,a5,-1
ffffffe0002030e8:	f4f43823          	sd	a5,-176(s0)
ffffffe0002030ec:	6280006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == '.') {
ffffffe0002030f0:	f5043783          	ld	a5,-176(s0)
ffffffe0002030f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002030f8:	00078713          	mv	a4,a5
ffffffe0002030fc:	02e00793          	li	a5,46
ffffffe000203100:	06f71863          	bne	a4,a5,ffffffe000203170 <vprintfmt+0x218>
                fmt++;
ffffffe000203104:	f5043783          	ld	a5,-176(s0)
ffffffe000203108:	00178793          	addi	a5,a5,1
ffffffe00020310c:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000203110:	f5043783          	ld	a5,-176(s0)
ffffffe000203114:	0007c783          	lbu	a5,0(a5)
ffffffe000203118:	00078713          	mv	a4,a5
ffffffe00020311c:	02a00793          	li	a5,42
ffffffe000203120:	00f71e63          	bne	a4,a5,ffffffe00020313c <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000203124:	f4843783          	ld	a5,-184(s0)
ffffffe000203128:	00878713          	addi	a4,a5,8
ffffffe00020312c:	f4e43423          	sd	a4,-184(s0)
ffffffe000203130:	0007a783          	lw	a5,0(a5)
ffffffe000203134:	f8f42623          	sw	a5,-116(s0)
ffffffe000203138:	5dc0006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe00020313c:	f5043783          	ld	a5,-176(s0)
ffffffe000203140:	f5040713          	addi	a4,s0,-176
ffffffe000203144:	00a00613          	li	a2,10
ffffffe000203148:	00070593          	mv	a1,a4
ffffffe00020314c:	00078513          	mv	a0,a5
ffffffe000203150:	fe4ff0ef          	jal	ffffffe000202934 <strtol>
ffffffe000203154:	00050793          	mv	a5,a0
ffffffe000203158:	0007879b          	sext.w	a5,a5
ffffffe00020315c:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000203160:	f5043783          	ld	a5,-176(s0)
ffffffe000203164:	fff78793          	addi	a5,a5,-1
ffffffe000203168:	f4f43823          	sd	a5,-176(s0)
ffffffe00020316c:	5a80006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000203170:	f5043783          	ld	a5,-176(s0)
ffffffe000203174:	0007c783          	lbu	a5,0(a5)
ffffffe000203178:	00078713          	mv	a4,a5
ffffffe00020317c:	07800793          	li	a5,120
ffffffe000203180:	02f70663          	beq	a4,a5,ffffffe0002031ac <vprintfmt+0x254>
ffffffe000203184:	f5043783          	ld	a5,-176(s0)
ffffffe000203188:	0007c783          	lbu	a5,0(a5)
ffffffe00020318c:	00078713          	mv	a4,a5
ffffffe000203190:	05800793          	li	a5,88
ffffffe000203194:	00f70c63          	beq	a4,a5,ffffffe0002031ac <vprintfmt+0x254>
ffffffe000203198:	f5043783          	ld	a5,-176(s0)
ffffffe00020319c:	0007c783          	lbu	a5,0(a5)
ffffffe0002031a0:	00078713          	mv	a4,a5
ffffffe0002031a4:	07000793          	li	a5,112
ffffffe0002031a8:	30f71063          	bne	a4,a5,ffffffe0002034a8 <vprintfmt+0x550>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe0002031ac:	f5043783          	ld	a5,-176(s0)
ffffffe0002031b0:	0007c783          	lbu	a5,0(a5)
ffffffe0002031b4:	00078713          	mv	a4,a5
ffffffe0002031b8:	07000793          	li	a5,112
ffffffe0002031bc:	00f70663          	beq	a4,a5,ffffffe0002031c8 <vprintfmt+0x270>
ffffffe0002031c0:	f8144783          	lbu	a5,-127(s0)
ffffffe0002031c4:	00078663          	beqz	a5,ffffffe0002031d0 <vprintfmt+0x278>
ffffffe0002031c8:	00100793          	li	a5,1
ffffffe0002031cc:	0080006f          	j	ffffffe0002031d4 <vprintfmt+0x27c>
ffffffe0002031d0:	00000793          	li	a5,0
ffffffe0002031d4:	faf403a3          	sb	a5,-89(s0)
ffffffe0002031d8:	fa744783          	lbu	a5,-89(s0)
ffffffe0002031dc:	0017f793          	andi	a5,a5,1
ffffffe0002031e0:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe0002031e4:	fa744783          	lbu	a5,-89(s0)
ffffffe0002031e8:	0ff7f793          	zext.b	a5,a5
ffffffe0002031ec:	00078c63          	beqz	a5,ffffffe000203204 <vprintfmt+0x2ac>
ffffffe0002031f0:	f4843783          	ld	a5,-184(s0)
ffffffe0002031f4:	00878713          	addi	a4,a5,8
ffffffe0002031f8:	f4e43423          	sd	a4,-184(s0)
ffffffe0002031fc:	0007b783          	ld	a5,0(a5)
ffffffe000203200:	01c0006f          	j	ffffffe00020321c <vprintfmt+0x2c4>
ffffffe000203204:	f4843783          	ld	a5,-184(s0)
ffffffe000203208:	00878713          	addi	a4,a5,8
ffffffe00020320c:	f4e43423          	sd	a4,-184(s0)
ffffffe000203210:	0007a783          	lw	a5,0(a5)
ffffffe000203214:	02079793          	slli	a5,a5,0x20
ffffffe000203218:	0207d793          	srli	a5,a5,0x20
ffffffe00020321c:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000203220:	f8c42783          	lw	a5,-116(s0)
ffffffe000203224:	02079463          	bnez	a5,ffffffe00020324c <vprintfmt+0x2f4>
ffffffe000203228:	fe043783          	ld	a5,-32(s0)
ffffffe00020322c:	02079063          	bnez	a5,ffffffe00020324c <vprintfmt+0x2f4>
ffffffe000203230:	f5043783          	ld	a5,-176(s0)
ffffffe000203234:	0007c783          	lbu	a5,0(a5)
ffffffe000203238:	00078713          	mv	a4,a5
ffffffe00020323c:	07000793          	li	a5,112
ffffffe000203240:	00f70663          	beq	a4,a5,ffffffe00020324c <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000203244:	f8040023          	sb	zero,-128(s0)
ffffffe000203248:	4cc0006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe00020324c:	f5043783          	ld	a5,-176(s0)
ffffffe000203250:	0007c783          	lbu	a5,0(a5)
ffffffe000203254:	00078713          	mv	a4,a5
ffffffe000203258:	07000793          	li	a5,112
ffffffe00020325c:	00f70a63          	beq	a4,a5,ffffffe000203270 <vprintfmt+0x318>
ffffffe000203260:	f8244783          	lbu	a5,-126(s0)
ffffffe000203264:	00078a63          	beqz	a5,ffffffe000203278 <vprintfmt+0x320>
ffffffe000203268:	fe043783          	ld	a5,-32(s0)
ffffffe00020326c:	00078663          	beqz	a5,ffffffe000203278 <vprintfmt+0x320>
ffffffe000203270:	00100793          	li	a5,1
ffffffe000203274:	0080006f          	j	ffffffe00020327c <vprintfmt+0x324>
ffffffe000203278:	00000793          	li	a5,0
ffffffe00020327c:	faf40323          	sb	a5,-90(s0)
ffffffe000203280:	fa644783          	lbu	a5,-90(s0)
ffffffe000203284:	0017f793          	andi	a5,a5,1
ffffffe000203288:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe00020328c:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000203290:	f5043783          	ld	a5,-176(s0)
ffffffe000203294:	0007c783          	lbu	a5,0(a5)
ffffffe000203298:	00078713          	mv	a4,a5
ffffffe00020329c:	05800793          	li	a5,88
ffffffe0002032a0:	00f71863          	bne	a4,a5,ffffffe0002032b0 <vprintfmt+0x358>
ffffffe0002032a4:	00001797          	auipc	a5,0x1
ffffffe0002032a8:	1dc78793          	addi	a5,a5,476 # ffffffe000204480 <upperxdigits.1>
ffffffe0002032ac:	00c0006f          	j	ffffffe0002032b8 <vprintfmt+0x360>
ffffffe0002032b0:	00001797          	auipc	a5,0x1
ffffffe0002032b4:	1e878793          	addi	a5,a5,488 # ffffffe000204498 <lowerxdigits.0>
ffffffe0002032b8:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe0002032bc:	fe043783          	ld	a5,-32(s0)
ffffffe0002032c0:	00f7f793          	andi	a5,a5,15
ffffffe0002032c4:	f9843703          	ld	a4,-104(s0)
ffffffe0002032c8:	00f70733          	add	a4,a4,a5
ffffffe0002032cc:	fdc42783          	lw	a5,-36(s0)
ffffffe0002032d0:	0017869b          	addiw	a3,a5,1
ffffffe0002032d4:	fcd42e23          	sw	a3,-36(s0)
ffffffe0002032d8:	00074703          	lbu	a4,0(a4)
ffffffe0002032dc:	ff078793          	addi	a5,a5,-16
ffffffe0002032e0:	008787b3          	add	a5,a5,s0
ffffffe0002032e4:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe0002032e8:	fe043783          	ld	a5,-32(s0)
ffffffe0002032ec:	0047d793          	srli	a5,a5,0x4
ffffffe0002032f0:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe0002032f4:	fe043783          	ld	a5,-32(s0)
ffffffe0002032f8:	fc0792e3          	bnez	a5,ffffffe0002032bc <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe0002032fc:	f8c42703          	lw	a4,-116(s0)
ffffffe000203300:	fff00793          	li	a5,-1
ffffffe000203304:	02f71663          	bne	a4,a5,ffffffe000203330 <vprintfmt+0x3d8>
ffffffe000203308:	f8344783          	lbu	a5,-125(s0)
ffffffe00020330c:	02078263          	beqz	a5,ffffffe000203330 <vprintfmt+0x3d8>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000203310:	f8842703          	lw	a4,-120(s0)
ffffffe000203314:	fa644783          	lbu	a5,-90(s0)
ffffffe000203318:	0007879b          	sext.w	a5,a5
ffffffe00020331c:	0017979b          	slliw	a5,a5,0x1
ffffffe000203320:	0007879b          	sext.w	a5,a5
ffffffe000203324:	40f707bb          	subw	a5,a4,a5
ffffffe000203328:	0007879b          	sext.w	a5,a5
ffffffe00020332c:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000203330:	f8842703          	lw	a4,-120(s0)
ffffffe000203334:	fa644783          	lbu	a5,-90(s0)
ffffffe000203338:	0007879b          	sext.w	a5,a5
ffffffe00020333c:	0017979b          	slliw	a5,a5,0x1
ffffffe000203340:	0007879b          	sext.w	a5,a5
ffffffe000203344:	40f707bb          	subw	a5,a4,a5
ffffffe000203348:	0007871b          	sext.w	a4,a5
ffffffe00020334c:	fdc42783          	lw	a5,-36(s0)
ffffffe000203350:	f8f42a23          	sw	a5,-108(s0)
ffffffe000203354:	f8c42783          	lw	a5,-116(s0)
ffffffe000203358:	f8f42823          	sw	a5,-112(s0)
ffffffe00020335c:	f9442783          	lw	a5,-108(s0)
ffffffe000203360:	00078593          	mv	a1,a5
ffffffe000203364:	f9042783          	lw	a5,-112(s0)
ffffffe000203368:	00078613          	mv	a2,a5
ffffffe00020336c:	0006069b          	sext.w	a3,a2
ffffffe000203370:	0005879b          	sext.w	a5,a1
ffffffe000203374:	00f6d463          	bge	a3,a5,ffffffe00020337c <vprintfmt+0x424>
ffffffe000203378:	00058613          	mv	a2,a1
ffffffe00020337c:	0006079b          	sext.w	a5,a2
ffffffe000203380:	40f707bb          	subw	a5,a4,a5
ffffffe000203384:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203388:	0280006f          	j	ffffffe0002033b0 <vprintfmt+0x458>
                    putch(' ');
ffffffe00020338c:	f5843783          	ld	a5,-168(s0)
ffffffe000203390:	02000513          	li	a0,32
ffffffe000203394:	000780e7          	jalr	a5
                    ++written;
ffffffe000203398:	fec42783          	lw	a5,-20(s0)
ffffffe00020339c:	0017879b          	addiw	a5,a5,1
ffffffe0002033a0:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe0002033a4:	fd842783          	lw	a5,-40(s0)
ffffffe0002033a8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002033ac:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002033b0:	fd842783          	lw	a5,-40(s0)
ffffffe0002033b4:	0007879b          	sext.w	a5,a5
ffffffe0002033b8:	fcf04ae3          	bgtz	a5,ffffffe00020338c <vprintfmt+0x434>
                }

                if (prefix) {
ffffffe0002033bc:	fa644783          	lbu	a5,-90(s0)
ffffffe0002033c0:	0ff7f793          	zext.b	a5,a5
ffffffe0002033c4:	04078463          	beqz	a5,ffffffe00020340c <vprintfmt+0x4b4>
                    putch('0');
ffffffe0002033c8:	f5843783          	ld	a5,-168(s0)
ffffffe0002033cc:	03000513          	li	a0,48
ffffffe0002033d0:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe0002033d4:	f5043783          	ld	a5,-176(s0)
ffffffe0002033d8:	0007c783          	lbu	a5,0(a5)
ffffffe0002033dc:	00078713          	mv	a4,a5
ffffffe0002033e0:	05800793          	li	a5,88
ffffffe0002033e4:	00f71663          	bne	a4,a5,ffffffe0002033f0 <vprintfmt+0x498>
ffffffe0002033e8:	05800793          	li	a5,88
ffffffe0002033ec:	0080006f          	j	ffffffe0002033f4 <vprintfmt+0x49c>
ffffffe0002033f0:	07800793          	li	a5,120
ffffffe0002033f4:	f5843703          	ld	a4,-168(s0)
ffffffe0002033f8:	00078513          	mv	a0,a5
ffffffe0002033fc:	000700e7          	jalr	a4
                    written += 2;
ffffffe000203400:	fec42783          	lw	a5,-20(s0)
ffffffe000203404:	0027879b          	addiw	a5,a5,2
ffffffe000203408:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe00020340c:	fdc42783          	lw	a5,-36(s0)
ffffffe000203410:	fcf42a23          	sw	a5,-44(s0)
ffffffe000203414:	0280006f          	j	ffffffe00020343c <vprintfmt+0x4e4>
                    putch('0');
ffffffe000203418:	f5843783          	ld	a5,-168(s0)
ffffffe00020341c:	03000513          	li	a0,48
ffffffe000203420:	000780e7          	jalr	a5
                    ++written;
ffffffe000203424:	fec42783          	lw	a5,-20(s0)
ffffffe000203428:	0017879b          	addiw	a5,a5,1
ffffffe00020342c:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000203430:	fd442783          	lw	a5,-44(s0)
ffffffe000203434:	0017879b          	addiw	a5,a5,1
ffffffe000203438:	fcf42a23          	sw	a5,-44(s0)
ffffffe00020343c:	f8c42783          	lw	a5,-116(s0)
ffffffe000203440:	fd442703          	lw	a4,-44(s0)
ffffffe000203444:	0007071b          	sext.w	a4,a4
ffffffe000203448:	fcf748e3          	blt	a4,a5,ffffffe000203418 <vprintfmt+0x4c0>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe00020344c:	fdc42783          	lw	a5,-36(s0)
ffffffe000203450:	fff7879b          	addiw	a5,a5,-1
ffffffe000203454:	fcf42823          	sw	a5,-48(s0)
ffffffe000203458:	03c0006f          	j	ffffffe000203494 <vprintfmt+0x53c>
                    putch(buf[i]);
ffffffe00020345c:	fd042783          	lw	a5,-48(s0)
ffffffe000203460:	ff078793          	addi	a5,a5,-16
ffffffe000203464:	008787b3          	add	a5,a5,s0
ffffffe000203468:	f807c783          	lbu	a5,-128(a5)
ffffffe00020346c:	0007871b          	sext.w	a4,a5
ffffffe000203470:	f5843783          	ld	a5,-168(s0)
ffffffe000203474:	00070513          	mv	a0,a4
ffffffe000203478:	000780e7          	jalr	a5
                    ++written;
ffffffe00020347c:	fec42783          	lw	a5,-20(s0)
ffffffe000203480:	0017879b          	addiw	a5,a5,1
ffffffe000203484:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000203488:	fd042783          	lw	a5,-48(s0)
ffffffe00020348c:	fff7879b          	addiw	a5,a5,-1
ffffffe000203490:	fcf42823          	sw	a5,-48(s0)
ffffffe000203494:	fd042783          	lw	a5,-48(s0)
ffffffe000203498:	0007879b          	sext.w	a5,a5
ffffffe00020349c:	fc07d0e3          	bgez	a5,ffffffe00020345c <vprintfmt+0x504>
                }

                flags.in_format = false;
ffffffe0002034a0:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe0002034a4:	2700006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe0002034a8:	f5043783          	ld	a5,-176(s0)
ffffffe0002034ac:	0007c783          	lbu	a5,0(a5)
ffffffe0002034b0:	00078713          	mv	a4,a5
ffffffe0002034b4:	06400793          	li	a5,100
ffffffe0002034b8:	02f70663          	beq	a4,a5,ffffffe0002034e4 <vprintfmt+0x58c>
ffffffe0002034bc:	f5043783          	ld	a5,-176(s0)
ffffffe0002034c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002034c4:	00078713          	mv	a4,a5
ffffffe0002034c8:	06900793          	li	a5,105
ffffffe0002034cc:	00f70c63          	beq	a4,a5,ffffffe0002034e4 <vprintfmt+0x58c>
ffffffe0002034d0:	f5043783          	ld	a5,-176(s0)
ffffffe0002034d4:	0007c783          	lbu	a5,0(a5)
ffffffe0002034d8:	00078713          	mv	a4,a5
ffffffe0002034dc:	07500793          	li	a5,117
ffffffe0002034e0:	08f71063          	bne	a4,a5,ffffffe000203560 <vprintfmt+0x608>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe0002034e4:	f8144783          	lbu	a5,-127(s0)
ffffffe0002034e8:	00078c63          	beqz	a5,ffffffe000203500 <vprintfmt+0x5a8>
ffffffe0002034ec:	f4843783          	ld	a5,-184(s0)
ffffffe0002034f0:	00878713          	addi	a4,a5,8
ffffffe0002034f4:	f4e43423          	sd	a4,-184(s0)
ffffffe0002034f8:	0007b783          	ld	a5,0(a5)
ffffffe0002034fc:	0140006f          	j	ffffffe000203510 <vprintfmt+0x5b8>
ffffffe000203500:	f4843783          	ld	a5,-184(s0)
ffffffe000203504:	00878713          	addi	a4,a5,8
ffffffe000203508:	f4e43423          	sd	a4,-184(s0)
ffffffe00020350c:	0007a783          	lw	a5,0(a5)
ffffffe000203510:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000203514:	fa843583          	ld	a1,-88(s0)
ffffffe000203518:	f5043783          	ld	a5,-176(s0)
ffffffe00020351c:	0007c783          	lbu	a5,0(a5)
ffffffe000203520:	0007871b          	sext.w	a4,a5
ffffffe000203524:	07500793          	li	a5,117
ffffffe000203528:	40f707b3          	sub	a5,a4,a5
ffffffe00020352c:	00f037b3          	snez	a5,a5
ffffffe000203530:	0ff7f793          	zext.b	a5,a5
ffffffe000203534:	f8040713          	addi	a4,s0,-128
ffffffe000203538:	00070693          	mv	a3,a4
ffffffe00020353c:	00078613          	mv	a2,a5
ffffffe000203540:	f5843503          	ld	a0,-168(s0)
ffffffe000203544:	ee4ff0ef          	jal	ffffffe000202c28 <print_dec_int>
ffffffe000203548:	00050793          	mv	a5,a0
ffffffe00020354c:	fec42703          	lw	a4,-20(s0)
ffffffe000203550:	00f707bb          	addw	a5,a4,a5
ffffffe000203554:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203558:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe00020355c:	1b80006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == 'n') {
ffffffe000203560:	f5043783          	ld	a5,-176(s0)
ffffffe000203564:	0007c783          	lbu	a5,0(a5)
ffffffe000203568:	00078713          	mv	a4,a5
ffffffe00020356c:	06e00793          	li	a5,110
ffffffe000203570:	04f71c63          	bne	a4,a5,ffffffe0002035c8 <vprintfmt+0x670>
                if (flags.longflag) {
ffffffe000203574:	f8144783          	lbu	a5,-127(s0)
ffffffe000203578:	02078463          	beqz	a5,ffffffe0002035a0 <vprintfmt+0x648>
                    long *n = va_arg(vl, long *);
ffffffe00020357c:	f4843783          	ld	a5,-184(s0)
ffffffe000203580:	00878713          	addi	a4,a5,8
ffffffe000203584:	f4e43423          	sd	a4,-184(s0)
ffffffe000203588:	0007b783          	ld	a5,0(a5)
ffffffe00020358c:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000203590:	fec42703          	lw	a4,-20(s0)
ffffffe000203594:	fb043783          	ld	a5,-80(s0)
ffffffe000203598:	00e7b023          	sd	a4,0(a5)
ffffffe00020359c:	0240006f          	j	ffffffe0002035c0 <vprintfmt+0x668>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe0002035a0:	f4843783          	ld	a5,-184(s0)
ffffffe0002035a4:	00878713          	addi	a4,a5,8
ffffffe0002035a8:	f4e43423          	sd	a4,-184(s0)
ffffffe0002035ac:	0007b783          	ld	a5,0(a5)
ffffffe0002035b0:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe0002035b4:	fb843783          	ld	a5,-72(s0)
ffffffe0002035b8:	fec42703          	lw	a4,-20(s0)
ffffffe0002035bc:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe0002035c0:	f8040023          	sb	zero,-128(s0)
ffffffe0002035c4:	1500006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == 's') {
ffffffe0002035c8:	f5043783          	ld	a5,-176(s0)
ffffffe0002035cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002035d0:	00078713          	mv	a4,a5
ffffffe0002035d4:	07300793          	li	a5,115
ffffffe0002035d8:	02f71e63          	bne	a4,a5,ffffffe000203614 <vprintfmt+0x6bc>
                const char *s = va_arg(vl, const char *);
ffffffe0002035dc:	f4843783          	ld	a5,-184(s0)
ffffffe0002035e0:	00878713          	addi	a4,a5,8
ffffffe0002035e4:	f4e43423          	sd	a4,-184(s0)
ffffffe0002035e8:	0007b783          	ld	a5,0(a5)
ffffffe0002035ec:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe0002035f0:	fc043583          	ld	a1,-64(s0)
ffffffe0002035f4:	f5843503          	ld	a0,-168(s0)
ffffffe0002035f8:	da8ff0ef          	jal	ffffffe000202ba0 <puts_wo_nl>
ffffffe0002035fc:	00050793          	mv	a5,a0
ffffffe000203600:	fec42703          	lw	a4,-20(s0)
ffffffe000203604:	00f707bb          	addw	a5,a4,a5
ffffffe000203608:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe00020360c:	f8040023          	sb	zero,-128(s0)
ffffffe000203610:	1040006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == 'c') {
ffffffe000203614:	f5043783          	ld	a5,-176(s0)
ffffffe000203618:	0007c783          	lbu	a5,0(a5)
ffffffe00020361c:	00078713          	mv	a4,a5
ffffffe000203620:	06300793          	li	a5,99
ffffffe000203624:	02f71e63          	bne	a4,a5,ffffffe000203660 <vprintfmt+0x708>
                int ch = va_arg(vl, int);
ffffffe000203628:	f4843783          	ld	a5,-184(s0)
ffffffe00020362c:	00878713          	addi	a4,a5,8
ffffffe000203630:	f4e43423          	sd	a4,-184(s0)
ffffffe000203634:	0007a783          	lw	a5,0(a5)
ffffffe000203638:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe00020363c:	fcc42703          	lw	a4,-52(s0)
ffffffe000203640:	f5843783          	ld	a5,-168(s0)
ffffffe000203644:	00070513          	mv	a0,a4
ffffffe000203648:	000780e7          	jalr	a5
                ++written;
ffffffe00020364c:	fec42783          	lw	a5,-20(s0)
ffffffe000203650:	0017879b          	addiw	a5,a5,1
ffffffe000203654:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203658:	f8040023          	sb	zero,-128(s0)
ffffffe00020365c:	0b80006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else if (*fmt == '%') {
ffffffe000203660:	f5043783          	ld	a5,-176(s0)
ffffffe000203664:	0007c783          	lbu	a5,0(a5)
ffffffe000203668:	00078713          	mv	a4,a5
ffffffe00020366c:	02500793          	li	a5,37
ffffffe000203670:	02f71263          	bne	a4,a5,ffffffe000203694 <vprintfmt+0x73c>
                putch('%');
ffffffe000203674:	f5843783          	ld	a5,-168(s0)
ffffffe000203678:	02500513          	li	a0,37
ffffffe00020367c:	000780e7          	jalr	a5
                ++written;
ffffffe000203680:	fec42783          	lw	a5,-20(s0)
ffffffe000203684:	0017879b          	addiw	a5,a5,1
ffffffe000203688:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe00020368c:	f8040023          	sb	zero,-128(s0)
ffffffe000203690:	0840006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            } else {
                putch(*fmt);
ffffffe000203694:	f5043783          	ld	a5,-176(s0)
ffffffe000203698:	0007c783          	lbu	a5,0(a5)
ffffffe00020369c:	0007871b          	sext.w	a4,a5
ffffffe0002036a0:	f5843783          	ld	a5,-168(s0)
ffffffe0002036a4:	00070513          	mv	a0,a4
ffffffe0002036a8:	000780e7          	jalr	a5
                ++written;
ffffffe0002036ac:	fec42783          	lw	a5,-20(s0)
ffffffe0002036b0:	0017879b          	addiw	a5,a5,1
ffffffe0002036b4:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002036b8:	f8040023          	sb	zero,-128(s0)
ffffffe0002036bc:	0580006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
            }
        } else if (*fmt == '%') {
ffffffe0002036c0:	f5043783          	ld	a5,-176(s0)
ffffffe0002036c4:	0007c783          	lbu	a5,0(a5)
ffffffe0002036c8:	00078713          	mv	a4,a5
ffffffe0002036cc:	02500793          	li	a5,37
ffffffe0002036d0:	02f71063          	bne	a4,a5,ffffffe0002036f0 <vprintfmt+0x798>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe0002036d4:	f8043023          	sd	zero,-128(s0)
ffffffe0002036d8:	f8043423          	sd	zero,-120(s0)
ffffffe0002036dc:	00100793          	li	a5,1
ffffffe0002036e0:	f8f40023          	sb	a5,-128(s0)
ffffffe0002036e4:	fff00793          	li	a5,-1
ffffffe0002036e8:	f8f42623          	sw	a5,-116(s0)
ffffffe0002036ec:	0280006f          	j	ffffffe000203714 <vprintfmt+0x7bc>
        } else {
            putch(*fmt);
ffffffe0002036f0:	f5043783          	ld	a5,-176(s0)
ffffffe0002036f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002036f8:	0007871b          	sext.w	a4,a5
ffffffe0002036fc:	f5843783          	ld	a5,-168(s0)
ffffffe000203700:	00070513          	mv	a0,a4
ffffffe000203704:	000780e7          	jalr	a5
            ++written;
ffffffe000203708:	fec42783          	lw	a5,-20(s0)
ffffffe00020370c:	0017879b          	addiw	a5,a5,1
ffffffe000203710:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe000203714:	f5043783          	ld	a5,-176(s0)
ffffffe000203718:	00178793          	addi	a5,a5,1
ffffffe00020371c:	f4f43823          	sd	a5,-176(s0)
ffffffe000203720:	f5043783          	ld	a5,-176(s0)
ffffffe000203724:	0007c783          	lbu	a5,0(a5)
ffffffe000203728:	84079ee3          	bnez	a5,ffffffe000202f84 <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe00020372c:	fec42783          	lw	a5,-20(s0)
}
ffffffe000203730:	00078513          	mv	a0,a5
ffffffe000203734:	0b813083          	ld	ra,184(sp)
ffffffe000203738:	0b013403          	ld	s0,176(sp)
ffffffe00020373c:	0c010113          	addi	sp,sp,192
ffffffe000203740:	00008067          	ret

ffffffe000203744 <printk>:

int printk(const char* s, ...) {
ffffffe000203744:	f9010113          	addi	sp,sp,-112
ffffffe000203748:	02113423          	sd	ra,40(sp)
ffffffe00020374c:	02813023          	sd	s0,32(sp)
ffffffe000203750:	03010413          	addi	s0,sp,48
ffffffe000203754:	fca43c23          	sd	a0,-40(s0)
ffffffe000203758:	00b43423          	sd	a1,8(s0)
ffffffe00020375c:	00c43823          	sd	a2,16(s0)
ffffffe000203760:	00d43c23          	sd	a3,24(s0)
ffffffe000203764:	02e43023          	sd	a4,32(s0)
ffffffe000203768:	02f43423          	sd	a5,40(s0)
ffffffe00020376c:	03043823          	sd	a6,48(s0)
ffffffe000203770:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe000203774:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000203778:	04040793          	addi	a5,s0,64
ffffffe00020377c:	fcf43823          	sd	a5,-48(s0)
ffffffe000203780:	fd043783          	ld	a5,-48(s0)
ffffffe000203784:	fc878793          	addi	a5,a5,-56
ffffffe000203788:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe00020378c:	fe043783          	ld	a5,-32(s0)
ffffffe000203790:	00078613          	mv	a2,a5
ffffffe000203794:	fd843583          	ld	a1,-40(s0)
ffffffe000203798:	fffff517          	auipc	a0,0xfffff
ffffffe00020379c:	0ec50513          	addi	a0,a0,236 # ffffffe000202884 <putc>
ffffffe0002037a0:	fb8ff0ef          	jal	ffffffe000202f58 <vprintfmt>
ffffffe0002037a4:	00050793          	mv	a5,a0
ffffffe0002037a8:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe0002037ac:	fec42783          	lw	a5,-20(s0)
}
ffffffe0002037b0:	00078513          	mv	a0,a5
ffffffe0002037b4:	02813083          	ld	ra,40(sp)
ffffffe0002037b8:	02013403          	ld	s0,32(sp)
ffffffe0002037bc:	07010113          	addi	sp,sp,112
ffffffe0002037c0:	00008067          	ret

ffffffe0002037c4 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe0002037c4:	fe010113          	addi	sp,sp,-32
ffffffe0002037c8:	00113c23          	sd	ra,24(sp)
ffffffe0002037cc:	00813823          	sd	s0,16(sp)
ffffffe0002037d0:	02010413          	addi	s0,sp,32
ffffffe0002037d4:	00050793          	mv	a5,a0
ffffffe0002037d8:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe0002037dc:	fec42783          	lw	a5,-20(s0)
ffffffe0002037e0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002037e4:	0007879b          	sext.w	a5,a5
ffffffe0002037e8:	02079713          	slli	a4,a5,0x20
ffffffe0002037ec:	02075713          	srli	a4,a4,0x20
ffffffe0002037f0:	00006797          	auipc	a5,0x6
ffffffe0002037f4:	83078793          	addi	a5,a5,-2000 # ffffffe000209020 <seed>
ffffffe0002037f8:	00e7b023          	sd	a4,0(a5)
}
ffffffe0002037fc:	00000013          	nop
ffffffe000203800:	01813083          	ld	ra,24(sp)
ffffffe000203804:	01013403          	ld	s0,16(sp)
ffffffe000203808:	02010113          	addi	sp,sp,32
ffffffe00020380c:	00008067          	ret

ffffffe000203810 <rand>:

int rand(void) {
ffffffe000203810:	ff010113          	addi	sp,sp,-16
ffffffe000203814:	00113423          	sd	ra,8(sp)
ffffffe000203818:	00813023          	sd	s0,0(sp)
ffffffe00020381c:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe000203820:	00006797          	auipc	a5,0x6
ffffffe000203824:	80078793          	addi	a5,a5,-2048 # ffffffe000209020 <seed>
ffffffe000203828:	0007b703          	ld	a4,0(a5)
ffffffe00020382c:	00001797          	auipc	a5,0x1
ffffffe000203830:	c8478793          	addi	a5,a5,-892 # ffffffe0002044b0 <lowerxdigits.0+0x18>
ffffffe000203834:	0007b783          	ld	a5,0(a5)
ffffffe000203838:	02f707b3          	mul	a5,a4,a5
ffffffe00020383c:	00178713          	addi	a4,a5,1
ffffffe000203840:	00005797          	auipc	a5,0x5
ffffffe000203844:	7e078793          	addi	a5,a5,2016 # ffffffe000209020 <seed>
ffffffe000203848:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe00020384c:	00005797          	auipc	a5,0x5
ffffffe000203850:	7d478793          	addi	a5,a5,2004 # ffffffe000209020 <seed>
ffffffe000203854:	0007b783          	ld	a5,0(a5)
ffffffe000203858:	0217d793          	srli	a5,a5,0x21
ffffffe00020385c:	0007879b          	sext.w	a5,a5
}
ffffffe000203860:	00078513          	mv	a0,a5
ffffffe000203864:	00813083          	ld	ra,8(sp)
ffffffe000203868:	00013403          	ld	s0,0(sp)
ffffffe00020386c:	01010113          	addi	sp,sp,16
ffffffe000203870:	00008067          	ret

ffffffe000203874 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe000203874:	fc010113          	addi	sp,sp,-64
ffffffe000203878:	02113c23          	sd	ra,56(sp)
ffffffe00020387c:	02813823          	sd	s0,48(sp)
ffffffe000203880:	04010413          	addi	s0,sp,64
ffffffe000203884:	fca43c23          	sd	a0,-40(s0)
ffffffe000203888:	00058793          	mv	a5,a1
ffffffe00020388c:	fcc43423          	sd	a2,-56(s0)
ffffffe000203890:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe000203894:	fd843783          	ld	a5,-40(s0)
ffffffe000203898:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe00020389c:	fe043423          	sd	zero,-24(s0)
ffffffe0002038a0:	0280006f          	j	ffffffe0002038c8 <memset+0x54>
        s[i] = c;
ffffffe0002038a4:	fe043703          	ld	a4,-32(s0)
ffffffe0002038a8:	fe843783          	ld	a5,-24(s0)
ffffffe0002038ac:	00f707b3          	add	a5,a4,a5
ffffffe0002038b0:	fd442703          	lw	a4,-44(s0)
ffffffe0002038b4:	0ff77713          	zext.b	a4,a4
ffffffe0002038b8:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe0002038bc:	fe843783          	ld	a5,-24(s0)
ffffffe0002038c0:	00178793          	addi	a5,a5,1
ffffffe0002038c4:	fef43423          	sd	a5,-24(s0)
ffffffe0002038c8:	fe843703          	ld	a4,-24(s0)
ffffffe0002038cc:	fc843783          	ld	a5,-56(s0)
ffffffe0002038d0:	fcf76ae3          	bltu	a4,a5,ffffffe0002038a4 <memset+0x30>
    }
    return dest;
ffffffe0002038d4:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002038d8:	00078513          	mv	a0,a5
ffffffe0002038dc:	03813083          	ld	ra,56(sp)
ffffffe0002038e0:	03013403          	ld	s0,48(sp)
ffffffe0002038e4:	04010113          	addi	sp,sp,64
ffffffe0002038e8:	00008067          	ret

ffffffe0002038ec <memcpy>:

void *memcpy(void *dest, const void *src, uint64_t n) {
ffffffe0002038ec:	fb010113          	addi	sp,sp,-80
ffffffe0002038f0:	04113423          	sd	ra,72(sp)
ffffffe0002038f4:	04813023          	sd	s0,64(sp)
ffffffe0002038f8:	05010413          	addi	s0,sp,80
ffffffe0002038fc:	fca43423          	sd	a0,-56(s0)
ffffffe000203900:	fcb43023          	sd	a1,-64(s0)
ffffffe000203904:	fac43c23          	sd	a2,-72(s0)
    const uint8_t *source = (const uint8_t *)src;
ffffffe000203908:	fc043783          	ld	a5,-64(s0)
ffffffe00020390c:	fef43023          	sd	a5,-32(s0)
    uint8_t *target = (uint8_t *)dest;
ffffffe000203910:	fc843783          	ld	a5,-56(s0)
ffffffe000203914:	fcf43c23          	sd	a5,-40(s0)
    for (uint64_t i = 0; i < n; i++) {
ffffffe000203918:	fe043423          	sd	zero,-24(s0)
ffffffe00020391c:	0300006f          	j	ffffffe00020394c <memcpy+0x60>
        target[i] = source[i];
ffffffe000203920:	fe043703          	ld	a4,-32(s0)
ffffffe000203924:	fe843783          	ld	a5,-24(s0)
ffffffe000203928:	00f70733          	add	a4,a4,a5
ffffffe00020392c:	fd843683          	ld	a3,-40(s0)
ffffffe000203930:	fe843783          	ld	a5,-24(s0)
ffffffe000203934:	00f687b3          	add	a5,a3,a5
ffffffe000203938:	00074703          	lbu	a4,0(a4)
ffffffe00020393c:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; i++) {
ffffffe000203940:	fe843783          	ld	a5,-24(s0)
ffffffe000203944:	00178793          	addi	a5,a5,1
ffffffe000203948:	fef43423          	sd	a5,-24(s0)
ffffffe00020394c:	fe843703          	ld	a4,-24(s0)
ffffffe000203950:	fb843783          	ld	a5,-72(s0)
ffffffe000203954:	fcf766e3          	bltu	a4,a5,ffffffe000203920 <memcpy+0x34>
    }
    return dest;
ffffffe000203958:	fc843783          	ld	a5,-56(s0)
}
ffffffe00020395c:	00078513          	mv	a0,a5
ffffffe000203960:	04813083          	ld	ra,72(sp)
ffffffe000203964:	04013403          	ld	s0,64(sp)
ffffffe000203968:	05010113          	addi	sp,sp,80
ffffffe00020396c:	00008067          	ret
