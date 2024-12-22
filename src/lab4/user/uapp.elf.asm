
uapp.elf:     file format elf64-littleriscv


Disassembly of section .text.init:

0000000000000000 <_start>:
   0:	0400006f          	j	40 <main>

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

Disassembly of section .text.main:

0000000000000040 <main>:
  40:	fe010113          	addi	sp,sp,-32
  44:	00113c23          	sd	ra,24(sp)
  48:	00813823          	sd	s0,16(sp)
  4c:	02010413          	addi	s0,sp,32
  50:	00000097          	auipc	ra,0x0
  54:	fb4080e7          	jalr	-76(ra) # 4 <getpid>
  58:	00050593          	mv	a1,a0
  5c:	00010613          	mv	a2,sp
  60:	00001797          	auipc	a5,0x1
  64:	28478793          	addi	a5,a5,644 # 12e4 <counter>
  68:	0007a783          	lw	a5,0(a5)
  6c:	0017879b          	addiw	a5,a5,1
  70:	0007871b          	sext.w	a4,a5
  74:	00001797          	auipc	a5,0x1
  78:	27078793          	addi	a5,a5,624 # 12e4 <counter>
  7c:	00e7a023          	sw	a4,0(a5)
  80:	00001797          	auipc	a5,0x1
  84:	26478793          	addi	a5,a5,612 # 12e4 <counter>
  88:	0007a783          	lw	a5,0(a5)
  8c:	00078693          	mv	a3,a5
  90:	00001517          	auipc	a0,0x1
  94:	1c850513          	addi	a0,a0,456 # 1258 <printf+0x28c>
  98:	00001097          	auipc	ra,0x1
  9c:	f34080e7          	jalr	-204(ra) # fcc <printf>
  a0:	fe042623          	sw	zero,-20(s0)
  a4:	0100006f          	j	b4 <main+0x74>
  a8:	fec42783          	lw	a5,-20(s0)
  ac:	0017879b          	addiw	a5,a5,1
  b0:	fef42623          	sw	a5,-20(s0)
  b4:	fec42783          	lw	a5,-20(s0)
  b8:	0007871b          	sext.w	a4,a5
  bc:	500007b7          	lui	a5,0x50000
  c0:	ffe78793          	addi	a5,a5,-2 # 4ffffffe <buffer+0x4fffed0e>
  c4:	fee7f2e3          	bgeu	a5,a4,a8 <main+0x68>
  c8:	f89ff06f          	j	50 <main+0x10>

Disassembly of section .text.putc:

00000000000000cc <putc>:
  cc:	fe010113          	addi	sp,sp,-32
  d0:	00113c23          	sd	ra,24(sp)
  d4:	00813823          	sd	s0,16(sp)
  d8:	02010413          	addi	s0,sp,32
  dc:	00050793          	mv	a5,a0
  e0:	fef42623          	sw	a5,-20(s0)
  e4:	00001797          	auipc	a5,0x1
  e8:	20478793          	addi	a5,a5,516 # 12e8 <tail>
  ec:	0007a783          	lw	a5,0(a5)
  f0:	0017871b          	addiw	a4,a5,1
  f4:	0007069b          	sext.w	a3,a4
  f8:	00001717          	auipc	a4,0x1
  fc:	1f070713          	addi	a4,a4,496 # 12e8 <tail>
 100:	00d72023          	sw	a3,0(a4)
 104:	fec42703          	lw	a4,-20(s0)
 108:	0ff77713          	zext.b	a4,a4
 10c:	00001697          	auipc	a3,0x1
 110:	1e468693          	addi	a3,a3,484 # 12f0 <buffer>
 114:	00f687b3          	add	a5,a3,a5
 118:	00e78023          	sb	a4,0(a5)
 11c:	fec42783          	lw	a5,-20(s0)
 120:	0ff7f793          	zext.b	a5,a5
 124:	0007879b          	sext.w	a5,a5
 128:	00078513          	mv	a0,a5
 12c:	01813083          	ld	ra,24(sp)
 130:	01013403          	ld	s0,16(sp)
 134:	02010113          	addi	sp,sp,32
 138:	00008067          	ret

Disassembly of section .text.isspace:

000000000000013c <isspace>:
 13c:	fe010113          	addi	sp,sp,-32
 140:	00113c23          	sd	ra,24(sp)
 144:	00813823          	sd	s0,16(sp)
 148:	02010413          	addi	s0,sp,32
 14c:	00050793          	mv	a5,a0
 150:	fef42623          	sw	a5,-20(s0)
 154:	fec42783          	lw	a5,-20(s0)
 158:	0007871b          	sext.w	a4,a5
 15c:	02000793          	li	a5,32
 160:	02f70263          	beq	a4,a5,184 <isspace+0x48>
 164:	fec42783          	lw	a5,-20(s0)
 168:	0007871b          	sext.w	a4,a5
 16c:	00800793          	li	a5,8
 170:	00e7de63          	bge	a5,a4,18c <isspace+0x50>
 174:	fec42783          	lw	a5,-20(s0)
 178:	0007871b          	sext.w	a4,a5
 17c:	00d00793          	li	a5,13
 180:	00e7c663          	blt	a5,a4,18c <isspace+0x50>
 184:	00100793          	li	a5,1
 188:	0080006f          	j	190 <isspace+0x54>
 18c:	00000793          	li	a5,0
 190:	00078513          	mv	a0,a5
 194:	01813083          	ld	ra,24(sp)
 198:	01013403          	ld	s0,16(sp)
 19c:	02010113          	addi	sp,sp,32
 1a0:	00008067          	ret

Disassembly of section .text.strtol:

00000000000001a4 <strtol>:
 1a4:	fb010113          	addi	sp,sp,-80
 1a8:	04113423          	sd	ra,72(sp)
 1ac:	04813023          	sd	s0,64(sp)
 1b0:	05010413          	addi	s0,sp,80
 1b4:	fca43423          	sd	a0,-56(s0)
 1b8:	fcb43023          	sd	a1,-64(s0)
 1bc:	00060793          	mv	a5,a2
 1c0:	faf42e23          	sw	a5,-68(s0)
 1c4:	fe043423          	sd	zero,-24(s0)
 1c8:	fe0403a3          	sb	zero,-25(s0)
 1cc:	fc843783          	ld	a5,-56(s0)
 1d0:	fcf43c23          	sd	a5,-40(s0)
 1d4:	0100006f          	j	1e4 <strtol+0x40>
 1d8:	fd843783          	ld	a5,-40(s0)
 1dc:	00178793          	addi	a5,a5,1
 1e0:	fcf43c23          	sd	a5,-40(s0)
 1e4:	fd843783          	ld	a5,-40(s0)
 1e8:	0007c783          	lbu	a5,0(a5)
 1ec:	0007879b          	sext.w	a5,a5
 1f0:	00078513          	mv	a0,a5
 1f4:	00000097          	auipc	ra,0x0
 1f8:	f48080e7          	jalr	-184(ra) # 13c <isspace>
 1fc:	00050793          	mv	a5,a0
 200:	fc079ce3          	bnez	a5,1d8 <strtol+0x34>
 204:	fd843783          	ld	a5,-40(s0)
 208:	0007c783          	lbu	a5,0(a5)
 20c:	00078713          	mv	a4,a5
 210:	02d00793          	li	a5,45
 214:	00f71e63          	bne	a4,a5,230 <strtol+0x8c>
 218:	00100793          	li	a5,1
 21c:	fef403a3          	sb	a5,-25(s0)
 220:	fd843783          	ld	a5,-40(s0)
 224:	00178793          	addi	a5,a5,1
 228:	fcf43c23          	sd	a5,-40(s0)
 22c:	0240006f          	j	250 <strtol+0xac>
 230:	fd843783          	ld	a5,-40(s0)
 234:	0007c783          	lbu	a5,0(a5)
 238:	00078713          	mv	a4,a5
 23c:	02b00793          	li	a5,43
 240:	00f71863          	bne	a4,a5,250 <strtol+0xac>
 244:	fd843783          	ld	a5,-40(s0)
 248:	00178793          	addi	a5,a5,1
 24c:	fcf43c23          	sd	a5,-40(s0)
 250:	fbc42783          	lw	a5,-68(s0)
 254:	0007879b          	sext.w	a5,a5
 258:	06079c63          	bnez	a5,2d0 <strtol+0x12c>
 25c:	fd843783          	ld	a5,-40(s0)
 260:	0007c783          	lbu	a5,0(a5)
 264:	00078713          	mv	a4,a5
 268:	03000793          	li	a5,48
 26c:	04f71e63          	bne	a4,a5,2c8 <strtol+0x124>
 270:	fd843783          	ld	a5,-40(s0)
 274:	00178793          	addi	a5,a5,1
 278:	fcf43c23          	sd	a5,-40(s0)
 27c:	fd843783          	ld	a5,-40(s0)
 280:	0007c783          	lbu	a5,0(a5)
 284:	00078713          	mv	a4,a5
 288:	07800793          	li	a5,120
 28c:	00f70c63          	beq	a4,a5,2a4 <strtol+0x100>
 290:	fd843783          	ld	a5,-40(s0)
 294:	0007c783          	lbu	a5,0(a5)
 298:	00078713          	mv	a4,a5
 29c:	05800793          	li	a5,88
 2a0:	00f71e63          	bne	a4,a5,2bc <strtol+0x118>
 2a4:	01000793          	li	a5,16
 2a8:	faf42e23          	sw	a5,-68(s0)
 2ac:	fd843783          	ld	a5,-40(s0)
 2b0:	00178793          	addi	a5,a5,1
 2b4:	fcf43c23          	sd	a5,-40(s0)
 2b8:	0180006f          	j	2d0 <strtol+0x12c>
 2bc:	00800793          	li	a5,8
 2c0:	faf42e23          	sw	a5,-68(s0)
 2c4:	00c0006f          	j	2d0 <strtol+0x12c>
 2c8:	00a00793          	li	a5,10
 2cc:	faf42e23          	sw	a5,-68(s0)
 2d0:	fd843783          	ld	a5,-40(s0)
 2d4:	0007c783          	lbu	a5,0(a5)
 2d8:	00078713          	mv	a4,a5
 2dc:	02f00793          	li	a5,47
 2e0:	02e7f863          	bgeu	a5,a4,310 <strtol+0x16c>
 2e4:	fd843783          	ld	a5,-40(s0)
 2e8:	0007c783          	lbu	a5,0(a5)
 2ec:	00078713          	mv	a4,a5
 2f0:	03900793          	li	a5,57
 2f4:	00e7ee63          	bltu	a5,a4,310 <strtol+0x16c>
 2f8:	fd843783          	ld	a5,-40(s0)
 2fc:	0007c783          	lbu	a5,0(a5)
 300:	0007879b          	sext.w	a5,a5
 304:	fd07879b          	addiw	a5,a5,-48
 308:	fcf42a23          	sw	a5,-44(s0)
 30c:	0800006f          	j	38c <strtol+0x1e8>
 310:	fd843783          	ld	a5,-40(s0)
 314:	0007c783          	lbu	a5,0(a5)
 318:	00078713          	mv	a4,a5
 31c:	06000793          	li	a5,96
 320:	02e7f863          	bgeu	a5,a4,350 <strtol+0x1ac>
 324:	fd843783          	ld	a5,-40(s0)
 328:	0007c783          	lbu	a5,0(a5)
 32c:	00078713          	mv	a4,a5
 330:	07a00793          	li	a5,122
 334:	00e7ee63          	bltu	a5,a4,350 <strtol+0x1ac>
 338:	fd843783          	ld	a5,-40(s0)
 33c:	0007c783          	lbu	a5,0(a5)
 340:	0007879b          	sext.w	a5,a5
 344:	fa97879b          	addiw	a5,a5,-87
 348:	fcf42a23          	sw	a5,-44(s0)
 34c:	0400006f          	j	38c <strtol+0x1e8>
 350:	fd843783          	ld	a5,-40(s0)
 354:	0007c783          	lbu	a5,0(a5)
 358:	00078713          	mv	a4,a5
 35c:	04000793          	li	a5,64
 360:	06e7f863          	bgeu	a5,a4,3d0 <strtol+0x22c>
 364:	fd843783          	ld	a5,-40(s0)
 368:	0007c783          	lbu	a5,0(a5)
 36c:	00078713          	mv	a4,a5
 370:	05a00793          	li	a5,90
 374:	04e7ee63          	bltu	a5,a4,3d0 <strtol+0x22c>
 378:	fd843783          	ld	a5,-40(s0)
 37c:	0007c783          	lbu	a5,0(a5)
 380:	0007879b          	sext.w	a5,a5
 384:	fc97879b          	addiw	a5,a5,-55
 388:	fcf42a23          	sw	a5,-44(s0)
 38c:	fd442783          	lw	a5,-44(s0)
 390:	00078713          	mv	a4,a5
 394:	fbc42783          	lw	a5,-68(s0)
 398:	0007071b          	sext.w	a4,a4
 39c:	0007879b          	sext.w	a5,a5
 3a0:	02f75663          	bge	a4,a5,3cc <strtol+0x228>
 3a4:	fbc42703          	lw	a4,-68(s0)
 3a8:	fe843783          	ld	a5,-24(s0)
 3ac:	02f70733          	mul	a4,a4,a5
 3b0:	fd442783          	lw	a5,-44(s0)
 3b4:	00f707b3          	add	a5,a4,a5
 3b8:	fef43423          	sd	a5,-24(s0)
 3bc:	fd843783          	ld	a5,-40(s0)
 3c0:	00178793          	addi	a5,a5,1
 3c4:	fcf43c23          	sd	a5,-40(s0)
 3c8:	f09ff06f          	j	2d0 <strtol+0x12c>
 3cc:	00000013          	nop
 3d0:	fc043783          	ld	a5,-64(s0)
 3d4:	00078863          	beqz	a5,3e4 <strtol+0x240>
 3d8:	fc043783          	ld	a5,-64(s0)
 3dc:	fd843703          	ld	a4,-40(s0)
 3e0:	00e7b023          	sd	a4,0(a5)
 3e4:	fe744783          	lbu	a5,-25(s0)
 3e8:	0ff7f793          	zext.b	a5,a5
 3ec:	00078863          	beqz	a5,3fc <strtol+0x258>
 3f0:	fe843783          	ld	a5,-24(s0)
 3f4:	40f007b3          	neg	a5,a5
 3f8:	0080006f          	j	400 <strtol+0x25c>
 3fc:	fe843783          	ld	a5,-24(s0)
 400:	00078513          	mv	a0,a5
 404:	04813083          	ld	ra,72(sp)
 408:	04013403          	ld	s0,64(sp)
 40c:	05010113          	addi	sp,sp,80
 410:	00008067          	ret

Disassembly of section .text.puts_wo_nl:

0000000000000414 <puts_wo_nl>:
 414:	fd010113          	addi	sp,sp,-48
 418:	02113423          	sd	ra,40(sp)
 41c:	02813023          	sd	s0,32(sp)
 420:	03010413          	addi	s0,sp,48
 424:	fca43c23          	sd	a0,-40(s0)
 428:	fcb43823          	sd	a1,-48(s0)
 42c:	fd043783          	ld	a5,-48(s0)
 430:	00079863          	bnez	a5,440 <puts_wo_nl+0x2c>
 434:	00001797          	auipc	a5,0x1
 438:	e5c78793          	addi	a5,a5,-420 # 1290 <printf+0x2c4>
 43c:	fcf43823          	sd	a5,-48(s0)
 440:	fd043783          	ld	a5,-48(s0)
 444:	fef43423          	sd	a5,-24(s0)
 448:	0240006f          	j	46c <puts_wo_nl+0x58>
 44c:	fe843783          	ld	a5,-24(s0)
 450:	00178713          	addi	a4,a5,1
 454:	fee43423          	sd	a4,-24(s0)
 458:	0007c783          	lbu	a5,0(a5)
 45c:	0007871b          	sext.w	a4,a5
 460:	fd843783          	ld	a5,-40(s0)
 464:	00070513          	mv	a0,a4
 468:	000780e7          	jalr	a5
 46c:	fe843783          	ld	a5,-24(s0)
 470:	0007c783          	lbu	a5,0(a5)
 474:	fc079ce3          	bnez	a5,44c <puts_wo_nl+0x38>
 478:	fe843703          	ld	a4,-24(s0)
 47c:	fd043783          	ld	a5,-48(s0)
 480:	40f707b3          	sub	a5,a4,a5
 484:	0007879b          	sext.w	a5,a5
 488:	00078513          	mv	a0,a5
 48c:	02813083          	ld	ra,40(sp)
 490:	02013403          	ld	s0,32(sp)
 494:	03010113          	addi	sp,sp,48
 498:	00008067          	ret

Disassembly of section .text.print_dec_int:

000000000000049c <print_dec_int>:
 49c:	f9010113          	addi	sp,sp,-112
 4a0:	06113423          	sd	ra,104(sp)
 4a4:	06813023          	sd	s0,96(sp)
 4a8:	07010413          	addi	s0,sp,112
 4ac:	faa43423          	sd	a0,-88(s0)
 4b0:	fab43023          	sd	a1,-96(s0)
 4b4:	00060793          	mv	a5,a2
 4b8:	f8d43823          	sd	a3,-112(s0)
 4bc:	f8f40fa3          	sb	a5,-97(s0)
 4c0:	f9f44783          	lbu	a5,-97(s0)
 4c4:	0ff7f793          	zext.b	a5,a5
 4c8:	02078863          	beqz	a5,4f8 <print_dec_int+0x5c>
 4cc:	fa043703          	ld	a4,-96(s0)
 4d0:	fff00793          	li	a5,-1
 4d4:	03f79793          	slli	a5,a5,0x3f
 4d8:	02f71063          	bne	a4,a5,4f8 <print_dec_int+0x5c>
 4dc:	00001597          	auipc	a1,0x1
 4e0:	dbc58593          	addi	a1,a1,-580 # 1298 <printf+0x2cc>
 4e4:	fa843503          	ld	a0,-88(s0)
 4e8:	00000097          	auipc	ra,0x0
 4ec:	f2c080e7          	jalr	-212(ra) # 414 <puts_wo_nl>
 4f0:	00050793          	mv	a5,a0
 4f4:	2c80006f          	j	7bc <print_dec_int+0x320>
 4f8:	f9043783          	ld	a5,-112(s0)
 4fc:	00c7a783          	lw	a5,12(a5)
 500:	00079a63          	bnez	a5,514 <print_dec_int+0x78>
 504:	fa043783          	ld	a5,-96(s0)
 508:	00079663          	bnez	a5,514 <print_dec_int+0x78>
 50c:	00000793          	li	a5,0
 510:	2ac0006f          	j	7bc <print_dec_int+0x320>
 514:	fe0407a3          	sb	zero,-17(s0)
 518:	f9f44783          	lbu	a5,-97(s0)
 51c:	0ff7f793          	zext.b	a5,a5
 520:	02078063          	beqz	a5,540 <print_dec_int+0xa4>
 524:	fa043783          	ld	a5,-96(s0)
 528:	0007dc63          	bgez	a5,540 <print_dec_int+0xa4>
 52c:	00100793          	li	a5,1
 530:	fef407a3          	sb	a5,-17(s0)
 534:	fa043783          	ld	a5,-96(s0)
 538:	40f007b3          	neg	a5,a5
 53c:	faf43023          	sd	a5,-96(s0)
 540:	fe042423          	sw	zero,-24(s0)
 544:	f9f44783          	lbu	a5,-97(s0)
 548:	0ff7f793          	zext.b	a5,a5
 54c:	02078863          	beqz	a5,57c <print_dec_int+0xe0>
 550:	fef44783          	lbu	a5,-17(s0)
 554:	0ff7f793          	zext.b	a5,a5
 558:	00079e63          	bnez	a5,574 <print_dec_int+0xd8>
 55c:	f9043783          	ld	a5,-112(s0)
 560:	0057c783          	lbu	a5,5(a5)
 564:	00079863          	bnez	a5,574 <print_dec_int+0xd8>
 568:	f9043783          	ld	a5,-112(s0)
 56c:	0047c783          	lbu	a5,4(a5)
 570:	00078663          	beqz	a5,57c <print_dec_int+0xe0>
 574:	00100793          	li	a5,1
 578:	0080006f          	j	580 <print_dec_int+0xe4>
 57c:	00000793          	li	a5,0
 580:	fcf40ba3          	sb	a5,-41(s0)
 584:	fd744783          	lbu	a5,-41(s0)
 588:	0017f793          	andi	a5,a5,1
 58c:	fcf40ba3          	sb	a5,-41(s0)
 590:	fa043683          	ld	a3,-96(s0)
 594:	00001797          	auipc	a5,0x1
 598:	d1c78793          	addi	a5,a5,-740 # 12b0 <printf+0x2e4>
 59c:	0007b783          	ld	a5,0(a5)
 5a0:	02f6b7b3          	mulhu	a5,a3,a5
 5a4:	0037d713          	srli	a4,a5,0x3
 5a8:	00070793          	mv	a5,a4
 5ac:	00279793          	slli	a5,a5,0x2
 5b0:	00e787b3          	add	a5,a5,a4
 5b4:	00179793          	slli	a5,a5,0x1
 5b8:	40f68733          	sub	a4,a3,a5
 5bc:	0ff77713          	zext.b	a4,a4
 5c0:	fe842783          	lw	a5,-24(s0)
 5c4:	0017869b          	addiw	a3,a5,1
 5c8:	fed42423          	sw	a3,-24(s0)
 5cc:	0307071b          	addiw	a4,a4,48
 5d0:	0ff77713          	zext.b	a4,a4
 5d4:	ff078793          	addi	a5,a5,-16
 5d8:	008787b3          	add	a5,a5,s0
 5dc:	fce78423          	sb	a4,-56(a5)
 5e0:	fa043703          	ld	a4,-96(s0)
 5e4:	00001797          	auipc	a5,0x1
 5e8:	ccc78793          	addi	a5,a5,-820 # 12b0 <printf+0x2e4>
 5ec:	0007b783          	ld	a5,0(a5)
 5f0:	02f737b3          	mulhu	a5,a4,a5
 5f4:	0037d793          	srli	a5,a5,0x3
 5f8:	faf43023          	sd	a5,-96(s0)
 5fc:	fa043783          	ld	a5,-96(s0)
 600:	f80798e3          	bnez	a5,590 <print_dec_int+0xf4>
 604:	f9043783          	ld	a5,-112(s0)
 608:	00c7a703          	lw	a4,12(a5)
 60c:	fff00793          	li	a5,-1
 610:	02f71063          	bne	a4,a5,630 <print_dec_int+0x194>
 614:	f9043783          	ld	a5,-112(s0)
 618:	0037c783          	lbu	a5,3(a5)
 61c:	00078a63          	beqz	a5,630 <print_dec_int+0x194>
 620:	f9043783          	ld	a5,-112(s0)
 624:	0087a703          	lw	a4,8(a5)
 628:	f9043783          	ld	a5,-112(s0)
 62c:	00e7a623          	sw	a4,12(a5)
 630:	fe042223          	sw	zero,-28(s0)
 634:	f9043783          	ld	a5,-112(s0)
 638:	0087a703          	lw	a4,8(a5)
 63c:	fe842783          	lw	a5,-24(s0)
 640:	fcf42823          	sw	a5,-48(s0)
 644:	f9043783          	ld	a5,-112(s0)
 648:	00c7a783          	lw	a5,12(a5)
 64c:	fcf42623          	sw	a5,-52(s0)
 650:	fd042783          	lw	a5,-48(s0)
 654:	00078593          	mv	a1,a5
 658:	fcc42783          	lw	a5,-52(s0)
 65c:	00078613          	mv	a2,a5
 660:	0006069b          	sext.w	a3,a2
 664:	0005879b          	sext.w	a5,a1
 668:	00f6d463          	bge	a3,a5,670 <print_dec_int+0x1d4>
 66c:	00058613          	mv	a2,a1
 670:	0006079b          	sext.w	a5,a2
 674:	40f707bb          	subw	a5,a4,a5
 678:	0007871b          	sext.w	a4,a5
 67c:	fd744783          	lbu	a5,-41(s0)
 680:	0007879b          	sext.w	a5,a5
 684:	40f707bb          	subw	a5,a4,a5
 688:	fef42023          	sw	a5,-32(s0)
 68c:	0280006f          	j	6b4 <print_dec_int+0x218>
 690:	fa843783          	ld	a5,-88(s0)
 694:	02000513          	li	a0,32
 698:	000780e7          	jalr	a5
 69c:	fe442783          	lw	a5,-28(s0)
 6a0:	0017879b          	addiw	a5,a5,1
 6a4:	fef42223          	sw	a5,-28(s0)
 6a8:	fe042783          	lw	a5,-32(s0)
 6ac:	fff7879b          	addiw	a5,a5,-1
 6b0:	fef42023          	sw	a5,-32(s0)
 6b4:	fe042783          	lw	a5,-32(s0)
 6b8:	0007879b          	sext.w	a5,a5
 6bc:	fcf04ae3          	bgtz	a5,690 <print_dec_int+0x1f4>
 6c0:	fd744783          	lbu	a5,-41(s0)
 6c4:	0ff7f793          	zext.b	a5,a5
 6c8:	04078463          	beqz	a5,710 <print_dec_int+0x274>
 6cc:	fef44783          	lbu	a5,-17(s0)
 6d0:	0ff7f793          	zext.b	a5,a5
 6d4:	00078663          	beqz	a5,6e0 <print_dec_int+0x244>
 6d8:	02d00793          	li	a5,45
 6dc:	01c0006f          	j	6f8 <print_dec_int+0x25c>
 6e0:	f9043783          	ld	a5,-112(s0)
 6e4:	0057c783          	lbu	a5,5(a5)
 6e8:	00078663          	beqz	a5,6f4 <print_dec_int+0x258>
 6ec:	02b00793          	li	a5,43
 6f0:	0080006f          	j	6f8 <print_dec_int+0x25c>
 6f4:	02000793          	li	a5,32
 6f8:	fa843703          	ld	a4,-88(s0)
 6fc:	00078513          	mv	a0,a5
 700:	000700e7          	jalr	a4
 704:	fe442783          	lw	a5,-28(s0)
 708:	0017879b          	addiw	a5,a5,1
 70c:	fef42223          	sw	a5,-28(s0)
 710:	fe842783          	lw	a5,-24(s0)
 714:	fcf42e23          	sw	a5,-36(s0)
 718:	0280006f          	j	740 <print_dec_int+0x2a4>
 71c:	fa843783          	ld	a5,-88(s0)
 720:	03000513          	li	a0,48
 724:	000780e7          	jalr	a5
 728:	fe442783          	lw	a5,-28(s0)
 72c:	0017879b          	addiw	a5,a5,1
 730:	fef42223          	sw	a5,-28(s0)
 734:	fdc42783          	lw	a5,-36(s0)
 738:	0017879b          	addiw	a5,a5,1
 73c:	fcf42e23          	sw	a5,-36(s0)
 740:	f9043783          	ld	a5,-112(s0)
 744:	00c7a703          	lw	a4,12(a5)
 748:	fd744783          	lbu	a5,-41(s0)
 74c:	0007879b          	sext.w	a5,a5
 750:	40f707bb          	subw	a5,a4,a5
 754:	0007879b          	sext.w	a5,a5
 758:	fdc42703          	lw	a4,-36(s0)
 75c:	0007071b          	sext.w	a4,a4
 760:	faf74ee3          	blt	a4,a5,71c <print_dec_int+0x280>
 764:	fe842783          	lw	a5,-24(s0)
 768:	fff7879b          	addiw	a5,a5,-1
 76c:	fcf42c23          	sw	a5,-40(s0)
 770:	03c0006f          	j	7ac <print_dec_int+0x310>
 774:	fd842783          	lw	a5,-40(s0)
 778:	ff078793          	addi	a5,a5,-16
 77c:	008787b3          	add	a5,a5,s0
 780:	fc87c783          	lbu	a5,-56(a5)
 784:	0007871b          	sext.w	a4,a5
 788:	fa843783          	ld	a5,-88(s0)
 78c:	00070513          	mv	a0,a4
 790:	000780e7          	jalr	a5
 794:	fe442783          	lw	a5,-28(s0)
 798:	0017879b          	addiw	a5,a5,1
 79c:	fef42223          	sw	a5,-28(s0)
 7a0:	fd842783          	lw	a5,-40(s0)
 7a4:	fff7879b          	addiw	a5,a5,-1
 7a8:	fcf42c23          	sw	a5,-40(s0)
 7ac:	fd842783          	lw	a5,-40(s0)
 7b0:	0007879b          	sext.w	a5,a5
 7b4:	fc07d0e3          	bgez	a5,774 <print_dec_int+0x2d8>
 7b8:	fe442783          	lw	a5,-28(s0)
 7bc:	00078513          	mv	a0,a5
 7c0:	06813083          	ld	ra,104(sp)
 7c4:	06013403          	ld	s0,96(sp)
 7c8:	07010113          	addi	sp,sp,112
 7cc:	00008067          	ret

Disassembly of section .text.vprintfmt:

00000000000007d0 <vprintfmt>:
 7d0:	f4010113          	addi	sp,sp,-192
 7d4:	0a113c23          	sd	ra,184(sp)
 7d8:	0a813823          	sd	s0,176(sp)
 7dc:	0c010413          	addi	s0,sp,192
 7e0:	f4a43c23          	sd	a0,-168(s0)
 7e4:	f4b43823          	sd	a1,-176(s0)
 7e8:	f4c43423          	sd	a2,-184(s0)
 7ec:	f8043023          	sd	zero,-128(s0)
 7f0:	f8043423          	sd	zero,-120(s0)
 7f4:	fe042623          	sw	zero,-20(s0)
 7f8:	7b00006f          	j	fa8 <vprintfmt+0x7d8>
 7fc:	f8044783          	lbu	a5,-128(s0)
 800:	74078463          	beqz	a5,f48 <vprintfmt+0x778>
 804:	f5043783          	ld	a5,-176(s0)
 808:	0007c783          	lbu	a5,0(a5)
 80c:	00078713          	mv	a4,a5
 810:	02300793          	li	a5,35
 814:	00f71863          	bne	a4,a5,824 <vprintfmt+0x54>
 818:	00100793          	li	a5,1
 81c:	f8f40123          	sb	a5,-126(s0)
 820:	77c0006f          	j	f9c <vprintfmt+0x7cc>
 824:	f5043783          	ld	a5,-176(s0)
 828:	0007c783          	lbu	a5,0(a5)
 82c:	00078713          	mv	a4,a5
 830:	03000793          	li	a5,48
 834:	00f71863          	bne	a4,a5,844 <vprintfmt+0x74>
 838:	00100793          	li	a5,1
 83c:	f8f401a3          	sb	a5,-125(s0)
 840:	75c0006f          	j	f9c <vprintfmt+0x7cc>
 844:	f5043783          	ld	a5,-176(s0)
 848:	0007c783          	lbu	a5,0(a5)
 84c:	00078713          	mv	a4,a5
 850:	06c00793          	li	a5,108
 854:	04f70063          	beq	a4,a5,894 <vprintfmt+0xc4>
 858:	f5043783          	ld	a5,-176(s0)
 85c:	0007c783          	lbu	a5,0(a5)
 860:	00078713          	mv	a4,a5
 864:	07a00793          	li	a5,122
 868:	02f70663          	beq	a4,a5,894 <vprintfmt+0xc4>
 86c:	f5043783          	ld	a5,-176(s0)
 870:	0007c783          	lbu	a5,0(a5)
 874:	00078713          	mv	a4,a5
 878:	07400793          	li	a5,116
 87c:	00f70c63          	beq	a4,a5,894 <vprintfmt+0xc4>
 880:	f5043783          	ld	a5,-176(s0)
 884:	0007c783          	lbu	a5,0(a5)
 888:	00078713          	mv	a4,a5
 88c:	06a00793          	li	a5,106
 890:	00f71863          	bne	a4,a5,8a0 <vprintfmt+0xd0>
 894:	00100793          	li	a5,1
 898:	f8f400a3          	sb	a5,-127(s0)
 89c:	7000006f          	j	f9c <vprintfmt+0x7cc>
 8a0:	f5043783          	ld	a5,-176(s0)
 8a4:	0007c783          	lbu	a5,0(a5)
 8a8:	00078713          	mv	a4,a5
 8ac:	02b00793          	li	a5,43
 8b0:	00f71863          	bne	a4,a5,8c0 <vprintfmt+0xf0>
 8b4:	00100793          	li	a5,1
 8b8:	f8f402a3          	sb	a5,-123(s0)
 8bc:	6e00006f          	j	f9c <vprintfmt+0x7cc>
 8c0:	f5043783          	ld	a5,-176(s0)
 8c4:	0007c783          	lbu	a5,0(a5)
 8c8:	00078713          	mv	a4,a5
 8cc:	02000793          	li	a5,32
 8d0:	00f71863          	bne	a4,a5,8e0 <vprintfmt+0x110>
 8d4:	00100793          	li	a5,1
 8d8:	f8f40223          	sb	a5,-124(s0)
 8dc:	6c00006f          	j	f9c <vprintfmt+0x7cc>
 8e0:	f5043783          	ld	a5,-176(s0)
 8e4:	0007c783          	lbu	a5,0(a5)
 8e8:	00078713          	mv	a4,a5
 8ec:	02a00793          	li	a5,42
 8f0:	00f71e63          	bne	a4,a5,90c <vprintfmt+0x13c>
 8f4:	f4843783          	ld	a5,-184(s0)
 8f8:	00878713          	addi	a4,a5,8
 8fc:	f4e43423          	sd	a4,-184(s0)
 900:	0007a783          	lw	a5,0(a5)
 904:	f8f42423          	sw	a5,-120(s0)
 908:	6940006f          	j	f9c <vprintfmt+0x7cc>
 90c:	f5043783          	ld	a5,-176(s0)
 910:	0007c783          	lbu	a5,0(a5)
 914:	00078713          	mv	a4,a5
 918:	03000793          	li	a5,48
 91c:	04e7f863          	bgeu	a5,a4,96c <vprintfmt+0x19c>
 920:	f5043783          	ld	a5,-176(s0)
 924:	0007c783          	lbu	a5,0(a5)
 928:	00078713          	mv	a4,a5
 92c:	03900793          	li	a5,57
 930:	02e7ee63          	bltu	a5,a4,96c <vprintfmt+0x19c>
 934:	f5043783          	ld	a5,-176(s0)
 938:	f5040713          	addi	a4,s0,-176
 93c:	00a00613          	li	a2,10
 940:	00070593          	mv	a1,a4
 944:	00078513          	mv	a0,a5
 948:	00000097          	auipc	ra,0x0
 94c:	85c080e7          	jalr	-1956(ra) # 1a4 <strtol>
 950:	00050793          	mv	a5,a0
 954:	0007879b          	sext.w	a5,a5
 958:	f8f42423          	sw	a5,-120(s0)
 95c:	f5043783          	ld	a5,-176(s0)
 960:	fff78793          	addi	a5,a5,-1
 964:	f4f43823          	sd	a5,-176(s0)
 968:	6340006f          	j	f9c <vprintfmt+0x7cc>
 96c:	f5043783          	ld	a5,-176(s0)
 970:	0007c783          	lbu	a5,0(a5)
 974:	00078713          	mv	a4,a5
 978:	02e00793          	li	a5,46
 97c:	06f71a63          	bne	a4,a5,9f0 <vprintfmt+0x220>
 980:	f5043783          	ld	a5,-176(s0)
 984:	00178793          	addi	a5,a5,1
 988:	f4f43823          	sd	a5,-176(s0)
 98c:	f5043783          	ld	a5,-176(s0)
 990:	0007c783          	lbu	a5,0(a5)
 994:	00078713          	mv	a4,a5
 998:	02a00793          	li	a5,42
 99c:	00f71e63          	bne	a4,a5,9b8 <vprintfmt+0x1e8>
 9a0:	f4843783          	ld	a5,-184(s0)
 9a4:	00878713          	addi	a4,a5,8
 9a8:	f4e43423          	sd	a4,-184(s0)
 9ac:	0007a783          	lw	a5,0(a5)
 9b0:	f8f42623          	sw	a5,-116(s0)
 9b4:	5e80006f          	j	f9c <vprintfmt+0x7cc>
 9b8:	f5043783          	ld	a5,-176(s0)
 9bc:	f5040713          	addi	a4,s0,-176
 9c0:	00a00613          	li	a2,10
 9c4:	00070593          	mv	a1,a4
 9c8:	00078513          	mv	a0,a5
 9cc:	fffff097          	auipc	ra,0xfffff
 9d0:	7d8080e7          	jalr	2008(ra) # 1a4 <strtol>
 9d4:	00050793          	mv	a5,a0
 9d8:	0007879b          	sext.w	a5,a5
 9dc:	f8f42623          	sw	a5,-116(s0)
 9e0:	f5043783          	ld	a5,-176(s0)
 9e4:	fff78793          	addi	a5,a5,-1
 9e8:	f4f43823          	sd	a5,-176(s0)
 9ec:	5b00006f          	j	f9c <vprintfmt+0x7cc>
 9f0:	f5043783          	ld	a5,-176(s0)
 9f4:	0007c783          	lbu	a5,0(a5)
 9f8:	00078713          	mv	a4,a5
 9fc:	07800793          	li	a5,120
 a00:	02f70663          	beq	a4,a5,a2c <vprintfmt+0x25c>
 a04:	f5043783          	ld	a5,-176(s0)
 a08:	0007c783          	lbu	a5,0(a5)
 a0c:	00078713          	mv	a4,a5
 a10:	05800793          	li	a5,88
 a14:	00f70c63          	beq	a4,a5,a2c <vprintfmt+0x25c>
 a18:	f5043783          	ld	a5,-176(s0)
 a1c:	0007c783          	lbu	a5,0(a5)
 a20:	00078713          	mv	a4,a5
 a24:	07000793          	li	a5,112
 a28:	30f71063          	bne	a4,a5,d28 <vprintfmt+0x558>
 a2c:	f5043783          	ld	a5,-176(s0)
 a30:	0007c783          	lbu	a5,0(a5)
 a34:	00078713          	mv	a4,a5
 a38:	07000793          	li	a5,112
 a3c:	00f70663          	beq	a4,a5,a48 <vprintfmt+0x278>
 a40:	f8144783          	lbu	a5,-127(s0)
 a44:	00078663          	beqz	a5,a50 <vprintfmt+0x280>
 a48:	00100793          	li	a5,1
 a4c:	0080006f          	j	a54 <vprintfmt+0x284>
 a50:	00000793          	li	a5,0
 a54:	faf403a3          	sb	a5,-89(s0)
 a58:	fa744783          	lbu	a5,-89(s0)
 a5c:	0017f793          	andi	a5,a5,1
 a60:	faf403a3          	sb	a5,-89(s0)
 a64:	fa744783          	lbu	a5,-89(s0)
 a68:	0ff7f793          	zext.b	a5,a5
 a6c:	00078c63          	beqz	a5,a84 <vprintfmt+0x2b4>
 a70:	f4843783          	ld	a5,-184(s0)
 a74:	00878713          	addi	a4,a5,8
 a78:	f4e43423          	sd	a4,-184(s0)
 a7c:	0007b783          	ld	a5,0(a5)
 a80:	01c0006f          	j	a9c <vprintfmt+0x2cc>
 a84:	f4843783          	ld	a5,-184(s0)
 a88:	00878713          	addi	a4,a5,8
 a8c:	f4e43423          	sd	a4,-184(s0)
 a90:	0007a783          	lw	a5,0(a5)
 a94:	02079793          	slli	a5,a5,0x20
 a98:	0207d793          	srli	a5,a5,0x20
 a9c:	fef43023          	sd	a5,-32(s0)
 aa0:	f8c42783          	lw	a5,-116(s0)
 aa4:	02079463          	bnez	a5,acc <vprintfmt+0x2fc>
 aa8:	fe043783          	ld	a5,-32(s0)
 aac:	02079063          	bnez	a5,acc <vprintfmt+0x2fc>
 ab0:	f5043783          	ld	a5,-176(s0)
 ab4:	0007c783          	lbu	a5,0(a5)
 ab8:	00078713          	mv	a4,a5
 abc:	07000793          	li	a5,112
 ac0:	00f70663          	beq	a4,a5,acc <vprintfmt+0x2fc>
 ac4:	f8040023          	sb	zero,-128(s0)
 ac8:	4d40006f          	j	f9c <vprintfmt+0x7cc>
 acc:	f5043783          	ld	a5,-176(s0)
 ad0:	0007c783          	lbu	a5,0(a5)
 ad4:	00078713          	mv	a4,a5
 ad8:	07000793          	li	a5,112
 adc:	00f70a63          	beq	a4,a5,af0 <vprintfmt+0x320>
 ae0:	f8244783          	lbu	a5,-126(s0)
 ae4:	00078a63          	beqz	a5,af8 <vprintfmt+0x328>
 ae8:	fe043783          	ld	a5,-32(s0)
 aec:	00078663          	beqz	a5,af8 <vprintfmt+0x328>
 af0:	00100793          	li	a5,1
 af4:	0080006f          	j	afc <vprintfmt+0x32c>
 af8:	00000793          	li	a5,0
 afc:	faf40323          	sb	a5,-90(s0)
 b00:	fa644783          	lbu	a5,-90(s0)
 b04:	0017f793          	andi	a5,a5,1
 b08:	faf40323          	sb	a5,-90(s0)
 b0c:	fc042e23          	sw	zero,-36(s0)
 b10:	f5043783          	ld	a5,-176(s0)
 b14:	0007c783          	lbu	a5,0(a5)
 b18:	00078713          	mv	a4,a5
 b1c:	05800793          	li	a5,88
 b20:	00f71863          	bne	a4,a5,b30 <vprintfmt+0x360>
 b24:	00000797          	auipc	a5,0x0
 b28:	79478793          	addi	a5,a5,1940 # 12b8 <upperxdigits.1>
 b2c:	00c0006f          	j	b38 <vprintfmt+0x368>
 b30:	00000797          	auipc	a5,0x0
 b34:	7a078793          	addi	a5,a5,1952 # 12d0 <lowerxdigits.0>
 b38:	f8f43c23          	sd	a5,-104(s0)
 b3c:	fe043783          	ld	a5,-32(s0)
 b40:	00f7f793          	andi	a5,a5,15
 b44:	f9843703          	ld	a4,-104(s0)
 b48:	00f70733          	add	a4,a4,a5
 b4c:	fdc42783          	lw	a5,-36(s0)
 b50:	0017869b          	addiw	a3,a5,1
 b54:	fcd42e23          	sw	a3,-36(s0)
 b58:	00074703          	lbu	a4,0(a4)
 b5c:	ff078793          	addi	a5,a5,-16
 b60:	008787b3          	add	a5,a5,s0
 b64:	f8e78023          	sb	a4,-128(a5)
 b68:	fe043783          	ld	a5,-32(s0)
 b6c:	0047d793          	srli	a5,a5,0x4
 b70:	fef43023          	sd	a5,-32(s0)
 b74:	fe043783          	ld	a5,-32(s0)
 b78:	fc0792e3          	bnez	a5,b3c <vprintfmt+0x36c>
 b7c:	f8c42703          	lw	a4,-116(s0)
 b80:	fff00793          	li	a5,-1
 b84:	02f71663          	bne	a4,a5,bb0 <vprintfmt+0x3e0>
 b88:	f8344783          	lbu	a5,-125(s0)
 b8c:	02078263          	beqz	a5,bb0 <vprintfmt+0x3e0>
 b90:	f8842703          	lw	a4,-120(s0)
 b94:	fa644783          	lbu	a5,-90(s0)
 b98:	0007879b          	sext.w	a5,a5
 b9c:	0017979b          	slliw	a5,a5,0x1
 ba0:	0007879b          	sext.w	a5,a5
 ba4:	40f707bb          	subw	a5,a4,a5
 ba8:	0007879b          	sext.w	a5,a5
 bac:	f8f42623          	sw	a5,-116(s0)
 bb0:	f8842703          	lw	a4,-120(s0)
 bb4:	fa644783          	lbu	a5,-90(s0)
 bb8:	0007879b          	sext.w	a5,a5
 bbc:	0017979b          	slliw	a5,a5,0x1
 bc0:	0007879b          	sext.w	a5,a5
 bc4:	40f707bb          	subw	a5,a4,a5
 bc8:	0007871b          	sext.w	a4,a5
 bcc:	fdc42783          	lw	a5,-36(s0)
 bd0:	f8f42a23          	sw	a5,-108(s0)
 bd4:	f8c42783          	lw	a5,-116(s0)
 bd8:	f8f42823          	sw	a5,-112(s0)
 bdc:	f9442783          	lw	a5,-108(s0)
 be0:	00078593          	mv	a1,a5
 be4:	f9042783          	lw	a5,-112(s0)
 be8:	00078613          	mv	a2,a5
 bec:	0006069b          	sext.w	a3,a2
 bf0:	0005879b          	sext.w	a5,a1
 bf4:	00f6d463          	bge	a3,a5,bfc <vprintfmt+0x42c>
 bf8:	00058613          	mv	a2,a1
 bfc:	0006079b          	sext.w	a5,a2
 c00:	40f707bb          	subw	a5,a4,a5
 c04:	fcf42c23          	sw	a5,-40(s0)
 c08:	0280006f          	j	c30 <vprintfmt+0x460>
 c0c:	f5843783          	ld	a5,-168(s0)
 c10:	02000513          	li	a0,32
 c14:	000780e7          	jalr	a5
 c18:	fec42783          	lw	a5,-20(s0)
 c1c:	0017879b          	addiw	a5,a5,1
 c20:	fef42623          	sw	a5,-20(s0)
 c24:	fd842783          	lw	a5,-40(s0)
 c28:	fff7879b          	addiw	a5,a5,-1
 c2c:	fcf42c23          	sw	a5,-40(s0)
 c30:	fd842783          	lw	a5,-40(s0)
 c34:	0007879b          	sext.w	a5,a5
 c38:	fcf04ae3          	bgtz	a5,c0c <vprintfmt+0x43c>
 c3c:	fa644783          	lbu	a5,-90(s0)
 c40:	0ff7f793          	zext.b	a5,a5
 c44:	04078463          	beqz	a5,c8c <vprintfmt+0x4bc>
 c48:	f5843783          	ld	a5,-168(s0)
 c4c:	03000513          	li	a0,48
 c50:	000780e7          	jalr	a5
 c54:	f5043783          	ld	a5,-176(s0)
 c58:	0007c783          	lbu	a5,0(a5)
 c5c:	00078713          	mv	a4,a5
 c60:	05800793          	li	a5,88
 c64:	00f71663          	bne	a4,a5,c70 <vprintfmt+0x4a0>
 c68:	05800793          	li	a5,88
 c6c:	0080006f          	j	c74 <vprintfmt+0x4a4>
 c70:	07800793          	li	a5,120
 c74:	f5843703          	ld	a4,-168(s0)
 c78:	00078513          	mv	a0,a5
 c7c:	000700e7          	jalr	a4
 c80:	fec42783          	lw	a5,-20(s0)
 c84:	0027879b          	addiw	a5,a5,2
 c88:	fef42623          	sw	a5,-20(s0)
 c8c:	fdc42783          	lw	a5,-36(s0)
 c90:	fcf42a23          	sw	a5,-44(s0)
 c94:	0280006f          	j	cbc <vprintfmt+0x4ec>
 c98:	f5843783          	ld	a5,-168(s0)
 c9c:	03000513          	li	a0,48
 ca0:	000780e7          	jalr	a5
 ca4:	fec42783          	lw	a5,-20(s0)
 ca8:	0017879b          	addiw	a5,a5,1
 cac:	fef42623          	sw	a5,-20(s0)
 cb0:	fd442783          	lw	a5,-44(s0)
 cb4:	0017879b          	addiw	a5,a5,1
 cb8:	fcf42a23          	sw	a5,-44(s0)
 cbc:	f8c42783          	lw	a5,-116(s0)
 cc0:	fd442703          	lw	a4,-44(s0)
 cc4:	0007071b          	sext.w	a4,a4
 cc8:	fcf748e3          	blt	a4,a5,c98 <vprintfmt+0x4c8>
 ccc:	fdc42783          	lw	a5,-36(s0)
 cd0:	fff7879b          	addiw	a5,a5,-1
 cd4:	fcf42823          	sw	a5,-48(s0)
 cd8:	03c0006f          	j	d14 <vprintfmt+0x544>
 cdc:	fd042783          	lw	a5,-48(s0)
 ce0:	ff078793          	addi	a5,a5,-16
 ce4:	008787b3          	add	a5,a5,s0
 ce8:	f807c783          	lbu	a5,-128(a5)
 cec:	0007871b          	sext.w	a4,a5
 cf0:	f5843783          	ld	a5,-168(s0)
 cf4:	00070513          	mv	a0,a4
 cf8:	000780e7          	jalr	a5
 cfc:	fec42783          	lw	a5,-20(s0)
 d00:	0017879b          	addiw	a5,a5,1
 d04:	fef42623          	sw	a5,-20(s0)
 d08:	fd042783          	lw	a5,-48(s0)
 d0c:	fff7879b          	addiw	a5,a5,-1
 d10:	fcf42823          	sw	a5,-48(s0)
 d14:	fd042783          	lw	a5,-48(s0)
 d18:	0007879b          	sext.w	a5,a5
 d1c:	fc07d0e3          	bgez	a5,cdc <vprintfmt+0x50c>
 d20:	f8040023          	sb	zero,-128(s0)
 d24:	2780006f          	j	f9c <vprintfmt+0x7cc>
 d28:	f5043783          	ld	a5,-176(s0)
 d2c:	0007c783          	lbu	a5,0(a5)
 d30:	00078713          	mv	a4,a5
 d34:	06400793          	li	a5,100
 d38:	02f70663          	beq	a4,a5,d64 <vprintfmt+0x594>
 d3c:	f5043783          	ld	a5,-176(s0)
 d40:	0007c783          	lbu	a5,0(a5)
 d44:	00078713          	mv	a4,a5
 d48:	06900793          	li	a5,105
 d4c:	00f70c63          	beq	a4,a5,d64 <vprintfmt+0x594>
 d50:	f5043783          	ld	a5,-176(s0)
 d54:	0007c783          	lbu	a5,0(a5)
 d58:	00078713          	mv	a4,a5
 d5c:	07500793          	li	a5,117
 d60:	08f71263          	bne	a4,a5,de4 <vprintfmt+0x614>
 d64:	f8144783          	lbu	a5,-127(s0)
 d68:	00078c63          	beqz	a5,d80 <vprintfmt+0x5b0>
 d6c:	f4843783          	ld	a5,-184(s0)
 d70:	00878713          	addi	a4,a5,8
 d74:	f4e43423          	sd	a4,-184(s0)
 d78:	0007b783          	ld	a5,0(a5)
 d7c:	0140006f          	j	d90 <vprintfmt+0x5c0>
 d80:	f4843783          	ld	a5,-184(s0)
 d84:	00878713          	addi	a4,a5,8
 d88:	f4e43423          	sd	a4,-184(s0)
 d8c:	0007a783          	lw	a5,0(a5)
 d90:	faf43423          	sd	a5,-88(s0)
 d94:	fa843583          	ld	a1,-88(s0)
 d98:	f5043783          	ld	a5,-176(s0)
 d9c:	0007c783          	lbu	a5,0(a5)
 da0:	0007871b          	sext.w	a4,a5
 da4:	07500793          	li	a5,117
 da8:	40f707b3          	sub	a5,a4,a5
 dac:	00f037b3          	snez	a5,a5
 db0:	0ff7f793          	zext.b	a5,a5
 db4:	f8040713          	addi	a4,s0,-128
 db8:	00070693          	mv	a3,a4
 dbc:	00078613          	mv	a2,a5
 dc0:	f5843503          	ld	a0,-168(s0)
 dc4:	fffff097          	auipc	ra,0xfffff
 dc8:	6d8080e7          	jalr	1752(ra) # 49c <print_dec_int>
 dcc:	00050793          	mv	a5,a0
 dd0:	fec42703          	lw	a4,-20(s0)
 dd4:	00f707bb          	addw	a5,a4,a5
 dd8:	fef42623          	sw	a5,-20(s0)
 ddc:	f8040023          	sb	zero,-128(s0)
 de0:	1bc0006f          	j	f9c <vprintfmt+0x7cc>
 de4:	f5043783          	ld	a5,-176(s0)
 de8:	0007c783          	lbu	a5,0(a5)
 dec:	00078713          	mv	a4,a5
 df0:	06e00793          	li	a5,110
 df4:	04f71c63          	bne	a4,a5,e4c <vprintfmt+0x67c>
 df8:	f8144783          	lbu	a5,-127(s0)
 dfc:	02078463          	beqz	a5,e24 <vprintfmt+0x654>
 e00:	f4843783          	ld	a5,-184(s0)
 e04:	00878713          	addi	a4,a5,8
 e08:	f4e43423          	sd	a4,-184(s0)
 e0c:	0007b783          	ld	a5,0(a5)
 e10:	faf43823          	sd	a5,-80(s0)
 e14:	fec42703          	lw	a4,-20(s0)
 e18:	fb043783          	ld	a5,-80(s0)
 e1c:	00e7b023          	sd	a4,0(a5)
 e20:	0240006f          	j	e44 <vprintfmt+0x674>
 e24:	f4843783          	ld	a5,-184(s0)
 e28:	00878713          	addi	a4,a5,8
 e2c:	f4e43423          	sd	a4,-184(s0)
 e30:	0007b783          	ld	a5,0(a5)
 e34:	faf43c23          	sd	a5,-72(s0)
 e38:	fb843783          	ld	a5,-72(s0)
 e3c:	fec42703          	lw	a4,-20(s0)
 e40:	00e7a023          	sw	a4,0(a5)
 e44:	f8040023          	sb	zero,-128(s0)
 e48:	1540006f          	j	f9c <vprintfmt+0x7cc>
 e4c:	f5043783          	ld	a5,-176(s0)
 e50:	0007c783          	lbu	a5,0(a5)
 e54:	00078713          	mv	a4,a5
 e58:	07300793          	li	a5,115
 e5c:	04f71063          	bne	a4,a5,e9c <vprintfmt+0x6cc>
 e60:	f4843783          	ld	a5,-184(s0)
 e64:	00878713          	addi	a4,a5,8
 e68:	f4e43423          	sd	a4,-184(s0)
 e6c:	0007b783          	ld	a5,0(a5)
 e70:	fcf43023          	sd	a5,-64(s0)
 e74:	fc043583          	ld	a1,-64(s0)
 e78:	f5843503          	ld	a0,-168(s0)
 e7c:	fffff097          	auipc	ra,0xfffff
 e80:	598080e7          	jalr	1432(ra) # 414 <puts_wo_nl>
 e84:	00050793          	mv	a5,a0
 e88:	fec42703          	lw	a4,-20(s0)
 e8c:	00f707bb          	addw	a5,a4,a5
 e90:	fef42623          	sw	a5,-20(s0)
 e94:	f8040023          	sb	zero,-128(s0)
 e98:	1040006f          	j	f9c <vprintfmt+0x7cc>
 e9c:	f5043783          	ld	a5,-176(s0)
 ea0:	0007c783          	lbu	a5,0(a5)
 ea4:	00078713          	mv	a4,a5
 ea8:	06300793          	li	a5,99
 eac:	02f71e63          	bne	a4,a5,ee8 <vprintfmt+0x718>
 eb0:	f4843783          	ld	a5,-184(s0)
 eb4:	00878713          	addi	a4,a5,8
 eb8:	f4e43423          	sd	a4,-184(s0)
 ebc:	0007a783          	lw	a5,0(a5)
 ec0:	fcf42623          	sw	a5,-52(s0)
 ec4:	fcc42703          	lw	a4,-52(s0)
 ec8:	f5843783          	ld	a5,-168(s0)
 ecc:	00070513          	mv	a0,a4
 ed0:	000780e7          	jalr	a5
 ed4:	fec42783          	lw	a5,-20(s0)
 ed8:	0017879b          	addiw	a5,a5,1
 edc:	fef42623          	sw	a5,-20(s0)
 ee0:	f8040023          	sb	zero,-128(s0)
 ee4:	0b80006f          	j	f9c <vprintfmt+0x7cc>
 ee8:	f5043783          	ld	a5,-176(s0)
 eec:	0007c783          	lbu	a5,0(a5)
 ef0:	00078713          	mv	a4,a5
 ef4:	02500793          	li	a5,37
 ef8:	02f71263          	bne	a4,a5,f1c <vprintfmt+0x74c>
 efc:	f5843783          	ld	a5,-168(s0)
 f00:	02500513          	li	a0,37
 f04:	000780e7          	jalr	a5
 f08:	fec42783          	lw	a5,-20(s0)
 f0c:	0017879b          	addiw	a5,a5,1
 f10:	fef42623          	sw	a5,-20(s0)
 f14:	f8040023          	sb	zero,-128(s0)
 f18:	0840006f          	j	f9c <vprintfmt+0x7cc>
 f1c:	f5043783          	ld	a5,-176(s0)
 f20:	0007c783          	lbu	a5,0(a5)
 f24:	0007871b          	sext.w	a4,a5
 f28:	f5843783          	ld	a5,-168(s0)
 f2c:	00070513          	mv	a0,a4
 f30:	000780e7          	jalr	a5
 f34:	fec42783          	lw	a5,-20(s0)
 f38:	0017879b          	addiw	a5,a5,1
 f3c:	fef42623          	sw	a5,-20(s0)
 f40:	f8040023          	sb	zero,-128(s0)
 f44:	0580006f          	j	f9c <vprintfmt+0x7cc>
 f48:	f5043783          	ld	a5,-176(s0)
 f4c:	0007c783          	lbu	a5,0(a5)
 f50:	00078713          	mv	a4,a5
 f54:	02500793          	li	a5,37
 f58:	02f71063          	bne	a4,a5,f78 <vprintfmt+0x7a8>
 f5c:	f8043023          	sd	zero,-128(s0)
 f60:	f8043423          	sd	zero,-120(s0)
 f64:	00100793          	li	a5,1
 f68:	f8f40023          	sb	a5,-128(s0)
 f6c:	fff00793          	li	a5,-1
 f70:	f8f42623          	sw	a5,-116(s0)
 f74:	0280006f          	j	f9c <vprintfmt+0x7cc>
 f78:	f5043783          	ld	a5,-176(s0)
 f7c:	0007c783          	lbu	a5,0(a5)
 f80:	0007871b          	sext.w	a4,a5
 f84:	f5843783          	ld	a5,-168(s0)
 f88:	00070513          	mv	a0,a4
 f8c:	000780e7          	jalr	a5
 f90:	fec42783          	lw	a5,-20(s0)
 f94:	0017879b          	addiw	a5,a5,1
 f98:	fef42623          	sw	a5,-20(s0)
 f9c:	f5043783          	ld	a5,-176(s0)
 fa0:	00178793          	addi	a5,a5,1
 fa4:	f4f43823          	sd	a5,-176(s0)
 fa8:	f5043783          	ld	a5,-176(s0)
 fac:	0007c783          	lbu	a5,0(a5)
 fb0:	840796e3          	bnez	a5,7fc <vprintfmt+0x2c>
 fb4:	fec42783          	lw	a5,-20(s0)
 fb8:	00078513          	mv	a0,a5
 fbc:	0b813083          	ld	ra,184(sp)
 fc0:	0b013403          	ld	s0,176(sp)
 fc4:	0c010113          	addi	sp,sp,192
 fc8:	00008067          	ret

Disassembly of section .text.printf:

0000000000000fcc <printf>:
     fcc:	f8010113          	addi	sp,sp,-128
     fd0:	02113c23          	sd	ra,56(sp)
     fd4:	02813823          	sd	s0,48(sp)
     fd8:	04010413          	addi	s0,sp,64
     fdc:	fca43423          	sd	a0,-56(s0)
     fe0:	00b43423          	sd	a1,8(s0)
     fe4:	00c43823          	sd	a2,16(s0)
     fe8:	00d43c23          	sd	a3,24(s0)
     fec:	02e43023          	sd	a4,32(s0)
     ff0:	02f43423          	sd	a5,40(s0)
     ff4:	03043823          	sd	a6,48(s0)
     ff8:	03143c23          	sd	a7,56(s0)
     ffc:	fe042623          	sw	zero,-20(s0)
    1000:	04040793          	addi	a5,s0,64
    1004:	fcf43023          	sd	a5,-64(s0)
    1008:	fc043783          	ld	a5,-64(s0)
    100c:	fc878793          	addi	a5,a5,-56
    1010:	fcf43823          	sd	a5,-48(s0)
    1014:	fd043783          	ld	a5,-48(s0)
    1018:	00078613          	mv	a2,a5
    101c:	fc843583          	ld	a1,-56(s0)
    1020:	fffff517          	auipc	a0,0xfffff
    1024:	0ac50513          	addi	a0,a0,172 # cc <putc>
    1028:	fffff097          	auipc	ra,0xfffff
    102c:	7a8080e7          	jalr	1960(ra) # 7d0 <vprintfmt>
    1030:	00050793          	mv	a5,a0
    1034:	fef42623          	sw	a5,-20(s0)
    1038:	00100793          	li	a5,1
    103c:	fef43023          	sd	a5,-32(s0)
    1040:	00000797          	auipc	a5,0x0
    1044:	2a878793          	addi	a5,a5,680 # 12e8 <tail>
    1048:	0007a783          	lw	a5,0(a5)
    104c:	0017871b          	addiw	a4,a5,1
    1050:	0007069b          	sext.w	a3,a4
    1054:	00000717          	auipc	a4,0x0
    1058:	29470713          	addi	a4,a4,660 # 12e8 <tail>
    105c:	00d72023          	sw	a3,0(a4)
    1060:	00000717          	auipc	a4,0x0
    1064:	29070713          	addi	a4,a4,656 # 12f0 <buffer>
    1068:	00f707b3          	add	a5,a4,a5
    106c:	00078023          	sb	zero,0(a5)
    1070:	00000797          	auipc	a5,0x0
    1074:	27878793          	addi	a5,a5,632 # 12e8 <tail>
    1078:	0007a603          	lw	a2,0(a5)
    107c:	fe043703          	ld	a4,-32(s0)
    1080:	00000697          	auipc	a3,0x0
    1084:	27068693          	addi	a3,a3,624 # 12f0 <buffer>
    1088:	fd843783          	ld	a5,-40(s0)
    108c:	04000893          	li	a7,64
    1090:	00070513          	mv	a0,a4
    1094:	00068593          	mv	a1,a3
    1098:	00060613          	mv	a2,a2
    109c:	00000073          	ecall
    10a0:	00050793          	mv	a5,a0
    10a4:	fcf43c23          	sd	a5,-40(s0)
    10a8:	00000797          	auipc	a5,0x0
    10ac:	24078793          	addi	a5,a5,576 # 12e8 <tail>
    10b0:	0007a023          	sw	zero,0(a5)
    10b4:	fec42783          	lw	a5,-20(s0)
    10b8:	00078513          	mv	a0,a5
    10bc:	03813083          	ld	ra,56(sp)
    10c0:	03013403          	ld	s0,48(sp)
    10c4:	08010113          	addi	sp,sp,128
    10c8:	00008067          	ret
