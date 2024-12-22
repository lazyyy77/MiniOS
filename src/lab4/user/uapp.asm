
uapp:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100e8 <_start>:
   100e8:	0400006f          	j	10128 <main>

00000000000100ec <getpid>:
   100ec:	fe010113          	addi	sp,sp,-32
   100f0:	00113c23          	sd	ra,24(sp)
   100f4:	00813823          	sd	s0,16(sp)
   100f8:	02010413          	addi	s0,sp,32
   100fc:	fe843783          	ld	a5,-24(s0)
   10100:	0ac00893          	li	a7,172
   10104:	00000073          	ecall
   10108:	00050793          	mv	a5,a0
   1010c:	fef43423          	sd	a5,-24(s0)
   10110:	fe843783          	ld	a5,-24(s0)
   10114:	00078513          	mv	a0,a5
   10118:	01813083          	ld	ra,24(sp)
   1011c:	01013403          	ld	s0,16(sp)
   10120:	02010113          	addi	sp,sp,32
   10124:	00008067          	ret

0000000000010128 <main>:
   10128:	fe010113          	addi	sp,sp,-32
   1012c:	00113c23          	sd	ra,24(sp)
   10130:	00813823          	sd	s0,16(sp)
   10134:	02010413          	addi	s0,sp,32
   10138:	00000097          	auipc	ra,0x0
   1013c:	fb4080e7          	jalr	-76(ra) # 100ec <getpid>
   10140:	00050593          	mv	a1,a0
   10144:	00010613          	mv	a2,sp
   10148:	00002797          	auipc	a5,0x2
   1014c:	eb878793          	addi	a5,a5,-328 # 12000 <counter>
   10150:	0007a783          	lw	a5,0(a5)
   10154:	0017879b          	addiw	a5,a5,1
   10158:	0007871b          	sext.w	a4,a5
   1015c:	00002797          	auipc	a5,0x2
   10160:	ea478793          	addi	a5,a5,-348 # 12000 <counter>
   10164:	00e7a023          	sw	a4,0(a5)
   10168:	00002797          	auipc	a5,0x2
   1016c:	e9878793          	addi	a5,a5,-360 # 12000 <counter>
   10170:	0007a783          	lw	a5,0(a5)
   10174:	00078693          	mv	a3,a5
   10178:	00001517          	auipc	a0,0x1
   1017c:	04050513          	addi	a0,a0,64 # 111b8 <printf+0x104>
   10180:	00001097          	auipc	ra,0x1
   10184:	f34080e7          	jalr	-204(ra) # 110b4 <printf>
   10188:	fe042623          	sw	zero,-20(s0)
   1018c:	0100006f          	j	1019c <main+0x74>
   10190:	fec42783          	lw	a5,-20(s0)
   10194:	0017879b          	addiw	a5,a5,1
   10198:	fef42623          	sw	a5,-20(s0)
   1019c:	fec42783          	lw	a5,-20(s0)
   101a0:	0007871b          	sext.w	a4,a5
   101a4:	500007b7          	lui	a5,0x50000
   101a8:	ffe78793          	addi	a5,a5,-2 # 4ffffffe <__global_pointer$+0x4ffed7fe>
   101ac:	fee7f2e3          	bgeu	a5,a4,10190 <main+0x68>
   101b0:	f89ff06f          	j	10138 <main+0x10>

00000000000101b4 <putc>:
   101b4:	fe010113          	addi	sp,sp,-32
   101b8:	00113c23          	sd	ra,24(sp)
   101bc:	00813823          	sd	s0,16(sp)
   101c0:	02010413          	addi	s0,sp,32
   101c4:	00050793          	mv	a5,a0
   101c8:	fef42623          	sw	a5,-20(s0)
   101cc:	00002797          	auipc	a5,0x2
   101d0:	e3878793          	addi	a5,a5,-456 # 12004 <tail>
   101d4:	0007a783          	lw	a5,0(a5)
   101d8:	0017871b          	addiw	a4,a5,1
   101dc:	0007069b          	sext.w	a3,a4
   101e0:	00002717          	auipc	a4,0x2
   101e4:	e2470713          	addi	a4,a4,-476 # 12004 <tail>
   101e8:	00d72023          	sw	a3,0(a4)
   101ec:	fec42703          	lw	a4,-20(s0)
   101f0:	0ff77713          	zext.b	a4,a4
   101f4:	00002697          	auipc	a3,0x2
   101f8:	e1468693          	addi	a3,a3,-492 # 12008 <buffer>
   101fc:	00f687b3          	add	a5,a3,a5
   10200:	00e78023          	sb	a4,0(a5)
   10204:	fec42783          	lw	a5,-20(s0)
   10208:	0ff7f793          	zext.b	a5,a5
   1020c:	0007879b          	sext.w	a5,a5
   10210:	00078513          	mv	a0,a5
   10214:	01813083          	ld	ra,24(sp)
   10218:	01013403          	ld	s0,16(sp)
   1021c:	02010113          	addi	sp,sp,32
   10220:	00008067          	ret

0000000000010224 <isspace>:
   10224:	fe010113          	addi	sp,sp,-32
   10228:	00113c23          	sd	ra,24(sp)
   1022c:	00813823          	sd	s0,16(sp)
   10230:	02010413          	addi	s0,sp,32
   10234:	00050793          	mv	a5,a0
   10238:	fef42623          	sw	a5,-20(s0)
   1023c:	fec42783          	lw	a5,-20(s0)
   10240:	0007871b          	sext.w	a4,a5
   10244:	02000793          	li	a5,32
   10248:	02f70263          	beq	a4,a5,1026c <isspace+0x48>
   1024c:	fec42783          	lw	a5,-20(s0)
   10250:	0007871b          	sext.w	a4,a5
   10254:	00800793          	li	a5,8
   10258:	00e7de63          	bge	a5,a4,10274 <isspace+0x50>
   1025c:	fec42783          	lw	a5,-20(s0)
   10260:	0007871b          	sext.w	a4,a5
   10264:	00d00793          	li	a5,13
   10268:	00e7c663          	blt	a5,a4,10274 <isspace+0x50>
   1026c:	00100793          	li	a5,1
   10270:	0080006f          	j	10278 <isspace+0x54>
   10274:	00000793          	li	a5,0
   10278:	00078513          	mv	a0,a5
   1027c:	01813083          	ld	ra,24(sp)
   10280:	01013403          	ld	s0,16(sp)
   10284:	02010113          	addi	sp,sp,32
   10288:	00008067          	ret

000000000001028c <strtol>:
   1028c:	fb010113          	addi	sp,sp,-80
   10290:	04113423          	sd	ra,72(sp)
   10294:	04813023          	sd	s0,64(sp)
   10298:	05010413          	addi	s0,sp,80
   1029c:	fca43423          	sd	a0,-56(s0)
   102a0:	fcb43023          	sd	a1,-64(s0)
   102a4:	00060793          	mv	a5,a2
   102a8:	faf42e23          	sw	a5,-68(s0)
   102ac:	fe043423          	sd	zero,-24(s0)
   102b0:	fe0403a3          	sb	zero,-25(s0)
   102b4:	fc843783          	ld	a5,-56(s0)
   102b8:	fcf43c23          	sd	a5,-40(s0)
   102bc:	0100006f          	j	102cc <strtol+0x40>
   102c0:	fd843783          	ld	a5,-40(s0)
   102c4:	00178793          	addi	a5,a5,1
   102c8:	fcf43c23          	sd	a5,-40(s0)
   102cc:	fd843783          	ld	a5,-40(s0)
   102d0:	0007c783          	lbu	a5,0(a5)
   102d4:	0007879b          	sext.w	a5,a5
   102d8:	00078513          	mv	a0,a5
   102dc:	00000097          	auipc	ra,0x0
   102e0:	f48080e7          	jalr	-184(ra) # 10224 <isspace>
   102e4:	00050793          	mv	a5,a0
   102e8:	fc079ce3          	bnez	a5,102c0 <strtol+0x34>
   102ec:	fd843783          	ld	a5,-40(s0)
   102f0:	0007c783          	lbu	a5,0(a5)
   102f4:	00078713          	mv	a4,a5
   102f8:	02d00793          	li	a5,45
   102fc:	00f71e63          	bne	a4,a5,10318 <strtol+0x8c>
   10300:	00100793          	li	a5,1
   10304:	fef403a3          	sb	a5,-25(s0)
   10308:	fd843783          	ld	a5,-40(s0)
   1030c:	00178793          	addi	a5,a5,1
   10310:	fcf43c23          	sd	a5,-40(s0)
   10314:	0240006f          	j	10338 <strtol+0xac>
   10318:	fd843783          	ld	a5,-40(s0)
   1031c:	0007c783          	lbu	a5,0(a5)
   10320:	00078713          	mv	a4,a5
   10324:	02b00793          	li	a5,43
   10328:	00f71863          	bne	a4,a5,10338 <strtol+0xac>
   1032c:	fd843783          	ld	a5,-40(s0)
   10330:	00178793          	addi	a5,a5,1
   10334:	fcf43c23          	sd	a5,-40(s0)
   10338:	fbc42783          	lw	a5,-68(s0)
   1033c:	0007879b          	sext.w	a5,a5
   10340:	06079c63          	bnez	a5,103b8 <strtol+0x12c>
   10344:	fd843783          	ld	a5,-40(s0)
   10348:	0007c783          	lbu	a5,0(a5)
   1034c:	00078713          	mv	a4,a5
   10350:	03000793          	li	a5,48
   10354:	04f71e63          	bne	a4,a5,103b0 <strtol+0x124>
   10358:	fd843783          	ld	a5,-40(s0)
   1035c:	00178793          	addi	a5,a5,1
   10360:	fcf43c23          	sd	a5,-40(s0)
   10364:	fd843783          	ld	a5,-40(s0)
   10368:	0007c783          	lbu	a5,0(a5)
   1036c:	00078713          	mv	a4,a5
   10370:	07800793          	li	a5,120
   10374:	00f70c63          	beq	a4,a5,1038c <strtol+0x100>
   10378:	fd843783          	ld	a5,-40(s0)
   1037c:	0007c783          	lbu	a5,0(a5)
   10380:	00078713          	mv	a4,a5
   10384:	05800793          	li	a5,88
   10388:	00f71e63          	bne	a4,a5,103a4 <strtol+0x118>
   1038c:	01000793          	li	a5,16
   10390:	faf42e23          	sw	a5,-68(s0)
   10394:	fd843783          	ld	a5,-40(s0)
   10398:	00178793          	addi	a5,a5,1
   1039c:	fcf43c23          	sd	a5,-40(s0)
   103a0:	0180006f          	j	103b8 <strtol+0x12c>
   103a4:	00800793          	li	a5,8
   103a8:	faf42e23          	sw	a5,-68(s0)
   103ac:	00c0006f          	j	103b8 <strtol+0x12c>
   103b0:	00a00793          	li	a5,10
   103b4:	faf42e23          	sw	a5,-68(s0)
   103b8:	fd843783          	ld	a5,-40(s0)
   103bc:	0007c783          	lbu	a5,0(a5)
   103c0:	00078713          	mv	a4,a5
   103c4:	02f00793          	li	a5,47
   103c8:	02e7f863          	bgeu	a5,a4,103f8 <strtol+0x16c>
   103cc:	fd843783          	ld	a5,-40(s0)
   103d0:	0007c783          	lbu	a5,0(a5)
   103d4:	00078713          	mv	a4,a5
   103d8:	03900793          	li	a5,57
   103dc:	00e7ee63          	bltu	a5,a4,103f8 <strtol+0x16c>
   103e0:	fd843783          	ld	a5,-40(s0)
   103e4:	0007c783          	lbu	a5,0(a5)
   103e8:	0007879b          	sext.w	a5,a5
   103ec:	fd07879b          	addiw	a5,a5,-48
   103f0:	fcf42a23          	sw	a5,-44(s0)
   103f4:	0800006f          	j	10474 <strtol+0x1e8>
   103f8:	fd843783          	ld	a5,-40(s0)
   103fc:	0007c783          	lbu	a5,0(a5)
   10400:	00078713          	mv	a4,a5
   10404:	06000793          	li	a5,96
   10408:	02e7f863          	bgeu	a5,a4,10438 <strtol+0x1ac>
   1040c:	fd843783          	ld	a5,-40(s0)
   10410:	0007c783          	lbu	a5,0(a5)
   10414:	00078713          	mv	a4,a5
   10418:	07a00793          	li	a5,122
   1041c:	00e7ee63          	bltu	a5,a4,10438 <strtol+0x1ac>
   10420:	fd843783          	ld	a5,-40(s0)
   10424:	0007c783          	lbu	a5,0(a5)
   10428:	0007879b          	sext.w	a5,a5
   1042c:	fa97879b          	addiw	a5,a5,-87
   10430:	fcf42a23          	sw	a5,-44(s0)
   10434:	0400006f          	j	10474 <strtol+0x1e8>
   10438:	fd843783          	ld	a5,-40(s0)
   1043c:	0007c783          	lbu	a5,0(a5)
   10440:	00078713          	mv	a4,a5
   10444:	04000793          	li	a5,64
   10448:	06e7f863          	bgeu	a5,a4,104b8 <strtol+0x22c>
   1044c:	fd843783          	ld	a5,-40(s0)
   10450:	0007c783          	lbu	a5,0(a5)
   10454:	00078713          	mv	a4,a5
   10458:	05a00793          	li	a5,90
   1045c:	04e7ee63          	bltu	a5,a4,104b8 <strtol+0x22c>
   10460:	fd843783          	ld	a5,-40(s0)
   10464:	0007c783          	lbu	a5,0(a5)
   10468:	0007879b          	sext.w	a5,a5
   1046c:	fc97879b          	addiw	a5,a5,-55
   10470:	fcf42a23          	sw	a5,-44(s0)
   10474:	fd442783          	lw	a5,-44(s0)
   10478:	00078713          	mv	a4,a5
   1047c:	fbc42783          	lw	a5,-68(s0)
   10480:	0007071b          	sext.w	a4,a4
   10484:	0007879b          	sext.w	a5,a5
   10488:	02f75663          	bge	a4,a5,104b4 <strtol+0x228>
   1048c:	fbc42703          	lw	a4,-68(s0)
   10490:	fe843783          	ld	a5,-24(s0)
   10494:	02f70733          	mul	a4,a4,a5
   10498:	fd442783          	lw	a5,-44(s0)
   1049c:	00f707b3          	add	a5,a4,a5
   104a0:	fef43423          	sd	a5,-24(s0)
   104a4:	fd843783          	ld	a5,-40(s0)
   104a8:	00178793          	addi	a5,a5,1
   104ac:	fcf43c23          	sd	a5,-40(s0)
   104b0:	f09ff06f          	j	103b8 <strtol+0x12c>
   104b4:	00000013          	nop
   104b8:	fc043783          	ld	a5,-64(s0)
   104bc:	00078863          	beqz	a5,104cc <strtol+0x240>
   104c0:	fc043783          	ld	a5,-64(s0)
   104c4:	fd843703          	ld	a4,-40(s0)
   104c8:	00e7b023          	sd	a4,0(a5)
   104cc:	fe744783          	lbu	a5,-25(s0)
   104d0:	0ff7f793          	zext.b	a5,a5
   104d4:	00078863          	beqz	a5,104e4 <strtol+0x258>
   104d8:	fe843783          	ld	a5,-24(s0)
   104dc:	40f007b3          	neg	a5,a5
   104e0:	0080006f          	j	104e8 <strtol+0x25c>
   104e4:	fe843783          	ld	a5,-24(s0)
   104e8:	00078513          	mv	a0,a5
   104ec:	04813083          	ld	ra,72(sp)
   104f0:	04013403          	ld	s0,64(sp)
   104f4:	05010113          	addi	sp,sp,80
   104f8:	00008067          	ret

00000000000104fc <puts_wo_nl>:
   104fc:	fd010113          	addi	sp,sp,-48
   10500:	02113423          	sd	ra,40(sp)
   10504:	02813023          	sd	s0,32(sp)
   10508:	03010413          	addi	s0,sp,48
   1050c:	fca43c23          	sd	a0,-40(s0)
   10510:	fcb43823          	sd	a1,-48(s0)
   10514:	fd043783          	ld	a5,-48(s0)
   10518:	00079863          	bnez	a5,10528 <puts_wo_nl+0x2c>
   1051c:	00001797          	auipc	a5,0x1
   10520:	cd478793          	addi	a5,a5,-812 # 111f0 <printf+0x13c>
   10524:	fcf43823          	sd	a5,-48(s0)
   10528:	fd043783          	ld	a5,-48(s0)
   1052c:	fef43423          	sd	a5,-24(s0)
   10530:	0240006f          	j	10554 <puts_wo_nl+0x58>
   10534:	fe843783          	ld	a5,-24(s0)
   10538:	00178713          	addi	a4,a5,1
   1053c:	fee43423          	sd	a4,-24(s0)
   10540:	0007c783          	lbu	a5,0(a5)
   10544:	0007871b          	sext.w	a4,a5
   10548:	fd843783          	ld	a5,-40(s0)
   1054c:	00070513          	mv	a0,a4
   10550:	000780e7          	jalr	a5
   10554:	fe843783          	ld	a5,-24(s0)
   10558:	0007c783          	lbu	a5,0(a5)
   1055c:	fc079ce3          	bnez	a5,10534 <puts_wo_nl+0x38>
   10560:	fe843703          	ld	a4,-24(s0)
   10564:	fd043783          	ld	a5,-48(s0)
   10568:	40f707b3          	sub	a5,a4,a5
   1056c:	0007879b          	sext.w	a5,a5
   10570:	00078513          	mv	a0,a5
   10574:	02813083          	ld	ra,40(sp)
   10578:	02013403          	ld	s0,32(sp)
   1057c:	03010113          	addi	sp,sp,48
   10580:	00008067          	ret

0000000000010584 <print_dec_int>:
   10584:	f9010113          	addi	sp,sp,-112
   10588:	06113423          	sd	ra,104(sp)
   1058c:	06813023          	sd	s0,96(sp)
   10590:	07010413          	addi	s0,sp,112
   10594:	faa43423          	sd	a0,-88(s0)
   10598:	fab43023          	sd	a1,-96(s0)
   1059c:	00060793          	mv	a5,a2
   105a0:	f8d43823          	sd	a3,-112(s0)
   105a4:	f8f40fa3          	sb	a5,-97(s0)
   105a8:	f9f44783          	lbu	a5,-97(s0)
   105ac:	0ff7f793          	zext.b	a5,a5
   105b0:	02078863          	beqz	a5,105e0 <print_dec_int+0x5c>
   105b4:	fa043703          	ld	a4,-96(s0)
   105b8:	fff00793          	li	a5,-1
   105bc:	03f79793          	slli	a5,a5,0x3f
   105c0:	02f71063          	bne	a4,a5,105e0 <print_dec_int+0x5c>
   105c4:	00001597          	auipc	a1,0x1
   105c8:	c3458593          	addi	a1,a1,-972 # 111f8 <printf+0x144>
   105cc:	fa843503          	ld	a0,-88(s0)
   105d0:	00000097          	auipc	ra,0x0
   105d4:	f2c080e7          	jalr	-212(ra) # 104fc <puts_wo_nl>
   105d8:	00050793          	mv	a5,a0
   105dc:	2c80006f          	j	108a4 <print_dec_int+0x320>
   105e0:	f9043783          	ld	a5,-112(s0)
   105e4:	00c7a783          	lw	a5,12(a5)
   105e8:	00079a63          	bnez	a5,105fc <print_dec_int+0x78>
   105ec:	fa043783          	ld	a5,-96(s0)
   105f0:	00079663          	bnez	a5,105fc <print_dec_int+0x78>
   105f4:	00000793          	li	a5,0
   105f8:	2ac0006f          	j	108a4 <print_dec_int+0x320>
   105fc:	fe0407a3          	sb	zero,-17(s0)
   10600:	f9f44783          	lbu	a5,-97(s0)
   10604:	0ff7f793          	zext.b	a5,a5
   10608:	02078063          	beqz	a5,10628 <print_dec_int+0xa4>
   1060c:	fa043783          	ld	a5,-96(s0)
   10610:	0007dc63          	bgez	a5,10628 <print_dec_int+0xa4>
   10614:	00100793          	li	a5,1
   10618:	fef407a3          	sb	a5,-17(s0)
   1061c:	fa043783          	ld	a5,-96(s0)
   10620:	40f007b3          	neg	a5,a5
   10624:	faf43023          	sd	a5,-96(s0)
   10628:	fe042423          	sw	zero,-24(s0)
   1062c:	f9f44783          	lbu	a5,-97(s0)
   10630:	0ff7f793          	zext.b	a5,a5
   10634:	02078863          	beqz	a5,10664 <print_dec_int+0xe0>
   10638:	fef44783          	lbu	a5,-17(s0)
   1063c:	0ff7f793          	zext.b	a5,a5
   10640:	00079e63          	bnez	a5,1065c <print_dec_int+0xd8>
   10644:	f9043783          	ld	a5,-112(s0)
   10648:	0057c783          	lbu	a5,5(a5)
   1064c:	00079863          	bnez	a5,1065c <print_dec_int+0xd8>
   10650:	f9043783          	ld	a5,-112(s0)
   10654:	0047c783          	lbu	a5,4(a5)
   10658:	00078663          	beqz	a5,10664 <print_dec_int+0xe0>
   1065c:	00100793          	li	a5,1
   10660:	0080006f          	j	10668 <print_dec_int+0xe4>
   10664:	00000793          	li	a5,0
   10668:	fcf40ba3          	sb	a5,-41(s0)
   1066c:	fd744783          	lbu	a5,-41(s0)
   10670:	0017f793          	andi	a5,a5,1
   10674:	fcf40ba3          	sb	a5,-41(s0)
   10678:	fa043683          	ld	a3,-96(s0)
   1067c:	00001797          	auipc	a5,0x1
   10680:	b9478793          	addi	a5,a5,-1132 # 11210 <printf+0x15c>
   10684:	0007b783          	ld	a5,0(a5)
   10688:	02f6b7b3          	mulhu	a5,a3,a5
   1068c:	0037d713          	srli	a4,a5,0x3
   10690:	00070793          	mv	a5,a4
   10694:	00279793          	slli	a5,a5,0x2
   10698:	00e787b3          	add	a5,a5,a4
   1069c:	00179793          	slli	a5,a5,0x1
   106a0:	40f68733          	sub	a4,a3,a5
   106a4:	0ff77713          	zext.b	a4,a4
   106a8:	fe842783          	lw	a5,-24(s0)
   106ac:	0017869b          	addiw	a3,a5,1
   106b0:	fed42423          	sw	a3,-24(s0)
   106b4:	0307071b          	addiw	a4,a4,48
   106b8:	0ff77713          	zext.b	a4,a4
   106bc:	ff078793          	addi	a5,a5,-16
   106c0:	008787b3          	add	a5,a5,s0
   106c4:	fce78423          	sb	a4,-56(a5)
   106c8:	fa043703          	ld	a4,-96(s0)
   106cc:	00001797          	auipc	a5,0x1
   106d0:	b4478793          	addi	a5,a5,-1212 # 11210 <printf+0x15c>
   106d4:	0007b783          	ld	a5,0(a5)
   106d8:	02f737b3          	mulhu	a5,a4,a5
   106dc:	0037d793          	srli	a5,a5,0x3
   106e0:	faf43023          	sd	a5,-96(s0)
   106e4:	fa043783          	ld	a5,-96(s0)
   106e8:	f80798e3          	bnez	a5,10678 <print_dec_int+0xf4>
   106ec:	f9043783          	ld	a5,-112(s0)
   106f0:	00c7a703          	lw	a4,12(a5)
   106f4:	fff00793          	li	a5,-1
   106f8:	02f71063          	bne	a4,a5,10718 <print_dec_int+0x194>
   106fc:	f9043783          	ld	a5,-112(s0)
   10700:	0037c783          	lbu	a5,3(a5)
   10704:	00078a63          	beqz	a5,10718 <print_dec_int+0x194>
   10708:	f9043783          	ld	a5,-112(s0)
   1070c:	0087a703          	lw	a4,8(a5)
   10710:	f9043783          	ld	a5,-112(s0)
   10714:	00e7a623          	sw	a4,12(a5)
   10718:	fe042223          	sw	zero,-28(s0)
   1071c:	f9043783          	ld	a5,-112(s0)
   10720:	0087a703          	lw	a4,8(a5)
   10724:	fe842783          	lw	a5,-24(s0)
   10728:	fcf42823          	sw	a5,-48(s0)
   1072c:	f9043783          	ld	a5,-112(s0)
   10730:	00c7a783          	lw	a5,12(a5)
   10734:	fcf42623          	sw	a5,-52(s0)
   10738:	fd042783          	lw	a5,-48(s0)
   1073c:	00078593          	mv	a1,a5
   10740:	fcc42783          	lw	a5,-52(s0)
   10744:	00078613          	mv	a2,a5
   10748:	0006069b          	sext.w	a3,a2
   1074c:	0005879b          	sext.w	a5,a1
   10750:	00f6d463          	bge	a3,a5,10758 <print_dec_int+0x1d4>
   10754:	00058613          	mv	a2,a1
   10758:	0006079b          	sext.w	a5,a2
   1075c:	40f707bb          	subw	a5,a4,a5
   10760:	0007871b          	sext.w	a4,a5
   10764:	fd744783          	lbu	a5,-41(s0)
   10768:	0007879b          	sext.w	a5,a5
   1076c:	40f707bb          	subw	a5,a4,a5
   10770:	fef42023          	sw	a5,-32(s0)
   10774:	0280006f          	j	1079c <print_dec_int+0x218>
   10778:	fa843783          	ld	a5,-88(s0)
   1077c:	02000513          	li	a0,32
   10780:	000780e7          	jalr	a5
   10784:	fe442783          	lw	a5,-28(s0)
   10788:	0017879b          	addiw	a5,a5,1
   1078c:	fef42223          	sw	a5,-28(s0)
   10790:	fe042783          	lw	a5,-32(s0)
   10794:	fff7879b          	addiw	a5,a5,-1
   10798:	fef42023          	sw	a5,-32(s0)
   1079c:	fe042783          	lw	a5,-32(s0)
   107a0:	0007879b          	sext.w	a5,a5
   107a4:	fcf04ae3          	bgtz	a5,10778 <print_dec_int+0x1f4>
   107a8:	fd744783          	lbu	a5,-41(s0)
   107ac:	0ff7f793          	zext.b	a5,a5
   107b0:	04078463          	beqz	a5,107f8 <print_dec_int+0x274>
   107b4:	fef44783          	lbu	a5,-17(s0)
   107b8:	0ff7f793          	zext.b	a5,a5
   107bc:	00078663          	beqz	a5,107c8 <print_dec_int+0x244>
   107c0:	02d00793          	li	a5,45
   107c4:	01c0006f          	j	107e0 <print_dec_int+0x25c>
   107c8:	f9043783          	ld	a5,-112(s0)
   107cc:	0057c783          	lbu	a5,5(a5)
   107d0:	00078663          	beqz	a5,107dc <print_dec_int+0x258>
   107d4:	02b00793          	li	a5,43
   107d8:	0080006f          	j	107e0 <print_dec_int+0x25c>
   107dc:	02000793          	li	a5,32
   107e0:	fa843703          	ld	a4,-88(s0)
   107e4:	00078513          	mv	a0,a5
   107e8:	000700e7          	jalr	a4
   107ec:	fe442783          	lw	a5,-28(s0)
   107f0:	0017879b          	addiw	a5,a5,1
   107f4:	fef42223          	sw	a5,-28(s0)
   107f8:	fe842783          	lw	a5,-24(s0)
   107fc:	fcf42e23          	sw	a5,-36(s0)
   10800:	0280006f          	j	10828 <print_dec_int+0x2a4>
   10804:	fa843783          	ld	a5,-88(s0)
   10808:	03000513          	li	a0,48
   1080c:	000780e7          	jalr	a5
   10810:	fe442783          	lw	a5,-28(s0)
   10814:	0017879b          	addiw	a5,a5,1
   10818:	fef42223          	sw	a5,-28(s0)
   1081c:	fdc42783          	lw	a5,-36(s0)
   10820:	0017879b          	addiw	a5,a5,1
   10824:	fcf42e23          	sw	a5,-36(s0)
   10828:	f9043783          	ld	a5,-112(s0)
   1082c:	00c7a703          	lw	a4,12(a5)
   10830:	fd744783          	lbu	a5,-41(s0)
   10834:	0007879b          	sext.w	a5,a5
   10838:	40f707bb          	subw	a5,a4,a5
   1083c:	0007879b          	sext.w	a5,a5
   10840:	fdc42703          	lw	a4,-36(s0)
   10844:	0007071b          	sext.w	a4,a4
   10848:	faf74ee3          	blt	a4,a5,10804 <print_dec_int+0x280>
   1084c:	fe842783          	lw	a5,-24(s0)
   10850:	fff7879b          	addiw	a5,a5,-1
   10854:	fcf42c23          	sw	a5,-40(s0)
   10858:	03c0006f          	j	10894 <print_dec_int+0x310>
   1085c:	fd842783          	lw	a5,-40(s0)
   10860:	ff078793          	addi	a5,a5,-16
   10864:	008787b3          	add	a5,a5,s0
   10868:	fc87c783          	lbu	a5,-56(a5)
   1086c:	0007871b          	sext.w	a4,a5
   10870:	fa843783          	ld	a5,-88(s0)
   10874:	00070513          	mv	a0,a4
   10878:	000780e7          	jalr	a5
   1087c:	fe442783          	lw	a5,-28(s0)
   10880:	0017879b          	addiw	a5,a5,1
   10884:	fef42223          	sw	a5,-28(s0)
   10888:	fd842783          	lw	a5,-40(s0)
   1088c:	fff7879b          	addiw	a5,a5,-1
   10890:	fcf42c23          	sw	a5,-40(s0)
   10894:	fd842783          	lw	a5,-40(s0)
   10898:	0007879b          	sext.w	a5,a5
   1089c:	fc07d0e3          	bgez	a5,1085c <print_dec_int+0x2d8>
   108a0:	fe442783          	lw	a5,-28(s0)
   108a4:	00078513          	mv	a0,a5
   108a8:	06813083          	ld	ra,104(sp)
   108ac:	06013403          	ld	s0,96(sp)
   108b0:	07010113          	addi	sp,sp,112
   108b4:	00008067          	ret

00000000000108b8 <vprintfmt>:
   108b8:	f4010113          	addi	sp,sp,-192
   108bc:	0a113c23          	sd	ra,184(sp)
   108c0:	0a813823          	sd	s0,176(sp)
   108c4:	0c010413          	addi	s0,sp,192
   108c8:	f4a43c23          	sd	a0,-168(s0)
   108cc:	f4b43823          	sd	a1,-176(s0)
   108d0:	f4c43423          	sd	a2,-184(s0)
   108d4:	f8043023          	sd	zero,-128(s0)
   108d8:	f8043423          	sd	zero,-120(s0)
   108dc:	fe042623          	sw	zero,-20(s0)
   108e0:	7b00006f          	j	11090 <vprintfmt+0x7d8>
   108e4:	f8044783          	lbu	a5,-128(s0)
   108e8:	74078463          	beqz	a5,11030 <vprintfmt+0x778>
   108ec:	f5043783          	ld	a5,-176(s0)
   108f0:	0007c783          	lbu	a5,0(a5)
   108f4:	00078713          	mv	a4,a5
   108f8:	02300793          	li	a5,35
   108fc:	00f71863          	bne	a4,a5,1090c <vprintfmt+0x54>
   10900:	00100793          	li	a5,1
   10904:	f8f40123          	sb	a5,-126(s0)
   10908:	77c0006f          	j	11084 <vprintfmt+0x7cc>
   1090c:	f5043783          	ld	a5,-176(s0)
   10910:	0007c783          	lbu	a5,0(a5)
   10914:	00078713          	mv	a4,a5
   10918:	03000793          	li	a5,48
   1091c:	00f71863          	bne	a4,a5,1092c <vprintfmt+0x74>
   10920:	00100793          	li	a5,1
   10924:	f8f401a3          	sb	a5,-125(s0)
   10928:	75c0006f          	j	11084 <vprintfmt+0x7cc>
   1092c:	f5043783          	ld	a5,-176(s0)
   10930:	0007c783          	lbu	a5,0(a5)
   10934:	00078713          	mv	a4,a5
   10938:	06c00793          	li	a5,108
   1093c:	04f70063          	beq	a4,a5,1097c <vprintfmt+0xc4>
   10940:	f5043783          	ld	a5,-176(s0)
   10944:	0007c783          	lbu	a5,0(a5)
   10948:	00078713          	mv	a4,a5
   1094c:	07a00793          	li	a5,122
   10950:	02f70663          	beq	a4,a5,1097c <vprintfmt+0xc4>
   10954:	f5043783          	ld	a5,-176(s0)
   10958:	0007c783          	lbu	a5,0(a5)
   1095c:	00078713          	mv	a4,a5
   10960:	07400793          	li	a5,116
   10964:	00f70c63          	beq	a4,a5,1097c <vprintfmt+0xc4>
   10968:	f5043783          	ld	a5,-176(s0)
   1096c:	0007c783          	lbu	a5,0(a5)
   10970:	00078713          	mv	a4,a5
   10974:	06a00793          	li	a5,106
   10978:	00f71863          	bne	a4,a5,10988 <vprintfmt+0xd0>
   1097c:	00100793          	li	a5,1
   10980:	f8f400a3          	sb	a5,-127(s0)
   10984:	7000006f          	j	11084 <vprintfmt+0x7cc>
   10988:	f5043783          	ld	a5,-176(s0)
   1098c:	0007c783          	lbu	a5,0(a5)
   10990:	00078713          	mv	a4,a5
   10994:	02b00793          	li	a5,43
   10998:	00f71863          	bne	a4,a5,109a8 <vprintfmt+0xf0>
   1099c:	00100793          	li	a5,1
   109a0:	f8f402a3          	sb	a5,-123(s0)
   109a4:	6e00006f          	j	11084 <vprintfmt+0x7cc>
   109a8:	f5043783          	ld	a5,-176(s0)
   109ac:	0007c783          	lbu	a5,0(a5)
   109b0:	00078713          	mv	a4,a5
   109b4:	02000793          	li	a5,32
   109b8:	00f71863          	bne	a4,a5,109c8 <vprintfmt+0x110>
   109bc:	00100793          	li	a5,1
   109c0:	f8f40223          	sb	a5,-124(s0)
   109c4:	6c00006f          	j	11084 <vprintfmt+0x7cc>
   109c8:	f5043783          	ld	a5,-176(s0)
   109cc:	0007c783          	lbu	a5,0(a5)
   109d0:	00078713          	mv	a4,a5
   109d4:	02a00793          	li	a5,42
   109d8:	00f71e63          	bne	a4,a5,109f4 <vprintfmt+0x13c>
   109dc:	f4843783          	ld	a5,-184(s0)
   109e0:	00878713          	addi	a4,a5,8
   109e4:	f4e43423          	sd	a4,-184(s0)
   109e8:	0007a783          	lw	a5,0(a5)
   109ec:	f8f42423          	sw	a5,-120(s0)
   109f0:	6940006f          	j	11084 <vprintfmt+0x7cc>
   109f4:	f5043783          	ld	a5,-176(s0)
   109f8:	0007c783          	lbu	a5,0(a5)
   109fc:	00078713          	mv	a4,a5
   10a00:	03000793          	li	a5,48
   10a04:	04e7f863          	bgeu	a5,a4,10a54 <vprintfmt+0x19c>
   10a08:	f5043783          	ld	a5,-176(s0)
   10a0c:	0007c783          	lbu	a5,0(a5)
   10a10:	00078713          	mv	a4,a5
   10a14:	03900793          	li	a5,57
   10a18:	02e7ee63          	bltu	a5,a4,10a54 <vprintfmt+0x19c>
   10a1c:	f5043783          	ld	a5,-176(s0)
   10a20:	f5040713          	addi	a4,s0,-176
   10a24:	00a00613          	li	a2,10
   10a28:	00070593          	mv	a1,a4
   10a2c:	00078513          	mv	a0,a5
   10a30:	00000097          	auipc	ra,0x0
   10a34:	85c080e7          	jalr	-1956(ra) # 1028c <strtol>
   10a38:	00050793          	mv	a5,a0
   10a3c:	0007879b          	sext.w	a5,a5
   10a40:	f8f42423          	sw	a5,-120(s0)
   10a44:	f5043783          	ld	a5,-176(s0)
   10a48:	fff78793          	addi	a5,a5,-1
   10a4c:	f4f43823          	sd	a5,-176(s0)
   10a50:	6340006f          	j	11084 <vprintfmt+0x7cc>
   10a54:	f5043783          	ld	a5,-176(s0)
   10a58:	0007c783          	lbu	a5,0(a5)
   10a5c:	00078713          	mv	a4,a5
   10a60:	02e00793          	li	a5,46
   10a64:	06f71a63          	bne	a4,a5,10ad8 <vprintfmt+0x220>
   10a68:	f5043783          	ld	a5,-176(s0)
   10a6c:	00178793          	addi	a5,a5,1
   10a70:	f4f43823          	sd	a5,-176(s0)
   10a74:	f5043783          	ld	a5,-176(s0)
   10a78:	0007c783          	lbu	a5,0(a5)
   10a7c:	00078713          	mv	a4,a5
   10a80:	02a00793          	li	a5,42
   10a84:	00f71e63          	bne	a4,a5,10aa0 <vprintfmt+0x1e8>
   10a88:	f4843783          	ld	a5,-184(s0)
   10a8c:	00878713          	addi	a4,a5,8
   10a90:	f4e43423          	sd	a4,-184(s0)
   10a94:	0007a783          	lw	a5,0(a5)
   10a98:	f8f42623          	sw	a5,-116(s0)
   10a9c:	5e80006f          	j	11084 <vprintfmt+0x7cc>
   10aa0:	f5043783          	ld	a5,-176(s0)
   10aa4:	f5040713          	addi	a4,s0,-176
   10aa8:	00a00613          	li	a2,10
   10aac:	00070593          	mv	a1,a4
   10ab0:	00078513          	mv	a0,a5
   10ab4:	fffff097          	auipc	ra,0xfffff
   10ab8:	7d8080e7          	jalr	2008(ra) # 1028c <strtol>
   10abc:	00050793          	mv	a5,a0
   10ac0:	0007879b          	sext.w	a5,a5
   10ac4:	f8f42623          	sw	a5,-116(s0)
   10ac8:	f5043783          	ld	a5,-176(s0)
   10acc:	fff78793          	addi	a5,a5,-1
   10ad0:	f4f43823          	sd	a5,-176(s0)
   10ad4:	5b00006f          	j	11084 <vprintfmt+0x7cc>
   10ad8:	f5043783          	ld	a5,-176(s0)
   10adc:	0007c783          	lbu	a5,0(a5)
   10ae0:	00078713          	mv	a4,a5
   10ae4:	07800793          	li	a5,120
   10ae8:	02f70663          	beq	a4,a5,10b14 <vprintfmt+0x25c>
   10aec:	f5043783          	ld	a5,-176(s0)
   10af0:	0007c783          	lbu	a5,0(a5)
   10af4:	00078713          	mv	a4,a5
   10af8:	05800793          	li	a5,88
   10afc:	00f70c63          	beq	a4,a5,10b14 <vprintfmt+0x25c>
   10b00:	f5043783          	ld	a5,-176(s0)
   10b04:	0007c783          	lbu	a5,0(a5)
   10b08:	00078713          	mv	a4,a5
   10b0c:	07000793          	li	a5,112
   10b10:	30f71063          	bne	a4,a5,10e10 <vprintfmt+0x558>
   10b14:	f5043783          	ld	a5,-176(s0)
   10b18:	0007c783          	lbu	a5,0(a5)
   10b1c:	00078713          	mv	a4,a5
   10b20:	07000793          	li	a5,112
   10b24:	00f70663          	beq	a4,a5,10b30 <vprintfmt+0x278>
   10b28:	f8144783          	lbu	a5,-127(s0)
   10b2c:	00078663          	beqz	a5,10b38 <vprintfmt+0x280>
   10b30:	00100793          	li	a5,1
   10b34:	0080006f          	j	10b3c <vprintfmt+0x284>
   10b38:	00000793          	li	a5,0
   10b3c:	faf403a3          	sb	a5,-89(s0)
   10b40:	fa744783          	lbu	a5,-89(s0)
   10b44:	0017f793          	andi	a5,a5,1
   10b48:	faf403a3          	sb	a5,-89(s0)
   10b4c:	fa744783          	lbu	a5,-89(s0)
   10b50:	0ff7f793          	zext.b	a5,a5
   10b54:	00078c63          	beqz	a5,10b6c <vprintfmt+0x2b4>
   10b58:	f4843783          	ld	a5,-184(s0)
   10b5c:	00878713          	addi	a4,a5,8
   10b60:	f4e43423          	sd	a4,-184(s0)
   10b64:	0007b783          	ld	a5,0(a5)
   10b68:	01c0006f          	j	10b84 <vprintfmt+0x2cc>
   10b6c:	f4843783          	ld	a5,-184(s0)
   10b70:	00878713          	addi	a4,a5,8
   10b74:	f4e43423          	sd	a4,-184(s0)
   10b78:	0007a783          	lw	a5,0(a5)
   10b7c:	02079793          	slli	a5,a5,0x20
   10b80:	0207d793          	srli	a5,a5,0x20
   10b84:	fef43023          	sd	a5,-32(s0)
   10b88:	f8c42783          	lw	a5,-116(s0)
   10b8c:	02079463          	bnez	a5,10bb4 <vprintfmt+0x2fc>
   10b90:	fe043783          	ld	a5,-32(s0)
   10b94:	02079063          	bnez	a5,10bb4 <vprintfmt+0x2fc>
   10b98:	f5043783          	ld	a5,-176(s0)
   10b9c:	0007c783          	lbu	a5,0(a5)
   10ba0:	00078713          	mv	a4,a5
   10ba4:	07000793          	li	a5,112
   10ba8:	00f70663          	beq	a4,a5,10bb4 <vprintfmt+0x2fc>
   10bac:	f8040023          	sb	zero,-128(s0)
   10bb0:	4d40006f          	j	11084 <vprintfmt+0x7cc>
   10bb4:	f5043783          	ld	a5,-176(s0)
   10bb8:	0007c783          	lbu	a5,0(a5)
   10bbc:	00078713          	mv	a4,a5
   10bc0:	07000793          	li	a5,112
   10bc4:	00f70a63          	beq	a4,a5,10bd8 <vprintfmt+0x320>
   10bc8:	f8244783          	lbu	a5,-126(s0)
   10bcc:	00078a63          	beqz	a5,10be0 <vprintfmt+0x328>
   10bd0:	fe043783          	ld	a5,-32(s0)
   10bd4:	00078663          	beqz	a5,10be0 <vprintfmt+0x328>
   10bd8:	00100793          	li	a5,1
   10bdc:	0080006f          	j	10be4 <vprintfmt+0x32c>
   10be0:	00000793          	li	a5,0
   10be4:	faf40323          	sb	a5,-90(s0)
   10be8:	fa644783          	lbu	a5,-90(s0)
   10bec:	0017f793          	andi	a5,a5,1
   10bf0:	faf40323          	sb	a5,-90(s0)
   10bf4:	fc042e23          	sw	zero,-36(s0)
   10bf8:	f5043783          	ld	a5,-176(s0)
   10bfc:	0007c783          	lbu	a5,0(a5)
   10c00:	00078713          	mv	a4,a5
   10c04:	05800793          	li	a5,88
   10c08:	00f71863          	bne	a4,a5,10c18 <vprintfmt+0x360>
   10c0c:	00000797          	auipc	a5,0x0
   10c10:	60c78793          	addi	a5,a5,1548 # 11218 <upperxdigits.1>
   10c14:	00c0006f          	j	10c20 <vprintfmt+0x368>
   10c18:	00000797          	auipc	a5,0x0
   10c1c:	61878793          	addi	a5,a5,1560 # 11230 <lowerxdigits.0>
   10c20:	f8f43c23          	sd	a5,-104(s0)
   10c24:	fe043783          	ld	a5,-32(s0)
   10c28:	00f7f793          	andi	a5,a5,15
   10c2c:	f9843703          	ld	a4,-104(s0)
   10c30:	00f70733          	add	a4,a4,a5
   10c34:	fdc42783          	lw	a5,-36(s0)
   10c38:	0017869b          	addiw	a3,a5,1
   10c3c:	fcd42e23          	sw	a3,-36(s0)
   10c40:	00074703          	lbu	a4,0(a4)
   10c44:	ff078793          	addi	a5,a5,-16
   10c48:	008787b3          	add	a5,a5,s0
   10c4c:	f8e78023          	sb	a4,-128(a5)
   10c50:	fe043783          	ld	a5,-32(s0)
   10c54:	0047d793          	srli	a5,a5,0x4
   10c58:	fef43023          	sd	a5,-32(s0)
   10c5c:	fe043783          	ld	a5,-32(s0)
   10c60:	fc0792e3          	bnez	a5,10c24 <vprintfmt+0x36c>
   10c64:	f8c42703          	lw	a4,-116(s0)
   10c68:	fff00793          	li	a5,-1
   10c6c:	02f71663          	bne	a4,a5,10c98 <vprintfmt+0x3e0>
   10c70:	f8344783          	lbu	a5,-125(s0)
   10c74:	02078263          	beqz	a5,10c98 <vprintfmt+0x3e0>
   10c78:	f8842703          	lw	a4,-120(s0)
   10c7c:	fa644783          	lbu	a5,-90(s0)
   10c80:	0007879b          	sext.w	a5,a5
   10c84:	0017979b          	slliw	a5,a5,0x1
   10c88:	0007879b          	sext.w	a5,a5
   10c8c:	40f707bb          	subw	a5,a4,a5
   10c90:	0007879b          	sext.w	a5,a5
   10c94:	f8f42623          	sw	a5,-116(s0)
   10c98:	f8842703          	lw	a4,-120(s0)
   10c9c:	fa644783          	lbu	a5,-90(s0)
   10ca0:	0007879b          	sext.w	a5,a5
   10ca4:	0017979b          	slliw	a5,a5,0x1
   10ca8:	0007879b          	sext.w	a5,a5
   10cac:	40f707bb          	subw	a5,a4,a5
   10cb0:	0007871b          	sext.w	a4,a5
   10cb4:	fdc42783          	lw	a5,-36(s0)
   10cb8:	f8f42a23          	sw	a5,-108(s0)
   10cbc:	f8c42783          	lw	a5,-116(s0)
   10cc0:	f8f42823          	sw	a5,-112(s0)
   10cc4:	f9442783          	lw	a5,-108(s0)
   10cc8:	00078593          	mv	a1,a5
   10ccc:	f9042783          	lw	a5,-112(s0)
   10cd0:	00078613          	mv	a2,a5
   10cd4:	0006069b          	sext.w	a3,a2
   10cd8:	0005879b          	sext.w	a5,a1
   10cdc:	00f6d463          	bge	a3,a5,10ce4 <vprintfmt+0x42c>
   10ce0:	00058613          	mv	a2,a1
   10ce4:	0006079b          	sext.w	a5,a2
   10ce8:	40f707bb          	subw	a5,a4,a5
   10cec:	fcf42c23          	sw	a5,-40(s0)
   10cf0:	0280006f          	j	10d18 <vprintfmt+0x460>
   10cf4:	f5843783          	ld	a5,-168(s0)
   10cf8:	02000513          	li	a0,32
   10cfc:	000780e7          	jalr	a5
   10d00:	fec42783          	lw	a5,-20(s0)
   10d04:	0017879b          	addiw	a5,a5,1
   10d08:	fef42623          	sw	a5,-20(s0)
   10d0c:	fd842783          	lw	a5,-40(s0)
   10d10:	fff7879b          	addiw	a5,a5,-1
   10d14:	fcf42c23          	sw	a5,-40(s0)
   10d18:	fd842783          	lw	a5,-40(s0)
   10d1c:	0007879b          	sext.w	a5,a5
   10d20:	fcf04ae3          	bgtz	a5,10cf4 <vprintfmt+0x43c>
   10d24:	fa644783          	lbu	a5,-90(s0)
   10d28:	0ff7f793          	zext.b	a5,a5
   10d2c:	04078463          	beqz	a5,10d74 <vprintfmt+0x4bc>
   10d30:	f5843783          	ld	a5,-168(s0)
   10d34:	03000513          	li	a0,48
   10d38:	000780e7          	jalr	a5
   10d3c:	f5043783          	ld	a5,-176(s0)
   10d40:	0007c783          	lbu	a5,0(a5)
   10d44:	00078713          	mv	a4,a5
   10d48:	05800793          	li	a5,88
   10d4c:	00f71663          	bne	a4,a5,10d58 <vprintfmt+0x4a0>
   10d50:	05800793          	li	a5,88
   10d54:	0080006f          	j	10d5c <vprintfmt+0x4a4>
   10d58:	07800793          	li	a5,120
   10d5c:	f5843703          	ld	a4,-168(s0)
   10d60:	00078513          	mv	a0,a5
   10d64:	000700e7          	jalr	a4
   10d68:	fec42783          	lw	a5,-20(s0)
   10d6c:	0027879b          	addiw	a5,a5,2
   10d70:	fef42623          	sw	a5,-20(s0)
   10d74:	fdc42783          	lw	a5,-36(s0)
   10d78:	fcf42a23          	sw	a5,-44(s0)
   10d7c:	0280006f          	j	10da4 <vprintfmt+0x4ec>
   10d80:	f5843783          	ld	a5,-168(s0)
   10d84:	03000513          	li	a0,48
   10d88:	000780e7          	jalr	a5
   10d8c:	fec42783          	lw	a5,-20(s0)
   10d90:	0017879b          	addiw	a5,a5,1
   10d94:	fef42623          	sw	a5,-20(s0)
   10d98:	fd442783          	lw	a5,-44(s0)
   10d9c:	0017879b          	addiw	a5,a5,1
   10da0:	fcf42a23          	sw	a5,-44(s0)
   10da4:	f8c42783          	lw	a5,-116(s0)
   10da8:	fd442703          	lw	a4,-44(s0)
   10dac:	0007071b          	sext.w	a4,a4
   10db0:	fcf748e3          	blt	a4,a5,10d80 <vprintfmt+0x4c8>
   10db4:	fdc42783          	lw	a5,-36(s0)
   10db8:	fff7879b          	addiw	a5,a5,-1
   10dbc:	fcf42823          	sw	a5,-48(s0)
   10dc0:	03c0006f          	j	10dfc <vprintfmt+0x544>
   10dc4:	fd042783          	lw	a5,-48(s0)
   10dc8:	ff078793          	addi	a5,a5,-16
   10dcc:	008787b3          	add	a5,a5,s0
   10dd0:	f807c783          	lbu	a5,-128(a5)
   10dd4:	0007871b          	sext.w	a4,a5
   10dd8:	f5843783          	ld	a5,-168(s0)
   10ddc:	00070513          	mv	a0,a4
   10de0:	000780e7          	jalr	a5
   10de4:	fec42783          	lw	a5,-20(s0)
   10de8:	0017879b          	addiw	a5,a5,1
   10dec:	fef42623          	sw	a5,-20(s0)
   10df0:	fd042783          	lw	a5,-48(s0)
   10df4:	fff7879b          	addiw	a5,a5,-1
   10df8:	fcf42823          	sw	a5,-48(s0)
   10dfc:	fd042783          	lw	a5,-48(s0)
   10e00:	0007879b          	sext.w	a5,a5
   10e04:	fc07d0e3          	bgez	a5,10dc4 <vprintfmt+0x50c>
   10e08:	f8040023          	sb	zero,-128(s0)
   10e0c:	2780006f          	j	11084 <vprintfmt+0x7cc>
   10e10:	f5043783          	ld	a5,-176(s0)
   10e14:	0007c783          	lbu	a5,0(a5)
   10e18:	00078713          	mv	a4,a5
   10e1c:	06400793          	li	a5,100
   10e20:	02f70663          	beq	a4,a5,10e4c <vprintfmt+0x594>
   10e24:	f5043783          	ld	a5,-176(s0)
   10e28:	0007c783          	lbu	a5,0(a5)
   10e2c:	00078713          	mv	a4,a5
   10e30:	06900793          	li	a5,105
   10e34:	00f70c63          	beq	a4,a5,10e4c <vprintfmt+0x594>
   10e38:	f5043783          	ld	a5,-176(s0)
   10e3c:	0007c783          	lbu	a5,0(a5)
   10e40:	00078713          	mv	a4,a5
   10e44:	07500793          	li	a5,117
   10e48:	08f71263          	bne	a4,a5,10ecc <vprintfmt+0x614>
   10e4c:	f8144783          	lbu	a5,-127(s0)
   10e50:	00078c63          	beqz	a5,10e68 <vprintfmt+0x5b0>
   10e54:	f4843783          	ld	a5,-184(s0)
   10e58:	00878713          	addi	a4,a5,8
   10e5c:	f4e43423          	sd	a4,-184(s0)
   10e60:	0007b783          	ld	a5,0(a5)
   10e64:	0140006f          	j	10e78 <vprintfmt+0x5c0>
   10e68:	f4843783          	ld	a5,-184(s0)
   10e6c:	00878713          	addi	a4,a5,8
   10e70:	f4e43423          	sd	a4,-184(s0)
   10e74:	0007a783          	lw	a5,0(a5)
   10e78:	faf43423          	sd	a5,-88(s0)
   10e7c:	fa843583          	ld	a1,-88(s0)
   10e80:	f5043783          	ld	a5,-176(s0)
   10e84:	0007c783          	lbu	a5,0(a5)
   10e88:	0007871b          	sext.w	a4,a5
   10e8c:	07500793          	li	a5,117
   10e90:	40f707b3          	sub	a5,a4,a5
   10e94:	00f037b3          	snez	a5,a5
   10e98:	0ff7f793          	zext.b	a5,a5
   10e9c:	f8040713          	addi	a4,s0,-128
   10ea0:	00070693          	mv	a3,a4
   10ea4:	00078613          	mv	a2,a5
   10ea8:	f5843503          	ld	a0,-168(s0)
   10eac:	fffff097          	auipc	ra,0xfffff
   10eb0:	6d8080e7          	jalr	1752(ra) # 10584 <print_dec_int>
   10eb4:	00050793          	mv	a5,a0
   10eb8:	fec42703          	lw	a4,-20(s0)
   10ebc:	00f707bb          	addw	a5,a4,a5
   10ec0:	fef42623          	sw	a5,-20(s0)
   10ec4:	f8040023          	sb	zero,-128(s0)
   10ec8:	1bc0006f          	j	11084 <vprintfmt+0x7cc>
   10ecc:	f5043783          	ld	a5,-176(s0)
   10ed0:	0007c783          	lbu	a5,0(a5)
   10ed4:	00078713          	mv	a4,a5
   10ed8:	06e00793          	li	a5,110
   10edc:	04f71c63          	bne	a4,a5,10f34 <vprintfmt+0x67c>
   10ee0:	f8144783          	lbu	a5,-127(s0)
   10ee4:	02078463          	beqz	a5,10f0c <vprintfmt+0x654>
   10ee8:	f4843783          	ld	a5,-184(s0)
   10eec:	00878713          	addi	a4,a5,8
   10ef0:	f4e43423          	sd	a4,-184(s0)
   10ef4:	0007b783          	ld	a5,0(a5)
   10ef8:	faf43823          	sd	a5,-80(s0)
   10efc:	fec42703          	lw	a4,-20(s0)
   10f00:	fb043783          	ld	a5,-80(s0)
   10f04:	00e7b023          	sd	a4,0(a5)
   10f08:	0240006f          	j	10f2c <vprintfmt+0x674>
   10f0c:	f4843783          	ld	a5,-184(s0)
   10f10:	00878713          	addi	a4,a5,8
   10f14:	f4e43423          	sd	a4,-184(s0)
   10f18:	0007b783          	ld	a5,0(a5)
   10f1c:	faf43c23          	sd	a5,-72(s0)
   10f20:	fb843783          	ld	a5,-72(s0)
   10f24:	fec42703          	lw	a4,-20(s0)
   10f28:	00e7a023          	sw	a4,0(a5)
   10f2c:	f8040023          	sb	zero,-128(s0)
   10f30:	1540006f          	j	11084 <vprintfmt+0x7cc>
   10f34:	f5043783          	ld	a5,-176(s0)
   10f38:	0007c783          	lbu	a5,0(a5)
   10f3c:	00078713          	mv	a4,a5
   10f40:	07300793          	li	a5,115
   10f44:	04f71063          	bne	a4,a5,10f84 <vprintfmt+0x6cc>
   10f48:	f4843783          	ld	a5,-184(s0)
   10f4c:	00878713          	addi	a4,a5,8
   10f50:	f4e43423          	sd	a4,-184(s0)
   10f54:	0007b783          	ld	a5,0(a5)
   10f58:	fcf43023          	sd	a5,-64(s0)
   10f5c:	fc043583          	ld	a1,-64(s0)
   10f60:	f5843503          	ld	a0,-168(s0)
   10f64:	fffff097          	auipc	ra,0xfffff
   10f68:	598080e7          	jalr	1432(ra) # 104fc <puts_wo_nl>
   10f6c:	00050793          	mv	a5,a0
   10f70:	fec42703          	lw	a4,-20(s0)
   10f74:	00f707bb          	addw	a5,a4,a5
   10f78:	fef42623          	sw	a5,-20(s0)
   10f7c:	f8040023          	sb	zero,-128(s0)
   10f80:	1040006f          	j	11084 <vprintfmt+0x7cc>
   10f84:	f5043783          	ld	a5,-176(s0)
   10f88:	0007c783          	lbu	a5,0(a5)
   10f8c:	00078713          	mv	a4,a5
   10f90:	06300793          	li	a5,99
   10f94:	02f71e63          	bne	a4,a5,10fd0 <vprintfmt+0x718>
   10f98:	f4843783          	ld	a5,-184(s0)
   10f9c:	00878713          	addi	a4,a5,8
   10fa0:	f4e43423          	sd	a4,-184(s0)
   10fa4:	0007a783          	lw	a5,0(a5)
   10fa8:	fcf42623          	sw	a5,-52(s0)
   10fac:	fcc42703          	lw	a4,-52(s0)
   10fb0:	f5843783          	ld	a5,-168(s0)
   10fb4:	00070513          	mv	a0,a4
   10fb8:	000780e7          	jalr	a5
   10fbc:	fec42783          	lw	a5,-20(s0)
   10fc0:	0017879b          	addiw	a5,a5,1
   10fc4:	fef42623          	sw	a5,-20(s0)
   10fc8:	f8040023          	sb	zero,-128(s0)
   10fcc:	0b80006f          	j	11084 <vprintfmt+0x7cc>
   10fd0:	f5043783          	ld	a5,-176(s0)
   10fd4:	0007c783          	lbu	a5,0(a5)
   10fd8:	00078713          	mv	a4,a5
   10fdc:	02500793          	li	a5,37
   10fe0:	02f71263          	bne	a4,a5,11004 <vprintfmt+0x74c>
   10fe4:	f5843783          	ld	a5,-168(s0)
   10fe8:	02500513          	li	a0,37
   10fec:	000780e7          	jalr	a5
   10ff0:	fec42783          	lw	a5,-20(s0)
   10ff4:	0017879b          	addiw	a5,a5,1
   10ff8:	fef42623          	sw	a5,-20(s0)
   10ffc:	f8040023          	sb	zero,-128(s0)
   11000:	0840006f          	j	11084 <vprintfmt+0x7cc>
   11004:	f5043783          	ld	a5,-176(s0)
   11008:	0007c783          	lbu	a5,0(a5)
   1100c:	0007871b          	sext.w	a4,a5
   11010:	f5843783          	ld	a5,-168(s0)
   11014:	00070513          	mv	a0,a4
   11018:	000780e7          	jalr	a5
   1101c:	fec42783          	lw	a5,-20(s0)
   11020:	0017879b          	addiw	a5,a5,1
   11024:	fef42623          	sw	a5,-20(s0)
   11028:	f8040023          	sb	zero,-128(s0)
   1102c:	0580006f          	j	11084 <vprintfmt+0x7cc>
   11030:	f5043783          	ld	a5,-176(s0)
   11034:	0007c783          	lbu	a5,0(a5)
   11038:	00078713          	mv	a4,a5
   1103c:	02500793          	li	a5,37
   11040:	02f71063          	bne	a4,a5,11060 <vprintfmt+0x7a8>
   11044:	f8043023          	sd	zero,-128(s0)
   11048:	f8043423          	sd	zero,-120(s0)
   1104c:	00100793          	li	a5,1
   11050:	f8f40023          	sb	a5,-128(s0)
   11054:	fff00793          	li	a5,-1
   11058:	f8f42623          	sw	a5,-116(s0)
   1105c:	0280006f          	j	11084 <vprintfmt+0x7cc>
   11060:	f5043783          	ld	a5,-176(s0)
   11064:	0007c783          	lbu	a5,0(a5)
   11068:	0007871b          	sext.w	a4,a5
   1106c:	f5843783          	ld	a5,-168(s0)
   11070:	00070513          	mv	a0,a4
   11074:	000780e7          	jalr	a5
   11078:	fec42783          	lw	a5,-20(s0)
   1107c:	0017879b          	addiw	a5,a5,1
   11080:	fef42623          	sw	a5,-20(s0)
   11084:	f5043783          	ld	a5,-176(s0)
   11088:	00178793          	addi	a5,a5,1
   1108c:	f4f43823          	sd	a5,-176(s0)
   11090:	f5043783          	ld	a5,-176(s0)
   11094:	0007c783          	lbu	a5,0(a5)
   11098:	840796e3          	bnez	a5,108e4 <vprintfmt+0x2c>
   1109c:	fec42783          	lw	a5,-20(s0)
   110a0:	00078513          	mv	a0,a5
   110a4:	0b813083          	ld	ra,184(sp)
   110a8:	0b013403          	ld	s0,176(sp)
   110ac:	0c010113          	addi	sp,sp,192
   110b0:	00008067          	ret

00000000000110b4 <printf>:
   110b4:	f8010113          	addi	sp,sp,-128
   110b8:	02113c23          	sd	ra,56(sp)
   110bc:	02813823          	sd	s0,48(sp)
   110c0:	04010413          	addi	s0,sp,64
   110c4:	fca43423          	sd	a0,-56(s0)
   110c8:	00b43423          	sd	a1,8(s0)
   110cc:	00c43823          	sd	a2,16(s0)
   110d0:	00d43c23          	sd	a3,24(s0)
   110d4:	02e43023          	sd	a4,32(s0)
   110d8:	02f43423          	sd	a5,40(s0)
   110dc:	03043823          	sd	a6,48(s0)
   110e0:	03143c23          	sd	a7,56(s0)
   110e4:	fe042623          	sw	zero,-20(s0)
   110e8:	04040793          	addi	a5,s0,64
   110ec:	fcf43023          	sd	a5,-64(s0)
   110f0:	fc043783          	ld	a5,-64(s0)
   110f4:	fc878793          	addi	a5,a5,-56
   110f8:	fcf43823          	sd	a5,-48(s0)
   110fc:	fd043783          	ld	a5,-48(s0)
   11100:	00078613          	mv	a2,a5
   11104:	fc843583          	ld	a1,-56(s0)
   11108:	fffff517          	auipc	a0,0xfffff
   1110c:	0ac50513          	addi	a0,a0,172 # 101b4 <putc>
   11110:	fffff097          	auipc	ra,0xfffff
   11114:	7a8080e7          	jalr	1960(ra) # 108b8 <vprintfmt>
   11118:	00050793          	mv	a5,a0
   1111c:	fef42623          	sw	a5,-20(s0)
   11120:	00100793          	li	a5,1
   11124:	fef43023          	sd	a5,-32(s0)
   11128:	00001797          	auipc	a5,0x1
   1112c:	edc78793          	addi	a5,a5,-292 # 12004 <tail>
   11130:	0007a783          	lw	a5,0(a5)
   11134:	0017871b          	addiw	a4,a5,1
   11138:	0007069b          	sext.w	a3,a4
   1113c:	00001717          	auipc	a4,0x1
   11140:	ec870713          	addi	a4,a4,-312 # 12004 <tail>
   11144:	00d72023          	sw	a3,0(a4)
   11148:	00001717          	auipc	a4,0x1
   1114c:	ec070713          	addi	a4,a4,-320 # 12008 <buffer>
   11150:	00f707b3          	add	a5,a4,a5
   11154:	00078023          	sb	zero,0(a5)
   11158:	00001797          	auipc	a5,0x1
   1115c:	eac78793          	addi	a5,a5,-340 # 12004 <tail>
   11160:	0007a603          	lw	a2,0(a5)
   11164:	fe043703          	ld	a4,-32(s0)
   11168:	00001697          	auipc	a3,0x1
   1116c:	ea068693          	addi	a3,a3,-352 # 12008 <buffer>
   11170:	fd843783          	ld	a5,-40(s0)
   11174:	04000893          	li	a7,64
   11178:	00070513          	mv	a0,a4
   1117c:	00068593          	mv	a1,a3
   11180:	00060613          	mv	a2,a2
   11184:	00000073          	ecall
   11188:	00050793          	mv	a5,a0
   1118c:	fcf43c23          	sd	a5,-40(s0)
   11190:	00001797          	auipc	a5,0x1
   11194:	e7478793          	addi	a5,a5,-396 # 12004 <tail>
   11198:	0007a023          	sw	zero,0(a5)
   1119c:	fec42783          	lw	a5,-20(s0)
   111a0:	00078513          	mv	a0,a5
   111a4:	03813083          	ld	ra,56(sp)
   111a8:	03013403          	ld	s0,48(sp)
   111ac:	08010113          	addi	sp,sp,128
   111b0:	00008067          	ret
