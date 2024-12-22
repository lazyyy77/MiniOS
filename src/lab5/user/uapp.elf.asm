
uapp.elf:     file format elf64-littleriscv


Disassembly of section .text.init:

0000000000000000 <_start>:
   0:	0d80006f          	j	d8 <main>

Disassembly of section .text.getpid:

0000000000000004 <getpid>:
   4:	fe010113          	addi	sp,sp,-32
   8:	00113c23          	sd	ra,24(sp)
   c:	00813823          	sd	s0,16(sp)
  10:	02010413          	addi	s0,sp,32
  14:	fe843783          	ld	a5,-24(s0)
  18:	0ac00893          	li	a7,172
  1c:	00000073          	ecall
  20:	00050793          	mv	a5,a0
  24:	fef43423          	sd	a5,-24(s0)
  28:	fe843783          	ld	a5,-24(s0)
  2c:	00078513          	mv	a0,a5
  30:	01813083          	ld	ra,24(sp)
  34:	01013403          	ld	s0,16(sp)
  38:	02010113          	addi	sp,sp,32
  3c:	00008067          	ret

Disassembly of section .text.fork:

0000000000000040 <fork>:
  40:	fe010113          	addi	sp,sp,-32
  44:	00113c23          	sd	ra,24(sp)
  48:	00813823          	sd	s0,16(sp)
  4c:	02010413          	addi	s0,sp,32
  50:	fe843783          	ld	a5,-24(s0)
  54:	0dc00893          	li	a7,220
  58:	00000073          	ecall
  5c:	00050793          	mv	a5,a0
  60:	fef43423          	sd	a5,-24(s0)
  64:	fe843783          	ld	a5,-24(s0)
  68:	00078513          	mv	a0,a5
  6c:	01813083          	ld	ra,24(sp)
  70:	01013403          	ld	s0,16(sp)
  74:	02010113          	addi	sp,sp,32
  78:	00008067          	ret

Disassembly of section .text.wait:

000000000000007c <wait>:
  7c:	fd010113          	addi	sp,sp,-48
  80:	02113423          	sd	ra,40(sp)
  84:	02813023          	sd	s0,32(sp)
  88:	03010413          	addi	s0,sp,48
  8c:	00050793          	mv	a5,a0
  90:	fcf42e23          	sw	a5,-36(s0)
  94:	fe042623          	sw	zero,-20(s0)
  98:	0100006f          	j	a8 <wait+0x2c>
  9c:	fec42783          	lw	a5,-20(s0)
  a0:	0017879b          	addiw	a5,a5,1
  a4:	fef42623          	sw	a5,-20(s0)
  a8:	fec42783          	lw	a5,-20(s0)
  ac:	00078713          	mv	a4,a5
  b0:	fdc42783          	lw	a5,-36(s0)
  b4:	0007071b          	sext.w	a4,a4
  b8:	0007879b          	sext.w	a5,a5
  bc:	fef760e3          	bltu	a4,a5,9c <wait+0x20>
  c0:	00000013          	nop
  c4:	00000013          	nop
  c8:	02813083          	ld	ra,40(sp)
  cc:	02013403          	ld	s0,32(sp)
  d0:	03010113          	addi	sp,sp,48
  d4:	00008067          	ret

Disassembly of section .text.main:

00000000000000d8 <main>:
  d8:	ff010113          	addi	sp,sp,-16
  dc:	00113423          	sd	ra,8(sp)
  e0:	00813023          	sd	s0,0(sp)
  e4:	01010413          	addi	s0,sp,16
  e8:	00000097          	auipc	ra,0x0
  ec:	f1c080e7          	jalr	-228(ra) # 4 <getpid>
  f0:	00050593          	mv	a1,a0
  f4:	00001797          	auipc	a5,0x1
  f8:	34078793          	addi	a5,a5,832 # 1434 <global_variable>
  fc:	0007a783          	lw	a5,0(a5)
 100:	0017871b          	addiw	a4,a5,1
 104:	0007069b          	sext.w	a3,a4
 108:	00001717          	auipc	a4,0x1
 10c:	32c70713          	addi	a4,a4,812 # 1434 <global_variable>
 110:	00d72023          	sw	a3,0(a4)
 114:	00078613          	mv	a2,a5
 118:	00001517          	auipc	a0,0x1
 11c:	29850513          	addi	a0,a0,664 # 13b0 <printf+0x2d8>
 120:	00001097          	auipc	ra,0x1
 124:	fb8080e7          	jalr	-72(ra) # 10d8 <printf>
 128:	00000097          	auipc	ra,0x0
 12c:	f18080e7          	jalr	-232(ra) # 40 <fork>
 130:	00000097          	auipc	ra,0x0
 134:	f10080e7          	jalr	-240(ra) # 40 <fork>
 138:	00000097          	auipc	ra,0x0
 13c:	ecc080e7          	jalr	-308(ra) # 4 <getpid>
 140:	00050593          	mv	a1,a0
 144:	00001797          	auipc	a5,0x1
 148:	2f078793          	addi	a5,a5,752 # 1434 <global_variable>
 14c:	0007a783          	lw	a5,0(a5)
 150:	0017871b          	addiw	a4,a5,1
 154:	0007069b          	sext.w	a3,a4
 158:	00001717          	auipc	a4,0x1
 15c:	2dc70713          	addi	a4,a4,732 # 1434 <global_variable>
 160:	00d72023          	sw	a3,0(a4)
 164:	00078613          	mv	a2,a5
 168:	00001517          	auipc	a0,0x1
 16c:	24850513          	addi	a0,a0,584 # 13b0 <printf+0x2d8>
 170:	00001097          	auipc	ra,0x1
 174:	f68080e7          	jalr	-152(ra) # 10d8 <printf>
 178:	00000097          	auipc	ra,0x0
 17c:	ec8080e7          	jalr	-312(ra) # 40 <fork>
 180:	00000097          	auipc	ra,0x0
 184:	e84080e7          	jalr	-380(ra) # 4 <getpid>
 188:	00050593          	mv	a1,a0
 18c:	00001797          	auipc	a5,0x1
 190:	2a878793          	addi	a5,a5,680 # 1434 <global_variable>
 194:	0007a783          	lw	a5,0(a5)
 198:	0017871b          	addiw	a4,a5,1
 19c:	0007069b          	sext.w	a3,a4
 1a0:	00001717          	auipc	a4,0x1
 1a4:	29470713          	addi	a4,a4,660 # 1434 <global_variable>
 1a8:	00d72023          	sw	a3,0(a4)
 1ac:	00078613          	mv	a2,a5
 1b0:	00001517          	auipc	a0,0x1
 1b4:	20050513          	addi	a0,a0,512 # 13b0 <printf+0x2d8>
 1b8:	00001097          	auipc	ra,0x1
 1bc:	f20080e7          	jalr	-224(ra) # 10d8 <printf>
 1c0:	500007b7          	lui	a5,0x50000
 1c4:	fff78513          	addi	a0,a5,-1 # 4fffffff <buffer+0x4fffebbf>
 1c8:	00000097          	auipc	ra,0x0
 1cc:	eb4080e7          	jalr	-332(ra) # 7c <wait>
 1d0:	00000013          	nop
 1d4:	fadff06f          	j	180 <main+0xa8>

Disassembly of section .text.putc:

00000000000001d8 <putc>:
 1d8:	fe010113          	addi	sp,sp,-32
 1dc:	00113c23          	sd	ra,24(sp)
 1e0:	00813823          	sd	s0,16(sp)
 1e4:	02010413          	addi	s0,sp,32
 1e8:	00050793          	mv	a5,a0
 1ec:	fef42623          	sw	a5,-20(s0)
 1f0:	00001797          	auipc	a5,0x1
 1f4:	24878793          	addi	a5,a5,584 # 1438 <tail>
 1f8:	0007a783          	lw	a5,0(a5)
 1fc:	0017871b          	addiw	a4,a5,1
 200:	0007069b          	sext.w	a3,a4
 204:	00001717          	auipc	a4,0x1
 208:	23470713          	addi	a4,a4,564 # 1438 <tail>
 20c:	00d72023          	sw	a3,0(a4)
 210:	fec42703          	lw	a4,-20(s0)
 214:	0ff77713          	zext.b	a4,a4
 218:	00001697          	auipc	a3,0x1
 21c:	22868693          	addi	a3,a3,552 # 1440 <buffer>
 220:	00f687b3          	add	a5,a3,a5
 224:	00e78023          	sb	a4,0(a5)
 228:	fec42783          	lw	a5,-20(s0)
 22c:	0ff7f793          	zext.b	a5,a5
 230:	0007879b          	sext.w	a5,a5
 234:	00078513          	mv	a0,a5
 238:	01813083          	ld	ra,24(sp)
 23c:	01013403          	ld	s0,16(sp)
 240:	02010113          	addi	sp,sp,32
 244:	00008067          	ret

Disassembly of section .text.isspace:

0000000000000248 <isspace>:
 248:	fe010113          	addi	sp,sp,-32
 24c:	00113c23          	sd	ra,24(sp)
 250:	00813823          	sd	s0,16(sp)
 254:	02010413          	addi	s0,sp,32
 258:	00050793          	mv	a5,a0
 25c:	fef42623          	sw	a5,-20(s0)
 260:	fec42783          	lw	a5,-20(s0)
 264:	0007871b          	sext.w	a4,a5
 268:	02000793          	li	a5,32
 26c:	02f70263          	beq	a4,a5,290 <isspace+0x48>
 270:	fec42783          	lw	a5,-20(s0)
 274:	0007871b          	sext.w	a4,a5
 278:	00800793          	li	a5,8
 27c:	00e7de63          	bge	a5,a4,298 <isspace+0x50>
 280:	fec42783          	lw	a5,-20(s0)
 284:	0007871b          	sext.w	a4,a5
 288:	00d00793          	li	a5,13
 28c:	00e7c663          	blt	a5,a4,298 <isspace+0x50>
 290:	00100793          	li	a5,1
 294:	0080006f          	j	29c <isspace+0x54>
 298:	00000793          	li	a5,0
 29c:	00078513          	mv	a0,a5
 2a0:	01813083          	ld	ra,24(sp)
 2a4:	01013403          	ld	s0,16(sp)
 2a8:	02010113          	addi	sp,sp,32
 2ac:	00008067          	ret

Disassembly of section .text.strtol:

00000000000002b0 <strtol>:
 2b0:	fb010113          	addi	sp,sp,-80
 2b4:	04113423          	sd	ra,72(sp)
 2b8:	04813023          	sd	s0,64(sp)
 2bc:	05010413          	addi	s0,sp,80
 2c0:	fca43423          	sd	a0,-56(s0)
 2c4:	fcb43023          	sd	a1,-64(s0)
 2c8:	00060793          	mv	a5,a2
 2cc:	faf42e23          	sw	a5,-68(s0)
 2d0:	fe043423          	sd	zero,-24(s0)
 2d4:	fe0403a3          	sb	zero,-25(s0)
 2d8:	fc843783          	ld	a5,-56(s0)
 2dc:	fcf43c23          	sd	a5,-40(s0)
 2e0:	0100006f          	j	2f0 <strtol+0x40>
 2e4:	fd843783          	ld	a5,-40(s0)
 2e8:	00178793          	addi	a5,a5,1
 2ec:	fcf43c23          	sd	a5,-40(s0)
 2f0:	fd843783          	ld	a5,-40(s0)
 2f4:	0007c783          	lbu	a5,0(a5)
 2f8:	0007879b          	sext.w	a5,a5
 2fc:	00078513          	mv	a0,a5
 300:	00000097          	auipc	ra,0x0
 304:	f48080e7          	jalr	-184(ra) # 248 <isspace>
 308:	00050793          	mv	a5,a0
 30c:	fc079ce3          	bnez	a5,2e4 <strtol+0x34>
 310:	fd843783          	ld	a5,-40(s0)
 314:	0007c783          	lbu	a5,0(a5)
 318:	00078713          	mv	a4,a5
 31c:	02d00793          	li	a5,45
 320:	00f71e63          	bne	a4,a5,33c <strtol+0x8c>
 324:	00100793          	li	a5,1
 328:	fef403a3          	sb	a5,-25(s0)
 32c:	fd843783          	ld	a5,-40(s0)
 330:	00178793          	addi	a5,a5,1
 334:	fcf43c23          	sd	a5,-40(s0)
 338:	0240006f          	j	35c <strtol+0xac>
 33c:	fd843783          	ld	a5,-40(s0)
 340:	0007c783          	lbu	a5,0(a5)
 344:	00078713          	mv	a4,a5
 348:	02b00793          	li	a5,43
 34c:	00f71863          	bne	a4,a5,35c <strtol+0xac>
 350:	fd843783          	ld	a5,-40(s0)
 354:	00178793          	addi	a5,a5,1
 358:	fcf43c23          	sd	a5,-40(s0)
 35c:	fbc42783          	lw	a5,-68(s0)
 360:	0007879b          	sext.w	a5,a5
 364:	06079c63          	bnez	a5,3dc <strtol+0x12c>
 368:	fd843783          	ld	a5,-40(s0)
 36c:	0007c783          	lbu	a5,0(a5)
 370:	00078713          	mv	a4,a5
 374:	03000793          	li	a5,48
 378:	04f71e63          	bne	a4,a5,3d4 <strtol+0x124>
 37c:	fd843783          	ld	a5,-40(s0)
 380:	00178793          	addi	a5,a5,1
 384:	fcf43c23          	sd	a5,-40(s0)
 388:	fd843783          	ld	a5,-40(s0)
 38c:	0007c783          	lbu	a5,0(a5)
 390:	00078713          	mv	a4,a5
 394:	07800793          	li	a5,120
 398:	00f70c63          	beq	a4,a5,3b0 <strtol+0x100>
 39c:	fd843783          	ld	a5,-40(s0)
 3a0:	0007c783          	lbu	a5,0(a5)
 3a4:	00078713          	mv	a4,a5
 3a8:	05800793          	li	a5,88
 3ac:	00f71e63          	bne	a4,a5,3c8 <strtol+0x118>
 3b0:	01000793          	li	a5,16
 3b4:	faf42e23          	sw	a5,-68(s0)
 3b8:	fd843783          	ld	a5,-40(s0)
 3bc:	00178793          	addi	a5,a5,1
 3c0:	fcf43c23          	sd	a5,-40(s0)
 3c4:	0180006f          	j	3dc <strtol+0x12c>
 3c8:	00800793          	li	a5,8
 3cc:	faf42e23          	sw	a5,-68(s0)
 3d0:	00c0006f          	j	3dc <strtol+0x12c>
 3d4:	00a00793          	li	a5,10
 3d8:	faf42e23          	sw	a5,-68(s0)
 3dc:	fd843783          	ld	a5,-40(s0)
 3e0:	0007c783          	lbu	a5,0(a5)
 3e4:	00078713          	mv	a4,a5
 3e8:	02f00793          	li	a5,47
 3ec:	02e7f863          	bgeu	a5,a4,41c <strtol+0x16c>
 3f0:	fd843783          	ld	a5,-40(s0)
 3f4:	0007c783          	lbu	a5,0(a5)
 3f8:	00078713          	mv	a4,a5
 3fc:	03900793          	li	a5,57
 400:	00e7ee63          	bltu	a5,a4,41c <strtol+0x16c>
 404:	fd843783          	ld	a5,-40(s0)
 408:	0007c783          	lbu	a5,0(a5)
 40c:	0007879b          	sext.w	a5,a5
 410:	fd07879b          	addiw	a5,a5,-48
 414:	fcf42a23          	sw	a5,-44(s0)
 418:	0800006f          	j	498 <strtol+0x1e8>
 41c:	fd843783          	ld	a5,-40(s0)
 420:	0007c783          	lbu	a5,0(a5)
 424:	00078713          	mv	a4,a5
 428:	06000793          	li	a5,96
 42c:	02e7f863          	bgeu	a5,a4,45c <strtol+0x1ac>
 430:	fd843783          	ld	a5,-40(s0)
 434:	0007c783          	lbu	a5,0(a5)
 438:	00078713          	mv	a4,a5
 43c:	07a00793          	li	a5,122
 440:	00e7ee63          	bltu	a5,a4,45c <strtol+0x1ac>
 444:	fd843783          	ld	a5,-40(s0)
 448:	0007c783          	lbu	a5,0(a5)
 44c:	0007879b          	sext.w	a5,a5
 450:	fa97879b          	addiw	a5,a5,-87
 454:	fcf42a23          	sw	a5,-44(s0)
 458:	0400006f          	j	498 <strtol+0x1e8>
 45c:	fd843783          	ld	a5,-40(s0)
 460:	0007c783          	lbu	a5,0(a5)
 464:	00078713          	mv	a4,a5
 468:	04000793          	li	a5,64
 46c:	06e7f863          	bgeu	a5,a4,4dc <strtol+0x22c>
 470:	fd843783          	ld	a5,-40(s0)
 474:	0007c783          	lbu	a5,0(a5)
 478:	00078713          	mv	a4,a5
 47c:	05a00793          	li	a5,90
 480:	04e7ee63          	bltu	a5,a4,4dc <strtol+0x22c>
 484:	fd843783          	ld	a5,-40(s0)
 488:	0007c783          	lbu	a5,0(a5)
 48c:	0007879b          	sext.w	a5,a5
 490:	fc97879b          	addiw	a5,a5,-55
 494:	fcf42a23          	sw	a5,-44(s0)
 498:	fd442783          	lw	a5,-44(s0)
 49c:	00078713          	mv	a4,a5
 4a0:	fbc42783          	lw	a5,-68(s0)
 4a4:	0007071b          	sext.w	a4,a4
 4a8:	0007879b          	sext.w	a5,a5
 4ac:	02f75663          	bge	a4,a5,4d8 <strtol+0x228>
 4b0:	fbc42703          	lw	a4,-68(s0)
 4b4:	fe843783          	ld	a5,-24(s0)
 4b8:	02f70733          	mul	a4,a4,a5
 4bc:	fd442783          	lw	a5,-44(s0)
 4c0:	00f707b3          	add	a5,a4,a5
 4c4:	fef43423          	sd	a5,-24(s0)
 4c8:	fd843783          	ld	a5,-40(s0)
 4cc:	00178793          	addi	a5,a5,1
 4d0:	fcf43c23          	sd	a5,-40(s0)
 4d4:	f09ff06f          	j	3dc <strtol+0x12c>
 4d8:	00000013          	nop
 4dc:	fc043783          	ld	a5,-64(s0)
 4e0:	00078863          	beqz	a5,4f0 <strtol+0x240>
 4e4:	fc043783          	ld	a5,-64(s0)
 4e8:	fd843703          	ld	a4,-40(s0)
 4ec:	00e7b023          	sd	a4,0(a5)
 4f0:	fe744783          	lbu	a5,-25(s0)
 4f4:	0ff7f793          	zext.b	a5,a5
 4f8:	00078863          	beqz	a5,508 <strtol+0x258>
 4fc:	fe843783          	ld	a5,-24(s0)
 500:	40f007b3          	neg	a5,a5
 504:	0080006f          	j	50c <strtol+0x25c>
 508:	fe843783          	ld	a5,-24(s0)
 50c:	00078513          	mv	a0,a5
 510:	04813083          	ld	ra,72(sp)
 514:	04013403          	ld	s0,64(sp)
 518:	05010113          	addi	sp,sp,80
 51c:	00008067          	ret

Disassembly of section .text.puts_wo_nl:

0000000000000520 <puts_wo_nl>:
 520:	fd010113          	addi	sp,sp,-48
 524:	02113423          	sd	ra,40(sp)
 528:	02813023          	sd	s0,32(sp)
 52c:	03010413          	addi	s0,sp,48
 530:	fca43c23          	sd	a0,-40(s0)
 534:	fcb43823          	sd	a1,-48(s0)
 538:	fd043783          	ld	a5,-48(s0)
 53c:	00079863          	bnez	a5,54c <puts_wo_nl+0x2c>
 540:	00001797          	auipc	a5,0x1
 544:	ea078793          	addi	a5,a5,-352 # 13e0 <printf+0x308>
 548:	fcf43823          	sd	a5,-48(s0)
 54c:	fd043783          	ld	a5,-48(s0)
 550:	fef43423          	sd	a5,-24(s0)
 554:	0240006f          	j	578 <puts_wo_nl+0x58>
 558:	fe843783          	ld	a5,-24(s0)
 55c:	00178713          	addi	a4,a5,1
 560:	fee43423          	sd	a4,-24(s0)
 564:	0007c783          	lbu	a5,0(a5)
 568:	0007871b          	sext.w	a4,a5
 56c:	fd843783          	ld	a5,-40(s0)
 570:	00070513          	mv	a0,a4
 574:	000780e7          	jalr	a5
 578:	fe843783          	ld	a5,-24(s0)
 57c:	0007c783          	lbu	a5,0(a5)
 580:	fc079ce3          	bnez	a5,558 <puts_wo_nl+0x38>
 584:	fe843703          	ld	a4,-24(s0)
 588:	fd043783          	ld	a5,-48(s0)
 58c:	40f707b3          	sub	a5,a4,a5
 590:	0007879b          	sext.w	a5,a5
 594:	00078513          	mv	a0,a5
 598:	02813083          	ld	ra,40(sp)
 59c:	02013403          	ld	s0,32(sp)
 5a0:	03010113          	addi	sp,sp,48
 5a4:	00008067          	ret

Disassembly of section .text.print_dec_int:

00000000000005a8 <print_dec_int>:
 5a8:	f9010113          	addi	sp,sp,-112
 5ac:	06113423          	sd	ra,104(sp)
 5b0:	06813023          	sd	s0,96(sp)
 5b4:	07010413          	addi	s0,sp,112
 5b8:	faa43423          	sd	a0,-88(s0)
 5bc:	fab43023          	sd	a1,-96(s0)
 5c0:	00060793          	mv	a5,a2
 5c4:	f8d43823          	sd	a3,-112(s0)
 5c8:	f8f40fa3          	sb	a5,-97(s0)
 5cc:	f9f44783          	lbu	a5,-97(s0)
 5d0:	0ff7f793          	zext.b	a5,a5
 5d4:	02078863          	beqz	a5,604 <print_dec_int+0x5c>
 5d8:	fa043703          	ld	a4,-96(s0)
 5dc:	fff00793          	li	a5,-1
 5e0:	03f79793          	slli	a5,a5,0x3f
 5e4:	02f71063          	bne	a4,a5,604 <print_dec_int+0x5c>
 5e8:	00001597          	auipc	a1,0x1
 5ec:	e0058593          	addi	a1,a1,-512 # 13e8 <printf+0x310>
 5f0:	fa843503          	ld	a0,-88(s0)
 5f4:	00000097          	auipc	ra,0x0
 5f8:	f2c080e7          	jalr	-212(ra) # 520 <puts_wo_nl>
 5fc:	00050793          	mv	a5,a0
 600:	2c80006f          	j	8c8 <print_dec_int+0x320>
 604:	f9043783          	ld	a5,-112(s0)
 608:	00c7a783          	lw	a5,12(a5)
 60c:	00079a63          	bnez	a5,620 <print_dec_int+0x78>
 610:	fa043783          	ld	a5,-96(s0)
 614:	00079663          	bnez	a5,620 <print_dec_int+0x78>
 618:	00000793          	li	a5,0
 61c:	2ac0006f          	j	8c8 <print_dec_int+0x320>
 620:	fe0407a3          	sb	zero,-17(s0)
 624:	f9f44783          	lbu	a5,-97(s0)
 628:	0ff7f793          	zext.b	a5,a5
 62c:	02078063          	beqz	a5,64c <print_dec_int+0xa4>
 630:	fa043783          	ld	a5,-96(s0)
 634:	0007dc63          	bgez	a5,64c <print_dec_int+0xa4>
 638:	00100793          	li	a5,1
 63c:	fef407a3          	sb	a5,-17(s0)
 640:	fa043783          	ld	a5,-96(s0)
 644:	40f007b3          	neg	a5,a5
 648:	faf43023          	sd	a5,-96(s0)
 64c:	fe042423          	sw	zero,-24(s0)
 650:	f9f44783          	lbu	a5,-97(s0)
 654:	0ff7f793          	zext.b	a5,a5
 658:	02078863          	beqz	a5,688 <print_dec_int+0xe0>
 65c:	fef44783          	lbu	a5,-17(s0)
 660:	0ff7f793          	zext.b	a5,a5
 664:	00079e63          	bnez	a5,680 <print_dec_int+0xd8>
 668:	f9043783          	ld	a5,-112(s0)
 66c:	0057c783          	lbu	a5,5(a5)
 670:	00079863          	bnez	a5,680 <print_dec_int+0xd8>
 674:	f9043783          	ld	a5,-112(s0)
 678:	0047c783          	lbu	a5,4(a5)
 67c:	00078663          	beqz	a5,688 <print_dec_int+0xe0>
 680:	00100793          	li	a5,1
 684:	0080006f          	j	68c <print_dec_int+0xe4>
 688:	00000793          	li	a5,0
 68c:	fcf40ba3          	sb	a5,-41(s0)
 690:	fd744783          	lbu	a5,-41(s0)
 694:	0017f793          	andi	a5,a5,1
 698:	fcf40ba3          	sb	a5,-41(s0)
 69c:	fa043683          	ld	a3,-96(s0)
 6a0:	00001797          	auipc	a5,0x1
 6a4:	d6078793          	addi	a5,a5,-672 # 1400 <printf+0x328>
 6a8:	0007b783          	ld	a5,0(a5)
 6ac:	02f6b7b3          	mulhu	a5,a3,a5
 6b0:	0037d713          	srli	a4,a5,0x3
 6b4:	00070793          	mv	a5,a4
 6b8:	00279793          	slli	a5,a5,0x2
 6bc:	00e787b3          	add	a5,a5,a4
 6c0:	00179793          	slli	a5,a5,0x1
 6c4:	40f68733          	sub	a4,a3,a5
 6c8:	0ff77713          	zext.b	a4,a4
 6cc:	fe842783          	lw	a5,-24(s0)
 6d0:	0017869b          	addiw	a3,a5,1
 6d4:	fed42423          	sw	a3,-24(s0)
 6d8:	0307071b          	addiw	a4,a4,48
 6dc:	0ff77713          	zext.b	a4,a4
 6e0:	ff078793          	addi	a5,a5,-16
 6e4:	008787b3          	add	a5,a5,s0
 6e8:	fce78423          	sb	a4,-56(a5)
 6ec:	fa043703          	ld	a4,-96(s0)
 6f0:	00001797          	auipc	a5,0x1
 6f4:	d1078793          	addi	a5,a5,-752 # 1400 <printf+0x328>
 6f8:	0007b783          	ld	a5,0(a5)
 6fc:	02f737b3          	mulhu	a5,a4,a5
 700:	0037d793          	srli	a5,a5,0x3
 704:	faf43023          	sd	a5,-96(s0)
 708:	fa043783          	ld	a5,-96(s0)
 70c:	f80798e3          	bnez	a5,69c <print_dec_int+0xf4>
 710:	f9043783          	ld	a5,-112(s0)
 714:	00c7a703          	lw	a4,12(a5)
 718:	fff00793          	li	a5,-1
 71c:	02f71063          	bne	a4,a5,73c <print_dec_int+0x194>
 720:	f9043783          	ld	a5,-112(s0)
 724:	0037c783          	lbu	a5,3(a5)
 728:	00078a63          	beqz	a5,73c <print_dec_int+0x194>
 72c:	f9043783          	ld	a5,-112(s0)
 730:	0087a703          	lw	a4,8(a5)
 734:	f9043783          	ld	a5,-112(s0)
 738:	00e7a623          	sw	a4,12(a5)
 73c:	fe042223          	sw	zero,-28(s0)
 740:	f9043783          	ld	a5,-112(s0)
 744:	0087a703          	lw	a4,8(a5)
 748:	fe842783          	lw	a5,-24(s0)
 74c:	fcf42823          	sw	a5,-48(s0)
 750:	f9043783          	ld	a5,-112(s0)
 754:	00c7a783          	lw	a5,12(a5)
 758:	fcf42623          	sw	a5,-52(s0)
 75c:	fd042783          	lw	a5,-48(s0)
 760:	00078593          	mv	a1,a5
 764:	fcc42783          	lw	a5,-52(s0)
 768:	00078613          	mv	a2,a5
 76c:	0006069b          	sext.w	a3,a2
 770:	0005879b          	sext.w	a5,a1
 774:	00f6d463          	bge	a3,a5,77c <print_dec_int+0x1d4>
 778:	00058613          	mv	a2,a1
 77c:	0006079b          	sext.w	a5,a2
 780:	40f707bb          	subw	a5,a4,a5
 784:	0007871b          	sext.w	a4,a5
 788:	fd744783          	lbu	a5,-41(s0)
 78c:	0007879b          	sext.w	a5,a5
 790:	40f707bb          	subw	a5,a4,a5
 794:	fef42023          	sw	a5,-32(s0)
 798:	0280006f          	j	7c0 <print_dec_int+0x218>
 79c:	fa843783          	ld	a5,-88(s0)
 7a0:	02000513          	li	a0,32
 7a4:	000780e7          	jalr	a5
 7a8:	fe442783          	lw	a5,-28(s0)
 7ac:	0017879b          	addiw	a5,a5,1
 7b0:	fef42223          	sw	a5,-28(s0)
 7b4:	fe042783          	lw	a5,-32(s0)
 7b8:	fff7879b          	addiw	a5,a5,-1
 7bc:	fef42023          	sw	a5,-32(s0)
 7c0:	fe042783          	lw	a5,-32(s0)
 7c4:	0007879b          	sext.w	a5,a5
 7c8:	fcf04ae3          	bgtz	a5,79c <print_dec_int+0x1f4>
 7cc:	fd744783          	lbu	a5,-41(s0)
 7d0:	0ff7f793          	zext.b	a5,a5
 7d4:	04078463          	beqz	a5,81c <print_dec_int+0x274>
 7d8:	fef44783          	lbu	a5,-17(s0)
 7dc:	0ff7f793          	zext.b	a5,a5
 7e0:	00078663          	beqz	a5,7ec <print_dec_int+0x244>
 7e4:	02d00793          	li	a5,45
 7e8:	01c0006f          	j	804 <print_dec_int+0x25c>
 7ec:	f9043783          	ld	a5,-112(s0)
 7f0:	0057c783          	lbu	a5,5(a5)
 7f4:	00078663          	beqz	a5,800 <print_dec_int+0x258>
 7f8:	02b00793          	li	a5,43
 7fc:	0080006f          	j	804 <print_dec_int+0x25c>
 800:	02000793          	li	a5,32
 804:	fa843703          	ld	a4,-88(s0)
 808:	00078513          	mv	a0,a5
 80c:	000700e7          	jalr	a4
 810:	fe442783          	lw	a5,-28(s0)
 814:	0017879b          	addiw	a5,a5,1
 818:	fef42223          	sw	a5,-28(s0)
 81c:	fe842783          	lw	a5,-24(s0)
 820:	fcf42e23          	sw	a5,-36(s0)
 824:	0280006f          	j	84c <print_dec_int+0x2a4>
 828:	fa843783          	ld	a5,-88(s0)
 82c:	03000513          	li	a0,48
 830:	000780e7          	jalr	a5
 834:	fe442783          	lw	a5,-28(s0)
 838:	0017879b          	addiw	a5,a5,1
 83c:	fef42223          	sw	a5,-28(s0)
 840:	fdc42783          	lw	a5,-36(s0)
 844:	0017879b          	addiw	a5,a5,1
 848:	fcf42e23          	sw	a5,-36(s0)
 84c:	f9043783          	ld	a5,-112(s0)
 850:	00c7a703          	lw	a4,12(a5)
 854:	fd744783          	lbu	a5,-41(s0)
 858:	0007879b          	sext.w	a5,a5
 85c:	40f707bb          	subw	a5,a4,a5
 860:	0007879b          	sext.w	a5,a5
 864:	fdc42703          	lw	a4,-36(s0)
 868:	0007071b          	sext.w	a4,a4
 86c:	faf74ee3          	blt	a4,a5,828 <print_dec_int+0x280>
 870:	fe842783          	lw	a5,-24(s0)
 874:	fff7879b          	addiw	a5,a5,-1
 878:	fcf42c23          	sw	a5,-40(s0)
 87c:	03c0006f          	j	8b8 <print_dec_int+0x310>
 880:	fd842783          	lw	a5,-40(s0)
 884:	ff078793          	addi	a5,a5,-16
 888:	008787b3          	add	a5,a5,s0
 88c:	fc87c783          	lbu	a5,-56(a5)
 890:	0007871b          	sext.w	a4,a5
 894:	fa843783          	ld	a5,-88(s0)
 898:	00070513          	mv	a0,a4
 89c:	000780e7          	jalr	a5
 8a0:	fe442783          	lw	a5,-28(s0)
 8a4:	0017879b          	addiw	a5,a5,1
 8a8:	fef42223          	sw	a5,-28(s0)
 8ac:	fd842783          	lw	a5,-40(s0)
 8b0:	fff7879b          	addiw	a5,a5,-1
 8b4:	fcf42c23          	sw	a5,-40(s0)
 8b8:	fd842783          	lw	a5,-40(s0)
 8bc:	0007879b          	sext.w	a5,a5
 8c0:	fc07d0e3          	bgez	a5,880 <print_dec_int+0x2d8>
 8c4:	fe442783          	lw	a5,-28(s0)
 8c8:	00078513          	mv	a0,a5
 8cc:	06813083          	ld	ra,104(sp)
 8d0:	06013403          	ld	s0,96(sp)
 8d4:	07010113          	addi	sp,sp,112
 8d8:	00008067          	ret

Disassembly of section .text.vprintfmt:

00000000000008dc <vprintfmt>:
     8dc:	f4010113          	addi	sp,sp,-192
     8e0:	0a113c23          	sd	ra,184(sp)
     8e4:	0a813823          	sd	s0,176(sp)
     8e8:	0c010413          	addi	s0,sp,192
     8ec:	f4a43c23          	sd	a0,-168(s0)
     8f0:	f4b43823          	sd	a1,-176(s0)
     8f4:	f4c43423          	sd	a2,-184(s0)
     8f8:	f8043023          	sd	zero,-128(s0)
     8fc:	f8043423          	sd	zero,-120(s0)
     900:	fe042623          	sw	zero,-20(s0)
     904:	7b00006f          	j	10b4 <vprintfmt+0x7d8>
     908:	f8044783          	lbu	a5,-128(s0)
     90c:	74078463          	beqz	a5,1054 <vprintfmt+0x778>
     910:	f5043783          	ld	a5,-176(s0)
     914:	0007c783          	lbu	a5,0(a5)
     918:	00078713          	mv	a4,a5
     91c:	02300793          	li	a5,35
     920:	00f71863          	bne	a4,a5,930 <vprintfmt+0x54>
     924:	00100793          	li	a5,1
     928:	f8f40123          	sb	a5,-126(s0)
     92c:	77c0006f          	j	10a8 <vprintfmt+0x7cc>
     930:	f5043783          	ld	a5,-176(s0)
     934:	0007c783          	lbu	a5,0(a5)
     938:	00078713          	mv	a4,a5
     93c:	03000793          	li	a5,48
     940:	00f71863          	bne	a4,a5,950 <vprintfmt+0x74>
     944:	00100793          	li	a5,1
     948:	f8f401a3          	sb	a5,-125(s0)
     94c:	75c0006f          	j	10a8 <vprintfmt+0x7cc>
     950:	f5043783          	ld	a5,-176(s0)
     954:	0007c783          	lbu	a5,0(a5)
     958:	00078713          	mv	a4,a5
     95c:	06c00793          	li	a5,108
     960:	04f70063          	beq	a4,a5,9a0 <vprintfmt+0xc4>
     964:	f5043783          	ld	a5,-176(s0)
     968:	0007c783          	lbu	a5,0(a5)
     96c:	00078713          	mv	a4,a5
     970:	07a00793          	li	a5,122
     974:	02f70663          	beq	a4,a5,9a0 <vprintfmt+0xc4>
     978:	f5043783          	ld	a5,-176(s0)
     97c:	0007c783          	lbu	a5,0(a5)
     980:	00078713          	mv	a4,a5
     984:	07400793          	li	a5,116
     988:	00f70c63          	beq	a4,a5,9a0 <vprintfmt+0xc4>
     98c:	f5043783          	ld	a5,-176(s0)
     990:	0007c783          	lbu	a5,0(a5)
     994:	00078713          	mv	a4,a5
     998:	06a00793          	li	a5,106
     99c:	00f71863          	bne	a4,a5,9ac <vprintfmt+0xd0>
     9a0:	00100793          	li	a5,1
     9a4:	f8f400a3          	sb	a5,-127(s0)
     9a8:	7000006f          	j	10a8 <vprintfmt+0x7cc>
     9ac:	f5043783          	ld	a5,-176(s0)
     9b0:	0007c783          	lbu	a5,0(a5)
     9b4:	00078713          	mv	a4,a5
     9b8:	02b00793          	li	a5,43
     9bc:	00f71863          	bne	a4,a5,9cc <vprintfmt+0xf0>
     9c0:	00100793          	li	a5,1
     9c4:	f8f402a3          	sb	a5,-123(s0)
     9c8:	6e00006f          	j	10a8 <vprintfmt+0x7cc>
     9cc:	f5043783          	ld	a5,-176(s0)
     9d0:	0007c783          	lbu	a5,0(a5)
     9d4:	00078713          	mv	a4,a5
     9d8:	02000793          	li	a5,32
     9dc:	00f71863          	bne	a4,a5,9ec <vprintfmt+0x110>
     9e0:	00100793          	li	a5,1
     9e4:	f8f40223          	sb	a5,-124(s0)
     9e8:	6c00006f          	j	10a8 <vprintfmt+0x7cc>
     9ec:	f5043783          	ld	a5,-176(s0)
     9f0:	0007c783          	lbu	a5,0(a5)
     9f4:	00078713          	mv	a4,a5
     9f8:	02a00793          	li	a5,42
     9fc:	00f71e63          	bne	a4,a5,a18 <vprintfmt+0x13c>
     a00:	f4843783          	ld	a5,-184(s0)
     a04:	00878713          	addi	a4,a5,8
     a08:	f4e43423          	sd	a4,-184(s0)
     a0c:	0007a783          	lw	a5,0(a5)
     a10:	f8f42423          	sw	a5,-120(s0)
     a14:	6940006f          	j	10a8 <vprintfmt+0x7cc>
     a18:	f5043783          	ld	a5,-176(s0)
     a1c:	0007c783          	lbu	a5,0(a5)
     a20:	00078713          	mv	a4,a5
     a24:	03000793          	li	a5,48
     a28:	04e7f863          	bgeu	a5,a4,a78 <vprintfmt+0x19c>
     a2c:	f5043783          	ld	a5,-176(s0)
     a30:	0007c783          	lbu	a5,0(a5)
     a34:	00078713          	mv	a4,a5
     a38:	03900793          	li	a5,57
     a3c:	02e7ee63          	bltu	a5,a4,a78 <vprintfmt+0x19c>
     a40:	f5043783          	ld	a5,-176(s0)
     a44:	f5040713          	addi	a4,s0,-176
     a48:	00a00613          	li	a2,10
     a4c:	00070593          	mv	a1,a4
     a50:	00078513          	mv	a0,a5
     a54:	00000097          	auipc	ra,0x0
     a58:	85c080e7          	jalr	-1956(ra) # 2b0 <strtol>
     a5c:	00050793          	mv	a5,a0
     a60:	0007879b          	sext.w	a5,a5
     a64:	f8f42423          	sw	a5,-120(s0)
     a68:	f5043783          	ld	a5,-176(s0)
     a6c:	fff78793          	addi	a5,a5,-1
     a70:	f4f43823          	sd	a5,-176(s0)
     a74:	6340006f          	j	10a8 <vprintfmt+0x7cc>
     a78:	f5043783          	ld	a5,-176(s0)
     a7c:	0007c783          	lbu	a5,0(a5)
     a80:	00078713          	mv	a4,a5
     a84:	02e00793          	li	a5,46
     a88:	06f71a63          	bne	a4,a5,afc <vprintfmt+0x220>
     a8c:	f5043783          	ld	a5,-176(s0)
     a90:	00178793          	addi	a5,a5,1
     a94:	f4f43823          	sd	a5,-176(s0)
     a98:	f5043783          	ld	a5,-176(s0)
     a9c:	0007c783          	lbu	a5,0(a5)
     aa0:	00078713          	mv	a4,a5
     aa4:	02a00793          	li	a5,42
     aa8:	00f71e63          	bne	a4,a5,ac4 <vprintfmt+0x1e8>
     aac:	f4843783          	ld	a5,-184(s0)
     ab0:	00878713          	addi	a4,a5,8
     ab4:	f4e43423          	sd	a4,-184(s0)
     ab8:	0007a783          	lw	a5,0(a5)
     abc:	f8f42623          	sw	a5,-116(s0)
     ac0:	5e80006f          	j	10a8 <vprintfmt+0x7cc>
     ac4:	f5043783          	ld	a5,-176(s0)
     ac8:	f5040713          	addi	a4,s0,-176
     acc:	00a00613          	li	a2,10
     ad0:	00070593          	mv	a1,a4
     ad4:	00078513          	mv	a0,a5
     ad8:	fffff097          	auipc	ra,0xfffff
     adc:	7d8080e7          	jalr	2008(ra) # 2b0 <strtol>
     ae0:	00050793          	mv	a5,a0
     ae4:	0007879b          	sext.w	a5,a5
     ae8:	f8f42623          	sw	a5,-116(s0)
     aec:	f5043783          	ld	a5,-176(s0)
     af0:	fff78793          	addi	a5,a5,-1
     af4:	f4f43823          	sd	a5,-176(s0)
     af8:	5b00006f          	j	10a8 <vprintfmt+0x7cc>
     afc:	f5043783          	ld	a5,-176(s0)
     b00:	0007c783          	lbu	a5,0(a5)
     b04:	00078713          	mv	a4,a5
     b08:	07800793          	li	a5,120
     b0c:	02f70663          	beq	a4,a5,b38 <vprintfmt+0x25c>
     b10:	f5043783          	ld	a5,-176(s0)
     b14:	0007c783          	lbu	a5,0(a5)
     b18:	00078713          	mv	a4,a5
     b1c:	05800793          	li	a5,88
     b20:	00f70c63          	beq	a4,a5,b38 <vprintfmt+0x25c>
     b24:	f5043783          	ld	a5,-176(s0)
     b28:	0007c783          	lbu	a5,0(a5)
     b2c:	00078713          	mv	a4,a5
     b30:	07000793          	li	a5,112
     b34:	30f71063          	bne	a4,a5,e34 <vprintfmt+0x558>
     b38:	f5043783          	ld	a5,-176(s0)
     b3c:	0007c783          	lbu	a5,0(a5)
     b40:	00078713          	mv	a4,a5
     b44:	07000793          	li	a5,112
     b48:	00f70663          	beq	a4,a5,b54 <vprintfmt+0x278>
     b4c:	f8144783          	lbu	a5,-127(s0)
     b50:	00078663          	beqz	a5,b5c <vprintfmt+0x280>
     b54:	00100793          	li	a5,1
     b58:	0080006f          	j	b60 <vprintfmt+0x284>
     b5c:	00000793          	li	a5,0
     b60:	faf403a3          	sb	a5,-89(s0)
     b64:	fa744783          	lbu	a5,-89(s0)
     b68:	0017f793          	andi	a5,a5,1
     b6c:	faf403a3          	sb	a5,-89(s0)
     b70:	fa744783          	lbu	a5,-89(s0)
     b74:	0ff7f793          	zext.b	a5,a5
     b78:	00078c63          	beqz	a5,b90 <vprintfmt+0x2b4>
     b7c:	f4843783          	ld	a5,-184(s0)
     b80:	00878713          	addi	a4,a5,8
     b84:	f4e43423          	sd	a4,-184(s0)
     b88:	0007b783          	ld	a5,0(a5)
     b8c:	01c0006f          	j	ba8 <vprintfmt+0x2cc>
     b90:	f4843783          	ld	a5,-184(s0)
     b94:	00878713          	addi	a4,a5,8
     b98:	f4e43423          	sd	a4,-184(s0)
     b9c:	0007a783          	lw	a5,0(a5)
     ba0:	02079793          	slli	a5,a5,0x20
     ba4:	0207d793          	srli	a5,a5,0x20
     ba8:	fef43023          	sd	a5,-32(s0)
     bac:	f8c42783          	lw	a5,-116(s0)
     bb0:	02079463          	bnez	a5,bd8 <vprintfmt+0x2fc>
     bb4:	fe043783          	ld	a5,-32(s0)
     bb8:	02079063          	bnez	a5,bd8 <vprintfmt+0x2fc>
     bbc:	f5043783          	ld	a5,-176(s0)
     bc0:	0007c783          	lbu	a5,0(a5)
     bc4:	00078713          	mv	a4,a5
     bc8:	07000793          	li	a5,112
     bcc:	00f70663          	beq	a4,a5,bd8 <vprintfmt+0x2fc>
     bd0:	f8040023          	sb	zero,-128(s0)
     bd4:	4d40006f          	j	10a8 <vprintfmt+0x7cc>
     bd8:	f5043783          	ld	a5,-176(s0)
     bdc:	0007c783          	lbu	a5,0(a5)
     be0:	00078713          	mv	a4,a5
     be4:	07000793          	li	a5,112
     be8:	00f70a63          	beq	a4,a5,bfc <vprintfmt+0x320>
     bec:	f8244783          	lbu	a5,-126(s0)
     bf0:	00078a63          	beqz	a5,c04 <vprintfmt+0x328>
     bf4:	fe043783          	ld	a5,-32(s0)
     bf8:	00078663          	beqz	a5,c04 <vprintfmt+0x328>
     bfc:	00100793          	li	a5,1
     c00:	0080006f          	j	c08 <vprintfmt+0x32c>
     c04:	00000793          	li	a5,0
     c08:	faf40323          	sb	a5,-90(s0)
     c0c:	fa644783          	lbu	a5,-90(s0)
     c10:	0017f793          	andi	a5,a5,1
     c14:	faf40323          	sb	a5,-90(s0)
     c18:	fc042e23          	sw	zero,-36(s0)
     c1c:	f5043783          	ld	a5,-176(s0)
     c20:	0007c783          	lbu	a5,0(a5)
     c24:	00078713          	mv	a4,a5
     c28:	05800793          	li	a5,88
     c2c:	00f71863          	bne	a4,a5,c3c <vprintfmt+0x360>
     c30:	00000797          	auipc	a5,0x0
     c34:	7d878793          	addi	a5,a5,2008 # 1408 <upperxdigits.1>
     c38:	00c0006f          	j	c44 <vprintfmt+0x368>
     c3c:	00000797          	auipc	a5,0x0
     c40:	7e478793          	addi	a5,a5,2020 # 1420 <lowerxdigits.0>
     c44:	f8f43c23          	sd	a5,-104(s0)
     c48:	fe043783          	ld	a5,-32(s0)
     c4c:	00f7f793          	andi	a5,a5,15
     c50:	f9843703          	ld	a4,-104(s0)
     c54:	00f70733          	add	a4,a4,a5
     c58:	fdc42783          	lw	a5,-36(s0)
     c5c:	0017869b          	addiw	a3,a5,1
     c60:	fcd42e23          	sw	a3,-36(s0)
     c64:	00074703          	lbu	a4,0(a4)
     c68:	ff078793          	addi	a5,a5,-16
     c6c:	008787b3          	add	a5,a5,s0
     c70:	f8e78023          	sb	a4,-128(a5)
     c74:	fe043783          	ld	a5,-32(s0)
     c78:	0047d793          	srli	a5,a5,0x4
     c7c:	fef43023          	sd	a5,-32(s0)
     c80:	fe043783          	ld	a5,-32(s0)
     c84:	fc0792e3          	bnez	a5,c48 <vprintfmt+0x36c>
     c88:	f8c42703          	lw	a4,-116(s0)
     c8c:	fff00793          	li	a5,-1
     c90:	02f71663          	bne	a4,a5,cbc <vprintfmt+0x3e0>
     c94:	f8344783          	lbu	a5,-125(s0)
     c98:	02078263          	beqz	a5,cbc <vprintfmt+0x3e0>
     c9c:	f8842703          	lw	a4,-120(s0)
     ca0:	fa644783          	lbu	a5,-90(s0)
     ca4:	0007879b          	sext.w	a5,a5
     ca8:	0017979b          	slliw	a5,a5,0x1
     cac:	0007879b          	sext.w	a5,a5
     cb0:	40f707bb          	subw	a5,a4,a5
     cb4:	0007879b          	sext.w	a5,a5
     cb8:	f8f42623          	sw	a5,-116(s0)
     cbc:	f8842703          	lw	a4,-120(s0)
     cc0:	fa644783          	lbu	a5,-90(s0)
     cc4:	0007879b          	sext.w	a5,a5
     cc8:	0017979b          	slliw	a5,a5,0x1
     ccc:	0007879b          	sext.w	a5,a5
     cd0:	40f707bb          	subw	a5,a4,a5
     cd4:	0007871b          	sext.w	a4,a5
     cd8:	fdc42783          	lw	a5,-36(s0)
     cdc:	f8f42a23          	sw	a5,-108(s0)
     ce0:	f8c42783          	lw	a5,-116(s0)
     ce4:	f8f42823          	sw	a5,-112(s0)
     ce8:	f9442783          	lw	a5,-108(s0)
     cec:	00078593          	mv	a1,a5
     cf0:	f9042783          	lw	a5,-112(s0)
     cf4:	00078613          	mv	a2,a5
     cf8:	0006069b          	sext.w	a3,a2
     cfc:	0005879b          	sext.w	a5,a1
     d00:	00f6d463          	bge	a3,a5,d08 <vprintfmt+0x42c>
     d04:	00058613          	mv	a2,a1
     d08:	0006079b          	sext.w	a5,a2
     d0c:	40f707bb          	subw	a5,a4,a5
     d10:	fcf42c23          	sw	a5,-40(s0)
     d14:	0280006f          	j	d3c <vprintfmt+0x460>
     d18:	f5843783          	ld	a5,-168(s0)
     d1c:	02000513          	li	a0,32
     d20:	000780e7          	jalr	a5
     d24:	fec42783          	lw	a5,-20(s0)
     d28:	0017879b          	addiw	a5,a5,1
     d2c:	fef42623          	sw	a5,-20(s0)
     d30:	fd842783          	lw	a5,-40(s0)
     d34:	fff7879b          	addiw	a5,a5,-1
     d38:	fcf42c23          	sw	a5,-40(s0)
     d3c:	fd842783          	lw	a5,-40(s0)
     d40:	0007879b          	sext.w	a5,a5
     d44:	fcf04ae3          	bgtz	a5,d18 <vprintfmt+0x43c>
     d48:	fa644783          	lbu	a5,-90(s0)
     d4c:	0ff7f793          	zext.b	a5,a5
     d50:	04078463          	beqz	a5,d98 <vprintfmt+0x4bc>
     d54:	f5843783          	ld	a5,-168(s0)
     d58:	03000513          	li	a0,48
     d5c:	000780e7          	jalr	a5
     d60:	f5043783          	ld	a5,-176(s0)
     d64:	0007c783          	lbu	a5,0(a5)
     d68:	00078713          	mv	a4,a5
     d6c:	05800793          	li	a5,88
     d70:	00f71663          	bne	a4,a5,d7c <vprintfmt+0x4a0>
     d74:	05800793          	li	a5,88
     d78:	0080006f          	j	d80 <vprintfmt+0x4a4>
     d7c:	07800793          	li	a5,120
     d80:	f5843703          	ld	a4,-168(s0)
     d84:	00078513          	mv	a0,a5
     d88:	000700e7          	jalr	a4
     d8c:	fec42783          	lw	a5,-20(s0)
     d90:	0027879b          	addiw	a5,a5,2
     d94:	fef42623          	sw	a5,-20(s0)
     d98:	fdc42783          	lw	a5,-36(s0)
     d9c:	fcf42a23          	sw	a5,-44(s0)
     da0:	0280006f          	j	dc8 <vprintfmt+0x4ec>
     da4:	f5843783          	ld	a5,-168(s0)
     da8:	03000513          	li	a0,48
     dac:	000780e7          	jalr	a5
     db0:	fec42783          	lw	a5,-20(s0)
     db4:	0017879b          	addiw	a5,a5,1
     db8:	fef42623          	sw	a5,-20(s0)
     dbc:	fd442783          	lw	a5,-44(s0)
     dc0:	0017879b          	addiw	a5,a5,1
     dc4:	fcf42a23          	sw	a5,-44(s0)
     dc8:	f8c42783          	lw	a5,-116(s0)
     dcc:	fd442703          	lw	a4,-44(s0)
     dd0:	0007071b          	sext.w	a4,a4
     dd4:	fcf748e3          	blt	a4,a5,da4 <vprintfmt+0x4c8>
     dd8:	fdc42783          	lw	a5,-36(s0)
     ddc:	fff7879b          	addiw	a5,a5,-1
     de0:	fcf42823          	sw	a5,-48(s0)
     de4:	03c0006f          	j	e20 <vprintfmt+0x544>
     de8:	fd042783          	lw	a5,-48(s0)
     dec:	ff078793          	addi	a5,a5,-16
     df0:	008787b3          	add	a5,a5,s0
     df4:	f807c783          	lbu	a5,-128(a5)
     df8:	0007871b          	sext.w	a4,a5
     dfc:	f5843783          	ld	a5,-168(s0)
     e00:	00070513          	mv	a0,a4
     e04:	000780e7          	jalr	a5
     e08:	fec42783          	lw	a5,-20(s0)
     e0c:	0017879b          	addiw	a5,a5,1
     e10:	fef42623          	sw	a5,-20(s0)
     e14:	fd042783          	lw	a5,-48(s0)
     e18:	fff7879b          	addiw	a5,a5,-1
     e1c:	fcf42823          	sw	a5,-48(s0)
     e20:	fd042783          	lw	a5,-48(s0)
     e24:	0007879b          	sext.w	a5,a5
     e28:	fc07d0e3          	bgez	a5,de8 <vprintfmt+0x50c>
     e2c:	f8040023          	sb	zero,-128(s0)
     e30:	2780006f          	j	10a8 <vprintfmt+0x7cc>
     e34:	f5043783          	ld	a5,-176(s0)
     e38:	0007c783          	lbu	a5,0(a5)
     e3c:	00078713          	mv	a4,a5
     e40:	06400793          	li	a5,100
     e44:	02f70663          	beq	a4,a5,e70 <vprintfmt+0x594>
     e48:	f5043783          	ld	a5,-176(s0)
     e4c:	0007c783          	lbu	a5,0(a5)
     e50:	00078713          	mv	a4,a5
     e54:	06900793          	li	a5,105
     e58:	00f70c63          	beq	a4,a5,e70 <vprintfmt+0x594>
     e5c:	f5043783          	ld	a5,-176(s0)
     e60:	0007c783          	lbu	a5,0(a5)
     e64:	00078713          	mv	a4,a5
     e68:	07500793          	li	a5,117
     e6c:	08f71263          	bne	a4,a5,ef0 <vprintfmt+0x614>
     e70:	f8144783          	lbu	a5,-127(s0)
     e74:	00078c63          	beqz	a5,e8c <vprintfmt+0x5b0>
     e78:	f4843783          	ld	a5,-184(s0)
     e7c:	00878713          	addi	a4,a5,8
     e80:	f4e43423          	sd	a4,-184(s0)
     e84:	0007b783          	ld	a5,0(a5)
     e88:	0140006f          	j	e9c <vprintfmt+0x5c0>
     e8c:	f4843783          	ld	a5,-184(s0)
     e90:	00878713          	addi	a4,a5,8
     e94:	f4e43423          	sd	a4,-184(s0)
     e98:	0007a783          	lw	a5,0(a5)
     e9c:	faf43423          	sd	a5,-88(s0)
     ea0:	fa843583          	ld	a1,-88(s0)
     ea4:	f5043783          	ld	a5,-176(s0)
     ea8:	0007c783          	lbu	a5,0(a5)
     eac:	0007871b          	sext.w	a4,a5
     eb0:	07500793          	li	a5,117
     eb4:	40f707b3          	sub	a5,a4,a5
     eb8:	00f037b3          	snez	a5,a5
     ebc:	0ff7f793          	zext.b	a5,a5
     ec0:	f8040713          	addi	a4,s0,-128
     ec4:	00070693          	mv	a3,a4
     ec8:	00078613          	mv	a2,a5
     ecc:	f5843503          	ld	a0,-168(s0)
     ed0:	fffff097          	auipc	ra,0xfffff
     ed4:	6d8080e7          	jalr	1752(ra) # 5a8 <print_dec_int>
     ed8:	00050793          	mv	a5,a0
     edc:	fec42703          	lw	a4,-20(s0)
     ee0:	00f707bb          	addw	a5,a4,a5
     ee4:	fef42623          	sw	a5,-20(s0)
     ee8:	f8040023          	sb	zero,-128(s0)
     eec:	1bc0006f          	j	10a8 <vprintfmt+0x7cc>
     ef0:	f5043783          	ld	a5,-176(s0)
     ef4:	0007c783          	lbu	a5,0(a5)
     ef8:	00078713          	mv	a4,a5
     efc:	06e00793          	li	a5,110
     f00:	04f71c63          	bne	a4,a5,f58 <vprintfmt+0x67c>
     f04:	f8144783          	lbu	a5,-127(s0)
     f08:	02078463          	beqz	a5,f30 <vprintfmt+0x654>
     f0c:	f4843783          	ld	a5,-184(s0)
     f10:	00878713          	addi	a4,a5,8
     f14:	f4e43423          	sd	a4,-184(s0)
     f18:	0007b783          	ld	a5,0(a5)
     f1c:	faf43823          	sd	a5,-80(s0)
     f20:	fec42703          	lw	a4,-20(s0)
     f24:	fb043783          	ld	a5,-80(s0)
     f28:	00e7b023          	sd	a4,0(a5)
     f2c:	0240006f          	j	f50 <vprintfmt+0x674>
     f30:	f4843783          	ld	a5,-184(s0)
     f34:	00878713          	addi	a4,a5,8
     f38:	f4e43423          	sd	a4,-184(s0)
     f3c:	0007b783          	ld	a5,0(a5)
     f40:	faf43c23          	sd	a5,-72(s0)
     f44:	fb843783          	ld	a5,-72(s0)
     f48:	fec42703          	lw	a4,-20(s0)
     f4c:	00e7a023          	sw	a4,0(a5)
     f50:	f8040023          	sb	zero,-128(s0)
     f54:	1540006f          	j	10a8 <vprintfmt+0x7cc>
     f58:	f5043783          	ld	a5,-176(s0)
     f5c:	0007c783          	lbu	a5,0(a5)
     f60:	00078713          	mv	a4,a5
     f64:	07300793          	li	a5,115
     f68:	04f71063          	bne	a4,a5,fa8 <vprintfmt+0x6cc>
     f6c:	f4843783          	ld	a5,-184(s0)
     f70:	00878713          	addi	a4,a5,8
     f74:	f4e43423          	sd	a4,-184(s0)
     f78:	0007b783          	ld	a5,0(a5)
     f7c:	fcf43023          	sd	a5,-64(s0)
     f80:	fc043583          	ld	a1,-64(s0)
     f84:	f5843503          	ld	a0,-168(s0)
     f88:	fffff097          	auipc	ra,0xfffff
     f8c:	598080e7          	jalr	1432(ra) # 520 <puts_wo_nl>
     f90:	00050793          	mv	a5,a0
     f94:	fec42703          	lw	a4,-20(s0)
     f98:	00f707bb          	addw	a5,a4,a5
     f9c:	fef42623          	sw	a5,-20(s0)
     fa0:	f8040023          	sb	zero,-128(s0)
     fa4:	1040006f          	j	10a8 <vprintfmt+0x7cc>
     fa8:	f5043783          	ld	a5,-176(s0)
     fac:	0007c783          	lbu	a5,0(a5)
     fb0:	00078713          	mv	a4,a5
     fb4:	06300793          	li	a5,99
     fb8:	02f71e63          	bne	a4,a5,ff4 <vprintfmt+0x718>
     fbc:	f4843783          	ld	a5,-184(s0)
     fc0:	00878713          	addi	a4,a5,8
     fc4:	f4e43423          	sd	a4,-184(s0)
     fc8:	0007a783          	lw	a5,0(a5)
     fcc:	fcf42623          	sw	a5,-52(s0)
     fd0:	fcc42703          	lw	a4,-52(s0)
     fd4:	f5843783          	ld	a5,-168(s0)
     fd8:	00070513          	mv	a0,a4
     fdc:	000780e7          	jalr	a5
     fe0:	fec42783          	lw	a5,-20(s0)
     fe4:	0017879b          	addiw	a5,a5,1
     fe8:	fef42623          	sw	a5,-20(s0)
     fec:	f8040023          	sb	zero,-128(s0)
     ff0:	0b80006f          	j	10a8 <vprintfmt+0x7cc>
     ff4:	f5043783          	ld	a5,-176(s0)
     ff8:	0007c783          	lbu	a5,0(a5)
     ffc:	00078713          	mv	a4,a5
    1000:	02500793          	li	a5,37
    1004:	02f71263          	bne	a4,a5,1028 <vprintfmt+0x74c>
    1008:	f5843783          	ld	a5,-168(s0)
    100c:	02500513          	li	a0,37
    1010:	000780e7          	jalr	a5
    1014:	fec42783          	lw	a5,-20(s0)
    1018:	0017879b          	addiw	a5,a5,1
    101c:	fef42623          	sw	a5,-20(s0)
    1020:	f8040023          	sb	zero,-128(s0)
    1024:	0840006f          	j	10a8 <vprintfmt+0x7cc>
    1028:	f5043783          	ld	a5,-176(s0)
    102c:	0007c783          	lbu	a5,0(a5)
    1030:	0007871b          	sext.w	a4,a5
    1034:	f5843783          	ld	a5,-168(s0)
    1038:	00070513          	mv	a0,a4
    103c:	000780e7          	jalr	a5
    1040:	fec42783          	lw	a5,-20(s0)
    1044:	0017879b          	addiw	a5,a5,1
    1048:	fef42623          	sw	a5,-20(s0)
    104c:	f8040023          	sb	zero,-128(s0)
    1050:	0580006f          	j	10a8 <vprintfmt+0x7cc>
    1054:	f5043783          	ld	a5,-176(s0)
    1058:	0007c783          	lbu	a5,0(a5)
    105c:	00078713          	mv	a4,a5
    1060:	02500793          	li	a5,37
    1064:	02f71063          	bne	a4,a5,1084 <vprintfmt+0x7a8>
    1068:	f8043023          	sd	zero,-128(s0)
    106c:	f8043423          	sd	zero,-120(s0)
    1070:	00100793          	li	a5,1
    1074:	f8f40023          	sb	a5,-128(s0)
    1078:	fff00793          	li	a5,-1
    107c:	f8f42623          	sw	a5,-116(s0)
    1080:	0280006f          	j	10a8 <vprintfmt+0x7cc>
    1084:	f5043783          	ld	a5,-176(s0)
    1088:	0007c783          	lbu	a5,0(a5)
    108c:	0007871b          	sext.w	a4,a5
    1090:	f5843783          	ld	a5,-168(s0)
    1094:	00070513          	mv	a0,a4
    1098:	000780e7          	jalr	a5
    109c:	fec42783          	lw	a5,-20(s0)
    10a0:	0017879b          	addiw	a5,a5,1
    10a4:	fef42623          	sw	a5,-20(s0)
    10a8:	f5043783          	ld	a5,-176(s0)
    10ac:	00178793          	addi	a5,a5,1
    10b0:	f4f43823          	sd	a5,-176(s0)
    10b4:	f5043783          	ld	a5,-176(s0)
    10b8:	0007c783          	lbu	a5,0(a5)
    10bc:	840796e3          	bnez	a5,908 <vprintfmt+0x2c>
    10c0:	fec42783          	lw	a5,-20(s0)
    10c4:	00078513          	mv	a0,a5
    10c8:	0b813083          	ld	ra,184(sp)
    10cc:	0b013403          	ld	s0,176(sp)
    10d0:	0c010113          	addi	sp,sp,192
    10d4:	00008067          	ret

Disassembly of section .text.printf:

00000000000010d8 <printf>:
    10d8:	f8010113          	addi	sp,sp,-128
    10dc:	02113c23          	sd	ra,56(sp)
    10e0:	02813823          	sd	s0,48(sp)
    10e4:	04010413          	addi	s0,sp,64
    10e8:	fca43423          	sd	a0,-56(s0)
    10ec:	00b43423          	sd	a1,8(s0)
    10f0:	00c43823          	sd	a2,16(s0)
    10f4:	00d43c23          	sd	a3,24(s0)
    10f8:	02e43023          	sd	a4,32(s0)
    10fc:	02f43423          	sd	a5,40(s0)
    1100:	03043823          	sd	a6,48(s0)
    1104:	03143c23          	sd	a7,56(s0)
    1108:	fe042623          	sw	zero,-20(s0)
    110c:	04040793          	addi	a5,s0,64
    1110:	fcf43023          	sd	a5,-64(s0)
    1114:	fc043783          	ld	a5,-64(s0)
    1118:	fc878793          	addi	a5,a5,-56
    111c:	fcf43823          	sd	a5,-48(s0)
    1120:	fd043783          	ld	a5,-48(s0)
    1124:	00078613          	mv	a2,a5
    1128:	fc843583          	ld	a1,-56(s0)
    112c:	fffff517          	auipc	a0,0xfffff
    1130:	0ac50513          	addi	a0,a0,172 # 1d8 <putc>
    1134:	fffff097          	auipc	ra,0xfffff
    1138:	7a8080e7          	jalr	1960(ra) # 8dc <vprintfmt>
    113c:	00050793          	mv	a5,a0
    1140:	fef42623          	sw	a5,-20(s0)
    1144:	00100793          	li	a5,1
    1148:	fef43023          	sd	a5,-32(s0)
    114c:	00000797          	auipc	a5,0x0
    1150:	2ec78793          	addi	a5,a5,748 # 1438 <tail>
    1154:	0007a783          	lw	a5,0(a5)
    1158:	0017871b          	addiw	a4,a5,1
    115c:	0007069b          	sext.w	a3,a4
    1160:	00000717          	auipc	a4,0x0
    1164:	2d870713          	addi	a4,a4,728 # 1438 <tail>
    1168:	00d72023          	sw	a3,0(a4)
    116c:	00000717          	auipc	a4,0x0
    1170:	2d470713          	addi	a4,a4,724 # 1440 <buffer>
    1174:	00f707b3          	add	a5,a4,a5
    1178:	00078023          	sb	zero,0(a5)
    117c:	00000797          	auipc	a5,0x0
    1180:	2bc78793          	addi	a5,a5,700 # 1438 <tail>
    1184:	0007a603          	lw	a2,0(a5)
    1188:	fe043703          	ld	a4,-32(s0)
    118c:	00000697          	auipc	a3,0x0
    1190:	2b468693          	addi	a3,a3,692 # 1440 <buffer>
    1194:	fd843783          	ld	a5,-40(s0)
    1198:	04000893          	li	a7,64
    119c:	00070513          	mv	a0,a4
    11a0:	00068593          	mv	a1,a3
    11a4:	00060613          	mv	a2,a2
    11a8:	00000073          	ecall
    11ac:	00050793          	mv	a5,a0
    11b0:	fcf43c23          	sd	a5,-40(s0)
    11b4:	00000797          	auipc	a5,0x0
    11b8:	28478793          	addi	a5,a5,644 # 1438 <tail>
    11bc:	0007a023          	sw	zero,0(a5)
    11c0:	fec42783          	lw	a5,-20(s0)
    11c4:	00078513          	mv	a0,a5
    11c8:	03813083          	ld	ra,56(sp)
    11cc:	03013403          	ld	s0,48(sp)
    11d0:	08010113          	addi	sp,sp,128
    11d4:	00008067          	ret
