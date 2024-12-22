
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_skernel>:
    .extern setup_vm_final      # add in lab3
    .section .text.init
    .globl _start
_start:

    la sp, boot_stack_top   # initialize the stack_pointer
ffffffe000200000:	00008117          	auipc	sp,0x8
ffffffe000200004:	00010113          	mv	sp,sp
    call setup_vm
ffffffe000200008:	14d010ef          	jal	ffffffe000201954 <setup_vm>
    call relocate
ffffffe00020000c:	05c000ef          	jal	ffffffe000200068 <relocate>
    jal x1, mm_init
ffffffe000200010:	2d9000ef          	jal	ffffffe000200ae8 <mm_init>
    call setup_vm_final
ffffffe000200014:	2cd010ef          	jal	ffffffe000201ae0 <setup_vm_final>
    jal x1, task_init
ffffffe000200018:	4ed000ef          	jal	ffffffe000200d04 <task_init>
    
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
ffffffe000200064:	669010ef          	jal	ffffffe000201ecc <start_kernel>

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
ffffffe00020007c:	00009517          	auipc	a0,0x9
ffffffe000200080:	f8450513          	addi	a0,a0,-124 # ffffffe000209000 <early_pgtbl>
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
ffffffe0002000b4:	ef810113          	addi	sp,sp,-264 # ffffffe000207ef8 <_sbss+0xef8>
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
ffffffe000200148:	700010ef          	jal	ffffffe000201848 <trap_handler>

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
ffffffe000200318:	00004797          	auipc	a5,0x4
ffffffe00020031c:	ce878793          	addi	a5,a5,-792 # ffffffe000204000 <TIMECLOCK>
ffffffe000200320:	0007b783          	ld	a5,0(a5)
ffffffe000200324:	00f707b3          	add	a5,a4,a5
ffffffe000200328:	fef43423          	sd	a5,-24(s0)
    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    struct sbiret res;
    res = sbi_set_timer(next);
ffffffe00020032c:	fe843503          	ld	a0,-24(s0)
ffffffe000200330:	2b0010ef          	jal	ffffffe0002015e0 <sbi_set_timer>
ffffffe000200334:	00050713          	mv	a4,a0
ffffffe000200338:	00058793          	mv	a5,a1
ffffffe00020033c:	fce43c23          	sd	a4,-40(s0)
ffffffe000200340:	fef43023          	sd	a5,-32(s0)
    if (res.error)
ffffffe000200344:	fd843783          	ld	a5,-40(s0)
ffffffe000200348:	00078a63          	beqz	a5,ffffffe00020035c <clock_set_next_event+0x5c>
        printk("bad\n");
ffffffe00020034c:	00003517          	auipc	a0,0x3
ffffffe000200350:	cb450513          	addi	a0,a0,-844 # ffffffe000203000 <_srodata>
ffffffe000200354:	2f9020ef          	jal	ffffffe000202e4c <printk>
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
ffffffe00020045c:	00008797          	auipc	a5,0x8
ffffffe000200460:	bcc78793          	addi	a5,a5,-1076 # ffffffe000208028 <buddy>
ffffffe000200464:	fe843703          	ld	a4,-24(s0)
ffffffe000200468:	00e7b023          	sd	a4,0(a5)
    buddy.bitmap = free_page_start;
ffffffe00020046c:	00004797          	auipc	a5,0x4
ffffffe000200470:	b9c78793          	addi	a5,a5,-1124 # ffffffe000204008 <free_page_start>
ffffffe000200474:	0007b703          	ld	a4,0(a5)
ffffffe000200478:	00008797          	auipc	a5,0x8
ffffffe00020047c:	bb078793          	addi	a5,a5,-1104 # ffffffe000208028 <buddy>
ffffffe000200480:	00e7b423          	sd	a4,8(a5)
    free_page_start += 2 * buddy.size * sizeof(*buddy.bitmap);
ffffffe000200484:	00004797          	auipc	a5,0x4
ffffffe000200488:	b8478793          	addi	a5,a5,-1148 # ffffffe000204008 <free_page_start>
ffffffe00020048c:	0007b703          	ld	a4,0(a5)
ffffffe000200490:	00008797          	auipc	a5,0x8
ffffffe000200494:	b9878793          	addi	a5,a5,-1128 # ffffffe000208028 <buddy>
ffffffe000200498:	0007b783          	ld	a5,0(a5)
ffffffe00020049c:	00479793          	slli	a5,a5,0x4
ffffffe0002004a0:	00f70733          	add	a4,a4,a5
ffffffe0002004a4:	00004797          	auipc	a5,0x4
ffffffe0002004a8:	b6478793          	addi	a5,a5,-1180 # ffffffe000204008 <free_page_start>
ffffffe0002004ac:	00e7b023          	sd	a4,0(a5)
    memset(buddy.bitmap, 0, 2 * buddy.size * sizeof(*buddy.bitmap));
ffffffe0002004b0:	00008797          	auipc	a5,0x8
ffffffe0002004b4:	b7878793          	addi	a5,a5,-1160 # ffffffe000208028 <buddy>
ffffffe0002004b8:	0087b703          	ld	a4,8(a5)
ffffffe0002004bc:	00008797          	auipc	a5,0x8
ffffffe0002004c0:	b6c78793          	addi	a5,a5,-1172 # ffffffe000208028 <buddy>
ffffffe0002004c4:	0007b783          	ld	a5,0(a5)
ffffffe0002004c8:	00479793          	slli	a5,a5,0x4
ffffffe0002004cc:	00078613          	mv	a2,a5
ffffffe0002004d0:	00000593          	li	a1,0
ffffffe0002004d4:	00070513          	mv	a0,a4
ffffffe0002004d8:	2a5020ef          	jal	ffffffe000202f7c <memset>

    uint64_t node_size = buddy.size * 2;
ffffffe0002004dc:	00008797          	auipc	a5,0x8
ffffffe0002004e0:	b4c78793          	addi	a5,a5,-1204 # ffffffe000208028 <buddy>
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
ffffffe000200518:	00008797          	auipc	a5,0x8
ffffffe00020051c:	b1078793          	addi	a5,a5,-1264 # ffffffe000208028 <buddy>
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
ffffffe000200544:	00008797          	auipc	a5,0x8
ffffffe000200548:	ae478793          	addi	a5,a5,-1308 # ffffffe000208028 <buddy>
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
ffffffe000200590:	00004797          	auipc	a5,0x4
ffffffe000200594:	a7878793          	addi	a5,a5,-1416 # ffffffe000204008 <free_page_start>
ffffffe000200598:	0007b783          	ld	a5,0(a5)
ffffffe00020059c:	00078693          	mv	a3,a5
ffffffe0002005a0:	04100793          	li	a5,65
ffffffe0002005a4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002005a8:	00f687b3          	add	a5,a3,a5
ffffffe0002005ac:	faf76ee3          	bltu	a4,a5,ffffffe000200568 <buddy_init+0x144>
    }

    printk("...buddy_init done!\n");
ffffffe0002005b0:	00003517          	auipc	a0,0x3
ffffffe0002005b4:	a5850513          	addi	a0,a0,-1448 # ffffffe000203008 <_srodata+0x8>
ffffffe0002005b8:	095020ef          	jal	ffffffe000202e4c <printk>
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
ffffffe0002005f0:	00008797          	auipc	a5,0x8
ffffffe0002005f4:	a3878793          	addi	a5,a5,-1480 # ffffffe000208028 <buddy>
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
ffffffe000200638:	00008797          	auipc	a5,0x8
ffffffe00020063c:	9f078793          	addi	a5,a5,-1552 # ffffffe000208028 <buddy>
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
ffffffe000200660:	00008797          	auipc	a5,0x8
ffffffe000200664:	9c878793          	addi	a5,a5,-1592 # ffffffe000208028 <buddy>
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
ffffffe0002006a4:	00008797          	auipc	a5,0x8
ffffffe0002006a8:	98478793          	addi	a5,a5,-1660 # ffffffe000208028 <buddy>
ffffffe0002006ac:	0087b703          	ld	a4,8(a5)
ffffffe0002006b0:	fe043783          	ld	a5,-32(s0)
ffffffe0002006b4:	00479793          	slli	a5,a5,0x4
ffffffe0002006b8:	00878793          	addi	a5,a5,8
ffffffe0002006bc:	00f707b3          	add	a5,a4,a5
ffffffe0002006c0:	0007b783          	ld	a5,0(a5)
ffffffe0002006c4:	fcf43c23          	sd	a5,-40(s0)
        right_longest = buddy.bitmap[RIGHT_LEAF(index)];
ffffffe0002006c8:	00008797          	auipc	a5,0x8
ffffffe0002006cc:	96078793          	addi	a5,a5,-1696 # ffffffe000208028 <buddy>
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
ffffffe000200700:	00008797          	auipc	a5,0x8
ffffffe000200704:	92878793          	addi	a5,a5,-1752 # ffffffe000208028 <buddy>
ffffffe000200708:	0087b703          	ld	a4,8(a5)
ffffffe00020070c:	fe043783          	ld	a5,-32(s0)
ffffffe000200710:	00379793          	slli	a5,a5,0x3
ffffffe000200714:	00f707b3          	add	a5,a4,a5
ffffffe000200718:	fe843703          	ld	a4,-24(s0)
ffffffe00020071c:	00e7b023          	sd	a4,0(a5)
ffffffe000200720:	0300006f          	j	ffffffe000200750 <buddy_free+0x180>
        else
            buddy.bitmap[index] = MAX(left_longest, right_longest);
ffffffe000200724:	00008797          	auipc	a5,0x8
ffffffe000200728:	90478793          	addi	a5,a5,-1788 # ffffffe000208028 <buddy>
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
ffffffe0002007c0:	00008797          	auipc	a5,0x8
ffffffe0002007c4:	86878793          	addi	a5,a5,-1944 # ffffffe000208028 <buddy>
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
ffffffe0002007ec:	00008797          	auipc	a5,0x8
ffffffe0002007f0:	83c78793          	addi	a5,a5,-1988 # ffffffe000208028 <buddy>
ffffffe0002007f4:	0007b783          	ld	a5,0(a5)
ffffffe0002007f8:	fef43023          	sd	a5,-32(s0)
ffffffe0002007fc:	05c0006f          	j	ffffffe000200858 <buddy_alloc+0xe8>
        if (buddy.bitmap[LEFT_LEAF(index)] >= nrpages)
ffffffe000200800:	00008797          	auipc	a5,0x8
ffffffe000200804:	82878793          	addi	a5,a5,-2008 # ffffffe000208028 <buddy>
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
ffffffe000200864:	00007797          	auipc	a5,0x7
ffffffe000200868:	7c478793          	addi	a5,a5,1988 # ffffffe000208028 <buddy>
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
ffffffe000200890:	00007797          	auipc	a5,0x7
ffffffe000200894:	79878793          	addi	a5,a5,1944 # ffffffe000208028 <buddy>
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
ffffffe0002008bc:	00007797          	auipc	a5,0x7
ffffffe0002008c0:	76c78793          	addi	a5,a5,1900 # ffffffe000208028 <buddy>
ffffffe0002008c4:	0087b703          	ld	a4,8(a5)
ffffffe0002008c8:	fe843783          	ld	a5,-24(s0)
ffffffe0002008cc:	00178793          	addi	a5,a5,1
ffffffe0002008d0:	00479793          	slli	a5,a5,0x4
ffffffe0002008d4:	00f707b3          	add	a5,a4,a5
ffffffe0002008d8:	0007b603          	ld	a2,0(a5)
ffffffe0002008dc:	00007797          	auipc	a5,0x7
ffffffe0002008e0:	74c78793          	addi	a5,a5,1868 # ffffffe000208028 <buddy>
ffffffe0002008e4:	0087b703          	ld	a4,8(a5)
ffffffe0002008e8:	fe843783          	ld	a5,-24(s0)
ffffffe0002008ec:	00479793          	slli	a5,a5,0x4
ffffffe0002008f0:	00878793          	addi	a5,a5,8
ffffffe0002008f4:	00f707b3          	add	a5,a4,a5
ffffffe0002008f8:	0007b703          	ld	a4,0(a5)
        buddy.bitmap[index] = 
ffffffe0002008fc:	00007797          	auipc	a5,0x7
ffffffe000200900:	72c78793          	addi	a5,a5,1836 # ffffffe000208028 <buddy>
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
ffffffe000200afc:	00002517          	auipc	a0,0x2
ffffffe000200b00:	52450513          	addi	a0,a0,1316 # ffffffe000203020 <_srodata+0x20>
ffffffe000200b04:	348020ef          	jal	ffffffe000202e4c <printk>
}
ffffffe000200b08:	00000013          	nop
ffffffe000200b0c:	00813083          	ld	ra,8(sp)
ffffffe000200b10:	00013403          	ld	s0,0(sp)
ffffffe000200b14:	01010113          	addi	sp,sp,16
ffffffe000200b18:	00008067          	ret

ffffffe000200b1c <load_program>:

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void load_program(struct task_struct *task) {
ffffffe000200b1c:	f9010113          	addi	sp,sp,-112
ffffffe000200b20:	06113423          	sd	ra,104(sp)
ffffffe000200b24:	06813023          	sd	s0,96(sp)
ffffffe000200b28:	07010413          	addi	s0,sp,112
ffffffe000200b2c:	f8a43c23          	sd	a0,-104(s0)
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe000200b30:	00004797          	auipc	a5,0x4
ffffffe000200b34:	4d078793          	addi	a5,a5,1232 # ffffffe000205000 <_sramdisk>
ffffffe000200b38:	fcf43823          	sd	a5,-48(s0)
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000200b3c:	fd043783          	ld	a5,-48(s0)
ffffffe000200b40:	0207b703          	ld	a4,32(a5)
ffffffe000200b44:	00004797          	auipc	a5,0x4
ffffffe000200b48:	4bc78793          	addi	a5,a5,1212 # ffffffe000205000 <_sramdisk>
ffffffe000200b4c:	00f707b3          	add	a5,a4,a5
ffffffe000200b50:	fcf43423          	sd	a5,-56(s0)
    for (int i = 0; i < ehdr->e_phnum; ++i) {
ffffffe000200b54:	fe042623          	sw	zero,-20(s0)
ffffffe000200b58:	1700006f          	j	ffffffe000200cc8 <load_program+0x1ac>
        Elf64_Phdr *phdr = phdrs + i;
ffffffe000200b5c:	fec42703          	lw	a4,-20(s0)
ffffffe000200b60:	00070793          	mv	a5,a4
ffffffe000200b64:	00379793          	slli	a5,a5,0x3
ffffffe000200b68:	40e787b3          	sub	a5,a5,a4
ffffffe000200b6c:	00379793          	slli	a5,a5,0x3
ffffffe000200b70:	00078713          	mv	a4,a5
ffffffe000200b74:	fc843783          	ld	a5,-56(s0)
ffffffe000200b78:	00e787b3          	add	a5,a5,a4
ffffffe000200b7c:	fcf43023          	sd	a5,-64(s0)
        if (phdr->p_type == PT_LOAD) {
ffffffe000200b80:	fc043783          	ld	a5,-64(s0)
ffffffe000200b84:	0007a703          	lw	a4,0(a5)
ffffffe000200b88:	00100793          	li	a5,1
ffffffe000200b8c:	12f71863          	bne	a4,a5,ffffffe000200cbc <load_program+0x1a0>
            uint64_t page_num = (phdr->p_memsz + phdr->p_offset + PGSIZE - 1) / PGSIZE;
ffffffe000200b90:	fc043783          	ld	a5,-64(s0)
ffffffe000200b94:	0287b703          	ld	a4,40(a5)
ffffffe000200b98:	fc043783          	ld	a5,-64(s0)
ffffffe000200b9c:	0087b783          	ld	a5,8(a5)
ffffffe000200ba0:	00f70733          	add	a4,a4,a5
ffffffe000200ba4:	000017b7          	lui	a5,0x1
ffffffe000200ba8:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200bac:	00f707b3          	add	a5,a4,a5
ffffffe000200bb0:	00c7d793          	srli	a5,a5,0xc
ffffffe000200bb4:	faf43c23          	sd	a5,-72(s0)
            // printk("here pagenum %lx\n", page_num);
            uint64_t *paddr = alloc_pages(page_num);
ffffffe000200bb8:	fb843503          	ld	a0,-72(s0)
ffffffe000200bbc:	d89ff0ef          	jal	ffffffe000200944 <alloc_pages>
ffffffe000200bc0:	faa43823          	sd	a0,-80(s0)
            uint64_t *addr = (uint64_t*)(_sramdisk + phdr->p_offset);
ffffffe000200bc4:	fc043783          	ld	a5,-64(s0)
ffffffe000200bc8:	0087b703          	ld	a4,8(a5)
ffffffe000200bcc:	00004797          	auipc	a5,0x4
ffffffe000200bd0:	43478793          	addi	a5,a5,1076 # ffffffe000205000 <_sramdisk>
ffffffe000200bd4:	00f707b3          	add	a5,a4,a5
ffffffe000200bd8:	faf43423          	sd	a5,-88(s0)
            uint64_t phy_offset = (uint64_t)addr & (PGSIZE - 1);
ffffffe000200bdc:	fa843703          	ld	a4,-88(s0)
ffffffe000200be0:	000017b7          	lui	a5,0x1
ffffffe000200be4:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200be8:	00f777b3          	and	a5,a4,a5
ffffffe000200bec:	faf43023          	sd	a5,-96(s0)
            for(uint64_t i = 0; i < phdr->p_memsz; i++){
ffffffe000200bf0:	fe043023          	sd	zero,-32(s0)
ffffffe000200bf4:	0380006f          	j	ffffffe000200c2c <load_program+0x110>
                *((char*)paddr + i + phy_offset) = *((char*)addr + i);
ffffffe000200bf8:	fa843703          	ld	a4,-88(s0)
ffffffe000200bfc:	fe043783          	ld	a5,-32(s0)
ffffffe000200c00:	00f70733          	add	a4,a4,a5
ffffffe000200c04:	fe043683          	ld	a3,-32(s0)
ffffffe000200c08:	fa043783          	ld	a5,-96(s0)
ffffffe000200c0c:	00f687b3          	add	a5,a3,a5
ffffffe000200c10:	fb043683          	ld	a3,-80(s0)
ffffffe000200c14:	00f687b3          	add	a5,a3,a5
ffffffe000200c18:	00074703          	lbu	a4,0(a4)
ffffffe000200c1c:	00e78023          	sb	a4,0(a5)
            for(uint64_t i = 0; i < phdr->p_memsz; i++){
ffffffe000200c20:	fe043783          	ld	a5,-32(s0)
ffffffe000200c24:	00178793          	addi	a5,a5,1
ffffffe000200c28:	fef43023          	sd	a5,-32(s0)
ffffffe000200c2c:	fc043783          	ld	a5,-64(s0)
ffffffe000200c30:	0287b783          	ld	a5,40(a5)
ffffffe000200c34:	fe043703          	ld	a4,-32(s0)
ffffffe000200c38:	fcf760e3          	bltu	a4,a5,ffffffe000200bf8 <load_program+0xdc>
            }
            for(uint64_t i = phdr->p_filesz; i < phdr->p_memsz; i++){
ffffffe000200c3c:	fc043783          	ld	a5,-64(s0)
ffffffe000200c40:	0207b783          	ld	a5,32(a5)
ffffffe000200c44:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200c48:	0280006f          	j	ffffffe000200c70 <load_program+0x154>
                *((char*)paddr + i + phy_offset) = 0;
ffffffe000200c4c:	fd843703          	ld	a4,-40(s0)
ffffffe000200c50:	fa043783          	ld	a5,-96(s0)
ffffffe000200c54:	00f707b3          	add	a5,a4,a5
ffffffe000200c58:	fb043703          	ld	a4,-80(s0)
ffffffe000200c5c:	00f707b3          	add	a5,a4,a5
ffffffe000200c60:	00078023          	sb	zero,0(a5)
            for(uint64_t i = phdr->p_filesz; i < phdr->p_memsz; i++){
ffffffe000200c64:	fd843783          	ld	a5,-40(s0)
ffffffe000200c68:	00178793          	addi	a5,a5,1
ffffffe000200c6c:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200c70:	fc043783          	ld	a5,-64(s0)
ffffffe000200c74:	0287b783          	ld	a5,40(a5)
ffffffe000200c78:	fd843703          	ld	a4,-40(s0)
ffffffe000200c7c:	fcf768e3          	bltu	a4,a5,ffffffe000200c4c <load_program+0x130>
            }
            create_mapping(task->pgd, phdr->p_vaddr - phy_offset, (uint64_t)paddr - PA2VA_OFFSET, phdr->p_memsz, 0x1f);
ffffffe000200c80:	f9843783          	ld	a5,-104(s0)
ffffffe000200c84:	0a87b503          	ld	a0,168(a5)
ffffffe000200c88:	fc043783          	ld	a5,-64(s0)
ffffffe000200c8c:	0107b703          	ld	a4,16(a5)
ffffffe000200c90:	fa043783          	ld	a5,-96(s0)
ffffffe000200c94:	40f705b3          	sub	a1,a4,a5
ffffffe000200c98:	fb043703          	ld	a4,-80(s0)
ffffffe000200c9c:	04100793          	li	a5,65
ffffffe000200ca0:	01f79793          	slli	a5,a5,0x1f
ffffffe000200ca4:	00f70633          	add	a2,a4,a5
ffffffe000200ca8:	fc043783          	ld	a5,-64(s0)
ffffffe000200cac:	0287b783          	ld	a5,40(a5)
ffffffe000200cb0:	01f00713          	li	a4,31
ffffffe000200cb4:	00078693          	mv	a3,a5
ffffffe000200cb8:	7fd000ef          	jal	ffffffe000201cb4 <create_mapping>
    for (int i = 0; i < ehdr->e_phnum; ++i) {
ffffffe000200cbc:	fec42783          	lw	a5,-20(s0)
ffffffe000200cc0:	0017879b          	addiw	a5,a5,1
ffffffe000200cc4:	fef42623          	sw	a5,-20(s0)
ffffffe000200cc8:	fd043783          	ld	a5,-48(s0)
ffffffe000200ccc:	0387d783          	lhu	a5,56(a5)
ffffffe000200cd0:	0007879b          	sext.w	a5,a5
ffffffe000200cd4:	fec42703          	lw	a4,-20(s0)
ffffffe000200cd8:	0007071b          	sext.w	a4,a4
ffffffe000200cdc:	e8f740e3          	blt	a4,a5,ffffffe000200b5c <load_program+0x40>
        }
    }
    task->thread.sepc = ehdr->e_entry;
ffffffe000200ce0:	fd043783          	ld	a5,-48(s0)
ffffffe000200ce4:	0187b703          	ld	a4,24(a5)
ffffffe000200ce8:	f9843783          	ld	a5,-104(s0)
ffffffe000200cec:	08e7b823          	sd	a4,144(a5)
}
ffffffe000200cf0:	00000013          	nop
ffffffe000200cf4:	06813083          	ld	ra,104(sp)
ffffffe000200cf8:	06013403          	ld	s0,96(sp)
ffffffe000200cfc:	07010113          	addi	sp,sp,112
ffffffe000200d00:	00008067          	ret

ffffffe000200d04 <task_init>:

void task_init() {
ffffffe000200d04:	f9010113          	addi	sp,sp,-112
ffffffe000200d08:	06113423          	sd	ra,104(sp)
ffffffe000200d0c:	06813023          	sd	s0,96(sp)
ffffffe000200d10:	04913c23          	sd	s1,88(sp)
ffffffe000200d14:	07010413          	addi	s0,sp,112
    srand(2024);
ffffffe000200d18:	7e800513          	li	a0,2024
ffffffe000200d1c:	1b0020ef          	jal	ffffffe000202ecc <srand>

    idle = kalloc();
ffffffe000200d20:	cf1ff0ef          	jal	ffffffe000200a10 <kalloc>
ffffffe000200d24:	00050713          	mv	a4,a0
ffffffe000200d28:	00007797          	auipc	a5,0x7
ffffffe000200d2c:	2e078793          	addi	a5,a5,736 # ffffffe000208008 <idle>
ffffffe000200d30:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
ffffffe000200d34:	00007797          	auipc	a5,0x7
ffffffe000200d38:	2d478793          	addi	a5,a5,724 # ffffffe000208008 <idle>
ffffffe000200d3c:	0007b783          	ld	a5,0(a5)
ffffffe000200d40:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe000200d44:	00007797          	auipc	a5,0x7
ffffffe000200d48:	2c478793          	addi	a5,a5,708 # ffffffe000208008 <idle>
ffffffe000200d4c:	0007b783          	ld	a5,0(a5)
ffffffe000200d50:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe000200d54:	00007797          	auipc	a5,0x7
ffffffe000200d58:	2b478793          	addi	a5,a5,692 # ffffffe000208008 <idle>
ffffffe000200d5c:	0007b783          	ld	a5,0(a5)
ffffffe000200d60:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe000200d64:	00007797          	auipc	a5,0x7
ffffffe000200d68:	2a478793          	addi	a5,a5,676 # ffffffe000208008 <idle>
ffffffe000200d6c:	0007b783          	ld	a5,0(a5)
ffffffe000200d70:	0007bc23          	sd	zero,24(a5)

    current = idle;
ffffffe000200d74:	00007797          	auipc	a5,0x7
ffffffe000200d78:	29478793          	addi	a5,a5,660 # ffffffe000208008 <idle>
ffffffe000200d7c:	0007b703          	ld	a4,0(a5)
ffffffe000200d80:	00007797          	auipc	a5,0x7
ffffffe000200d84:	29078793          	addi	a5,a5,656 # ffffffe000208010 <current>
ffffffe000200d88:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe000200d8c:	00007797          	auipc	a5,0x7
ffffffe000200d90:	27c78793          	addi	a5,a5,636 # ffffffe000208008 <idle>
ffffffe000200d94:	0007b703          	ld	a4,0(a5)
ffffffe000200d98:	00007797          	auipc	a5,0x7
ffffffe000200d9c:	2a078793          	addi	a5,a5,672 # ffffffe000208038 <task>
ffffffe000200da0:	00e7b023          	sd	a4,0(a5)
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle


    for (int i = 1; i < NR_TASKS; i++){
ffffffe000200da4:	00100793          	li	a5,1
ffffffe000200da8:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200dac:	3800006f          	j	ffffffe00020112c <task_init+0x428>
        task[i] = kalloc();
ffffffe000200db0:	c61ff0ef          	jal	ffffffe000200a10 <kalloc>
ffffffe000200db4:	00050693          	mv	a3,a0
ffffffe000200db8:	00007717          	auipc	a4,0x7
ffffffe000200dbc:	28070713          	addi	a4,a4,640 # ffffffe000208038 <task>
ffffffe000200dc0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200dc4:	00379793          	slli	a5,a5,0x3
ffffffe000200dc8:	00f707b3          	add	a5,a4,a5
ffffffe000200dcc:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe000200dd0:	00007717          	auipc	a4,0x7
ffffffe000200dd4:	26870713          	addi	a4,a4,616 # ffffffe000208038 <task>
ffffffe000200dd8:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ddc:	00379793          	slli	a5,a5,0x3
ffffffe000200de0:	00f707b3          	add	a5,a4,a5
ffffffe000200de4:	0007b783          	ld	a5,0(a5)
ffffffe000200de8:	0007b023          	sd	zero,0(a5)
        task[i]->pid = i;
ffffffe000200dec:	00007717          	auipc	a4,0x7
ffffffe000200df0:	24c70713          	addi	a4,a4,588 # ffffffe000208038 <task>
ffffffe000200df4:	fdc42783          	lw	a5,-36(s0)
ffffffe000200df8:	00379793          	slli	a5,a5,0x3
ffffffe000200dfc:	00f707b3          	add	a5,a4,a5
ffffffe000200e00:	0007b783          	ld	a5,0(a5)
ffffffe000200e04:	fdc42703          	lw	a4,-36(s0)
ffffffe000200e08:	00e7bc23          	sd	a4,24(a5)
        task[i]->counter = 0;
ffffffe000200e0c:	00007717          	auipc	a4,0x7
ffffffe000200e10:	22c70713          	addi	a4,a4,556 # ffffffe000208038 <task>
ffffffe000200e14:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e18:	00379793          	slli	a5,a5,0x3
ffffffe000200e1c:	00f707b3          	add	a5,a4,a5
ffffffe000200e20:	0007b783          	ld	a5,0(a5)
ffffffe000200e24:	0007b423          	sd	zero,8(a5)
        task[i]->priority = (rand() % (PRIORITY_MAX - PRIORITY_MIN + 1)) + PRIORITY_MIN;
ffffffe000200e28:	0f0020ef          	jal	ffffffe000202f18 <rand>
ffffffe000200e2c:	00050793          	mv	a5,a0
ffffffe000200e30:	00078713          	mv	a4,a5
ffffffe000200e34:	0007069b          	sext.w	a3,a4
ffffffe000200e38:	666667b7          	lui	a5,0x66666
ffffffe000200e3c:	66778793          	addi	a5,a5,1639 # 66666667 <PHY_SIZE+0x5e666667>
ffffffe000200e40:	02f687b3          	mul	a5,a3,a5
ffffffe000200e44:	0207d793          	srli	a5,a5,0x20
ffffffe000200e48:	4027d79b          	sraiw	a5,a5,0x2
ffffffe000200e4c:	00078693          	mv	a3,a5
ffffffe000200e50:	41f7579b          	sraiw	a5,a4,0x1f
ffffffe000200e54:	40f687bb          	subw	a5,a3,a5
ffffffe000200e58:	00078693          	mv	a3,a5
ffffffe000200e5c:	00068793          	mv	a5,a3
ffffffe000200e60:	0027979b          	slliw	a5,a5,0x2
ffffffe000200e64:	00d787bb          	addw	a5,a5,a3
ffffffe000200e68:	0017979b          	slliw	a5,a5,0x1
ffffffe000200e6c:	40f707bb          	subw	a5,a4,a5
ffffffe000200e70:	0007879b          	sext.w	a5,a5
ffffffe000200e74:	0017879b          	addiw	a5,a5,1
ffffffe000200e78:	0007869b          	sext.w	a3,a5
ffffffe000200e7c:	00007717          	auipc	a4,0x7
ffffffe000200e80:	1bc70713          	addi	a4,a4,444 # ffffffe000208038 <task>
ffffffe000200e84:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e88:	00379793          	slli	a5,a5,0x3
ffffffe000200e8c:	00f707b3          	add	a5,a4,a5
ffffffe000200e90:	0007b783          	ld	a5,0(a5)
ffffffe000200e94:	00068713          	mv	a4,a3
ffffffe000200e98:	00e7b823          	sd	a4,16(a5)
        task[i]->thread.sp = (uint64_t)((uint64_t)task[i] + PGSIZE);
ffffffe000200e9c:	00007717          	auipc	a4,0x7
ffffffe000200ea0:	19c70713          	addi	a4,a4,412 # ffffffe000208038 <task>
ffffffe000200ea4:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ea8:	00379793          	slli	a5,a5,0x3
ffffffe000200eac:	00f707b3          	add	a5,a4,a5
ffffffe000200eb0:	0007b783          	ld	a5,0(a5)
ffffffe000200eb4:	00078693          	mv	a3,a5
ffffffe000200eb8:	00007717          	auipc	a4,0x7
ffffffe000200ebc:	18070713          	addi	a4,a4,384 # ffffffe000208038 <task>
ffffffe000200ec0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ec4:	00379793          	slli	a5,a5,0x3
ffffffe000200ec8:	00f707b3          	add	a5,a4,a5
ffffffe000200ecc:	0007b783          	ld	a5,0(a5)
ffffffe000200ed0:	00001737          	lui	a4,0x1
ffffffe000200ed4:	00e68733          	add	a4,a3,a4
ffffffe000200ed8:	02e7b423          	sd	a4,40(a5)
        task[i]->thread.ra = (uint64_t)(__dummy);
ffffffe000200edc:	00007717          	auipc	a4,0x7
ffffffe000200ee0:	15c70713          	addi	a4,a4,348 # ffffffe000208038 <task>
ffffffe000200ee4:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ee8:	00379793          	slli	a5,a5,0x3
ffffffe000200eec:	00f707b3          	add	a5,a4,a5
ffffffe000200ef0:	0007b783          	ld	a5,0(a5)
ffffffe000200ef4:	fffff717          	auipc	a4,0xfffff
ffffffe000200ef8:	2fc70713          	addi	a4,a4,764 # ffffffe0002001f0 <__dummy>
ffffffe000200efc:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sepc = USER_START;
ffffffe000200f00:	00007717          	auipc	a4,0x7
ffffffe000200f04:	13870713          	addi	a4,a4,312 # ffffffe000208038 <task>
ffffffe000200f08:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f0c:	00379793          	slli	a5,a5,0x3
ffffffe000200f10:	00f707b3          	add	a5,a4,a5
ffffffe000200f14:	0007b783          	ld	a5,0(a5)
ffffffe000200f18:	0807b823          	sd	zero,144(a5)
        task[i]->thread.sstatus = 1 << 18 | 1 << 5;
ffffffe000200f1c:	00007717          	auipc	a4,0x7
ffffffe000200f20:	11c70713          	addi	a4,a4,284 # ffffffe000208038 <task>
ffffffe000200f24:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f28:	00379793          	slli	a5,a5,0x3
ffffffe000200f2c:	00f707b3          	add	a5,a4,a5
ffffffe000200f30:	0007b783          	ld	a5,0(a5)
ffffffe000200f34:	00040737          	lui	a4,0x40
ffffffe000200f38:	02070713          	addi	a4,a4,32 # 40020 <PGSIZE+0x3f020>
ffffffe000200f3c:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sscratch = USER_END;
ffffffe000200f40:	00007717          	auipc	a4,0x7
ffffffe000200f44:	0f870713          	addi	a4,a4,248 # ffffffe000208038 <task>
ffffffe000200f48:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f4c:	00379793          	slli	a5,a5,0x3
ffffffe000200f50:	00f707b3          	add	a5,a4,a5
ffffffe000200f54:	0007b783          	ld	a5,0(a5)
ffffffe000200f58:	00100713          	li	a4,1
ffffffe000200f5c:	02671713          	slli	a4,a4,0x26
ffffffe000200f60:	0ae7b023          	sd	a4,160(a5)
        task[i]->pgd = alloc_page();
ffffffe000200f64:	00007717          	auipc	a4,0x7
ffffffe000200f68:	0d470713          	addi	a4,a4,212 # ffffffe000208038 <task>
ffffffe000200f6c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f70:	00379793          	slli	a5,a5,0x3
ffffffe000200f74:	00f707b3          	add	a5,a4,a5
ffffffe000200f78:	0007b483          	ld	s1,0(a5)
ffffffe000200f7c:	a21ff0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000200f80:	00050793          	mv	a5,a0
ffffffe000200f84:	0af4b423          	sd	a5,168(s1)
        // memcpy(task[i]->pgd, swapper_pg_dir, sizeof(swapper_pg_dir));
        uint64_t *a = task[i]->pgd;
ffffffe000200f88:	00007717          	auipc	a4,0x7
ffffffe000200f8c:	0b070713          	addi	a4,a4,176 # ffffffe000208038 <task>
ffffffe000200f90:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f94:	00379793          	slli	a5,a5,0x3
ffffffe000200f98:	00f707b3          	add	a5,a4,a5
ffffffe000200f9c:	0007b783          	ld	a5,0(a5)
ffffffe000200fa0:	0a87b783          	ld	a5,168(a5)
ffffffe000200fa4:	fcf43023          	sd	a5,-64(s0)
        for(uint64_t i = 0; i < 512;i++){
ffffffe000200fa8:	fc043823          	sd	zero,-48(s0)
ffffffe000200fac:	03c0006f          	j	ffffffe000200fe8 <task_init+0x2e4>
            a[i] = swapper_pg_dir[i];
ffffffe000200fb0:	fd043783          	ld	a5,-48(s0)
ffffffe000200fb4:	00379793          	slli	a5,a5,0x3
ffffffe000200fb8:	fc043703          	ld	a4,-64(s0)
ffffffe000200fbc:	00f707b3          	add	a5,a4,a5
ffffffe000200fc0:	00009697          	auipc	a3,0x9
ffffffe000200fc4:	04068693          	addi	a3,a3,64 # ffffffe00020a000 <swapper_pg_dir>
ffffffe000200fc8:	fd043703          	ld	a4,-48(s0)
ffffffe000200fcc:	00371713          	slli	a4,a4,0x3
ffffffe000200fd0:	00e68733          	add	a4,a3,a4
ffffffe000200fd4:	00073703          	ld	a4,0(a4)
ffffffe000200fd8:	00e7b023          	sd	a4,0(a5)
        for(uint64_t i = 0; i < 512;i++){
ffffffe000200fdc:	fd043783          	ld	a5,-48(s0)
ffffffe000200fe0:	00178793          	addi	a5,a5,1
ffffffe000200fe4:	fcf43823          	sd	a5,-48(s0)
ffffffe000200fe8:	fd043703          	ld	a4,-48(s0)
ffffffe000200fec:	1ff00793          	li	a5,511
ffffffe000200ff0:	fce7f0e3          	bgeu	a5,a4,ffffffe000200fb0 <task_init+0x2ac>
            // printk("i is %lu, swapper is %lx\n", i, swapper_pg_dir[i]);
        }

        // load_program(task[i]);
        uint64_t bin_size = (uint64_t)_eramdisk - (uint64_t)_sramdisk;
ffffffe000200ff4:	00005717          	auipc	a4,0x5
ffffffe000200ff8:	6e470713          	addi	a4,a4,1764 # ffffffe0002066d8 <_eramdisk>
ffffffe000200ffc:	00004797          	auipc	a5,0x4
ffffffe000201000:	00478793          	addi	a5,a5,4 # ffffffe000205000 <_sramdisk>
ffffffe000201004:	40f707b3          	sub	a5,a4,a5
ffffffe000201008:	faf43c23          	sd	a5,-72(s0)
        uint64_t page_num = (bin_size + PGSIZE - 1)/PGSIZE;
ffffffe00020100c:	fb843703          	ld	a4,-72(s0)
ffffffe000201010:	000017b7          	lui	a5,0x1
ffffffe000201014:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201018:	00f707b3          	add	a5,a4,a5
ffffffe00020101c:	00c7d793          	srli	a5,a5,0xc
ffffffe000201020:	faf43823          	sd	a5,-80(s0)

        uint64_t *addr = alloc_pages(page_num);
ffffffe000201024:	fb043503          	ld	a0,-80(s0)
ffffffe000201028:	91dff0ef          	jal	ffffffe000200944 <alloc_pages>
ffffffe00020102c:	faa43423          	sd	a0,-88(s0)
        char *phy_addr = (char*)addr;
ffffffe000201030:	fa843783          	ld	a5,-88(s0)
ffffffe000201034:	faf43023          	sd	a5,-96(s0)
        // memcpy(addr, (uint64_t*)_sramdisk, bin_size);
        // printk("binsize: %lx, pagenum: %lu\n", bin_size, page_num);
        for(uint64_t i = 0; i < bin_size; i++){
ffffffe000201038:	fc043423          	sd	zero,-56(s0)
ffffffe00020103c:	0340006f          	j	ffffffe000201070 <task_init+0x36c>
            phy_addr[i] = _sramdisk[i];
ffffffe000201040:	fa043703          	ld	a4,-96(s0)
ffffffe000201044:	fc843783          	ld	a5,-56(s0)
ffffffe000201048:	00f707b3          	add	a5,a4,a5
ffffffe00020104c:	00004697          	auipc	a3,0x4
ffffffe000201050:	fb468693          	addi	a3,a3,-76 # ffffffe000205000 <_sramdisk>
ffffffe000201054:	fc843703          	ld	a4,-56(s0)
ffffffe000201058:	00e68733          	add	a4,a3,a4
ffffffe00020105c:	00074703          	lbu	a4,0(a4)
ffffffe000201060:	00e78023          	sb	a4,0(a5)
        for(uint64_t i = 0; i < bin_size; i++){
ffffffe000201064:	fc843783          	ld	a5,-56(s0)
ffffffe000201068:	00178793          	addi	a5,a5,1
ffffffe00020106c:	fcf43423          	sd	a5,-56(s0)
ffffffe000201070:	fc843703          	ld	a4,-56(s0)
ffffffe000201074:	fb843783          	ld	a5,-72(s0)
ffffffe000201078:	fcf764e3          	bltu	a4,a5,ffffffe000201040 <task_init+0x33c>
        }
        // printk("%lx\n", *((uint32_t*)phy_addr));
        // printk("%lx\n", *((uint32_t*)phy_addr + 1));
        create_mapping(task[i]->pgd, USER_START, (uint64_t)addr - PA2VA_OFFSET, bin_size, 0x1f);
ffffffe00020107c:	00007717          	auipc	a4,0x7
ffffffe000201080:	fbc70713          	addi	a4,a4,-68 # ffffffe000208038 <task>
ffffffe000201084:	fdc42783          	lw	a5,-36(s0)
ffffffe000201088:	00379793          	slli	a5,a5,0x3
ffffffe00020108c:	00f707b3          	add	a5,a4,a5
ffffffe000201090:	0007b783          	ld	a5,0(a5)
ffffffe000201094:	0a87b503          	ld	a0,168(a5)
ffffffe000201098:	fa843703          	ld	a4,-88(s0)
ffffffe00020109c:	04100793          	li	a5,65
ffffffe0002010a0:	01f79793          	slli	a5,a5,0x1f
ffffffe0002010a4:	00f707b3          	add	a5,a4,a5
ffffffe0002010a8:	01f00713          	li	a4,31
ffffffe0002010ac:	fb843683          	ld	a3,-72(s0)
ffffffe0002010b0:	00078613          	mv	a2,a5
ffffffe0002010b4:	00000593          	li	a1,0
ffffffe0002010b8:	3fd000ef          	jal	ffffffe000201cb4 <create_mapping>
        uint64_t *user_stack = alloc_page();
ffffffe0002010bc:	8e1ff0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe0002010c0:	f8a43c23          	sd	a0,-104(s0)
        create_mapping(task[i]->pgd, USER_END - PGSIZE, (uint64_t)user_stack - PA2VA_OFFSET, PGSIZE, 0x1f);
ffffffe0002010c4:	00007717          	auipc	a4,0x7
ffffffe0002010c8:	f7470713          	addi	a4,a4,-140 # ffffffe000208038 <task>
ffffffe0002010cc:	fdc42783          	lw	a5,-36(s0)
ffffffe0002010d0:	00379793          	slli	a5,a5,0x3
ffffffe0002010d4:	00f707b3          	add	a5,a4,a5
ffffffe0002010d8:	0007b783          	ld	a5,0(a5)
ffffffe0002010dc:	0a87b503          	ld	a0,168(a5)
ffffffe0002010e0:	f9843703          	ld	a4,-104(s0)
ffffffe0002010e4:	04100793          	li	a5,65
ffffffe0002010e8:	01f79793          	slli	a5,a5,0x1f
ffffffe0002010ec:	00f707b3          	add	a5,a4,a5
ffffffe0002010f0:	01f00713          	li	a4,31
ffffffe0002010f4:	000016b7          	lui	a3,0x1
ffffffe0002010f8:	00078613          	mv	a2,a5
ffffffe0002010fc:	040007b7          	lui	a5,0x4000
ffffffe000201100:	fff78793          	addi	a5,a5,-1 # 3ffffff <OPENSBI_SIZE+0x3dfffff>
ffffffe000201104:	00c79593          	slli	a1,a5,0xc
ffffffe000201108:	3ad000ef          	jal	ffffffe000201cb4 <create_mapping>

        printk("after task[%lu] mapping\n", i);
ffffffe00020110c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201110:	00078593          	mv	a1,a5
ffffffe000201114:	00002517          	auipc	a0,0x2
ffffffe000201118:	f2450513          	addi	a0,a0,-220 # ffffffe000203038 <_srodata+0x38>
ffffffe00020111c:	531010ef          	jal	ffffffe000202e4c <printk>
    for (int i = 1; i < NR_TASKS; i++){
ffffffe000201120:	fdc42783          	lw	a5,-36(s0)
ffffffe000201124:	0017879b          	addiw	a5,a5,1
ffffffe000201128:	fcf42e23          	sw	a5,-36(s0)
ffffffe00020112c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201130:	0007871b          	sext.w	a4,a5
ffffffe000201134:	00400793          	li	a5,4
ffffffe000201138:	c6e7dce3          	bge	a5,a4,ffffffe000200db0 <task_init+0xac>
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址


    printk("...task_init done!\n");
ffffffe00020113c:	00002517          	auipc	a0,0x2
ffffffe000201140:	f1c50513          	addi	a0,a0,-228 # ffffffe000203058 <_srodata+0x58>
ffffffe000201144:	509010ef          	jal	ffffffe000202e4c <printk>
}
ffffffe000201148:	00000013          	nop
ffffffe00020114c:	06813083          	ld	ra,104(sp)
ffffffe000201150:	06013403          	ld	s0,96(sp)
ffffffe000201154:	05813483          	ld	s1,88(sp)
ffffffe000201158:	07010113          	addi	sp,sp,112
ffffffe00020115c:	00008067          	ret

ffffffe000201160 <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
ffffffe000201160:	fd010113          	addi	sp,sp,-48
ffffffe000201164:	02113423          	sd	ra,40(sp)
ffffffe000201168:	02813023          	sd	s0,32(sp)
ffffffe00020116c:	03010413          	addi	s0,sp,48
    // printk("in dummy\n");
    uint64_t MOD = 1000000007;
ffffffe000201170:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe000201174:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe000201178:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe00020117c:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe000201180:	fff00793          	li	a5,-1
ffffffe000201184:	fef42223          	sw	a5,-28(s0)
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000201188:	fe442783          	lw	a5,-28(s0)
ffffffe00020118c:	0007871b          	sext.w	a4,a5
ffffffe000201190:	fff00793          	li	a5,-1
ffffffe000201194:	00f70e63          	beq	a4,a5,ffffffe0002011b0 <dummy+0x50>
ffffffe000201198:	00007797          	auipc	a5,0x7
ffffffe00020119c:	e7878793          	addi	a5,a5,-392 # ffffffe000208010 <current>
ffffffe0002011a0:	0007b783          	ld	a5,0(a5)
ffffffe0002011a4:	0087b703          	ld	a4,8(a5)
ffffffe0002011a8:	fe442783          	lw	a5,-28(s0)
ffffffe0002011ac:	fcf70ee3          	beq	a4,a5,ffffffe000201188 <dummy+0x28>
ffffffe0002011b0:	00007797          	auipc	a5,0x7
ffffffe0002011b4:	e6078793          	addi	a5,a5,-416 # ffffffe000208010 <current>
ffffffe0002011b8:	0007b783          	ld	a5,0(a5)
ffffffe0002011bc:	0087b783          	ld	a5,8(a5)
ffffffe0002011c0:	fc0784e3          	beqz	a5,ffffffe000201188 <dummy+0x28>
            if (current->counter == 1) {
ffffffe0002011c4:	00007797          	auipc	a5,0x7
ffffffe0002011c8:	e4c78793          	addi	a5,a5,-436 # ffffffe000208010 <current>
ffffffe0002011cc:	0007b783          	ld	a5,0(a5)
ffffffe0002011d0:	0087b703          	ld	a4,8(a5)
ffffffe0002011d4:	00100793          	li	a5,1
ffffffe0002011d8:	00f71e63          	bne	a4,a5,ffffffe0002011f4 <dummy+0x94>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002011dc:	00007797          	auipc	a5,0x7
ffffffe0002011e0:	e3478793          	addi	a5,a5,-460 # ffffffe000208010 <current>
ffffffe0002011e4:	0007b783          	ld	a5,0(a5)
ffffffe0002011e8:	0087b703          	ld	a4,8(a5)
ffffffe0002011ec:	fff70713          	addi	a4,a4,-1
ffffffe0002011f0:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe0002011f4:	00007797          	auipc	a5,0x7
ffffffe0002011f8:	e1c78793          	addi	a5,a5,-484 # ffffffe000208010 <current>
ffffffe0002011fc:	0007b783          	ld	a5,0(a5)
ffffffe000201200:	0087b783          	ld	a5,8(a5)
ffffffe000201204:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe000201208:	fe843783          	ld	a5,-24(s0)
ffffffe00020120c:	00178713          	addi	a4,a5,1
ffffffe000201210:	fd843783          	ld	a5,-40(s0)
ffffffe000201214:	02f777b3          	remu	a5,a4,a5
ffffffe000201218:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe00020121c:	00007797          	auipc	a5,0x7
ffffffe000201220:	df478793          	addi	a5,a5,-524 # ffffffe000208010 <current>
ffffffe000201224:	0007b783          	ld	a5,0(a5)
ffffffe000201228:	0187b783          	ld	a5,24(a5)
ffffffe00020122c:	fe843603          	ld	a2,-24(s0)
ffffffe000201230:	00078593          	mv	a1,a5
ffffffe000201234:	00002517          	auipc	a0,0x2
ffffffe000201238:	e3c50513          	addi	a0,a0,-452 # ffffffe000203070 <_srodata+0x70>
ffffffe00020123c:	411010ef          	jal	ffffffe000202e4c <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000201240:	f49ff06f          	j	ffffffe000201188 <dummy+0x28>

ffffffe000201244 <switch_to>:
            #endif
        }
    }
}

void switch_to(struct task_struct *next) {
ffffffe000201244:	fd010113          	addi	sp,sp,-48
ffffffe000201248:	02113423          	sd	ra,40(sp)
ffffffe00020124c:	02813023          	sd	s0,32(sp)
ffffffe000201250:	03010413          	addi	s0,sp,48
ffffffe000201254:	fca43c23          	sd	a0,-40(s0)
    // printk("in switch_to\n");
    if(current->pid != next->pid){
ffffffe000201258:	00007797          	auipc	a5,0x7
ffffffe00020125c:	db878793          	addi	a5,a5,-584 # ffffffe000208010 <current>
ffffffe000201260:	0007b783          	ld	a5,0(a5)
ffffffe000201264:	0187b703          	ld	a4,24(a5)
ffffffe000201268:	fd843783          	ld	a5,-40(s0)
ffffffe00020126c:	0187b783          	ld	a5,24(a5)
ffffffe000201270:	06f70063          	beq	a4,a5,ffffffe0002012d0 <switch_to+0x8c>
        printk(PURPLE "switch to [pid = %d, priority = %d, priority = %d]\n" CLEAR, next->pid, next->priority, next->counter);
ffffffe000201274:	fd843783          	ld	a5,-40(s0)
ffffffe000201278:	0187b703          	ld	a4,24(a5)
ffffffe00020127c:	fd843783          	ld	a5,-40(s0)
ffffffe000201280:	0107b603          	ld	a2,16(a5)
ffffffe000201284:	fd843783          	ld	a5,-40(s0)
ffffffe000201288:	0087b783          	ld	a5,8(a5)
ffffffe00020128c:	00078693          	mv	a3,a5
ffffffe000201290:	00070593          	mv	a1,a4
ffffffe000201294:	00002517          	auipc	a0,0x2
ffffffe000201298:	e0c50513          	addi	a0,a0,-500 # ffffffe0002030a0 <_srodata+0xa0>
ffffffe00020129c:	3b1010ef          	jal	ffffffe000202e4c <printk>
        struct task_struct *tmp = current;
ffffffe0002012a0:	00007797          	auipc	a5,0x7
ffffffe0002012a4:	d7078793          	addi	a5,a5,-656 # ffffffe000208010 <current>
ffffffe0002012a8:	0007b783          	ld	a5,0(a5)
ffffffe0002012ac:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe0002012b0:	00007797          	auipc	a5,0x7
ffffffe0002012b4:	d6078793          	addi	a5,a5,-672 # ffffffe000208010 <current>
ffffffe0002012b8:	fd843703          	ld	a4,-40(s0)
ffffffe0002012bc:	00e7b023          	sd	a4,0(a5)
        __switch_to(tmp, next);
ffffffe0002012c0:	fd843583          	ld	a1,-40(s0)
ffffffe0002012c4:	fe843503          	ld	a0,-24(s0)
ffffffe0002012c8:	f39fe0ef          	jal	ffffffe000200200 <__switch_to>
    }
        
    return;
ffffffe0002012cc:	00000013          	nop
ffffffe0002012d0:	00000013          	nop
}
ffffffe0002012d4:	02813083          	ld	ra,40(sp)
ffffffe0002012d8:	02013403          	ld	s0,32(sp)
ffffffe0002012dc:	03010113          	addi	sp,sp,48
ffffffe0002012e0:	00008067          	ret

ffffffe0002012e4 <do_timer>:

void do_timer() {
ffffffe0002012e4:	ff010113          	addi	sp,sp,-16
ffffffe0002012e8:	00113423          	sd	ra,8(sp)
ffffffe0002012ec:	00813023          	sd	s0,0(sp)
ffffffe0002012f0:	01010413          	addi	s0,sp,16
    // printk("in do_timer\n");
    // printk("in do_timer, current pid is %ld, current counter is %ld\n", current->pid, current->counter);

    if(current->pid == 0 || current->counter == 0)  schedule();
ffffffe0002012f4:	00007797          	auipc	a5,0x7
ffffffe0002012f8:	d1c78793          	addi	a5,a5,-740 # ffffffe000208010 <current>
ffffffe0002012fc:	0007b783          	ld	a5,0(a5)
ffffffe000201300:	0187b783          	ld	a5,24(a5)
ffffffe000201304:	00078c63          	beqz	a5,ffffffe00020131c <do_timer+0x38>
ffffffe000201308:	00007797          	auipc	a5,0x7
ffffffe00020130c:	d0878793          	addi	a5,a5,-760 # ffffffe000208010 <current>
ffffffe000201310:	0007b783          	ld	a5,0(a5)
ffffffe000201314:	0087b783          	ld	a5,8(a5)
ffffffe000201318:	00079663          	bnez	a5,ffffffe000201324 <do_timer+0x40>
ffffffe00020131c:	05c000ef          	jal	ffffffe000201378 <schedule>
    else {
        current->counter -= 1;
        if(current->counter > 0)    return;
        else    schedule();
    }
    return;
ffffffe000201320:	0480006f          	j	ffffffe000201368 <do_timer+0x84>
        current->counter -= 1;
ffffffe000201324:	00007797          	auipc	a5,0x7
ffffffe000201328:	cec78793          	addi	a5,a5,-788 # ffffffe000208010 <current>
ffffffe00020132c:	0007b783          	ld	a5,0(a5)
ffffffe000201330:	0087b703          	ld	a4,8(a5)
ffffffe000201334:	00007797          	auipc	a5,0x7
ffffffe000201338:	cdc78793          	addi	a5,a5,-804 # ffffffe000208010 <current>
ffffffe00020133c:	0007b783          	ld	a5,0(a5)
ffffffe000201340:	fff70713          	addi	a4,a4,-1
ffffffe000201344:	00e7b423          	sd	a4,8(a5)
        if(current->counter > 0)    return;
ffffffe000201348:	00007797          	auipc	a5,0x7
ffffffe00020134c:	cc878793          	addi	a5,a5,-824 # ffffffe000208010 <current>
ffffffe000201350:	0007b783          	ld	a5,0(a5)
ffffffe000201354:	0087b783          	ld	a5,8(a5)
ffffffe000201358:	00079663          	bnez	a5,ffffffe000201364 <do_timer+0x80>
        else    schedule();
ffffffe00020135c:	01c000ef          	jal	ffffffe000201378 <schedule>
    return;
ffffffe000201360:	0080006f          	j	ffffffe000201368 <do_timer+0x84>
        if(current->counter > 0)    return;
ffffffe000201364:	00000013          	nop
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
}
ffffffe000201368:	00813083          	ld	ra,8(sp)
ffffffe00020136c:	00013403          	ld	s0,0(sp)
ffffffe000201370:	01010113          	addi	sp,sp,16
ffffffe000201374:	00008067          	ret

ffffffe000201378 <schedule>:

void schedule() {
ffffffe000201378:	fd010113          	addi	sp,sp,-48
ffffffe00020137c:	02113423          	sd	ra,40(sp)
ffffffe000201380:	02813023          	sd	s0,32(sp)
ffffffe000201384:	03010413          	addi	s0,sp,48
    // printk("in schedule\n");

    int i = NR_TASKS;
ffffffe000201388:	00500793          	li	a5,5
ffffffe00020138c:	fef42623          	sw	a5,-20(s0)
    int max_counter = -1, chosen_p;
ffffffe000201390:	fff00793          	li	a5,-1
ffffffe000201394:	fef42423          	sw	a5,-24(s0)
    struct task_struct *p = task[NR_TASKS];
ffffffe000201398:	00007797          	auipc	a5,0x7
ffffffe00020139c:	ca078793          	addi	a5,a5,-864 # ffffffe000208038 <task>
ffffffe0002013a0:	0287b783          	ld	a5,40(a5)
ffffffe0002013a4:	fcf43c23          	sd	a5,-40(s0)
    
    while(--i){
ffffffe0002013a8:	06c0006f          	j	ffffffe000201414 <schedule+0x9c>
        // if(*--p == NULL)    continue;
        p = task[i];
ffffffe0002013ac:	00007717          	auipc	a4,0x7
ffffffe0002013b0:	c8c70713          	addi	a4,a4,-884 # ffffffe000208038 <task>
ffffffe0002013b4:	fec42783          	lw	a5,-20(s0)
ffffffe0002013b8:	00379793          	slli	a5,a5,0x3
ffffffe0002013bc:	00f707b3          	add	a5,a4,a5
ffffffe0002013c0:	0007b783          	ld	a5,0(a5)
ffffffe0002013c4:	fcf43c23          	sd	a5,-40(s0)
        if(!p) continue;
ffffffe0002013c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002013cc:	04078263          	beqz	a5,ffffffe000201410 <schedule+0x98>
        // printk("p pid is %ld, p counter is %ld\n", p->pid, p->counter);
        int pct = p->counter;
ffffffe0002013d0:	fd843783          	ld	a5,-40(s0)
ffffffe0002013d4:	0087b783          	ld	a5,8(a5)
ffffffe0002013d8:	fcf42a23          	sw	a5,-44(s0)
        if(pct > max_counter){
ffffffe0002013dc:	fd442783          	lw	a5,-44(s0)
ffffffe0002013e0:	00078713          	mv	a4,a5
ffffffe0002013e4:	fe842783          	lw	a5,-24(s0)
ffffffe0002013e8:	0007071b          	sext.w	a4,a4
ffffffe0002013ec:	0007879b          	sext.w	a5,a5
ffffffe0002013f0:	02e7d263          	bge	a5,a4,ffffffe000201414 <schedule+0x9c>
            // printk("%ld\n", pct);
            max_counter = p->counter;
ffffffe0002013f4:	fd843783          	ld	a5,-40(s0)
ffffffe0002013f8:	0087b783          	ld	a5,8(a5)
ffffffe0002013fc:	fef42423          	sw	a5,-24(s0)
            chosen_p = p->pid;
ffffffe000201400:	fd843783          	ld	a5,-40(s0)
ffffffe000201404:	0187b783          	ld	a5,24(a5)
ffffffe000201408:	fef42223          	sw	a5,-28(s0)
ffffffe00020140c:	0080006f          	j	ffffffe000201414 <schedule+0x9c>
        if(!p) continue;
ffffffe000201410:	00000013          	nop
    while(--i){
ffffffe000201414:	fec42783          	lw	a5,-20(s0)
ffffffe000201418:	fff7879b          	addiw	a5,a5,-1
ffffffe00020141c:	fef42623          	sw	a5,-20(s0)
ffffffe000201420:	fec42783          	lw	a5,-20(s0)
ffffffe000201424:	0007879b          	sext.w	a5,a5
ffffffe000201428:	f80792e3          	bnez	a5,ffffffe0002013ac <schedule+0x34>
        }
    }
    // printk("maxcounter is %ld\n", max_counter);
    if(max_counter <= 0) {
ffffffe00020142c:	fe842783          	lw	a5,-24(s0)
ffffffe000201430:	0007879b          	sext.w	a5,a5
ffffffe000201434:	0af04263          	bgtz	a5,ffffffe0002014d8 <schedule+0x160>
        i = NR_TASKS;
ffffffe000201438:	00500793          	li	a5,5
ffffffe00020143c:	fef42623          	sw	a5,-20(s0)
        p = task[NR_TASKS];
ffffffe000201440:	00007797          	auipc	a5,0x7
ffffffe000201444:	bf878793          	addi	a5,a5,-1032 # ffffffe000208038 <task>
ffffffe000201448:	0287b783          	ld	a5,40(a5)
ffffffe00020144c:	fcf43c23          	sd	a5,-40(s0)
        while(--i){
ffffffe000201450:	06c0006f          	j	ffffffe0002014bc <schedule+0x144>
            // if(*--p == NULL)   continue;
            p = task[i];
ffffffe000201454:	00007717          	auipc	a4,0x7
ffffffe000201458:	be470713          	addi	a4,a4,-1052 # ffffffe000208038 <task>
ffffffe00020145c:	fec42783          	lw	a5,-20(s0)
ffffffe000201460:	00379793          	slli	a5,a5,0x3
ffffffe000201464:	00f707b3          	add	a5,a4,a5
ffffffe000201468:	0007b783          	ld	a5,0(a5)
ffffffe00020146c:	fcf43c23          	sd	a5,-40(s0)
            if(!p)  continue;
ffffffe000201470:	fd843783          	ld	a5,-40(s0)
ffffffe000201474:	04078263          	beqz	a5,ffffffe0002014b8 <schedule+0x140>
            p->counter = p->priority;
ffffffe000201478:	fd843783          	ld	a5,-40(s0)
ffffffe00020147c:	0107b703          	ld	a4,16(a5)
ffffffe000201480:	fd843783          	ld	a5,-40(s0)
ffffffe000201484:	00e7b423          	sd	a4,8(a5)
            printk(GREEN "SET [PID = %ld PRIORITY = %ld COUNTER = %ld]\n" CLEAR, p->pid, p->priority, p->counter);
ffffffe000201488:	fd843783          	ld	a5,-40(s0)
ffffffe00020148c:	0187b703          	ld	a4,24(a5)
ffffffe000201490:	fd843783          	ld	a5,-40(s0)
ffffffe000201494:	0107b603          	ld	a2,16(a5)
ffffffe000201498:	fd843783          	ld	a5,-40(s0)
ffffffe00020149c:	0087b783          	ld	a5,8(a5)
ffffffe0002014a0:	00078693          	mv	a3,a5
ffffffe0002014a4:	00070593          	mv	a1,a4
ffffffe0002014a8:	00002517          	auipc	a0,0x2
ffffffe0002014ac:	c3850513          	addi	a0,a0,-968 # ffffffe0002030e0 <_srodata+0xe0>
ffffffe0002014b0:	19d010ef          	jal	ffffffe000202e4c <printk>
ffffffe0002014b4:	0080006f          	j	ffffffe0002014bc <schedule+0x144>
            if(!p)  continue;
ffffffe0002014b8:	00000013          	nop
        while(--i){
ffffffe0002014bc:	fec42783          	lw	a5,-20(s0)
ffffffe0002014c0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002014c4:	fef42623          	sw	a5,-20(s0)
ffffffe0002014c8:	fec42783          	lw	a5,-20(s0)
ffffffe0002014cc:	0007879b          	sext.w	a5,a5
ffffffe0002014d0:	f80792e3          	bnez	a5,ffffffe000201454 <schedule+0xdc>
        }
        schedule();
ffffffe0002014d4:	ea5ff0ef          	jal	ffffffe000201378 <schedule>
    }
    switch_to(task[chosen_p]);
ffffffe0002014d8:	00007717          	auipc	a4,0x7
ffffffe0002014dc:	b6070713          	addi	a4,a4,-1184 # ffffffe000208038 <task>
ffffffe0002014e0:	fe442783          	lw	a5,-28(s0)
ffffffe0002014e4:	00379793          	slli	a5,a5,0x3
ffffffe0002014e8:	00f707b3          	add	a5,a4,a5
ffffffe0002014ec:	0007b783          	ld	a5,0(a5)
ffffffe0002014f0:	00078513          	mv	a0,a5
ffffffe0002014f4:	d51ff0ef          	jal	ffffffe000201244 <switch_to>
    return;
ffffffe0002014f8:	00000013          	nop
ffffffe0002014fc:	02813083          	ld	ra,40(sp)
ffffffe000201500:	02013403          	ld	s0,32(sp)
ffffffe000201504:	03010113          	addi	sp,sp,48
ffffffe000201508:	00008067          	ret

ffffffe00020150c <sbi_ecall>:
#include "sbi.h"
#define write_csr(reg, val) ({ asm volatile ( "csrw " #reg ", %0" :: "r"(val)); })
#define read_csr(csr) ({ uint64_t __v; asm volatile("csrr %0, " #csr : "=r"(__v) : : "memory"); __v;                                \})
struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe00020150c:	f8010113          	addi	sp,sp,-128
ffffffe000201510:	06113c23          	sd	ra,120(sp)
ffffffe000201514:	06813823          	sd	s0,112(sp)
ffffffe000201518:	08010413          	addi	s0,sp,128
ffffffe00020151c:	faa43c23          	sd	a0,-72(s0)
ffffffe000201520:	fab43823          	sd	a1,-80(s0)
ffffffe000201524:	fac43423          	sd	a2,-88(s0)
ffffffe000201528:	fad43023          	sd	a3,-96(s0)
ffffffe00020152c:	f8e43c23          	sd	a4,-104(s0)
ffffffe000201530:	f8f43823          	sd	a5,-112(s0)
ffffffe000201534:	f9043423          	sd	a6,-120(s0)
ffffffe000201538:	f9143023          	sd	a7,-128(s0)
    struct sbiret res;
    long error;
    long value;
    asm volatile (
ffffffe00020153c:	fb843783          	ld	a5,-72(s0)
ffffffe000201540:	fb043703          	ld	a4,-80(s0)
ffffffe000201544:	fa843683          	ld	a3,-88(s0)
ffffffe000201548:	fa043603          	ld	a2,-96(s0)
ffffffe00020154c:	f9843583          	ld	a1,-104(s0)
ffffffe000201550:	f9043503          	ld	a0,-112(s0)
ffffffe000201554:	f8843803          	ld	a6,-120(s0)
ffffffe000201558:	f8043883          	ld	a7,-128(s0)
ffffffe00020155c:	00078893          	mv	a7,a5
ffffffe000201560:	00070813          	mv	a6,a4
ffffffe000201564:	00068513          	mv	a0,a3
ffffffe000201568:	00060593          	mv	a1,a2
ffffffe00020156c:	00058613          	mv	a2,a1
ffffffe000201570:	00050693          	mv	a3,a0
ffffffe000201574:	00080713          	mv	a4,a6
ffffffe000201578:	00088793          	mv	a5,a7
ffffffe00020157c:	00000073          	ecall
ffffffe000201580:	00050713          	mv	a4,a0
ffffffe000201584:	00058793          	mv	a5,a1
ffffffe000201588:	fee43423          	sd	a4,-24(s0)
ffffffe00020158c:	fef43023          	sd	a5,-32(s0)
        : [error] "=r"(error),[value] "=r"(value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory"
    );
    //顺序问题 -- 绑定依然需要顺序 -- 为什么倒序不行
    res.error = error;
ffffffe000201590:	fe843783          	ld	a5,-24(s0)
ffffffe000201594:	fcf43023          	sd	a5,-64(s0)
    res.value = value;
ffffffe000201598:	fe043783          	ld	a5,-32(s0)
ffffffe00020159c:	fcf43423          	sd	a5,-56(s0)
    return res;
ffffffe0002015a0:	fc043783          	ld	a5,-64(s0)
ffffffe0002015a4:	fcf43823          	sd	a5,-48(s0)
ffffffe0002015a8:	fc843783          	ld	a5,-56(s0)
ffffffe0002015ac:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002015b0:	fd043703          	ld	a4,-48(s0)
ffffffe0002015b4:	fd843783          	ld	a5,-40(s0)
ffffffe0002015b8:	00070313          	mv	t1,a4
ffffffe0002015bc:	00078393          	mv	t2,a5
ffffffe0002015c0:	00030713          	mv	a4,t1
ffffffe0002015c4:	00038793          	mv	a5,t2
}
ffffffe0002015c8:	00070513          	mv	a0,a4
ffffffe0002015cc:	00078593          	mv	a1,a5
ffffffe0002015d0:	07813083          	ld	ra,120(sp)
ffffffe0002015d4:	07013403          	ld	s0,112(sp)
ffffffe0002015d8:	08010113          	addi	sp,sp,128
ffffffe0002015dc:	00008067          	ret

ffffffe0002015e0 <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime) {
ffffffe0002015e0:	fc010113          	addi	sp,sp,-64
ffffffe0002015e4:	02113c23          	sd	ra,56(sp)
ffffffe0002015e8:	02813823          	sd	s0,48(sp)
ffffffe0002015ec:	03213423          	sd	s2,40(sp)
ffffffe0002015f0:	03313023          	sd	s3,32(sp)
ffffffe0002015f4:	04010413          	addi	s0,sp,64
ffffffe0002015f8:	fca43423          	sd	a0,-56(s0)
    return sbi_ecall(0x54494D45, 0x0, stime, 0, 0, 0, 0, 0);
ffffffe0002015fc:	00000893          	li	a7,0
ffffffe000201600:	00000813          	li	a6,0
ffffffe000201604:	00000793          	li	a5,0
ffffffe000201608:	00000713          	li	a4,0
ffffffe00020160c:	00000693          	li	a3,0
ffffffe000201610:	fc843603          	ld	a2,-56(s0)
ffffffe000201614:	00000593          	li	a1,0
ffffffe000201618:	54495537          	lui	a0,0x54495
ffffffe00020161c:	d4550513          	addi	a0,a0,-699 # 54494d45 <PHY_SIZE+0x4c494d45>
ffffffe000201620:	eedff0ef          	jal	ffffffe00020150c <sbi_ecall>
ffffffe000201624:	00050713          	mv	a4,a0
ffffffe000201628:	00058793          	mv	a5,a1
ffffffe00020162c:	fce43823          	sd	a4,-48(s0)
ffffffe000201630:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201634:	fd043703          	ld	a4,-48(s0)
ffffffe000201638:	fd843783          	ld	a5,-40(s0)
ffffffe00020163c:	00070913          	mv	s2,a4
ffffffe000201640:	00078993          	mv	s3,a5
ffffffe000201644:	00090713          	mv	a4,s2
ffffffe000201648:	00098793          	mv	a5,s3
}
ffffffe00020164c:	00070513          	mv	a0,a4
ffffffe000201650:	00078593          	mv	a1,a5
ffffffe000201654:	03813083          	ld	ra,56(sp)
ffffffe000201658:	03013403          	ld	s0,48(sp)
ffffffe00020165c:	02813903          	ld	s2,40(sp)
ffffffe000201660:	02013983          	ld	s3,32(sp)
ffffffe000201664:	04010113          	addi	sp,sp,64
ffffffe000201668:	00008067          	ret

ffffffe00020166c <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe00020166c:	fc010113          	addi	sp,sp,-64
ffffffe000201670:	02113c23          	sd	ra,56(sp)
ffffffe000201674:	02813823          	sd	s0,48(sp)
ffffffe000201678:	03213423          	sd	s2,40(sp)
ffffffe00020167c:	03313023          	sd	s3,32(sp)
ffffffe000201680:	04010413          	addi	s0,sp,64
ffffffe000201684:	00050793          	mv	a5,a0
ffffffe000201688:	fcf407a3          	sb	a5,-49(s0)
    return sbi_ecall(0x4442434E, 0x2, byte, 0, 0, 0, 0, 0);
ffffffe00020168c:	fcf44603          	lbu	a2,-49(s0)
ffffffe000201690:	00000893          	li	a7,0
ffffffe000201694:	00000813          	li	a6,0
ffffffe000201698:	00000793          	li	a5,0
ffffffe00020169c:	00000713          	li	a4,0
ffffffe0002016a0:	00000693          	li	a3,0
ffffffe0002016a4:	00200593          	li	a1,2
ffffffe0002016a8:	44424537          	lui	a0,0x44424
ffffffe0002016ac:	34e50513          	addi	a0,a0,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe0002016b0:	e5dff0ef          	jal	ffffffe00020150c <sbi_ecall>
ffffffe0002016b4:	00050713          	mv	a4,a0
ffffffe0002016b8:	00058793          	mv	a5,a1
ffffffe0002016bc:	fce43823          	sd	a4,-48(s0)
ffffffe0002016c0:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002016c4:	fd043703          	ld	a4,-48(s0)
ffffffe0002016c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002016cc:	00070913          	mv	s2,a4
ffffffe0002016d0:	00078993          	mv	s3,a5
ffffffe0002016d4:	00090713          	mv	a4,s2
ffffffe0002016d8:	00098793          	mv	a5,s3
}
ffffffe0002016dc:	00070513          	mv	a0,a4
ffffffe0002016e0:	00078593          	mv	a1,a5
ffffffe0002016e4:	03813083          	ld	ra,56(sp)
ffffffe0002016e8:	03013403          	ld	s0,48(sp)
ffffffe0002016ec:	02813903          	ld	s2,40(sp)
ffffffe0002016f0:	02013983          	ld	s3,32(sp)
ffffffe0002016f4:	04010113          	addi	sp,sp,64
ffffffe0002016f8:	00008067          	ret

ffffffe0002016fc <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe0002016fc:	fc010113          	addi	sp,sp,-64
ffffffe000201700:	02113c23          	sd	ra,56(sp)
ffffffe000201704:	02813823          	sd	s0,48(sp)
ffffffe000201708:	03213423          	sd	s2,40(sp)
ffffffe00020170c:	03313023          	sd	s3,32(sp)
ffffffe000201710:	04010413          	addi	s0,sp,64
ffffffe000201714:	00050793          	mv	a5,a0
ffffffe000201718:	00058713          	mv	a4,a1
ffffffe00020171c:	fcf42623          	sw	a5,-52(s0)
ffffffe000201720:	00070793          	mv	a5,a4
ffffffe000201724:	fcf42423          	sw	a5,-56(s0)
    return sbi_ecall(0x53525354, 0x0, 0, 0, 0, 0, 0, 0);
ffffffe000201728:	00000893          	li	a7,0
ffffffe00020172c:	00000813          	li	a6,0
ffffffe000201730:	00000793          	li	a5,0
ffffffe000201734:	00000713          	li	a4,0
ffffffe000201738:	00000693          	li	a3,0
ffffffe00020173c:	00000613          	li	a2,0
ffffffe000201740:	00000593          	li	a1,0
ffffffe000201744:	53525537          	lui	a0,0x53525
ffffffe000201748:	35450513          	addi	a0,a0,852 # 53525354 <PHY_SIZE+0x4b525354>
ffffffe00020174c:	dc1ff0ef          	jal	ffffffe00020150c <sbi_ecall>
ffffffe000201750:	00050713          	mv	a4,a0
ffffffe000201754:	00058793          	mv	a5,a1
ffffffe000201758:	fce43823          	sd	a4,-48(s0)
ffffffe00020175c:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201760:	fd043703          	ld	a4,-48(s0)
ffffffe000201764:	fd843783          	ld	a5,-40(s0)
ffffffe000201768:	00070913          	mv	s2,a4
ffffffe00020176c:	00078993          	mv	s3,a5
ffffffe000201770:	00090713          	mv	a4,s2
ffffffe000201774:	00098793          	mv	a5,s3
ffffffe000201778:	00070513          	mv	a0,a4
ffffffe00020177c:	00078593          	mv	a1,a5
ffffffe000201780:	03813083          	ld	ra,56(sp)
ffffffe000201784:	03013403          	ld	s0,48(sp)
ffffffe000201788:	02813903          	ld	s2,40(sp)
ffffffe00020178c:	02013983          	ld	s3,32(sp)
ffffffe000201790:	04010113          	addi	sp,sp,64
ffffffe000201794:	00008067          	ret

ffffffe000201798 <sys_write>:

extern struct task_struct *current;

extern struct sbiret sbi_debug_console_write_byte(uint8_t byte);

uint64_t sys_write(unsigned int fd, const char* buf, size_t count){
ffffffe000201798:	fc010113          	addi	sp,sp,-64
ffffffe00020179c:	02113c23          	sd	ra,56(sp)
ffffffe0002017a0:	02813823          	sd	s0,48(sp)
ffffffe0002017a4:	04010413          	addi	s0,sp,64
ffffffe0002017a8:	00050793          	mv	a5,a0
ffffffe0002017ac:	fcb43823          	sd	a1,-48(s0)
ffffffe0002017b0:	fcc43423          	sd	a2,-56(s0)
ffffffe0002017b4:	fcf42e23          	sw	a5,-36(s0)
    uint64_t cnt = 0;
ffffffe0002017b8:	fe043423          	sd	zero,-24(s0)
    while (cnt < count){
ffffffe0002017bc:	0340006f          	j	ffffffe0002017f0 <sys_write+0x58>
        printk("%c", buf[cnt]);
ffffffe0002017c0:	fd043703          	ld	a4,-48(s0)
ffffffe0002017c4:	fe843783          	ld	a5,-24(s0)
ffffffe0002017c8:	00f707b3          	add	a5,a4,a5
ffffffe0002017cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002017d0:	0007879b          	sext.w	a5,a5
ffffffe0002017d4:	00078593          	mv	a1,a5
ffffffe0002017d8:	00002517          	auipc	a0,0x2
ffffffe0002017dc:	94050513          	addi	a0,a0,-1728 # ffffffe000203118 <_srodata+0x118>
ffffffe0002017e0:	66c010ef          	jal	ffffffe000202e4c <printk>
        cnt++;
ffffffe0002017e4:	fe843783          	ld	a5,-24(s0)
ffffffe0002017e8:	00178793          	addi	a5,a5,1
ffffffe0002017ec:	fef43423          	sd	a5,-24(s0)
    while (cnt < count){
ffffffe0002017f0:	fe843703          	ld	a4,-24(s0)
ffffffe0002017f4:	fc843783          	ld	a5,-56(s0)
ffffffe0002017f8:	fcf764e3          	bltu	a4,a5,ffffffe0002017c0 <sys_write+0x28>
    }
    return cnt;
ffffffe0002017fc:	fe843783          	ld	a5,-24(s0)
}
ffffffe000201800:	00078513          	mv	a0,a5
ffffffe000201804:	03813083          	ld	ra,56(sp)
ffffffe000201808:	03013403          	ld	s0,48(sp)
ffffffe00020180c:	04010113          	addi	sp,sp,64
ffffffe000201810:	00008067          	ret

ffffffe000201814 <sys_getpid>:

uint64_t sys_getpid(){
ffffffe000201814:	ff010113          	addi	sp,sp,-16
ffffffe000201818:	00113423          	sd	ra,8(sp)
ffffffe00020181c:	00813023          	sd	s0,0(sp)
ffffffe000201820:	01010413          	addi	s0,sp,16
    return current->pid;
ffffffe000201824:	00006797          	auipc	a5,0x6
ffffffe000201828:	7ec78793          	addi	a5,a5,2028 # ffffffe000208010 <current>
ffffffe00020182c:	0007b783          	ld	a5,0(a5)
ffffffe000201830:	0187b783          	ld	a5,24(a5)
ffffffe000201834:	00078513          	mv	a0,a5
ffffffe000201838:	00813083          	ld	ra,8(sp)
ffffffe00020183c:	00013403          	ld	s0,0(sp)
ffffffe000201840:	01010113          	addi	sp,sp,16
ffffffe000201844:	00008067          	ret

ffffffe000201848 <trap_handler>:

extern uint64_t sys_getpid();



void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs) {
ffffffe000201848:	fc010113          	addi	sp,sp,-64
ffffffe00020184c:	02113c23          	sd	ra,56(sp)
ffffffe000201850:	02813823          	sd	s0,48(sp)
ffffffe000201854:	04010413          	addi	s0,sp,64
ffffffe000201858:	fca43c23          	sd	a0,-40(s0)
ffffffe00020185c:	fcb43823          	sd	a1,-48(s0)
ffffffe000201860:	fcc43423          	sd	a2,-56(s0)

    uint64_t myscause;
    
    // asm volatile("csrr %0, scause" : "=r"(myscause)); 
    // myscause = csr_read(scause);
    myscause = scause;
ffffffe000201864:	fd843783          	ld	a5,-40(s0)
ffffffe000201868:	fef43423          	sd	a5,-24(s0)
    if (myscause & (1ull << 63)) {
ffffffe00020186c:	fe843783          	ld	a5,-24(s0)
ffffffe000201870:	0207d663          	bgez	a5,ffffffe00020189c <trap_handler+0x54>
        if (myscause & 0x5) {
ffffffe000201874:	fe843783          	ld	a5,-24(s0)
ffffffe000201878:	0057f793          	andi	a5,a5,5
ffffffe00020187c:	00078863          	beqz	a5,ffffffe00020188c <trap_handler+0x44>
            // printk("[S] is time interrupt\n");
            clock_set_next_event();
ffffffe000201880:	a81fe0ef          	jal	ffffffe000200300 <clock_set_next_event>
            do_timer();
ffffffe000201884:	a61ff0ef          	jal	ffffffe0002012e4 <do_timer>
            // uint64_t ss = csr_read(sstatus);
            // printk("sstatus is: %ld", ss);
            // csr_write(sscratch, 0x0001001001001000);
            return;
ffffffe000201888:	0bc0006f          	j	ffffffe000201944 <trap_handler+0xfc>
        } else {
            printk("not time interrupt\n");
ffffffe00020188c:	00002517          	auipc	a0,0x2
ffffffe000201890:	89450513          	addi	a0,a0,-1900 # ffffffe000203120 <_srodata+0x120>
ffffffe000201894:	5b8010ef          	jal	ffffffe000202e4c <printk>
            return;
ffffffe000201898:	0ac0006f          	j	ffffffe000201944 <trap_handler+0xfc>
        }
    } else {
        // printk("[S] not interrupt\n");
        if (myscause & 0x8) {
ffffffe00020189c:	fe843783          	ld	a5,-24(s0)
ffffffe0002018a0:	0087f793          	andi	a5,a5,8
ffffffe0002018a4:	08078e63          	beqz	a5,ffffffe000201940 <trap_handler+0xf8>
            // printk("[S] is ecall from U-mode\n");
            if (regs->a7 == SYS_GETPID){
ffffffe0002018a8:	fc843783          	ld	a5,-56(s0)
ffffffe0002018ac:	0787b703          	ld	a4,120(a5)
ffffffe0002018b0:	0ac00793          	li	a5,172
ffffffe0002018b4:	02f71663          	bne	a4,a5,ffffffe0002018e0 <trap_handler+0x98>
                regs->a0 = sys_getpid();
ffffffe0002018b8:	f5dff0ef          	jal	ffffffe000201814 <sys_getpid>
ffffffe0002018bc:	00050713          	mv	a4,a0
ffffffe0002018c0:	fc843783          	ld	a5,-56(s0)
ffffffe0002018c4:	04e7b023          	sd	a4,64(a5)
                // printk("return of sys_getpid: %lx\n", regs->a0);
                regs->sepc += 4;
ffffffe0002018c8:	fc843783          	ld	a5,-56(s0)
ffffffe0002018cc:	0f07b783          	ld	a5,240(a5)
ffffffe0002018d0:	00478713          	addi	a4,a5,4
ffffffe0002018d4:	fc843783          	ld	a5,-56(s0)
ffffffe0002018d8:	0ee7b823          	sd	a4,240(a5)
                regs->a0 = sys_write((uint64_t)regs->a0, (char*)regs->a1, (uint64_t)regs->a2);
                // printk("return of sys_write: %lx\n", regs->a0);
                regs->sepc += 4;
            }
        }
        return;
ffffffe0002018dc:	0640006f          	j	ffffffe000201940 <trap_handler+0xf8>
            } else if (regs->a7 == SYS_WRITE){
ffffffe0002018e0:	fc843783          	ld	a5,-56(s0)
ffffffe0002018e4:	0787b703          	ld	a4,120(a5)
ffffffe0002018e8:	04000793          	li	a5,64
ffffffe0002018ec:	04f71a63          	bne	a4,a5,ffffffe000201940 <trap_handler+0xf8>
                regs->a0 = sys_write((uint64_t)regs->a0, (char*)regs->a1, (uint64_t)regs->a2);
ffffffe0002018f0:	fc843783          	ld	a5,-56(s0)
ffffffe0002018f4:	0407b783          	ld	a5,64(a5)
ffffffe0002018f8:	0007871b          	sext.w	a4,a5
ffffffe0002018fc:	fc843783          	ld	a5,-56(s0)
ffffffe000201900:	0487b783          	ld	a5,72(a5)
ffffffe000201904:	00078693          	mv	a3,a5
ffffffe000201908:	fc843783          	ld	a5,-56(s0)
ffffffe00020190c:	0507b783          	ld	a5,80(a5)
ffffffe000201910:	00078613          	mv	a2,a5
ffffffe000201914:	00068593          	mv	a1,a3
ffffffe000201918:	00070513          	mv	a0,a4
ffffffe00020191c:	e7dff0ef          	jal	ffffffe000201798 <sys_write>
ffffffe000201920:	00050713          	mv	a4,a0
ffffffe000201924:	fc843783          	ld	a5,-56(s0)
ffffffe000201928:	04e7b023          	sd	a4,64(a5)
                regs->sepc += 4;
ffffffe00020192c:	fc843783          	ld	a5,-56(s0)
ffffffe000201930:	0f07b783          	ld	a5,240(a5)
ffffffe000201934:	00478713          	addi	a4,a5,4
ffffffe000201938:	fc843783          	ld	a5,-56(s0)
ffffffe00020193c:	0ee7b823          	sd	a4,240(a5)
        return;
ffffffe000201940:	00000013          	nop
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试
    return;
ffffffe000201944:	03813083          	ld	ra,56(sp)
ffffffe000201948:	03013403          	ld	s0,48(sp)
ffffffe00020194c:	04010113          	addi	sp,sp,64
ffffffe000201950:	00008067          	ret

ffffffe000201954 <setup_vm>:

uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);

void setup_vm() {
ffffffe000201954:	fc010113          	addi	sp,sp,-64
ffffffe000201958:	02113c23          	sd	ra,56(sp)
ffffffe00020195c:	02813823          	sd	s0,48(sp)
ffffffe000201960:	04010413          	addi	s0,sp,64
     *     中间 9 bit 作为 early_pgtbl 的 index
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

    uint64_t spa = PHY_START;
ffffffe000201964:	00100793          	li	a5,1
ffffffe000201968:	01f79793          	slli	a5,a5,0x1f
ffffffe00020196c:	fef43023          	sd	a5,-32(s0)
    uint64_t sva = VM_START;
ffffffe000201970:	fff00793          	li	a5,-1
ffffffe000201974:	02579793          	slli	a5,a5,0x25
ffffffe000201978:	fcf43c23          	sd	a5,-40(s0)
    memset(early_pgtbl, 0, sizeof(early_pgtbl));
ffffffe00020197c:	00001637          	lui	a2,0x1
ffffffe000201980:	00000593          	li	a1,0
ffffffe000201984:	00007517          	auipc	a0,0x7
ffffffe000201988:	67c50513          	addi	a0,a0,1660 # ffffffe000209000 <early_pgtbl>
ffffffe00020198c:	5f0010ef          	jal	ffffffe000202f7c <memset>
    printk("in setup vm\n");
ffffffe000201990:	00001517          	auipc	a0,0x1
ffffffe000201994:	7a850513          	addi	a0,a0,1960 # ffffffe000203138 <_srodata+0x138>
ffffffe000201998:	4b4010ef          	jal	ffffffe000202e4c <printk>

    uint64_t addr, vaddr, index, test;
    addr = PHY_START;
ffffffe00020199c:	00100793          	li	a5,1
ffffffe0002019a0:	01f79793          	slli	a5,a5,0x1f
ffffffe0002019a4:	fcf43823          	sd	a5,-48(s0)
    vaddr = addr;
ffffffe0002019a8:	fd043783          	ld	a5,-48(s0)
ffffffe0002019ac:	fcf43423          	sd	a5,-56(s0)
    index = (vaddr >> 30) & 0x1FF;
ffffffe0002019b0:	fc843783          	ld	a5,-56(s0)
ffffffe0002019b4:	01e7d793          	srli	a5,a5,0x1e
ffffffe0002019b8:	1ff7f793          	andi	a5,a5,511
ffffffe0002019bc:	fcf43023          	sd	a5,-64(s0)
    early_pgtbl[index] = (((addr >> 30) & 0x1ff) << 28) | PTE_V | PTE_R | PTE_W | PTE_X;
ffffffe0002019c0:	fd043783          	ld	a5,-48(s0)
ffffffe0002019c4:	01e7d793          	srli	a5,a5,0x1e
ffffffe0002019c8:	01c79713          	slli	a4,a5,0x1c
ffffffe0002019cc:	1ff00793          	li	a5,511
ffffffe0002019d0:	01c79793          	slli	a5,a5,0x1c
ffffffe0002019d4:	00f777b3          	and	a5,a4,a5
ffffffe0002019d8:	00f7e713          	ori	a4,a5,15
ffffffe0002019dc:	00007697          	auipc	a3,0x7
ffffffe0002019e0:	62468693          	addi	a3,a3,1572 # ffffffe000209000 <early_pgtbl>
ffffffe0002019e4:	fc043783          	ld	a5,-64(s0)
ffffffe0002019e8:	00379793          	slli	a5,a5,0x3
ffffffe0002019ec:	00f687b3          	add	a5,a3,a5
ffffffe0002019f0:	00e7b023          	sd	a4,0(a5)
    vaddr = addr + PA2VA_OFFSET;
ffffffe0002019f4:	fd043703          	ld	a4,-48(s0)
ffffffe0002019f8:	fbf00793          	li	a5,-65
ffffffe0002019fc:	01f79793          	slli	a5,a5,0x1f
ffffffe000201a00:	00f707b3          	add	a5,a4,a5
ffffffe000201a04:	fcf43423          	sd	a5,-56(s0)
    index = (vaddr >> 30) & 0x1FF;
ffffffe000201a08:	fc843783          	ld	a5,-56(s0)
ffffffe000201a0c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201a10:	1ff7f793          	andi	a5,a5,511
ffffffe000201a14:	fcf43023          	sd	a5,-64(s0)
    early_pgtbl[index] = (((addr >> 30) & 0x1ff) << 28) | PTE_V | PTE_R | PTE_W | PTE_X; 
ffffffe000201a18:	fd043783          	ld	a5,-48(s0)
ffffffe000201a1c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201a20:	01c79713          	slli	a4,a5,0x1c
ffffffe000201a24:	1ff00793          	li	a5,511
ffffffe000201a28:	01c79793          	slli	a5,a5,0x1c
ffffffe000201a2c:	00f777b3          	and	a5,a4,a5
ffffffe000201a30:	00f7e713          	ori	a4,a5,15
ffffffe000201a34:	00007697          	auipc	a3,0x7
ffffffe000201a38:	5cc68693          	addi	a3,a3,1484 # ffffffe000209000 <early_pgtbl>
ffffffe000201a3c:	fc043783          	ld	a5,-64(s0)
ffffffe000201a40:	00379793          	slli	a5,a5,0x3
ffffffe000201a44:	00f687b3          	add	a5,a3,a5
ffffffe000201a48:	00e7b023          	sd	a4,0(a5)

    for(uint64_t i = 0; i < 512; i++){
ffffffe000201a4c:	fe043423          	sd	zero,-24(s0)
ffffffe000201a50:	0700006f          	j	ffffffe000201ac0 <setup_vm+0x16c>
        if(early_pgtbl[i])
ffffffe000201a54:	00007717          	auipc	a4,0x7
ffffffe000201a58:	5ac70713          	addi	a4,a4,1452 # ffffffe000209000 <early_pgtbl>
ffffffe000201a5c:	fe843783          	ld	a5,-24(s0)
ffffffe000201a60:	00379793          	slli	a5,a5,0x3
ffffffe000201a64:	00f707b3          	add	a5,a4,a5
ffffffe000201a68:	0007b783          	ld	a5,0(a5)
ffffffe000201a6c:	04078463          	beqz	a5,ffffffe000201ab4 <setup_vm+0x160>
            printk("index: %u, pte: %llx, pte: %llu\n", i, early_pgtbl[i], early_pgtbl[i]);
ffffffe000201a70:	00007717          	auipc	a4,0x7
ffffffe000201a74:	59070713          	addi	a4,a4,1424 # ffffffe000209000 <early_pgtbl>
ffffffe000201a78:	fe843783          	ld	a5,-24(s0)
ffffffe000201a7c:	00379793          	slli	a5,a5,0x3
ffffffe000201a80:	00f707b3          	add	a5,a4,a5
ffffffe000201a84:	0007b603          	ld	a2,0(a5)
ffffffe000201a88:	00007717          	auipc	a4,0x7
ffffffe000201a8c:	57870713          	addi	a4,a4,1400 # ffffffe000209000 <early_pgtbl>
ffffffe000201a90:	fe843783          	ld	a5,-24(s0)
ffffffe000201a94:	00379793          	slli	a5,a5,0x3
ffffffe000201a98:	00f707b3          	add	a5,a4,a5
ffffffe000201a9c:	0007b783          	ld	a5,0(a5)
ffffffe000201aa0:	00078693          	mv	a3,a5
ffffffe000201aa4:	fe843583          	ld	a1,-24(s0)
ffffffe000201aa8:	00001517          	auipc	a0,0x1
ffffffe000201aac:	6a050513          	addi	a0,a0,1696 # ffffffe000203148 <_srodata+0x148>
ffffffe000201ab0:	39c010ef          	jal	ffffffe000202e4c <printk>
    for(uint64_t i = 0; i < 512; i++){
ffffffe000201ab4:	fe843783          	ld	a5,-24(s0)
ffffffe000201ab8:	00178793          	addi	a5,a5,1
ffffffe000201abc:	fef43423          	sd	a5,-24(s0)
ffffffe000201ac0:	fe843703          	ld	a4,-24(s0)
ffffffe000201ac4:	1ff00793          	li	a5,511
ffffffe000201ac8:	f8e7f6e3          	bgeu	a5,a4,ffffffe000201a54 <setup_vm+0x100>
    }
    return;
ffffffe000201acc:	00000013          	nop
}
ffffffe000201ad0:	03813083          	ld	ra,56(sp)
ffffffe000201ad4:	03013403          	ld	s0,48(sp)
ffffffe000201ad8:	04010113          	addi	sp,sp,64
ffffffe000201adc:	00008067          	ret

ffffffe000201ae0 <setup_vm_final>:

uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));
extern char _stext[], _etext[], _srodata[], _erodata[], _sdata[], _ebss[];
uint64_t phy_swapper_pg_dir;

void setup_vm_final() {
ffffffe000201ae0:	fa010113          	addi	sp,sp,-96
ffffffe000201ae4:	04113c23          	sd	ra,88(sp)
ffffffe000201ae8:	04813823          	sd	s0,80(sp)
ffffffe000201aec:	06010413          	addi	s0,sp,96
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000201af0:	00001637          	lui	a2,0x1
ffffffe000201af4:	00000593          	li	a1,0
ffffffe000201af8:	00008517          	auipc	a0,0x8
ffffffe000201afc:	50850513          	addi	a0,a0,1288 # ffffffe00020a000 <swapper_pg_dir>
ffffffe000201b00:	47c010ef          	jal	ffffffe000202f7c <memset>

    // No OpenSBI mapping required
    uint64_t stext = (uint64_t)_stext - PA2VA_OFFSET;
ffffffe000201b04:	ffffe717          	auipc	a4,0xffffe
ffffffe000201b08:	4fc70713          	addi	a4,a4,1276 # ffffffe000200000 <_skernel>
ffffffe000201b0c:	04100793          	li	a5,65
ffffffe000201b10:	01f79793          	slli	a5,a5,0x1f
ffffffe000201b14:	00f707b3          	add	a5,a4,a5
ffffffe000201b18:	fef43423          	sd	a5,-24(s0)
    uint64_t etext = (uint64_t)_etext - PA2VA_OFFSET;
ffffffe000201b1c:	00001717          	auipc	a4,0x1
ffffffe000201b20:	4d870713          	addi	a4,a4,1240 # ffffffe000202ff4 <_etext>
ffffffe000201b24:	04100793          	li	a5,65
ffffffe000201b28:	01f79793          	slli	a5,a5,0x1f
ffffffe000201b2c:	00f707b3          	add	a5,a4,a5
ffffffe000201b30:	fef43023          	sd	a5,-32(s0)
    uint64_t srodata = (uint64_t)_srodata - PA2VA_OFFSET;
ffffffe000201b34:	00001717          	auipc	a4,0x1
ffffffe000201b38:	4cc70713          	addi	a4,a4,1228 # ffffffe000203000 <_srodata>
ffffffe000201b3c:	04100793          	li	a5,65
ffffffe000201b40:	01f79793          	slli	a5,a5,0x1f
ffffffe000201b44:	00f707b3          	add	a5,a4,a5
ffffffe000201b48:	fcf43c23          	sd	a5,-40(s0)
    uint64_t erodata = (uint64_t)_erodata - PA2VA_OFFSET;
ffffffe000201b4c:	00001717          	auipc	a4,0x1
ffffffe000201b50:	70470713          	addi	a4,a4,1796 # ffffffe000203250 <_erodata>
ffffffe000201b54:	04100793          	li	a5,65
ffffffe000201b58:	01f79793          	slli	a5,a5,0x1f
ffffffe000201b5c:	00f707b3          	add	a5,a4,a5
ffffffe000201b60:	fcf43823          	sd	a5,-48(s0)
    uint64_t sdata = (uint64_t)_sdata - PA2VA_OFFSET;
ffffffe000201b64:	00002717          	auipc	a4,0x2
ffffffe000201b68:	49c70713          	addi	a4,a4,1180 # ffffffe000204000 <TIMECLOCK>
ffffffe000201b6c:	04100793          	li	a5,65
ffffffe000201b70:	01f79793          	slli	a5,a5,0x1f
ffffffe000201b74:	00f707b3          	add	a5,a4,a5
ffffffe000201b78:	fcf43423          	sd	a5,-56(s0)
    uint64_t ebss = (uint64_t)_ebss - PA2VA_OFFSET;
ffffffe000201b7c:	00009717          	auipc	a4,0x9
ffffffe000201b80:	48470713          	addi	a4,a4,1156 # ffffffe00020b000 <_ebss>
ffffffe000201b84:	04100793          	li	a5,65
ffffffe000201b88:	01f79793          	slli	a5,a5,0x1f
ffffffe000201b8c:	00f707b3          	add	a5,a4,a5
ffffffe000201b90:	fcf43023          	sd	a5,-64(s0)
    // printk("st: %lx\net: %lx\nsrod: %lx\nerod: %lx\nsd: %lx\neb: %lx\n", stext, etext, srodata, erodata, sdata, ebss);

    uint64_t text_size = etext - stext;
ffffffe000201b94:	fe043703          	ld	a4,-32(s0)
ffffffe000201b98:	fe843783          	ld	a5,-24(s0)
ffffffe000201b9c:	40f707b3          	sub	a5,a4,a5
ffffffe000201ba0:	faf43c23          	sd	a5,-72(s0)
    uint64_t rodata_size = erodata - srodata;
ffffffe000201ba4:	fd043703          	ld	a4,-48(s0)
ffffffe000201ba8:	fd843783          	ld	a5,-40(s0)
ffffffe000201bac:	40f707b3          	sub	a5,a4,a5
ffffffe000201bb0:	faf43823          	sd	a5,-80(s0)
    uint64_t remain_size = stext + PHY_SIZE - sdata;
ffffffe000201bb4:	fe843703          	ld	a4,-24(s0)
ffffffe000201bb8:	fc843783          	ld	a5,-56(s0)
ffffffe000201bbc:	40f70733          	sub	a4,a4,a5
ffffffe000201bc0:	080007b7          	lui	a5,0x8000
ffffffe000201bc4:	00f707b3          	add	a5,a4,a5
ffffffe000201bc8:	faf43423          	sd	a5,-88(s0)

    // mapping kernel text X|-|R|V
    phy_swapper_pg_dir = (uint64_t)swapper_pg_dir - PA2VA_OFFSET;
ffffffe000201bcc:	00008717          	auipc	a4,0x8
ffffffe000201bd0:	43470713          	addi	a4,a4,1076 # ffffffe00020a000 <swapper_pg_dir>
ffffffe000201bd4:	04100793          	li	a5,65
ffffffe000201bd8:	01f79793          	slli	a5,a5,0x1f
ffffffe000201bdc:	00f70733          	add	a4,a4,a5
ffffffe000201be0:	00006797          	auipc	a5,0x6
ffffffe000201be4:	43878793          	addi	a5,a5,1080 # ffffffe000208018 <phy_swapper_pg_dir>
ffffffe000201be8:	00e7b023          	sd	a4,0(a5)

    create_mapping(swapper_pg_dir, (uint64_t)_stext, stext, text_size, 0xb);
ffffffe000201bec:	ffffe797          	auipc	a5,0xffffe
ffffffe000201bf0:	41478793          	addi	a5,a5,1044 # ffffffe000200000 <_skernel>
ffffffe000201bf4:	00b00713          	li	a4,11
ffffffe000201bf8:	fb843683          	ld	a3,-72(s0)
ffffffe000201bfc:	fe843603          	ld	a2,-24(s0)
ffffffe000201c00:	00078593          	mv	a1,a5
ffffffe000201c04:	00008517          	auipc	a0,0x8
ffffffe000201c08:	3fc50513          	addi	a0,a0,1020 # ffffffe00020a000 <swapper_pg_dir>
ffffffe000201c0c:	0a8000ef          	jal	ffffffe000201cb4 <create_mapping>
    printk("after first mapping\n");
ffffffe000201c10:	00001517          	auipc	a0,0x1
ffffffe000201c14:	56050513          	addi	a0,a0,1376 # ffffffe000203170 <_srodata+0x170>
ffffffe000201c18:	234010ef          	jal	ffffffe000202e4c <printk>

    // mapping kernel rodata -|-|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_srodata, srodata, rodata_size, 0x3);
ffffffe000201c1c:	00001797          	auipc	a5,0x1
ffffffe000201c20:	3e478793          	addi	a5,a5,996 # ffffffe000203000 <_srodata>
ffffffe000201c24:	00300713          	li	a4,3
ffffffe000201c28:	fb043683          	ld	a3,-80(s0)
ffffffe000201c2c:	fd843603          	ld	a2,-40(s0)
ffffffe000201c30:	00078593          	mv	a1,a5
ffffffe000201c34:	00008517          	auipc	a0,0x8
ffffffe000201c38:	3cc50513          	addi	a0,a0,972 # ffffffe00020a000 <swapper_pg_dir>
ffffffe000201c3c:	078000ef          	jal	ffffffe000201cb4 <create_mapping>
    printk("after second mapping\n");
ffffffe000201c40:	00001517          	auipc	a0,0x1
ffffffe000201c44:	54850513          	addi	a0,a0,1352 # ffffffe000203188 <_srodata+0x188>
ffffffe000201c48:	204010ef          	jal	ffffffe000202e4c <printk>
    // mapping other memory -|W|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_sdata, sdata, remain_size, 0x7);
ffffffe000201c4c:	00002797          	auipc	a5,0x2
ffffffe000201c50:	3b478793          	addi	a5,a5,948 # ffffffe000204000 <TIMECLOCK>
ffffffe000201c54:	00700713          	li	a4,7
ffffffe000201c58:	fa843683          	ld	a3,-88(s0)
ffffffe000201c5c:	fc843603          	ld	a2,-56(s0)
ffffffe000201c60:	00078593          	mv	a1,a5
ffffffe000201c64:	00008517          	auipc	a0,0x8
ffffffe000201c68:	39c50513          	addi	a0,a0,924 # ffffffe00020a000 <swapper_pg_dir>
ffffffe000201c6c:	048000ef          	jal	ffffffe000201cb4 <create_mapping>
    printk("after third mapping\n");
ffffffe000201c70:	00001517          	auipc	a0,0x1
ffffffe000201c74:	53050513          	addi	a0,a0,1328 # ffffffe0002031a0 <_srodata+0x1a0>
ffffffe000201c78:	1d4010ef          	jal	ffffffe000202e4c <printk>

    // set satp with swapper_pg_dir
    asm volatile(".extern phy_swapper_pg_dir");
    asm volatile("la a1, phy_swapper_pg_dir");
ffffffe000201c7c:	00006597          	auipc	a1,0x6
ffffffe000201c80:	39c58593          	addi	a1,a1,924 # ffffffe000208018 <phy_swapper_pg_dir>
    asm volatile("ld a0, 0(a1)");
ffffffe000201c84:	0005b503          	ld	a0,0(a1)
    asm volatile("srli a0, a0, 12");
ffffffe000201c88:	00c55513          	srli	a0,a0,0xc
    asm volatile("li a1, 0x8000000000000000");
ffffffe000201c8c:	fff0059b          	addiw	a1,zero,-1
ffffffe000201c90:	03f59593          	slli	a1,a1,0x3f
    asm volatile("or a0, a0, a1");
ffffffe000201c94:	00b56533          	or	a0,a0,a1
    asm volatile("csrw satp, a0");
ffffffe000201c98:	18051073          	csrw	satp,a0

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000201c9c:	12000073          	sfence.vma

    // // flush icache
    // asm volatile("fence.i");
    return;
ffffffe000201ca0:	00000013          	nop
}
ffffffe000201ca4:	05813083          	ld	ra,88(sp)
ffffffe000201ca8:	05013403          	ld	s0,80(sp)
ffffffe000201cac:	06010113          	addi	sp,sp,96
ffffffe000201cb0:	00008067          	ret

ffffffe000201cb4 <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000201cb4:	f7010113          	addi	sp,sp,-144
ffffffe000201cb8:	08113423          	sd	ra,136(sp)
ffffffe000201cbc:	08813023          	sd	s0,128(sp)
ffffffe000201cc0:	09010413          	addi	s0,sp,144
ffffffe000201cc4:	f8a43c23          	sd	a0,-104(s0)
ffffffe000201cc8:	f8b43823          	sd	a1,-112(s0)
ffffffe000201ccc:	f8c43423          	sd	a2,-120(s0)
ffffffe000201cd0:	f8d43023          	sd	a3,-128(s0)
ffffffe000201cd4:	f6e43c23          	sd	a4,-136(s0)
    **/
    uint16_t vpn2, vpn1, vpn0;
    uint64_t addr, vaddr;
    uint64_t pte;
    uint64_t *tmptbl, *p_pte;
    for(uint64_t addr_offset = 0; addr_offset < sz; addr_offset += PGSIZE){
ffffffe000201cd8:	fe043023          	sd	zero,-32(s0)
ffffffe000201cdc:	1cc0006f          	j	ffffffe000201ea8 <create_mapping+0x1f4>
        addr = pa + addr_offset;
ffffffe000201ce0:	f8843703          	ld	a4,-120(s0)
ffffffe000201ce4:	fe043783          	ld	a5,-32(s0)
ffffffe000201ce8:	00f707b3          	add	a5,a4,a5
ffffffe000201cec:	fcf43c23          	sd	a5,-40(s0)
        vaddr = va + addr_offset;
ffffffe000201cf0:	f9043703          	ld	a4,-112(s0)
ffffffe000201cf4:	fe043783          	ld	a5,-32(s0)
ffffffe000201cf8:	00f707b3          	add	a5,a4,a5
ffffffe000201cfc:	fcf43823          	sd	a5,-48(s0)
        // printk("addr: %lx, vaddr: %lx\n", addr, vaddr);
        tmptbl = pgtbl;
ffffffe000201d00:	f9843783          	ld	a5,-104(s0)
ffffffe000201d04:	fef43423          	sd	a5,-24(s0)
        vpn2 = (vaddr >> 30) & 0x1ff;
ffffffe000201d08:	fd043783          	ld	a5,-48(s0)
ffffffe000201d0c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000201d10:	03079793          	slli	a5,a5,0x30
ffffffe000201d14:	0307d793          	srli	a5,a5,0x30
ffffffe000201d18:	1ff7f793          	andi	a5,a5,511
ffffffe000201d1c:	fcf41723          	sh	a5,-50(s0)
        vpn1 = (vaddr >> 21) & 0x1ff;
ffffffe000201d20:	fd043783          	ld	a5,-48(s0)
ffffffe000201d24:	0157d793          	srli	a5,a5,0x15
ffffffe000201d28:	03079793          	slli	a5,a5,0x30
ffffffe000201d2c:	0307d793          	srli	a5,a5,0x30
ffffffe000201d30:	1ff7f793          	andi	a5,a5,511
ffffffe000201d34:	fcf41623          	sh	a5,-52(s0)
        vpn0 = (vaddr >> 12) & 0x1ff;
ffffffe000201d38:	fd043783          	ld	a5,-48(s0)
ffffffe000201d3c:	00c7d793          	srli	a5,a5,0xc
ffffffe000201d40:	03079793          	slli	a5,a5,0x30
ffffffe000201d44:	0307d793          	srli	a5,a5,0x30
ffffffe000201d48:	1ff7f793          	andi	a5,a5,511
ffffffe000201d4c:	fcf41523          	sh	a5,-54(s0)
        // printk("vpn2: %d, vpn1: %d, vpn0: %d\n", vpn2, vpn1, vpn0);
        p_pte = tmptbl + vpn2;
ffffffe000201d50:	fce45783          	lhu	a5,-50(s0)
ffffffe000201d54:	00379793          	slli	a5,a5,0x3
ffffffe000201d58:	fe843703          	ld	a4,-24(s0)
ffffffe000201d5c:	00f707b3          	add	a5,a4,a5
ffffffe000201d60:	fcf43023          	sd	a5,-64(s0)
        pte = tmptbl[vpn2];
ffffffe000201d64:	fce45783          	lhu	a5,-50(s0)
ffffffe000201d68:	00379793          	slli	a5,a5,0x3
ffffffe000201d6c:	fe843703          	ld	a4,-24(s0)
ffffffe000201d70:	00f707b3          	add	a5,a4,a5
ffffffe000201d74:	0007b783          	ld	a5,0(a5)
ffffffe000201d78:	faf43c23          	sd	a5,-72(s0)
        // printk("tpmtbl: %lx, p_pte: %lx, pte: %lx\n", tmptbl, p_pte, pte);
        if(pte & 0x1){
ffffffe000201d7c:	fb843783          	ld	a5,-72(s0)
ffffffe000201d80:	0017f793          	andi	a5,a5,1
ffffffe000201d84:	02078263          	beqz	a5,ffffffe000201da8 <create_mapping+0xf4>
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
ffffffe000201d88:	fb843783          	ld	a5,-72(s0)
ffffffe000201d8c:	00a7d793          	srli	a5,a5,0xa
ffffffe000201d90:	00c79713          	slli	a4,a5,0xc
ffffffe000201d94:	fbf00793          	li	a5,-65
ffffffe000201d98:	01f79793          	slli	a5,a5,0x1f
ffffffe000201d9c:	00f707b3          	add	a5,a4,a5
ffffffe000201da0:	fef43423          	sd	a5,-24(s0)
ffffffe000201da4:	0380006f          	j	ffffffe000201ddc <create_mapping+0x128>
        } else {
            tmptbl = (uint64_t*)alloc_page();
ffffffe000201da8:	bf5fe0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000201dac:	fea43423          	sd	a0,-24(s0)
            // printk("kalloc: %lx\n", tmptbl);
            uint64_t* phy_tmptbl = (uint64_t*)((uint64_t)tmptbl - PA2VA_OFFSET);
ffffffe000201db0:	fe843703          	ld	a4,-24(s0)
ffffffe000201db4:	04100793          	li	a5,65
ffffffe000201db8:	01f79793          	slli	a5,a5,0x1f
ffffffe000201dbc:	00f707b3          	add	a5,a4,a5
ffffffe000201dc0:	faf43823          	sd	a5,-80(s0)
            *p_pte = (((uint64_t)phy_tmptbl >> 12) << 10) | 0x1;
ffffffe000201dc4:	fb043783          	ld	a5,-80(s0)
ffffffe000201dc8:	00c7d793          	srli	a5,a5,0xc
ffffffe000201dcc:	00a79793          	slli	a5,a5,0xa
ffffffe000201dd0:	0017e713          	ori	a4,a5,1
ffffffe000201dd4:	fc043783          	ld	a5,-64(s0)
ffffffe000201dd8:	00e7b023          	sd	a4,0(a5)
            // printk("new pte: %lx\n", *p_pte);
        }
        p_pte = tmptbl + vpn1;
ffffffe000201ddc:	fcc45783          	lhu	a5,-52(s0)
ffffffe000201de0:	00379793          	slli	a5,a5,0x3
ffffffe000201de4:	fe843703          	ld	a4,-24(s0)
ffffffe000201de8:	00f707b3          	add	a5,a4,a5
ffffffe000201dec:	fcf43023          	sd	a5,-64(s0)
        pte = tmptbl[vpn1];
ffffffe000201df0:	fcc45783          	lhu	a5,-52(s0)
ffffffe000201df4:	00379793          	slli	a5,a5,0x3
ffffffe000201df8:	fe843703          	ld	a4,-24(s0)
ffffffe000201dfc:	00f707b3          	add	a5,a4,a5
ffffffe000201e00:	0007b783          	ld	a5,0(a5)
ffffffe000201e04:	faf43c23          	sd	a5,-72(s0)
        // printk("tpmtbl: %lx, p_pte: %lx, pte: %lx\n", tmptbl, p_pte, pte);
        if(pte & 0x1){
ffffffe000201e08:	fb843783          	ld	a5,-72(s0)
ffffffe000201e0c:	0017f793          	andi	a5,a5,1
ffffffe000201e10:	02078263          	beqz	a5,ffffffe000201e34 <create_mapping+0x180>
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
ffffffe000201e14:	fb843783          	ld	a5,-72(s0)
ffffffe000201e18:	00a7d793          	srli	a5,a5,0xa
ffffffe000201e1c:	00c79713          	slli	a4,a5,0xc
ffffffe000201e20:	fbf00793          	li	a5,-65
ffffffe000201e24:	01f79793          	slli	a5,a5,0x1f
ffffffe000201e28:	00f707b3          	add	a5,a4,a5
ffffffe000201e2c:	fef43423          	sd	a5,-24(s0)
ffffffe000201e30:	0380006f          	j	ffffffe000201e68 <create_mapping+0x1b4>
        } else {
            tmptbl = (uint64_t*)alloc_page();
ffffffe000201e34:	b69fe0ef          	jal	ffffffe00020099c <alloc_page>
ffffffe000201e38:	fea43423          	sd	a0,-24(s0)
            // printk("kalloc: %lx\n", tmptbl);
            uint64_t* phy_tmptbl = (uint64_t*)((uint64_t)tmptbl - PA2VA_OFFSET);
ffffffe000201e3c:	fe843703          	ld	a4,-24(s0)
ffffffe000201e40:	04100793          	li	a5,65
ffffffe000201e44:	01f79793          	slli	a5,a5,0x1f
ffffffe000201e48:	00f707b3          	add	a5,a4,a5
ffffffe000201e4c:	faf43423          	sd	a5,-88(s0)
            *p_pte = (((uint64_t)phy_tmptbl >> 12) << 10) | 0x1;
ffffffe000201e50:	fa843783          	ld	a5,-88(s0)
ffffffe000201e54:	00c7d793          	srli	a5,a5,0xc
ffffffe000201e58:	00a79793          	slli	a5,a5,0xa
ffffffe000201e5c:	0017e713          	ori	a4,a5,1
ffffffe000201e60:	fc043783          	ld	a5,-64(s0)
ffffffe000201e64:	00e7b023          	sd	a4,0(a5)
            // printk("new pte: %lx\n", *p_pte);
        }
        p_pte = tmptbl + vpn0;
ffffffe000201e68:	fca45783          	lhu	a5,-54(s0)
ffffffe000201e6c:	00379793          	slli	a5,a5,0x3
ffffffe000201e70:	fe843703          	ld	a4,-24(s0)
ffffffe000201e74:	00f707b3          	add	a5,a4,a5
ffffffe000201e78:	fcf43023          	sd	a5,-64(s0)
        *p_pte = ((addr >> 12) << 10) | perm;
ffffffe000201e7c:	fd843783          	ld	a5,-40(s0)
ffffffe000201e80:	00c7d793          	srli	a5,a5,0xc
ffffffe000201e84:	00a79713          	slli	a4,a5,0xa
ffffffe000201e88:	f7843783          	ld	a5,-136(s0)
ffffffe000201e8c:	00f76733          	or	a4,a4,a5
ffffffe000201e90:	fc043783          	ld	a5,-64(s0)
ffffffe000201e94:	00e7b023          	sd	a4,0(a5)
    for(uint64_t addr_offset = 0; addr_offset < sz; addr_offset += PGSIZE){
ffffffe000201e98:	fe043703          	ld	a4,-32(s0)
ffffffe000201e9c:	000017b7          	lui	a5,0x1
ffffffe000201ea0:	00f707b3          	add	a5,a4,a5
ffffffe000201ea4:	fef43023          	sd	a5,-32(s0)
ffffffe000201ea8:	fe043703          	ld	a4,-32(s0)
ffffffe000201eac:	f8043783          	ld	a5,-128(s0)
ffffffe000201eb0:	e2f768e3          	bltu	a4,a5,ffffffe000201ce0 <create_mapping+0x2c>
        // printk("tmptbl: %lx, p_pte: %lx, pte: %lx\n", tmptbl, p_pte, *p_pte);
    }
    
}
ffffffe000201eb4:	00000013          	nop
ffffffe000201eb8:	00000013          	nop
ffffffe000201ebc:	08813083          	ld	ra,136(sp)
ffffffe000201ec0:	08013403          	ld	s0,128(sp)
ffffffe000201ec4:	09010113          	addi	sp,sp,144
ffffffe000201ec8:	00008067          	ret

ffffffe000201ecc <start_kernel>:
#include "printk.h"

extern void test();
extern void schedule();

int start_kernel() {
ffffffe000201ecc:	ff010113          	addi	sp,sp,-16
ffffffe000201ed0:	00113423          	sd	ra,8(sp)
ffffffe000201ed4:	00813023          	sd	s0,0(sp)
ffffffe000201ed8:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe000201edc:	00001517          	auipc	a0,0x1
ffffffe000201ee0:	2dc50513          	addi	a0,a0,732 # ffffffe0002031b8 <_srodata+0x1b8>
ffffffe000201ee4:	769000ef          	jal	ffffffe000202e4c <printk>
    printk(" ZJU Operating System\n");
ffffffe000201ee8:	00001517          	auipc	a0,0x1
ffffffe000201eec:	2d850513          	addi	a0,a0,728 # ffffffe0002031c0 <_srodata+0x1c0>
ffffffe000201ef0:	75d000ef          	jal	ffffffe000202e4c <printk>
    schedule();
ffffffe000201ef4:	c84ff0ef          	jal	ffffffe000201378 <schedule>
    test();
ffffffe000201ef8:	01c000ef          	jal	ffffffe000201f14 <test>
    return 0;
ffffffe000201efc:	00000793          	li	a5,0
}
ffffffe000201f00:	00078513          	mv	a0,a5
ffffffe000201f04:	00813083          	ld	ra,8(sp)
ffffffe000201f08:	00013403          	ld	s0,0(sp)
ffffffe000201f0c:	01010113          	addi	sp,sp,16
ffffffe000201f10:	00008067          	ret

ffffffe000201f14 <test>:
#include "sbi.h"
#include "printk.h"

void test() {
ffffffe000201f14:	fe010113          	addi	sp,sp,-32
ffffffe000201f18:	00113c23          	sd	ra,24(sp)
ffffffe000201f1c:	00813823          	sd	s0,16(sp)
ffffffe000201f20:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe000201f24:	fe042623          	sw	zero,-20(s0)
    while (1) {
        if ((++i) % 100000000 == 0) {
ffffffe000201f28:	fec42783          	lw	a5,-20(s0)
ffffffe000201f2c:	0017879b          	addiw	a5,a5,1 # 1001 <PGSIZE+0x1>
ffffffe000201f30:	fef42623          	sw	a5,-20(s0)
ffffffe000201f34:	fec42783          	lw	a5,-20(s0)
ffffffe000201f38:	0007869b          	sext.w	a3,a5
ffffffe000201f3c:	55e64737          	lui	a4,0x55e64
ffffffe000201f40:	b8970713          	addi	a4,a4,-1143 # 55e63b89 <PHY_SIZE+0x4de63b89>
ffffffe000201f44:	02e68733          	mul	a4,a3,a4
ffffffe000201f48:	02075713          	srli	a4,a4,0x20
ffffffe000201f4c:	4197571b          	sraiw	a4,a4,0x19
ffffffe000201f50:	00070693          	mv	a3,a4
ffffffe000201f54:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffe000201f58:	40e6873b          	subw	a4,a3,a4
ffffffe000201f5c:	00070693          	mv	a3,a4
ffffffe000201f60:	05f5e737          	lui	a4,0x5f5e
ffffffe000201f64:	1007071b          	addiw	a4,a4,256 # 5f5e100 <OPENSBI_SIZE+0x5d5e100>
ffffffe000201f68:	02e6873b          	mulw	a4,a3,a4
ffffffe000201f6c:	40e787bb          	subw	a5,a5,a4
ffffffe000201f70:	0007879b          	sext.w	a5,a5
ffffffe000201f74:	fa079ae3          	bnez	a5,ffffffe000201f28 <test+0x14>
            printk("kernel is running!\n");
ffffffe000201f78:	00001517          	auipc	a0,0x1
ffffffe000201f7c:	26050513          	addi	a0,a0,608 # ffffffe0002031d8 <_srodata+0x1d8>
ffffffe000201f80:	6cd000ef          	jal	ffffffe000202e4c <printk>
            i = 0;
ffffffe000201f84:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0) {
ffffffe000201f88:	fa1ff06f          	j	ffffffe000201f28 <test+0x14>

ffffffe000201f8c <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe000201f8c:	fe010113          	addi	sp,sp,-32
ffffffe000201f90:	00113c23          	sd	ra,24(sp)
ffffffe000201f94:	00813823          	sd	s0,16(sp)
ffffffe000201f98:	02010413          	addi	s0,sp,32
ffffffe000201f9c:	00050793          	mv	a5,a0
ffffffe000201fa0:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe000201fa4:	fec42783          	lw	a5,-20(s0)
ffffffe000201fa8:	0ff7f793          	zext.b	a5,a5
ffffffe000201fac:	00078513          	mv	a0,a5
ffffffe000201fb0:	ebcff0ef          	jal	ffffffe00020166c <sbi_debug_console_write_byte>
    return (char)c;
ffffffe000201fb4:	fec42783          	lw	a5,-20(s0)
ffffffe000201fb8:	0ff7f793          	zext.b	a5,a5
ffffffe000201fbc:	0007879b          	sext.w	a5,a5
}
ffffffe000201fc0:	00078513          	mv	a0,a5
ffffffe000201fc4:	01813083          	ld	ra,24(sp)
ffffffe000201fc8:	01013403          	ld	s0,16(sp)
ffffffe000201fcc:	02010113          	addi	sp,sp,32
ffffffe000201fd0:	00008067          	ret

ffffffe000201fd4 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe000201fd4:	fe010113          	addi	sp,sp,-32
ffffffe000201fd8:	00113c23          	sd	ra,24(sp)
ffffffe000201fdc:	00813823          	sd	s0,16(sp)
ffffffe000201fe0:	02010413          	addi	s0,sp,32
ffffffe000201fe4:	00050793          	mv	a5,a0
ffffffe000201fe8:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe000201fec:	fec42783          	lw	a5,-20(s0)
ffffffe000201ff0:	0007871b          	sext.w	a4,a5
ffffffe000201ff4:	02000793          	li	a5,32
ffffffe000201ff8:	02f70263          	beq	a4,a5,ffffffe00020201c <isspace+0x48>
ffffffe000201ffc:	fec42783          	lw	a5,-20(s0)
ffffffe000202000:	0007871b          	sext.w	a4,a5
ffffffe000202004:	00800793          	li	a5,8
ffffffe000202008:	00e7de63          	bge	a5,a4,ffffffe000202024 <isspace+0x50>
ffffffe00020200c:	fec42783          	lw	a5,-20(s0)
ffffffe000202010:	0007871b          	sext.w	a4,a5
ffffffe000202014:	00d00793          	li	a5,13
ffffffe000202018:	00e7c663          	blt	a5,a4,ffffffe000202024 <isspace+0x50>
ffffffe00020201c:	00100793          	li	a5,1
ffffffe000202020:	0080006f          	j	ffffffe000202028 <isspace+0x54>
ffffffe000202024:	00000793          	li	a5,0
}
ffffffe000202028:	00078513          	mv	a0,a5
ffffffe00020202c:	01813083          	ld	ra,24(sp)
ffffffe000202030:	01013403          	ld	s0,16(sp)
ffffffe000202034:	02010113          	addi	sp,sp,32
ffffffe000202038:	00008067          	ret

ffffffe00020203c <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe00020203c:	fb010113          	addi	sp,sp,-80
ffffffe000202040:	04113423          	sd	ra,72(sp)
ffffffe000202044:	04813023          	sd	s0,64(sp)
ffffffe000202048:	05010413          	addi	s0,sp,80
ffffffe00020204c:	fca43423          	sd	a0,-56(s0)
ffffffe000202050:	fcb43023          	sd	a1,-64(s0)
ffffffe000202054:	00060793          	mv	a5,a2
ffffffe000202058:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe00020205c:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000202060:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe000202064:	fc843783          	ld	a5,-56(s0)
ffffffe000202068:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe00020206c:	0100006f          	j	ffffffe00020207c <strtol+0x40>
        p++;
ffffffe000202070:	fd843783          	ld	a5,-40(s0)
ffffffe000202074:	00178793          	addi	a5,a5,1
ffffffe000202078:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe00020207c:	fd843783          	ld	a5,-40(s0)
ffffffe000202080:	0007c783          	lbu	a5,0(a5)
ffffffe000202084:	0007879b          	sext.w	a5,a5
ffffffe000202088:	00078513          	mv	a0,a5
ffffffe00020208c:	f49ff0ef          	jal	ffffffe000201fd4 <isspace>
ffffffe000202090:	00050793          	mv	a5,a0
ffffffe000202094:	fc079ee3          	bnez	a5,ffffffe000202070 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe000202098:	fd843783          	ld	a5,-40(s0)
ffffffe00020209c:	0007c783          	lbu	a5,0(a5)
ffffffe0002020a0:	00078713          	mv	a4,a5
ffffffe0002020a4:	02d00793          	li	a5,45
ffffffe0002020a8:	00f71e63          	bne	a4,a5,ffffffe0002020c4 <strtol+0x88>
        neg = true;
ffffffe0002020ac:	00100793          	li	a5,1
ffffffe0002020b0:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe0002020b4:	fd843783          	ld	a5,-40(s0)
ffffffe0002020b8:	00178793          	addi	a5,a5,1
ffffffe0002020bc:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002020c0:	0240006f          	j	ffffffe0002020e4 <strtol+0xa8>
    } else if (*p == '+') {
ffffffe0002020c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002020c8:	0007c783          	lbu	a5,0(a5)
ffffffe0002020cc:	00078713          	mv	a4,a5
ffffffe0002020d0:	02b00793          	li	a5,43
ffffffe0002020d4:	00f71863          	bne	a4,a5,ffffffe0002020e4 <strtol+0xa8>
        p++;
ffffffe0002020d8:	fd843783          	ld	a5,-40(s0)
ffffffe0002020dc:	00178793          	addi	a5,a5,1
ffffffe0002020e0:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe0002020e4:	fbc42783          	lw	a5,-68(s0)
ffffffe0002020e8:	0007879b          	sext.w	a5,a5
ffffffe0002020ec:	06079c63          	bnez	a5,ffffffe000202164 <strtol+0x128>
        if (*p == '0') {
ffffffe0002020f0:	fd843783          	ld	a5,-40(s0)
ffffffe0002020f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002020f8:	00078713          	mv	a4,a5
ffffffe0002020fc:	03000793          	li	a5,48
ffffffe000202100:	04f71e63          	bne	a4,a5,ffffffe00020215c <strtol+0x120>
            p++;
ffffffe000202104:	fd843783          	ld	a5,-40(s0)
ffffffe000202108:	00178793          	addi	a5,a5,1
ffffffe00020210c:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000202110:	fd843783          	ld	a5,-40(s0)
ffffffe000202114:	0007c783          	lbu	a5,0(a5)
ffffffe000202118:	00078713          	mv	a4,a5
ffffffe00020211c:	07800793          	li	a5,120
ffffffe000202120:	00f70c63          	beq	a4,a5,ffffffe000202138 <strtol+0xfc>
ffffffe000202124:	fd843783          	ld	a5,-40(s0)
ffffffe000202128:	0007c783          	lbu	a5,0(a5)
ffffffe00020212c:	00078713          	mv	a4,a5
ffffffe000202130:	05800793          	li	a5,88
ffffffe000202134:	00f71e63          	bne	a4,a5,ffffffe000202150 <strtol+0x114>
                base = 16;
ffffffe000202138:	01000793          	li	a5,16
ffffffe00020213c:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000202140:	fd843783          	ld	a5,-40(s0)
ffffffe000202144:	00178793          	addi	a5,a5,1
ffffffe000202148:	fcf43c23          	sd	a5,-40(s0)
ffffffe00020214c:	0180006f          	j	ffffffe000202164 <strtol+0x128>
            } else {
                base = 8;
ffffffe000202150:	00800793          	li	a5,8
ffffffe000202154:	faf42e23          	sw	a5,-68(s0)
ffffffe000202158:	00c0006f          	j	ffffffe000202164 <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe00020215c:	00a00793          	li	a5,10
ffffffe000202160:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe000202164:	fd843783          	ld	a5,-40(s0)
ffffffe000202168:	0007c783          	lbu	a5,0(a5)
ffffffe00020216c:	00078713          	mv	a4,a5
ffffffe000202170:	02f00793          	li	a5,47
ffffffe000202174:	02e7f863          	bgeu	a5,a4,ffffffe0002021a4 <strtol+0x168>
ffffffe000202178:	fd843783          	ld	a5,-40(s0)
ffffffe00020217c:	0007c783          	lbu	a5,0(a5)
ffffffe000202180:	00078713          	mv	a4,a5
ffffffe000202184:	03900793          	li	a5,57
ffffffe000202188:	00e7ee63          	bltu	a5,a4,ffffffe0002021a4 <strtol+0x168>
            digit = *p - '0';
ffffffe00020218c:	fd843783          	ld	a5,-40(s0)
ffffffe000202190:	0007c783          	lbu	a5,0(a5)
ffffffe000202194:	0007879b          	sext.w	a5,a5
ffffffe000202198:	fd07879b          	addiw	a5,a5,-48
ffffffe00020219c:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002021a0:	0800006f          	j	ffffffe000202220 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe0002021a4:	fd843783          	ld	a5,-40(s0)
ffffffe0002021a8:	0007c783          	lbu	a5,0(a5)
ffffffe0002021ac:	00078713          	mv	a4,a5
ffffffe0002021b0:	06000793          	li	a5,96
ffffffe0002021b4:	02e7f863          	bgeu	a5,a4,ffffffe0002021e4 <strtol+0x1a8>
ffffffe0002021b8:	fd843783          	ld	a5,-40(s0)
ffffffe0002021bc:	0007c783          	lbu	a5,0(a5)
ffffffe0002021c0:	00078713          	mv	a4,a5
ffffffe0002021c4:	07a00793          	li	a5,122
ffffffe0002021c8:	00e7ee63          	bltu	a5,a4,ffffffe0002021e4 <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe0002021cc:	fd843783          	ld	a5,-40(s0)
ffffffe0002021d0:	0007c783          	lbu	a5,0(a5)
ffffffe0002021d4:	0007879b          	sext.w	a5,a5
ffffffe0002021d8:	fa97879b          	addiw	a5,a5,-87
ffffffe0002021dc:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002021e0:	0400006f          	j	ffffffe000202220 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe0002021e4:	fd843783          	ld	a5,-40(s0)
ffffffe0002021e8:	0007c783          	lbu	a5,0(a5)
ffffffe0002021ec:	00078713          	mv	a4,a5
ffffffe0002021f0:	04000793          	li	a5,64
ffffffe0002021f4:	06e7f863          	bgeu	a5,a4,ffffffe000202264 <strtol+0x228>
ffffffe0002021f8:	fd843783          	ld	a5,-40(s0)
ffffffe0002021fc:	0007c783          	lbu	a5,0(a5)
ffffffe000202200:	00078713          	mv	a4,a5
ffffffe000202204:	05a00793          	li	a5,90
ffffffe000202208:	04e7ee63          	bltu	a5,a4,ffffffe000202264 <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe00020220c:	fd843783          	ld	a5,-40(s0)
ffffffe000202210:	0007c783          	lbu	a5,0(a5)
ffffffe000202214:	0007879b          	sext.w	a5,a5
ffffffe000202218:	fc97879b          	addiw	a5,a5,-55
ffffffe00020221c:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000202220:	fd442783          	lw	a5,-44(s0)
ffffffe000202224:	00078713          	mv	a4,a5
ffffffe000202228:	fbc42783          	lw	a5,-68(s0)
ffffffe00020222c:	0007071b          	sext.w	a4,a4
ffffffe000202230:	0007879b          	sext.w	a5,a5
ffffffe000202234:	02f75663          	bge	a4,a5,ffffffe000202260 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000202238:	fbc42703          	lw	a4,-68(s0)
ffffffe00020223c:	fe843783          	ld	a5,-24(s0)
ffffffe000202240:	02f70733          	mul	a4,a4,a5
ffffffe000202244:	fd442783          	lw	a5,-44(s0)
ffffffe000202248:	00f707b3          	add	a5,a4,a5
ffffffe00020224c:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000202250:	fd843783          	ld	a5,-40(s0)
ffffffe000202254:	00178793          	addi	a5,a5,1
ffffffe000202258:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe00020225c:	f09ff06f          	j	ffffffe000202164 <strtol+0x128>
            break;
ffffffe000202260:	00000013          	nop
    }

    if (endptr) {
ffffffe000202264:	fc043783          	ld	a5,-64(s0)
ffffffe000202268:	00078863          	beqz	a5,ffffffe000202278 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe00020226c:	fc043783          	ld	a5,-64(s0)
ffffffe000202270:	fd843703          	ld	a4,-40(s0)
ffffffe000202274:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe000202278:	fe744783          	lbu	a5,-25(s0)
ffffffe00020227c:	0ff7f793          	zext.b	a5,a5
ffffffe000202280:	00078863          	beqz	a5,ffffffe000202290 <strtol+0x254>
ffffffe000202284:	fe843783          	ld	a5,-24(s0)
ffffffe000202288:	40f007b3          	neg	a5,a5
ffffffe00020228c:	0080006f          	j	ffffffe000202294 <strtol+0x258>
ffffffe000202290:	fe843783          	ld	a5,-24(s0)
}
ffffffe000202294:	00078513          	mv	a0,a5
ffffffe000202298:	04813083          	ld	ra,72(sp)
ffffffe00020229c:	04013403          	ld	s0,64(sp)
ffffffe0002022a0:	05010113          	addi	sp,sp,80
ffffffe0002022a4:	00008067          	ret

ffffffe0002022a8 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe0002022a8:	fd010113          	addi	sp,sp,-48
ffffffe0002022ac:	02113423          	sd	ra,40(sp)
ffffffe0002022b0:	02813023          	sd	s0,32(sp)
ffffffe0002022b4:	03010413          	addi	s0,sp,48
ffffffe0002022b8:	fca43c23          	sd	a0,-40(s0)
ffffffe0002022bc:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe0002022c0:	fd043783          	ld	a5,-48(s0)
ffffffe0002022c4:	00079863          	bnez	a5,ffffffe0002022d4 <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe0002022c8:	00001797          	auipc	a5,0x1
ffffffe0002022cc:	f2878793          	addi	a5,a5,-216 # ffffffe0002031f0 <_srodata+0x1f0>
ffffffe0002022d0:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe0002022d4:	fd043783          	ld	a5,-48(s0)
ffffffe0002022d8:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe0002022dc:	0240006f          	j	ffffffe000202300 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe0002022e0:	fe843783          	ld	a5,-24(s0)
ffffffe0002022e4:	00178713          	addi	a4,a5,1
ffffffe0002022e8:	fee43423          	sd	a4,-24(s0)
ffffffe0002022ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002022f0:	0007871b          	sext.w	a4,a5
ffffffe0002022f4:	fd843783          	ld	a5,-40(s0)
ffffffe0002022f8:	00070513          	mv	a0,a4
ffffffe0002022fc:	000780e7          	jalr	a5
    while (*p) {
ffffffe000202300:	fe843783          	ld	a5,-24(s0)
ffffffe000202304:	0007c783          	lbu	a5,0(a5)
ffffffe000202308:	fc079ce3          	bnez	a5,ffffffe0002022e0 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe00020230c:	fe843703          	ld	a4,-24(s0)
ffffffe000202310:	fd043783          	ld	a5,-48(s0)
ffffffe000202314:	40f707b3          	sub	a5,a4,a5
ffffffe000202318:	0007879b          	sext.w	a5,a5
}
ffffffe00020231c:	00078513          	mv	a0,a5
ffffffe000202320:	02813083          	ld	ra,40(sp)
ffffffe000202324:	02013403          	ld	s0,32(sp)
ffffffe000202328:	03010113          	addi	sp,sp,48
ffffffe00020232c:	00008067          	ret

ffffffe000202330 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000202330:	f9010113          	addi	sp,sp,-112
ffffffe000202334:	06113423          	sd	ra,104(sp)
ffffffe000202338:	06813023          	sd	s0,96(sp)
ffffffe00020233c:	07010413          	addi	s0,sp,112
ffffffe000202340:	faa43423          	sd	a0,-88(s0)
ffffffe000202344:	fab43023          	sd	a1,-96(s0)
ffffffe000202348:	00060793          	mv	a5,a2
ffffffe00020234c:	f8d43823          	sd	a3,-112(s0)
ffffffe000202350:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe000202354:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202358:	0ff7f793          	zext.b	a5,a5
ffffffe00020235c:	02078663          	beqz	a5,ffffffe000202388 <print_dec_int+0x58>
ffffffe000202360:	fa043703          	ld	a4,-96(s0)
ffffffe000202364:	fff00793          	li	a5,-1
ffffffe000202368:	03f79793          	slli	a5,a5,0x3f
ffffffe00020236c:	00f71e63          	bne	a4,a5,ffffffe000202388 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000202370:	00001597          	auipc	a1,0x1
ffffffe000202374:	e8858593          	addi	a1,a1,-376 # ffffffe0002031f8 <_srodata+0x1f8>
ffffffe000202378:	fa843503          	ld	a0,-88(s0)
ffffffe00020237c:	f2dff0ef          	jal	ffffffe0002022a8 <puts_wo_nl>
ffffffe000202380:	00050793          	mv	a5,a0
ffffffe000202384:	2c80006f          	j	ffffffe00020264c <print_dec_int+0x31c>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe000202388:	f9043783          	ld	a5,-112(s0)
ffffffe00020238c:	00c7a783          	lw	a5,12(a5)
ffffffe000202390:	00079a63          	bnez	a5,ffffffe0002023a4 <print_dec_int+0x74>
ffffffe000202394:	fa043783          	ld	a5,-96(s0)
ffffffe000202398:	00079663          	bnez	a5,ffffffe0002023a4 <print_dec_int+0x74>
        return 0;
ffffffe00020239c:	00000793          	li	a5,0
ffffffe0002023a0:	2ac0006f          	j	ffffffe00020264c <print_dec_int+0x31c>
    }

    bool neg = false;
ffffffe0002023a4:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe0002023a8:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002023ac:	0ff7f793          	zext.b	a5,a5
ffffffe0002023b0:	02078063          	beqz	a5,ffffffe0002023d0 <print_dec_int+0xa0>
ffffffe0002023b4:	fa043783          	ld	a5,-96(s0)
ffffffe0002023b8:	0007dc63          	bgez	a5,ffffffe0002023d0 <print_dec_int+0xa0>
        neg = true;
ffffffe0002023bc:	00100793          	li	a5,1
ffffffe0002023c0:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe0002023c4:	fa043783          	ld	a5,-96(s0)
ffffffe0002023c8:	40f007b3          	neg	a5,a5
ffffffe0002023cc:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe0002023d0:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe0002023d4:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002023d8:	0ff7f793          	zext.b	a5,a5
ffffffe0002023dc:	02078863          	beqz	a5,ffffffe00020240c <print_dec_int+0xdc>
ffffffe0002023e0:	fef44783          	lbu	a5,-17(s0)
ffffffe0002023e4:	0ff7f793          	zext.b	a5,a5
ffffffe0002023e8:	00079e63          	bnez	a5,ffffffe000202404 <print_dec_int+0xd4>
ffffffe0002023ec:	f9043783          	ld	a5,-112(s0)
ffffffe0002023f0:	0057c783          	lbu	a5,5(a5)
ffffffe0002023f4:	00079863          	bnez	a5,ffffffe000202404 <print_dec_int+0xd4>
ffffffe0002023f8:	f9043783          	ld	a5,-112(s0)
ffffffe0002023fc:	0047c783          	lbu	a5,4(a5)
ffffffe000202400:	00078663          	beqz	a5,ffffffe00020240c <print_dec_int+0xdc>
ffffffe000202404:	00100793          	li	a5,1
ffffffe000202408:	0080006f          	j	ffffffe000202410 <print_dec_int+0xe0>
ffffffe00020240c:	00000793          	li	a5,0
ffffffe000202410:	fcf40ba3          	sb	a5,-41(s0)
ffffffe000202414:	fd744783          	lbu	a5,-41(s0)
ffffffe000202418:	0017f793          	andi	a5,a5,1
ffffffe00020241c:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000202420:	fa043683          	ld	a3,-96(s0)
ffffffe000202424:	00001797          	auipc	a5,0x1
ffffffe000202428:	dec78793          	addi	a5,a5,-532 # ffffffe000203210 <_srodata+0x210>
ffffffe00020242c:	0007b783          	ld	a5,0(a5)
ffffffe000202430:	02f6b7b3          	mulhu	a5,a3,a5
ffffffe000202434:	0037d713          	srli	a4,a5,0x3
ffffffe000202438:	00070793          	mv	a5,a4
ffffffe00020243c:	00279793          	slli	a5,a5,0x2
ffffffe000202440:	00e787b3          	add	a5,a5,a4
ffffffe000202444:	00179793          	slli	a5,a5,0x1
ffffffe000202448:	40f68733          	sub	a4,a3,a5
ffffffe00020244c:	0ff77713          	zext.b	a4,a4
ffffffe000202450:	fe842783          	lw	a5,-24(s0)
ffffffe000202454:	0017869b          	addiw	a3,a5,1
ffffffe000202458:	fed42423          	sw	a3,-24(s0)
ffffffe00020245c:	0307071b          	addiw	a4,a4,48
ffffffe000202460:	0ff77713          	zext.b	a4,a4
ffffffe000202464:	ff078793          	addi	a5,a5,-16
ffffffe000202468:	008787b3          	add	a5,a5,s0
ffffffe00020246c:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000202470:	fa043703          	ld	a4,-96(s0)
ffffffe000202474:	00001797          	auipc	a5,0x1
ffffffe000202478:	d9c78793          	addi	a5,a5,-612 # ffffffe000203210 <_srodata+0x210>
ffffffe00020247c:	0007b783          	ld	a5,0(a5)
ffffffe000202480:	02f737b3          	mulhu	a5,a4,a5
ffffffe000202484:	0037d793          	srli	a5,a5,0x3
ffffffe000202488:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe00020248c:	fa043783          	ld	a5,-96(s0)
ffffffe000202490:	f80798e3          	bnez	a5,ffffffe000202420 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000202494:	f9043783          	ld	a5,-112(s0)
ffffffe000202498:	00c7a703          	lw	a4,12(a5)
ffffffe00020249c:	fff00793          	li	a5,-1
ffffffe0002024a0:	02f71063          	bne	a4,a5,ffffffe0002024c0 <print_dec_int+0x190>
ffffffe0002024a4:	f9043783          	ld	a5,-112(s0)
ffffffe0002024a8:	0037c783          	lbu	a5,3(a5)
ffffffe0002024ac:	00078a63          	beqz	a5,ffffffe0002024c0 <print_dec_int+0x190>
        flags->prec = flags->width;
ffffffe0002024b0:	f9043783          	ld	a5,-112(s0)
ffffffe0002024b4:	0087a703          	lw	a4,8(a5)
ffffffe0002024b8:	f9043783          	ld	a5,-112(s0)
ffffffe0002024bc:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe0002024c0:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe0002024c4:	f9043783          	ld	a5,-112(s0)
ffffffe0002024c8:	0087a703          	lw	a4,8(a5)
ffffffe0002024cc:	fe842783          	lw	a5,-24(s0)
ffffffe0002024d0:	fcf42823          	sw	a5,-48(s0)
ffffffe0002024d4:	f9043783          	ld	a5,-112(s0)
ffffffe0002024d8:	00c7a783          	lw	a5,12(a5)
ffffffe0002024dc:	fcf42623          	sw	a5,-52(s0)
ffffffe0002024e0:	fd042783          	lw	a5,-48(s0)
ffffffe0002024e4:	00078593          	mv	a1,a5
ffffffe0002024e8:	fcc42783          	lw	a5,-52(s0)
ffffffe0002024ec:	00078613          	mv	a2,a5
ffffffe0002024f0:	0006069b          	sext.w	a3,a2
ffffffe0002024f4:	0005879b          	sext.w	a5,a1
ffffffe0002024f8:	00f6d463          	bge	a3,a5,ffffffe000202500 <print_dec_int+0x1d0>
ffffffe0002024fc:	00058613          	mv	a2,a1
ffffffe000202500:	0006079b          	sext.w	a5,a2
ffffffe000202504:	40f707bb          	subw	a5,a4,a5
ffffffe000202508:	0007871b          	sext.w	a4,a5
ffffffe00020250c:	fd744783          	lbu	a5,-41(s0)
ffffffe000202510:	0007879b          	sext.w	a5,a5
ffffffe000202514:	40f707bb          	subw	a5,a4,a5
ffffffe000202518:	fef42023          	sw	a5,-32(s0)
ffffffe00020251c:	0280006f          	j	ffffffe000202544 <print_dec_int+0x214>
        putch(' ');
ffffffe000202520:	fa843783          	ld	a5,-88(s0)
ffffffe000202524:	02000513          	li	a0,32
ffffffe000202528:	000780e7          	jalr	a5
        ++written;
ffffffe00020252c:	fe442783          	lw	a5,-28(s0)
ffffffe000202530:	0017879b          	addiw	a5,a5,1
ffffffe000202534:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202538:	fe042783          	lw	a5,-32(s0)
ffffffe00020253c:	fff7879b          	addiw	a5,a5,-1
ffffffe000202540:	fef42023          	sw	a5,-32(s0)
ffffffe000202544:	fe042783          	lw	a5,-32(s0)
ffffffe000202548:	0007879b          	sext.w	a5,a5
ffffffe00020254c:	fcf04ae3          	bgtz	a5,ffffffe000202520 <print_dec_int+0x1f0>
    }

    if (has_sign_char) {
ffffffe000202550:	fd744783          	lbu	a5,-41(s0)
ffffffe000202554:	0ff7f793          	zext.b	a5,a5
ffffffe000202558:	04078463          	beqz	a5,ffffffe0002025a0 <print_dec_int+0x270>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe00020255c:	fef44783          	lbu	a5,-17(s0)
ffffffe000202560:	0ff7f793          	zext.b	a5,a5
ffffffe000202564:	00078663          	beqz	a5,ffffffe000202570 <print_dec_int+0x240>
ffffffe000202568:	02d00793          	li	a5,45
ffffffe00020256c:	01c0006f          	j	ffffffe000202588 <print_dec_int+0x258>
ffffffe000202570:	f9043783          	ld	a5,-112(s0)
ffffffe000202574:	0057c783          	lbu	a5,5(a5)
ffffffe000202578:	00078663          	beqz	a5,ffffffe000202584 <print_dec_int+0x254>
ffffffe00020257c:	02b00793          	li	a5,43
ffffffe000202580:	0080006f          	j	ffffffe000202588 <print_dec_int+0x258>
ffffffe000202584:	02000793          	li	a5,32
ffffffe000202588:	fa843703          	ld	a4,-88(s0)
ffffffe00020258c:	00078513          	mv	a0,a5
ffffffe000202590:	000700e7          	jalr	a4
        ++written;
ffffffe000202594:	fe442783          	lw	a5,-28(s0)
ffffffe000202598:	0017879b          	addiw	a5,a5,1
ffffffe00020259c:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe0002025a0:	fe842783          	lw	a5,-24(s0)
ffffffe0002025a4:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002025a8:	0280006f          	j	ffffffe0002025d0 <print_dec_int+0x2a0>
        putch('0');
ffffffe0002025ac:	fa843783          	ld	a5,-88(s0)
ffffffe0002025b0:	03000513          	li	a0,48
ffffffe0002025b4:	000780e7          	jalr	a5
        ++written;
ffffffe0002025b8:	fe442783          	lw	a5,-28(s0)
ffffffe0002025bc:	0017879b          	addiw	a5,a5,1
ffffffe0002025c0:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe0002025c4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002025c8:	0017879b          	addiw	a5,a5,1
ffffffe0002025cc:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002025d0:	f9043783          	ld	a5,-112(s0)
ffffffe0002025d4:	00c7a703          	lw	a4,12(a5)
ffffffe0002025d8:	fd744783          	lbu	a5,-41(s0)
ffffffe0002025dc:	0007879b          	sext.w	a5,a5
ffffffe0002025e0:	40f707bb          	subw	a5,a4,a5
ffffffe0002025e4:	0007879b          	sext.w	a5,a5
ffffffe0002025e8:	fdc42703          	lw	a4,-36(s0)
ffffffe0002025ec:	0007071b          	sext.w	a4,a4
ffffffe0002025f0:	faf74ee3          	blt	a4,a5,ffffffe0002025ac <print_dec_int+0x27c>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe0002025f4:	fe842783          	lw	a5,-24(s0)
ffffffe0002025f8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002025fc:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202600:	03c0006f          	j	ffffffe00020263c <print_dec_int+0x30c>
        putch(buf[i]);
ffffffe000202604:	fd842783          	lw	a5,-40(s0)
ffffffe000202608:	ff078793          	addi	a5,a5,-16
ffffffe00020260c:	008787b3          	add	a5,a5,s0
ffffffe000202610:	fc87c783          	lbu	a5,-56(a5)
ffffffe000202614:	0007871b          	sext.w	a4,a5
ffffffe000202618:	fa843783          	ld	a5,-88(s0)
ffffffe00020261c:	00070513          	mv	a0,a4
ffffffe000202620:	000780e7          	jalr	a5
        ++written;
ffffffe000202624:	fe442783          	lw	a5,-28(s0)
ffffffe000202628:	0017879b          	addiw	a5,a5,1
ffffffe00020262c:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000202630:	fd842783          	lw	a5,-40(s0)
ffffffe000202634:	fff7879b          	addiw	a5,a5,-1
ffffffe000202638:	fcf42c23          	sw	a5,-40(s0)
ffffffe00020263c:	fd842783          	lw	a5,-40(s0)
ffffffe000202640:	0007879b          	sext.w	a5,a5
ffffffe000202644:	fc07d0e3          	bgez	a5,ffffffe000202604 <print_dec_int+0x2d4>
    }

    return written;
ffffffe000202648:	fe442783          	lw	a5,-28(s0)
}
ffffffe00020264c:	00078513          	mv	a0,a5
ffffffe000202650:	06813083          	ld	ra,104(sp)
ffffffe000202654:	06013403          	ld	s0,96(sp)
ffffffe000202658:	07010113          	addi	sp,sp,112
ffffffe00020265c:	00008067          	ret

ffffffe000202660 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000202660:	f4010113          	addi	sp,sp,-192
ffffffe000202664:	0a113c23          	sd	ra,184(sp)
ffffffe000202668:	0a813823          	sd	s0,176(sp)
ffffffe00020266c:	0c010413          	addi	s0,sp,192
ffffffe000202670:	f4a43c23          	sd	a0,-168(s0)
ffffffe000202674:	f4b43823          	sd	a1,-176(s0)
ffffffe000202678:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe00020267c:	f8043023          	sd	zero,-128(s0)
ffffffe000202680:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000202684:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000202688:	7a00006f          	j	ffffffe000202e28 <vprintfmt+0x7c8>
        if (flags.in_format) {
ffffffe00020268c:	f8044783          	lbu	a5,-128(s0)
ffffffe000202690:	72078c63          	beqz	a5,ffffffe000202dc8 <vprintfmt+0x768>
            if (*fmt == '#') {
ffffffe000202694:	f5043783          	ld	a5,-176(s0)
ffffffe000202698:	0007c783          	lbu	a5,0(a5)
ffffffe00020269c:	00078713          	mv	a4,a5
ffffffe0002026a0:	02300793          	li	a5,35
ffffffe0002026a4:	00f71863          	bne	a4,a5,ffffffe0002026b4 <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe0002026a8:	00100793          	li	a5,1
ffffffe0002026ac:	f8f40123          	sb	a5,-126(s0)
ffffffe0002026b0:	76c0006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == '0') {
ffffffe0002026b4:	f5043783          	ld	a5,-176(s0)
ffffffe0002026b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002026bc:	00078713          	mv	a4,a5
ffffffe0002026c0:	03000793          	li	a5,48
ffffffe0002026c4:	00f71863          	bne	a4,a5,ffffffe0002026d4 <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe0002026c8:	00100793          	li	a5,1
ffffffe0002026cc:	f8f401a3          	sb	a5,-125(s0)
ffffffe0002026d0:	74c0006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe0002026d4:	f5043783          	ld	a5,-176(s0)
ffffffe0002026d8:	0007c783          	lbu	a5,0(a5)
ffffffe0002026dc:	00078713          	mv	a4,a5
ffffffe0002026e0:	06c00793          	li	a5,108
ffffffe0002026e4:	04f70063          	beq	a4,a5,ffffffe000202724 <vprintfmt+0xc4>
ffffffe0002026e8:	f5043783          	ld	a5,-176(s0)
ffffffe0002026ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002026f0:	00078713          	mv	a4,a5
ffffffe0002026f4:	07a00793          	li	a5,122
ffffffe0002026f8:	02f70663          	beq	a4,a5,ffffffe000202724 <vprintfmt+0xc4>
ffffffe0002026fc:	f5043783          	ld	a5,-176(s0)
ffffffe000202700:	0007c783          	lbu	a5,0(a5)
ffffffe000202704:	00078713          	mv	a4,a5
ffffffe000202708:	07400793          	li	a5,116
ffffffe00020270c:	00f70c63          	beq	a4,a5,ffffffe000202724 <vprintfmt+0xc4>
ffffffe000202710:	f5043783          	ld	a5,-176(s0)
ffffffe000202714:	0007c783          	lbu	a5,0(a5)
ffffffe000202718:	00078713          	mv	a4,a5
ffffffe00020271c:	06a00793          	li	a5,106
ffffffe000202720:	00f71863          	bne	a4,a5,ffffffe000202730 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe000202724:	00100793          	li	a5,1
ffffffe000202728:	f8f400a3          	sb	a5,-127(s0)
ffffffe00020272c:	6f00006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == '+') {
ffffffe000202730:	f5043783          	ld	a5,-176(s0)
ffffffe000202734:	0007c783          	lbu	a5,0(a5)
ffffffe000202738:	00078713          	mv	a4,a5
ffffffe00020273c:	02b00793          	li	a5,43
ffffffe000202740:	00f71863          	bne	a4,a5,ffffffe000202750 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe000202744:	00100793          	li	a5,1
ffffffe000202748:	f8f402a3          	sb	a5,-123(s0)
ffffffe00020274c:	6d00006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == ' ') {
ffffffe000202750:	f5043783          	ld	a5,-176(s0)
ffffffe000202754:	0007c783          	lbu	a5,0(a5)
ffffffe000202758:	00078713          	mv	a4,a5
ffffffe00020275c:	02000793          	li	a5,32
ffffffe000202760:	00f71863          	bne	a4,a5,ffffffe000202770 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000202764:	00100793          	li	a5,1
ffffffe000202768:	f8f40223          	sb	a5,-124(s0)
ffffffe00020276c:	6b00006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == '*') {
ffffffe000202770:	f5043783          	ld	a5,-176(s0)
ffffffe000202774:	0007c783          	lbu	a5,0(a5)
ffffffe000202778:	00078713          	mv	a4,a5
ffffffe00020277c:	02a00793          	li	a5,42
ffffffe000202780:	00f71e63          	bne	a4,a5,ffffffe00020279c <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000202784:	f4843783          	ld	a5,-184(s0)
ffffffe000202788:	00878713          	addi	a4,a5,8
ffffffe00020278c:	f4e43423          	sd	a4,-184(s0)
ffffffe000202790:	0007a783          	lw	a5,0(a5)
ffffffe000202794:	f8f42423          	sw	a5,-120(s0)
ffffffe000202798:	6840006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe00020279c:	f5043783          	ld	a5,-176(s0)
ffffffe0002027a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002027a4:	00078713          	mv	a4,a5
ffffffe0002027a8:	03000793          	li	a5,48
ffffffe0002027ac:	04e7f663          	bgeu	a5,a4,ffffffe0002027f8 <vprintfmt+0x198>
ffffffe0002027b0:	f5043783          	ld	a5,-176(s0)
ffffffe0002027b4:	0007c783          	lbu	a5,0(a5)
ffffffe0002027b8:	00078713          	mv	a4,a5
ffffffe0002027bc:	03900793          	li	a5,57
ffffffe0002027c0:	02e7ec63          	bltu	a5,a4,ffffffe0002027f8 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe0002027c4:	f5043783          	ld	a5,-176(s0)
ffffffe0002027c8:	f5040713          	addi	a4,s0,-176
ffffffe0002027cc:	00a00613          	li	a2,10
ffffffe0002027d0:	00070593          	mv	a1,a4
ffffffe0002027d4:	00078513          	mv	a0,a5
ffffffe0002027d8:	865ff0ef          	jal	ffffffe00020203c <strtol>
ffffffe0002027dc:	00050793          	mv	a5,a0
ffffffe0002027e0:	0007879b          	sext.w	a5,a5
ffffffe0002027e4:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe0002027e8:	f5043783          	ld	a5,-176(s0)
ffffffe0002027ec:	fff78793          	addi	a5,a5,-1
ffffffe0002027f0:	f4f43823          	sd	a5,-176(s0)
ffffffe0002027f4:	6280006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == '.') {
ffffffe0002027f8:	f5043783          	ld	a5,-176(s0)
ffffffe0002027fc:	0007c783          	lbu	a5,0(a5)
ffffffe000202800:	00078713          	mv	a4,a5
ffffffe000202804:	02e00793          	li	a5,46
ffffffe000202808:	06f71863          	bne	a4,a5,ffffffe000202878 <vprintfmt+0x218>
                fmt++;
ffffffe00020280c:	f5043783          	ld	a5,-176(s0)
ffffffe000202810:	00178793          	addi	a5,a5,1
ffffffe000202814:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000202818:	f5043783          	ld	a5,-176(s0)
ffffffe00020281c:	0007c783          	lbu	a5,0(a5)
ffffffe000202820:	00078713          	mv	a4,a5
ffffffe000202824:	02a00793          	li	a5,42
ffffffe000202828:	00f71e63          	bne	a4,a5,ffffffe000202844 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe00020282c:	f4843783          	ld	a5,-184(s0)
ffffffe000202830:	00878713          	addi	a4,a5,8
ffffffe000202834:	f4e43423          	sd	a4,-184(s0)
ffffffe000202838:	0007a783          	lw	a5,0(a5)
ffffffe00020283c:	f8f42623          	sw	a5,-116(s0)
ffffffe000202840:	5dc0006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000202844:	f5043783          	ld	a5,-176(s0)
ffffffe000202848:	f5040713          	addi	a4,s0,-176
ffffffe00020284c:	00a00613          	li	a2,10
ffffffe000202850:	00070593          	mv	a1,a4
ffffffe000202854:	00078513          	mv	a0,a5
ffffffe000202858:	fe4ff0ef          	jal	ffffffe00020203c <strtol>
ffffffe00020285c:	00050793          	mv	a5,a0
ffffffe000202860:	0007879b          	sext.w	a5,a5
ffffffe000202864:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000202868:	f5043783          	ld	a5,-176(s0)
ffffffe00020286c:	fff78793          	addi	a5,a5,-1
ffffffe000202870:	f4f43823          	sd	a5,-176(s0)
ffffffe000202874:	5a80006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000202878:	f5043783          	ld	a5,-176(s0)
ffffffe00020287c:	0007c783          	lbu	a5,0(a5)
ffffffe000202880:	00078713          	mv	a4,a5
ffffffe000202884:	07800793          	li	a5,120
ffffffe000202888:	02f70663          	beq	a4,a5,ffffffe0002028b4 <vprintfmt+0x254>
ffffffe00020288c:	f5043783          	ld	a5,-176(s0)
ffffffe000202890:	0007c783          	lbu	a5,0(a5)
ffffffe000202894:	00078713          	mv	a4,a5
ffffffe000202898:	05800793          	li	a5,88
ffffffe00020289c:	00f70c63          	beq	a4,a5,ffffffe0002028b4 <vprintfmt+0x254>
ffffffe0002028a0:	f5043783          	ld	a5,-176(s0)
ffffffe0002028a4:	0007c783          	lbu	a5,0(a5)
ffffffe0002028a8:	00078713          	mv	a4,a5
ffffffe0002028ac:	07000793          	li	a5,112
ffffffe0002028b0:	30f71063          	bne	a4,a5,ffffffe000202bb0 <vprintfmt+0x550>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe0002028b4:	f5043783          	ld	a5,-176(s0)
ffffffe0002028b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002028bc:	00078713          	mv	a4,a5
ffffffe0002028c0:	07000793          	li	a5,112
ffffffe0002028c4:	00f70663          	beq	a4,a5,ffffffe0002028d0 <vprintfmt+0x270>
ffffffe0002028c8:	f8144783          	lbu	a5,-127(s0)
ffffffe0002028cc:	00078663          	beqz	a5,ffffffe0002028d8 <vprintfmt+0x278>
ffffffe0002028d0:	00100793          	li	a5,1
ffffffe0002028d4:	0080006f          	j	ffffffe0002028dc <vprintfmt+0x27c>
ffffffe0002028d8:	00000793          	li	a5,0
ffffffe0002028dc:	faf403a3          	sb	a5,-89(s0)
ffffffe0002028e0:	fa744783          	lbu	a5,-89(s0)
ffffffe0002028e4:	0017f793          	andi	a5,a5,1
ffffffe0002028e8:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe0002028ec:	fa744783          	lbu	a5,-89(s0)
ffffffe0002028f0:	0ff7f793          	zext.b	a5,a5
ffffffe0002028f4:	00078c63          	beqz	a5,ffffffe00020290c <vprintfmt+0x2ac>
ffffffe0002028f8:	f4843783          	ld	a5,-184(s0)
ffffffe0002028fc:	00878713          	addi	a4,a5,8
ffffffe000202900:	f4e43423          	sd	a4,-184(s0)
ffffffe000202904:	0007b783          	ld	a5,0(a5)
ffffffe000202908:	01c0006f          	j	ffffffe000202924 <vprintfmt+0x2c4>
ffffffe00020290c:	f4843783          	ld	a5,-184(s0)
ffffffe000202910:	00878713          	addi	a4,a5,8
ffffffe000202914:	f4e43423          	sd	a4,-184(s0)
ffffffe000202918:	0007a783          	lw	a5,0(a5)
ffffffe00020291c:	02079793          	slli	a5,a5,0x20
ffffffe000202920:	0207d793          	srli	a5,a5,0x20
ffffffe000202924:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000202928:	f8c42783          	lw	a5,-116(s0)
ffffffe00020292c:	02079463          	bnez	a5,ffffffe000202954 <vprintfmt+0x2f4>
ffffffe000202930:	fe043783          	ld	a5,-32(s0)
ffffffe000202934:	02079063          	bnez	a5,ffffffe000202954 <vprintfmt+0x2f4>
ffffffe000202938:	f5043783          	ld	a5,-176(s0)
ffffffe00020293c:	0007c783          	lbu	a5,0(a5)
ffffffe000202940:	00078713          	mv	a4,a5
ffffffe000202944:	07000793          	li	a5,112
ffffffe000202948:	00f70663          	beq	a4,a5,ffffffe000202954 <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe00020294c:	f8040023          	sb	zero,-128(s0)
ffffffe000202950:	4cc0006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000202954:	f5043783          	ld	a5,-176(s0)
ffffffe000202958:	0007c783          	lbu	a5,0(a5)
ffffffe00020295c:	00078713          	mv	a4,a5
ffffffe000202960:	07000793          	li	a5,112
ffffffe000202964:	00f70a63          	beq	a4,a5,ffffffe000202978 <vprintfmt+0x318>
ffffffe000202968:	f8244783          	lbu	a5,-126(s0)
ffffffe00020296c:	00078a63          	beqz	a5,ffffffe000202980 <vprintfmt+0x320>
ffffffe000202970:	fe043783          	ld	a5,-32(s0)
ffffffe000202974:	00078663          	beqz	a5,ffffffe000202980 <vprintfmt+0x320>
ffffffe000202978:	00100793          	li	a5,1
ffffffe00020297c:	0080006f          	j	ffffffe000202984 <vprintfmt+0x324>
ffffffe000202980:	00000793          	li	a5,0
ffffffe000202984:	faf40323          	sb	a5,-90(s0)
ffffffe000202988:	fa644783          	lbu	a5,-90(s0)
ffffffe00020298c:	0017f793          	andi	a5,a5,1
ffffffe000202990:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000202994:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000202998:	f5043783          	ld	a5,-176(s0)
ffffffe00020299c:	0007c783          	lbu	a5,0(a5)
ffffffe0002029a0:	00078713          	mv	a4,a5
ffffffe0002029a4:	05800793          	li	a5,88
ffffffe0002029a8:	00f71863          	bne	a4,a5,ffffffe0002029b8 <vprintfmt+0x358>
ffffffe0002029ac:	00001797          	auipc	a5,0x1
ffffffe0002029b0:	86c78793          	addi	a5,a5,-1940 # ffffffe000203218 <upperxdigits.1>
ffffffe0002029b4:	00c0006f          	j	ffffffe0002029c0 <vprintfmt+0x360>
ffffffe0002029b8:	00001797          	auipc	a5,0x1
ffffffe0002029bc:	87878793          	addi	a5,a5,-1928 # ffffffe000203230 <lowerxdigits.0>
ffffffe0002029c0:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe0002029c4:	fe043783          	ld	a5,-32(s0)
ffffffe0002029c8:	00f7f793          	andi	a5,a5,15
ffffffe0002029cc:	f9843703          	ld	a4,-104(s0)
ffffffe0002029d0:	00f70733          	add	a4,a4,a5
ffffffe0002029d4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002029d8:	0017869b          	addiw	a3,a5,1
ffffffe0002029dc:	fcd42e23          	sw	a3,-36(s0)
ffffffe0002029e0:	00074703          	lbu	a4,0(a4)
ffffffe0002029e4:	ff078793          	addi	a5,a5,-16
ffffffe0002029e8:	008787b3          	add	a5,a5,s0
ffffffe0002029ec:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe0002029f0:	fe043783          	ld	a5,-32(s0)
ffffffe0002029f4:	0047d793          	srli	a5,a5,0x4
ffffffe0002029f8:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe0002029fc:	fe043783          	ld	a5,-32(s0)
ffffffe000202a00:	fc0792e3          	bnez	a5,ffffffe0002029c4 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe000202a04:	f8c42703          	lw	a4,-116(s0)
ffffffe000202a08:	fff00793          	li	a5,-1
ffffffe000202a0c:	02f71663          	bne	a4,a5,ffffffe000202a38 <vprintfmt+0x3d8>
ffffffe000202a10:	f8344783          	lbu	a5,-125(s0)
ffffffe000202a14:	02078263          	beqz	a5,ffffffe000202a38 <vprintfmt+0x3d8>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000202a18:	f8842703          	lw	a4,-120(s0)
ffffffe000202a1c:	fa644783          	lbu	a5,-90(s0)
ffffffe000202a20:	0007879b          	sext.w	a5,a5
ffffffe000202a24:	0017979b          	slliw	a5,a5,0x1
ffffffe000202a28:	0007879b          	sext.w	a5,a5
ffffffe000202a2c:	40f707bb          	subw	a5,a4,a5
ffffffe000202a30:	0007879b          	sext.w	a5,a5
ffffffe000202a34:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202a38:	f8842703          	lw	a4,-120(s0)
ffffffe000202a3c:	fa644783          	lbu	a5,-90(s0)
ffffffe000202a40:	0007879b          	sext.w	a5,a5
ffffffe000202a44:	0017979b          	slliw	a5,a5,0x1
ffffffe000202a48:	0007879b          	sext.w	a5,a5
ffffffe000202a4c:	40f707bb          	subw	a5,a4,a5
ffffffe000202a50:	0007871b          	sext.w	a4,a5
ffffffe000202a54:	fdc42783          	lw	a5,-36(s0)
ffffffe000202a58:	f8f42a23          	sw	a5,-108(s0)
ffffffe000202a5c:	f8c42783          	lw	a5,-116(s0)
ffffffe000202a60:	f8f42823          	sw	a5,-112(s0)
ffffffe000202a64:	f9442783          	lw	a5,-108(s0)
ffffffe000202a68:	00078593          	mv	a1,a5
ffffffe000202a6c:	f9042783          	lw	a5,-112(s0)
ffffffe000202a70:	00078613          	mv	a2,a5
ffffffe000202a74:	0006069b          	sext.w	a3,a2
ffffffe000202a78:	0005879b          	sext.w	a5,a1
ffffffe000202a7c:	00f6d463          	bge	a3,a5,ffffffe000202a84 <vprintfmt+0x424>
ffffffe000202a80:	00058613          	mv	a2,a1
ffffffe000202a84:	0006079b          	sext.w	a5,a2
ffffffe000202a88:	40f707bb          	subw	a5,a4,a5
ffffffe000202a8c:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202a90:	0280006f          	j	ffffffe000202ab8 <vprintfmt+0x458>
                    putch(' ');
ffffffe000202a94:	f5843783          	ld	a5,-168(s0)
ffffffe000202a98:	02000513          	li	a0,32
ffffffe000202a9c:	000780e7          	jalr	a5
                    ++written;
ffffffe000202aa0:	fec42783          	lw	a5,-20(s0)
ffffffe000202aa4:	0017879b          	addiw	a5,a5,1
ffffffe000202aa8:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202aac:	fd842783          	lw	a5,-40(s0)
ffffffe000202ab0:	fff7879b          	addiw	a5,a5,-1
ffffffe000202ab4:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202ab8:	fd842783          	lw	a5,-40(s0)
ffffffe000202abc:	0007879b          	sext.w	a5,a5
ffffffe000202ac0:	fcf04ae3          	bgtz	a5,ffffffe000202a94 <vprintfmt+0x434>
                }

                if (prefix) {
ffffffe000202ac4:	fa644783          	lbu	a5,-90(s0)
ffffffe000202ac8:	0ff7f793          	zext.b	a5,a5
ffffffe000202acc:	04078463          	beqz	a5,ffffffe000202b14 <vprintfmt+0x4b4>
                    putch('0');
ffffffe000202ad0:	f5843783          	ld	a5,-168(s0)
ffffffe000202ad4:	03000513          	li	a0,48
ffffffe000202ad8:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe000202adc:	f5043783          	ld	a5,-176(s0)
ffffffe000202ae0:	0007c783          	lbu	a5,0(a5)
ffffffe000202ae4:	00078713          	mv	a4,a5
ffffffe000202ae8:	05800793          	li	a5,88
ffffffe000202aec:	00f71663          	bne	a4,a5,ffffffe000202af8 <vprintfmt+0x498>
ffffffe000202af0:	05800793          	li	a5,88
ffffffe000202af4:	0080006f          	j	ffffffe000202afc <vprintfmt+0x49c>
ffffffe000202af8:	07800793          	li	a5,120
ffffffe000202afc:	f5843703          	ld	a4,-168(s0)
ffffffe000202b00:	00078513          	mv	a0,a5
ffffffe000202b04:	000700e7          	jalr	a4
                    written += 2;
ffffffe000202b08:	fec42783          	lw	a5,-20(s0)
ffffffe000202b0c:	0027879b          	addiw	a5,a5,2
ffffffe000202b10:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000202b14:	fdc42783          	lw	a5,-36(s0)
ffffffe000202b18:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202b1c:	0280006f          	j	ffffffe000202b44 <vprintfmt+0x4e4>
                    putch('0');
ffffffe000202b20:	f5843783          	ld	a5,-168(s0)
ffffffe000202b24:	03000513          	li	a0,48
ffffffe000202b28:	000780e7          	jalr	a5
                    ++written;
ffffffe000202b2c:	fec42783          	lw	a5,-20(s0)
ffffffe000202b30:	0017879b          	addiw	a5,a5,1
ffffffe000202b34:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000202b38:	fd442783          	lw	a5,-44(s0)
ffffffe000202b3c:	0017879b          	addiw	a5,a5,1
ffffffe000202b40:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202b44:	f8c42783          	lw	a5,-116(s0)
ffffffe000202b48:	fd442703          	lw	a4,-44(s0)
ffffffe000202b4c:	0007071b          	sext.w	a4,a4
ffffffe000202b50:	fcf748e3          	blt	a4,a5,ffffffe000202b20 <vprintfmt+0x4c0>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202b54:	fdc42783          	lw	a5,-36(s0)
ffffffe000202b58:	fff7879b          	addiw	a5,a5,-1
ffffffe000202b5c:	fcf42823          	sw	a5,-48(s0)
ffffffe000202b60:	03c0006f          	j	ffffffe000202b9c <vprintfmt+0x53c>
                    putch(buf[i]);
ffffffe000202b64:	fd042783          	lw	a5,-48(s0)
ffffffe000202b68:	ff078793          	addi	a5,a5,-16
ffffffe000202b6c:	008787b3          	add	a5,a5,s0
ffffffe000202b70:	f807c783          	lbu	a5,-128(a5)
ffffffe000202b74:	0007871b          	sext.w	a4,a5
ffffffe000202b78:	f5843783          	ld	a5,-168(s0)
ffffffe000202b7c:	00070513          	mv	a0,a4
ffffffe000202b80:	000780e7          	jalr	a5
                    ++written;
ffffffe000202b84:	fec42783          	lw	a5,-20(s0)
ffffffe000202b88:	0017879b          	addiw	a5,a5,1
ffffffe000202b8c:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202b90:	fd042783          	lw	a5,-48(s0)
ffffffe000202b94:	fff7879b          	addiw	a5,a5,-1
ffffffe000202b98:	fcf42823          	sw	a5,-48(s0)
ffffffe000202b9c:	fd042783          	lw	a5,-48(s0)
ffffffe000202ba0:	0007879b          	sext.w	a5,a5
ffffffe000202ba4:	fc07d0e3          	bgez	a5,ffffffe000202b64 <vprintfmt+0x504>
                }

                flags.in_format = false;
ffffffe000202ba8:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000202bac:	2700006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202bb0:	f5043783          	ld	a5,-176(s0)
ffffffe000202bb4:	0007c783          	lbu	a5,0(a5)
ffffffe000202bb8:	00078713          	mv	a4,a5
ffffffe000202bbc:	06400793          	li	a5,100
ffffffe000202bc0:	02f70663          	beq	a4,a5,ffffffe000202bec <vprintfmt+0x58c>
ffffffe000202bc4:	f5043783          	ld	a5,-176(s0)
ffffffe000202bc8:	0007c783          	lbu	a5,0(a5)
ffffffe000202bcc:	00078713          	mv	a4,a5
ffffffe000202bd0:	06900793          	li	a5,105
ffffffe000202bd4:	00f70c63          	beq	a4,a5,ffffffe000202bec <vprintfmt+0x58c>
ffffffe000202bd8:	f5043783          	ld	a5,-176(s0)
ffffffe000202bdc:	0007c783          	lbu	a5,0(a5)
ffffffe000202be0:	00078713          	mv	a4,a5
ffffffe000202be4:	07500793          	li	a5,117
ffffffe000202be8:	08f71063          	bne	a4,a5,ffffffe000202c68 <vprintfmt+0x608>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000202bec:	f8144783          	lbu	a5,-127(s0)
ffffffe000202bf0:	00078c63          	beqz	a5,ffffffe000202c08 <vprintfmt+0x5a8>
ffffffe000202bf4:	f4843783          	ld	a5,-184(s0)
ffffffe000202bf8:	00878713          	addi	a4,a5,8
ffffffe000202bfc:	f4e43423          	sd	a4,-184(s0)
ffffffe000202c00:	0007b783          	ld	a5,0(a5)
ffffffe000202c04:	0140006f          	j	ffffffe000202c18 <vprintfmt+0x5b8>
ffffffe000202c08:	f4843783          	ld	a5,-184(s0)
ffffffe000202c0c:	00878713          	addi	a4,a5,8
ffffffe000202c10:	f4e43423          	sd	a4,-184(s0)
ffffffe000202c14:	0007a783          	lw	a5,0(a5)
ffffffe000202c18:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000202c1c:	fa843583          	ld	a1,-88(s0)
ffffffe000202c20:	f5043783          	ld	a5,-176(s0)
ffffffe000202c24:	0007c783          	lbu	a5,0(a5)
ffffffe000202c28:	0007871b          	sext.w	a4,a5
ffffffe000202c2c:	07500793          	li	a5,117
ffffffe000202c30:	40f707b3          	sub	a5,a4,a5
ffffffe000202c34:	00f037b3          	snez	a5,a5
ffffffe000202c38:	0ff7f793          	zext.b	a5,a5
ffffffe000202c3c:	f8040713          	addi	a4,s0,-128
ffffffe000202c40:	00070693          	mv	a3,a4
ffffffe000202c44:	00078613          	mv	a2,a5
ffffffe000202c48:	f5843503          	ld	a0,-168(s0)
ffffffe000202c4c:	ee4ff0ef          	jal	ffffffe000202330 <print_dec_int>
ffffffe000202c50:	00050793          	mv	a5,a0
ffffffe000202c54:	fec42703          	lw	a4,-20(s0)
ffffffe000202c58:	00f707bb          	addw	a5,a4,a5
ffffffe000202c5c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202c60:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202c64:	1b80006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == 'n') {
ffffffe000202c68:	f5043783          	ld	a5,-176(s0)
ffffffe000202c6c:	0007c783          	lbu	a5,0(a5)
ffffffe000202c70:	00078713          	mv	a4,a5
ffffffe000202c74:	06e00793          	li	a5,110
ffffffe000202c78:	04f71c63          	bne	a4,a5,ffffffe000202cd0 <vprintfmt+0x670>
                if (flags.longflag) {
ffffffe000202c7c:	f8144783          	lbu	a5,-127(s0)
ffffffe000202c80:	02078463          	beqz	a5,ffffffe000202ca8 <vprintfmt+0x648>
                    long *n = va_arg(vl, long *);
ffffffe000202c84:	f4843783          	ld	a5,-184(s0)
ffffffe000202c88:	00878713          	addi	a4,a5,8
ffffffe000202c8c:	f4e43423          	sd	a4,-184(s0)
ffffffe000202c90:	0007b783          	ld	a5,0(a5)
ffffffe000202c94:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000202c98:	fec42703          	lw	a4,-20(s0)
ffffffe000202c9c:	fb043783          	ld	a5,-80(s0)
ffffffe000202ca0:	00e7b023          	sd	a4,0(a5)
ffffffe000202ca4:	0240006f          	j	ffffffe000202cc8 <vprintfmt+0x668>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe000202ca8:	f4843783          	ld	a5,-184(s0)
ffffffe000202cac:	00878713          	addi	a4,a5,8
ffffffe000202cb0:	f4e43423          	sd	a4,-184(s0)
ffffffe000202cb4:	0007b783          	ld	a5,0(a5)
ffffffe000202cb8:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe000202cbc:	fb843783          	ld	a5,-72(s0)
ffffffe000202cc0:	fec42703          	lw	a4,-20(s0)
ffffffe000202cc4:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe000202cc8:	f8040023          	sb	zero,-128(s0)
ffffffe000202ccc:	1500006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == 's') {
ffffffe000202cd0:	f5043783          	ld	a5,-176(s0)
ffffffe000202cd4:	0007c783          	lbu	a5,0(a5)
ffffffe000202cd8:	00078713          	mv	a4,a5
ffffffe000202cdc:	07300793          	li	a5,115
ffffffe000202ce0:	02f71e63          	bne	a4,a5,ffffffe000202d1c <vprintfmt+0x6bc>
                const char *s = va_arg(vl, const char *);
ffffffe000202ce4:	f4843783          	ld	a5,-184(s0)
ffffffe000202ce8:	00878713          	addi	a4,a5,8
ffffffe000202cec:	f4e43423          	sd	a4,-184(s0)
ffffffe000202cf0:	0007b783          	ld	a5,0(a5)
ffffffe000202cf4:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe000202cf8:	fc043583          	ld	a1,-64(s0)
ffffffe000202cfc:	f5843503          	ld	a0,-168(s0)
ffffffe000202d00:	da8ff0ef          	jal	ffffffe0002022a8 <puts_wo_nl>
ffffffe000202d04:	00050793          	mv	a5,a0
ffffffe000202d08:	fec42703          	lw	a4,-20(s0)
ffffffe000202d0c:	00f707bb          	addw	a5,a4,a5
ffffffe000202d10:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202d14:	f8040023          	sb	zero,-128(s0)
ffffffe000202d18:	1040006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == 'c') {
ffffffe000202d1c:	f5043783          	ld	a5,-176(s0)
ffffffe000202d20:	0007c783          	lbu	a5,0(a5)
ffffffe000202d24:	00078713          	mv	a4,a5
ffffffe000202d28:	06300793          	li	a5,99
ffffffe000202d2c:	02f71e63          	bne	a4,a5,ffffffe000202d68 <vprintfmt+0x708>
                int ch = va_arg(vl, int);
ffffffe000202d30:	f4843783          	ld	a5,-184(s0)
ffffffe000202d34:	00878713          	addi	a4,a5,8
ffffffe000202d38:	f4e43423          	sd	a4,-184(s0)
ffffffe000202d3c:	0007a783          	lw	a5,0(a5)
ffffffe000202d40:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000202d44:	fcc42703          	lw	a4,-52(s0)
ffffffe000202d48:	f5843783          	ld	a5,-168(s0)
ffffffe000202d4c:	00070513          	mv	a0,a4
ffffffe000202d50:	000780e7          	jalr	a5
                ++written;
ffffffe000202d54:	fec42783          	lw	a5,-20(s0)
ffffffe000202d58:	0017879b          	addiw	a5,a5,1
ffffffe000202d5c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202d60:	f8040023          	sb	zero,-128(s0)
ffffffe000202d64:	0b80006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else if (*fmt == '%') {
ffffffe000202d68:	f5043783          	ld	a5,-176(s0)
ffffffe000202d6c:	0007c783          	lbu	a5,0(a5)
ffffffe000202d70:	00078713          	mv	a4,a5
ffffffe000202d74:	02500793          	li	a5,37
ffffffe000202d78:	02f71263          	bne	a4,a5,ffffffe000202d9c <vprintfmt+0x73c>
                putch('%');
ffffffe000202d7c:	f5843783          	ld	a5,-168(s0)
ffffffe000202d80:	02500513          	li	a0,37
ffffffe000202d84:	000780e7          	jalr	a5
                ++written;
ffffffe000202d88:	fec42783          	lw	a5,-20(s0)
ffffffe000202d8c:	0017879b          	addiw	a5,a5,1
ffffffe000202d90:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202d94:	f8040023          	sb	zero,-128(s0)
ffffffe000202d98:	0840006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            } else {
                putch(*fmt);
ffffffe000202d9c:	f5043783          	ld	a5,-176(s0)
ffffffe000202da0:	0007c783          	lbu	a5,0(a5)
ffffffe000202da4:	0007871b          	sext.w	a4,a5
ffffffe000202da8:	f5843783          	ld	a5,-168(s0)
ffffffe000202dac:	00070513          	mv	a0,a4
ffffffe000202db0:	000780e7          	jalr	a5
                ++written;
ffffffe000202db4:	fec42783          	lw	a5,-20(s0)
ffffffe000202db8:	0017879b          	addiw	a5,a5,1
ffffffe000202dbc:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202dc0:	f8040023          	sb	zero,-128(s0)
ffffffe000202dc4:	0580006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
            }
        } else if (*fmt == '%') {
ffffffe000202dc8:	f5043783          	ld	a5,-176(s0)
ffffffe000202dcc:	0007c783          	lbu	a5,0(a5)
ffffffe000202dd0:	00078713          	mv	a4,a5
ffffffe000202dd4:	02500793          	li	a5,37
ffffffe000202dd8:	02f71063          	bne	a4,a5,ffffffe000202df8 <vprintfmt+0x798>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe000202ddc:	f8043023          	sd	zero,-128(s0)
ffffffe000202de0:	f8043423          	sd	zero,-120(s0)
ffffffe000202de4:	00100793          	li	a5,1
ffffffe000202de8:	f8f40023          	sb	a5,-128(s0)
ffffffe000202dec:	fff00793          	li	a5,-1
ffffffe000202df0:	f8f42623          	sw	a5,-116(s0)
ffffffe000202df4:	0280006f          	j	ffffffe000202e1c <vprintfmt+0x7bc>
        } else {
            putch(*fmt);
ffffffe000202df8:	f5043783          	ld	a5,-176(s0)
ffffffe000202dfc:	0007c783          	lbu	a5,0(a5)
ffffffe000202e00:	0007871b          	sext.w	a4,a5
ffffffe000202e04:	f5843783          	ld	a5,-168(s0)
ffffffe000202e08:	00070513          	mv	a0,a4
ffffffe000202e0c:	000780e7          	jalr	a5
            ++written;
ffffffe000202e10:	fec42783          	lw	a5,-20(s0)
ffffffe000202e14:	0017879b          	addiw	a5,a5,1
ffffffe000202e18:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe000202e1c:	f5043783          	ld	a5,-176(s0)
ffffffe000202e20:	00178793          	addi	a5,a5,1
ffffffe000202e24:	f4f43823          	sd	a5,-176(s0)
ffffffe000202e28:	f5043783          	ld	a5,-176(s0)
ffffffe000202e2c:	0007c783          	lbu	a5,0(a5)
ffffffe000202e30:	84079ee3          	bnez	a5,ffffffe00020268c <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000202e34:	fec42783          	lw	a5,-20(s0)
}
ffffffe000202e38:	00078513          	mv	a0,a5
ffffffe000202e3c:	0b813083          	ld	ra,184(sp)
ffffffe000202e40:	0b013403          	ld	s0,176(sp)
ffffffe000202e44:	0c010113          	addi	sp,sp,192
ffffffe000202e48:	00008067          	ret

ffffffe000202e4c <printk>:

int printk(const char* s, ...) {
ffffffe000202e4c:	f9010113          	addi	sp,sp,-112
ffffffe000202e50:	02113423          	sd	ra,40(sp)
ffffffe000202e54:	02813023          	sd	s0,32(sp)
ffffffe000202e58:	03010413          	addi	s0,sp,48
ffffffe000202e5c:	fca43c23          	sd	a0,-40(s0)
ffffffe000202e60:	00b43423          	sd	a1,8(s0)
ffffffe000202e64:	00c43823          	sd	a2,16(s0)
ffffffe000202e68:	00d43c23          	sd	a3,24(s0)
ffffffe000202e6c:	02e43023          	sd	a4,32(s0)
ffffffe000202e70:	02f43423          	sd	a5,40(s0)
ffffffe000202e74:	03043823          	sd	a6,48(s0)
ffffffe000202e78:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe000202e7c:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000202e80:	04040793          	addi	a5,s0,64
ffffffe000202e84:	fcf43823          	sd	a5,-48(s0)
ffffffe000202e88:	fd043783          	ld	a5,-48(s0)
ffffffe000202e8c:	fc878793          	addi	a5,a5,-56
ffffffe000202e90:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000202e94:	fe043783          	ld	a5,-32(s0)
ffffffe000202e98:	00078613          	mv	a2,a5
ffffffe000202e9c:	fd843583          	ld	a1,-40(s0)
ffffffe000202ea0:	fffff517          	auipc	a0,0xfffff
ffffffe000202ea4:	0ec50513          	addi	a0,a0,236 # ffffffe000201f8c <putc>
ffffffe000202ea8:	fb8ff0ef          	jal	ffffffe000202660 <vprintfmt>
ffffffe000202eac:	00050793          	mv	a5,a0
ffffffe000202eb0:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe000202eb4:	fec42783          	lw	a5,-20(s0)
}
ffffffe000202eb8:	00078513          	mv	a0,a5
ffffffe000202ebc:	02813083          	ld	ra,40(sp)
ffffffe000202ec0:	02013403          	ld	s0,32(sp)
ffffffe000202ec4:	07010113          	addi	sp,sp,112
ffffffe000202ec8:	00008067          	ret

ffffffe000202ecc <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe000202ecc:	fe010113          	addi	sp,sp,-32
ffffffe000202ed0:	00113c23          	sd	ra,24(sp)
ffffffe000202ed4:	00813823          	sd	s0,16(sp)
ffffffe000202ed8:	02010413          	addi	s0,sp,32
ffffffe000202edc:	00050793          	mv	a5,a0
ffffffe000202ee0:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe000202ee4:	fec42783          	lw	a5,-20(s0)
ffffffe000202ee8:	fff7879b          	addiw	a5,a5,-1
ffffffe000202eec:	0007879b          	sext.w	a5,a5
ffffffe000202ef0:	02079713          	slli	a4,a5,0x20
ffffffe000202ef4:	02075713          	srli	a4,a4,0x20
ffffffe000202ef8:	00005797          	auipc	a5,0x5
ffffffe000202efc:	12878793          	addi	a5,a5,296 # ffffffe000208020 <seed>
ffffffe000202f00:	00e7b023          	sd	a4,0(a5)
}
ffffffe000202f04:	00000013          	nop
ffffffe000202f08:	01813083          	ld	ra,24(sp)
ffffffe000202f0c:	01013403          	ld	s0,16(sp)
ffffffe000202f10:	02010113          	addi	sp,sp,32
ffffffe000202f14:	00008067          	ret

ffffffe000202f18 <rand>:

int rand(void) {
ffffffe000202f18:	ff010113          	addi	sp,sp,-16
ffffffe000202f1c:	00113423          	sd	ra,8(sp)
ffffffe000202f20:	00813023          	sd	s0,0(sp)
ffffffe000202f24:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe000202f28:	00005797          	auipc	a5,0x5
ffffffe000202f2c:	0f878793          	addi	a5,a5,248 # ffffffe000208020 <seed>
ffffffe000202f30:	0007b703          	ld	a4,0(a5)
ffffffe000202f34:	00000797          	auipc	a5,0x0
ffffffe000202f38:	31478793          	addi	a5,a5,788 # ffffffe000203248 <lowerxdigits.0+0x18>
ffffffe000202f3c:	0007b783          	ld	a5,0(a5)
ffffffe000202f40:	02f707b3          	mul	a5,a4,a5
ffffffe000202f44:	00178713          	addi	a4,a5,1
ffffffe000202f48:	00005797          	auipc	a5,0x5
ffffffe000202f4c:	0d878793          	addi	a5,a5,216 # ffffffe000208020 <seed>
ffffffe000202f50:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe000202f54:	00005797          	auipc	a5,0x5
ffffffe000202f58:	0cc78793          	addi	a5,a5,204 # ffffffe000208020 <seed>
ffffffe000202f5c:	0007b783          	ld	a5,0(a5)
ffffffe000202f60:	0217d793          	srli	a5,a5,0x21
ffffffe000202f64:	0007879b          	sext.w	a5,a5
}
ffffffe000202f68:	00078513          	mv	a0,a5
ffffffe000202f6c:	00813083          	ld	ra,8(sp)
ffffffe000202f70:	00013403          	ld	s0,0(sp)
ffffffe000202f74:	01010113          	addi	sp,sp,16
ffffffe000202f78:	00008067          	ret

ffffffe000202f7c <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe000202f7c:	fc010113          	addi	sp,sp,-64
ffffffe000202f80:	02113c23          	sd	ra,56(sp)
ffffffe000202f84:	02813823          	sd	s0,48(sp)
ffffffe000202f88:	04010413          	addi	s0,sp,64
ffffffe000202f8c:	fca43c23          	sd	a0,-40(s0)
ffffffe000202f90:	00058793          	mv	a5,a1
ffffffe000202f94:	fcc43423          	sd	a2,-56(s0)
ffffffe000202f98:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe000202f9c:	fd843783          	ld	a5,-40(s0)
ffffffe000202fa0:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000202fa4:	fe043423          	sd	zero,-24(s0)
ffffffe000202fa8:	0280006f          	j	ffffffe000202fd0 <memset+0x54>
        s[i] = c;
ffffffe000202fac:	fe043703          	ld	a4,-32(s0)
ffffffe000202fb0:	fe843783          	ld	a5,-24(s0)
ffffffe000202fb4:	00f707b3          	add	a5,a4,a5
ffffffe000202fb8:	fd442703          	lw	a4,-44(s0)
ffffffe000202fbc:	0ff77713          	zext.b	a4,a4
ffffffe000202fc0:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000202fc4:	fe843783          	ld	a5,-24(s0)
ffffffe000202fc8:	00178793          	addi	a5,a5,1
ffffffe000202fcc:	fef43423          	sd	a5,-24(s0)
ffffffe000202fd0:	fe843703          	ld	a4,-24(s0)
ffffffe000202fd4:	fc843783          	ld	a5,-56(s0)
ffffffe000202fd8:	fcf76ae3          	bltu	a4,a5,ffffffe000202fac <memset+0x30>
    }
    return dest;
ffffffe000202fdc:	fd843783          	ld	a5,-40(s0)
}
ffffffe000202fe0:	00078513          	mv	a0,a5
ffffffe000202fe4:	03813083          	ld	ra,56(sp)
ffffffe000202fe8:	03013403          	ld	s0,48(sp)
ffffffe000202fec:	04010113          	addi	sp,sp,64
ffffffe000202ff0:	00008067          	ret
