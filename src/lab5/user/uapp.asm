
uapp:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100e8 <_start>:
   100e8:	0d80006f          	j	101c0 <main>

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

0000000000010128 <fork>:
   10128:	fe010113          	addi	sp,sp,-32
   1012c:	00113c23          	sd	ra,24(sp)
   10130:	00813823          	sd	s0,16(sp)
   10134:	02010413          	addi	s0,sp,32
   10138:	fe843783          	ld	a5,-24(s0)
   1013c:	0dc00893          	li	a7,220
   10140:	00000073          	ecall
   10144:	00050793          	mv	a5,a0
   10148:	fef43423          	sd	a5,-24(s0)
   1014c:	fe843783          	ld	a5,-24(s0)
   10150:	00078513          	mv	a0,a5
   10154:	01813083          	ld	ra,24(sp)
   10158:	01013403          	ld	s0,16(sp)
   1015c:	02010113          	addi	sp,sp,32
   10160:	00008067          	ret

0000000000010164 <wait>:
   10164:	fd010113          	addi	sp,sp,-48
   10168:	02113423          	sd	ra,40(sp)
   1016c:	02813023          	sd	s0,32(sp)
   10170:	03010413          	addi	s0,sp,48
   10174:	00050793          	mv	a5,a0
   10178:	fcf42e23          	sw	a5,-36(s0)
   1017c:	fe042623          	sw	zero,-20(s0)
   10180:	0100006f          	j	10190 <wait+0x2c>
   10184:	fec42783          	lw	a5,-20(s0)
   10188:	0017879b          	addiw	a5,a5,1
   1018c:	fef42623          	sw	a5,-20(s0)
   10190:	fec42783          	lw	a5,-20(s0)
   10194:	00078713          	mv	a4,a5
   10198:	fdc42783          	lw	a5,-36(s0)
   1019c:	0007071b          	sext.w	a4,a4
   101a0:	0007879b          	sext.w	a5,a5
   101a4:	fef760e3          	bltu	a4,a5,10184 <wait+0x20>
   101a8:	00000013          	nop
   101ac:	00000013          	nop
   101b0:	02813083          	ld	ra,40(sp)
   101b4:	02013403          	ld	s0,32(sp)
   101b8:	03010113          	addi	sp,sp,48
   101bc:	00008067          	ret

00000000000101c0 <main>:
   101c0:	ff010113          	addi	sp,sp,-16
   101c4:	00113423          	sd	ra,8(sp)
   101c8:	00813023          	sd	s0,0(sp)
   101cc:	01010413          	addi	s0,sp,16
   101d0:	00000097          	auipc	ra,0x0
   101d4:	f1c080e7          	jalr	-228(ra) # 100ec <getpid>
   101d8:	00050593          	mv	a1,a0
   101dc:	00002797          	auipc	a5,0x2
   101e0:	e2478793          	addi	a5,a5,-476 # 12000 <global_variable>
   101e4:	0007a783          	lw	a5,0(a5)
   101e8:	0017871b          	addiw	a4,a5,1
   101ec:	0007069b          	sext.w	a3,a4
   101f0:	00002717          	auipc	a4,0x2
   101f4:	e1070713          	addi	a4,a4,-496 # 12000 <global_variable>
   101f8:	00d72023          	sw	a3,0(a4)
   101fc:	00078613          	mv	a2,a5
   10200:	00001517          	auipc	a0,0x1
   10204:	0c050513          	addi	a0,a0,192 # 112c0 <printf+0x100>
   10208:	00001097          	auipc	ra,0x1
   1020c:	fb8080e7          	jalr	-72(ra) # 111c0 <printf>
   10210:	00000097          	auipc	ra,0x0
   10214:	f18080e7          	jalr	-232(ra) # 10128 <fork>
   10218:	00000097          	auipc	ra,0x0
   1021c:	f10080e7          	jalr	-240(ra) # 10128 <fork>
   10220:	00000097          	auipc	ra,0x0
   10224:	ecc080e7          	jalr	-308(ra) # 100ec <getpid>
   10228:	00050593          	mv	a1,a0
   1022c:	00002797          	auipc	a5,0x2
   10230:	dd478793          	addi	a5,a5,-556 # 12000 <global_variable>
   10234:	0007a783          	lw	a5,0(a5)
   10238:	0017871b          	addiw	a4,a5,1
   1023c:	0007069b          	sext.w	a3,a4
   10240:	00002717          	auipc	a4,0x2
   10244:	dc070713          	addi	a4,a4,-576 # 12000 <global_variable>
   10248:	00d72023          	sw	a3,0(a4)
   1024c:	00078613          	mv	a2,a5
   10250:	00001517          	auipc	a0,0x1
   10254:	07050513          	addi	a0,a0,112 # 112c0 <printf+0x100>
   10258:	00001097          	auipc	ra,0x1
   1025c:	f68080e7          	jalr	-152(ra) # 111c0 <printf>
   10260:	00000097          	auipc	ra,0x0
   10264:	ec8080e7          	jalr	-312(ra) # 10128 <fork>
   10268:	00000097          	auipc	ra,0x0
   1026c:	e84080e7          	jalr	-380(ra) # 100ec <getpid>
   10270:	00050593          	mv	a1,a0
   10274:	00002797          	auipc	a5,0x2
   10278:	d8c78793          	addi	a5,a5,-628 # 12000 <global_variable>
   1027c:	0007a783          	lw	a5,0(a5)
   10280:	0017871b          	addiw	a4,a5,1
   10284:	0007069b          	sext.w	a3,a4
   10288:	00002717          	auipc	a4,0x2
   1028c:	d7870713          	addi	a4,a4,-648 # 12000 <global_variable>
   10290:	00d72023          	sw	a3,0(a4)
   10294:	00078613          	mv	a2,a5
   10298:	00001517          	auipc	a0,0x1
   1029c:	02850513          	addi	a0,a0,40 # 112c0 <printf+0x100>
   102a0:	00001097          	auipc	ra,0x1
   102a4:	f20080e7          	jalr	-224(ra) # 111c0 <printf>
   102a8:	500007b7          	lui	a5,0x50000
   102ac:	fff78513          	addi	a0,a5,-1 # 4fffffff <__global_pointer$+0x4ffed7ff>
   102b0:	00000097          	auipc	ra,0x0
   102b4:	eb4080e7          	jalr	-332(ra) # 10164 <wait>
   102b8:	00000013          	nop
   102bc:	fadff06f          	j	10268 <main+0xa8>

00000000000102c0 <putc>:
   102c0:	fe010113          	addi	sp,sp,-32
   102c4:	00113c23          	sd	ra,24(sp)
   102c8:	00813823          	sd	s0,16(sp)
   102cc:	02010413          	addi	s0,sp,32
   102d0:	00050793          	mv	a5,a0
   102d4:	fef42623          	sw	a5,-20(s0)
   102d8:	00002797          	auipc	a5,0x2
   102dc:	d2c78793          	addi	a5,a5,-724 # 12004 <tail>
   102e0:	0007a783          	lw	a5,0(a5)
   102e4:	0017871b          	addiw	a4,a5,1
   102e8:	0007069b          	sext.w	a3,a4
   102ec:	00002717          	auipc	a4,0x2
   102f0:	d1870713          	addi	a4,a4,-744 # 12004 <tail>
   102f4:	00d72023          	sw	a3,0(a4)
   102f8:	fec42703          	lw	a4,-20(s0)
   102fc:	0ff77713          	zext.b	a4,a4
   10300:	00002697          	auipc	a3,0x2
   10304:	d0868693          	addi	a3,a3,-760 # 12008 <buffer>
   10308:	00f687b3          	add	a5,a3,a5
   1030c:	00e78023          	sb	a4,0(a5)
   10310:	fec42783          	lw	a5,-20(s0)
   10314:	0ff7f793          	zext.b	a5,a5
   10318:	0007879b          	sext.w	a5,a5
   1031c:	00078513          	mv	a0,a5
   10320:	01813083          	ld	ra,24(sp)
   10324:	01013403          	ld	s0,16(sp)
   10328:	02010113          	addi	sp,sp,32
   1032c:	00008067          	ret

0000000000010330 <isspace>:
   10330:	fe010113          	addi	sp,sp,-32
   10334:	00113c23          	sd	ra,24(sp)
   10338:	00813823          	sd	s0,16(sp)
   1033c:	02010413          	addi	s0,sp,32
   10340:	00050793          	mv	a5,a0
   10344:	fef42623          	sw	a5,-20(s0)
   10348:	fec42783          	lw	a5,-20(s0)
   1034c:	0007871b          	sext.w	a4,a5
   10350:	02000793          	li	a5,32
   10354:	02f70263          	beq	a4,a5,10378 <isspace+0x48>
   10358:	fec42783          	lw	a5,-20(s0)
   1035c:	0007871b          	sext.w	a4,a5
   10360:	00800793          	li	a5,8
   10364:	00e7de63          	bge	a5,a4,10380 <isspace+0x50>
   10368:	fec42783          	lw	a5,-20(s0)
   1036c:	0007871b          	sext.w	a4,a5
   10370:	00d00793          	li	a5,13
   10374:	00e7c663          	blt	a5,a4,10380 <isspace+0x50>
   10378:	00100793          	li	a5,1
   1037c:	0080006f          	j	10384 <isspace+0x54>
   10380:	00000793          	li	a5,0
   10384:	00078513          	mv	a0,a5
   10388:	01813083          	ld	ra,24(sp)
   1038c:	01013403          	ld	s0,16(sp)
   10390:	02010113          	addi	sp,sp,32
   10394:	00008067          	ret

0000000000010398 <strtol>:
   10398:	fb010113          	addi	sp,sp,-80
   1039c:	04113423          	sd	ra,72(sp)
   103a0:	04813023          	sd	s0,64(sp)
   103a4:	05010413          	addi	s0,sp,80
   103a8:	fca43423          	sd	a0,-56(s0)
   103ac:	fcb43023          	sd	a1,-64(s0)
   103b0:	00060793          	mv	a5,a2
   103b4:	faf42e23          	sw	a5,-68(s0)
   103b8:	fe043423          	sd	zero,-24(s0)
   103bc:	fe0403a3          	sb	zero,-25(s0)
   103c0:	fc843783          	ld	a5,-56(s0)
   103c4:	fcf43c23          	sd	a5,-40(s0)
   103c8:	0100006f          	j	103d8 <strtol+0x40>
   103cc:	fd843783          	ld	a5,-40(s0)
   103d0:	00178793          	addi	a5,a5,1
   103d4:	fcf43c23          	sd	a5,-40(s0)
   103d8:	fd843783          	ld	a5,-40(s0)
   103dc:	0007c783          	lbu	a5,0(a5)
   103e0:	0007879b          	sext.w	a5,a5
   103e4:	00078513          	mv	a0,a5
   103e8:	00000097          	auipc	ra,0x0
   103ec:	f48080e7          	jalr	-184(ra) # 10330 <isspace>
   103f0:	00050793          	mv	a5,a0
   103f4:	fc079ce3          	bnez	a5,103cc <strtol+0x34>
   103f8:	fd843783          	ld	a5,-40(s0)
   103fc:	0007c783          	lbu	a5,0(a5)
   10400:	00078713          	mv	a4,a5
   10404:	02d00793          	li	a5,45
   10408:	00f71e63          	bne	a4,a5,10424 <strtol+0x8c>
   1040c:	00100793          	li	a5,1
   10410:	fef403a3          	sb	a5,-25(s0)
   10414:	fd843783          	ld	a5,-40(s0)
   10418:	00178793          	addi	a5,a5,1
   1041c:	fcf43c23          	sd	a5,-40(s0)
   10420:	0240006f          	j	10444 <strtol+0xac>
   10424:	fd843783          	ld	a5,-40(s0)
   10428:	0007c783          	lbu	a5,0(a5)
   1042c:	00078713          	mv	a4,a5
   10430:	02b00793          	li	a5,43
   10434:	00f71863          	bne	a4,a5,10444 <strtol+0xac>
   10438:	fd843783          	ld	a5,-40(s0)
   1043c:	00178793          	addi	a5,a5,1
   10440:	fcf43c23          	sd	a5,-40(s0)
   10444:	fbc42783          	lw	a5,-68(s0)
   10448:	0007879b          	sext.w	a5,a5
   1044c:	06079c63          	bnez	a5,104c4 <strtol+0x12c>
   10450:	fd843783          	ld	a5,-40(s0)
   10454:	0007c783          	lbu	a5,0(a5)
   10458:	00078713          	mv	a4,a5
   1045c:	03000793          	li	a5,48
   10460:	04f71e63          	bne	a4,a5,104bc <strtol+0x124>
   10464:	fd843783          	ld	a5,-40(s0)
   10468:	00178793          	addi	a5,a5,1
   1046c:	fcf43c23          	sd	a5,-40(s0)
   10470:	fd843783          	ld	a5,-40(s0)
   10474:	0007c783          	lbu	a5,0(a5)
   10478:	00078713          	mv	a4,a5
   1047c:	07800793          	li	a5,120
   10480:	00f70c63          	beq	a4,a5,10498 <strtol+0x100>
   10484:	fd843783          	ld	a5,-40(s0)
   10488:	0007c783          	lbu	a5,0(a5)
   1048c:	00078713          	mv	a4,a5
   10490:	05800793          	li	a5,88
   10494:	00f71e63          	bne	a4,a5,104b0 <strtol+0x118>
   10498:	01000793          	li	a5,16
   1049c:	faf42e23          	sw	a5,-68(s0)
   104a0:	fd843783          	ld	a5,-40(s0)
   104a4:	00178793          	addi	a5,a5,1
   104a8:	fcf43c23          	sd	a5,-40(s0)
   104ac:	0180006f          	j	104c4 <strtol+0x12c>
   104b0:	00800793          	li	a5,8
   104b4:	faf42e23          	sw	a5,-68(s0)
   104b8:	00c0006f          	j	104c4 <strtol+0x12c>
   104bc:	00a00793          	li	a5,10
   104c0:	faf42e23          	sw	a5,-68(s0)
   104c4:	fd843783          	ld	a5,-40(s0)
   104c8:	0007c783          	lbu	a5,0(a5)
   104cc:	00078713          	mv	a4,a5
   104d0:	02f00793          	li	a5,47
   104d4:	02e7f863          	bgeu	a5,a4,10504 <strtol+0x16c>
   104d8:	fd843783          	ld	a5,-40(s0)
   104dc:	0007c783          	lbu	a5,0(a5)
   104e0:	00078713          	mv	a4,a5
   104e4:	03900793          	li	a5,57
   104e8:	00e7ee63          	bltu	a5,a4,10504 <strtol+0x16c>
   104ec:	fd843783          	ld	a5,-40(s0)
   104f0:	0007c783          	lbu	a5,0(a5)
   104f4:	0007879b          	sext.w	a5,a5
   104f8:	fd07879b          	addiw	a5,a5,-48
   104fc:	fcf42a23          	sw	a5,-44(s0)
   10500:	0800006f          	j	10580 <strtol+0x1e8>
   10504:	fd843783          	ld	a5,-40(s0)
   10508:	0007c783          	lbu	a5,0(a5)
   1050c:	00078713          	mv	a4,a5
   10510:	06000793          	li	a5,96
   10514:	02e7f863          	bgeu	a5,a4,10544 <strtol+0x1ac>
   10518:	fd843783          	ld	a5,-40(s0)
   1051c:	0007c783          	lbu	a5,0(a5)
   10520:	00078713          	mv	a4,a5
   10524:	07a00793          	li	a5,122
   10528:	00e7ee63          	bltu	a5,a4,10544 <strtol+0x1ac>
   1052c:	fd843783          	ld	a5,-40(s0)
   10530:	0007c783          	lbu	a5,0(a5)
   10534:	0007879b          	sext.w	a5,a5
   10538:	fa97879b          	addiw	a5,a5,-87
   1053c:	fcf42a23          	sw	a5,-44(s0)
   10540:	0400006f          	j	10580 <strtol+0x1e8>
   10544:	fd843783          	ld	a5,-40(s0)
   10548:	0007c783          	lbu	a5,0(a5)
   1054c:	00078713          	mv	a4,a5
   10550:	04000793          	li	a5,64
   10554:	06e7f863          	bgeu	a5,a4,105c4 <strtol+0x22c>
   10558:	fd843783          	ld	a5,-40(s0)
   1055c:	0007c783          	lbu	a5,0(a5)
   10560:	00078713          	mv	a4,a5
   10564:	05a00793          	li	a5,90
   10568:	04e7ee63          	bltu	a5,a4,105c4 <strtol+0x22c>
   1056c:	fd843783          	ld	a5,-40(s0)
   10570:	0007c783          	lbu	a5,0(a5)
   10574:	0007879b          	sext.w	a5,a5
   10578:	fc97879b          	addiw	a5,a5,-55
   1057c:	fcf42a23          	sw	a5,-44(s0)
   10580:	fd442783          	lw	a5,-44(s0)
   10584:	00078713          	mv	a4,a5
   10588:	fbc42783          	lw	a5,-68(s0)
   1058c:	0007071b          	sext.w	a4,a4
   10590:	0007879b          	sext.w	a5,a5
   10594:	02f75663          	bge	a4,a5,105c0 <strtol+0x228>
   10598:	fbc42703          	lw	a4,-68(s0)
   1059c:	fe843783          	ld	a5,-24(s0)
   105a0:	02f70733          	mul	a4,a4,a5
   105a4:	fd442783          	lw	a5,-44(s0)
   105a8:	00f707b3          	add	a5,a4,a5
   105ac:	fef43423          	sd	a5,-24(s0)
   105b0:	fd843783          	ld	a5,-40(s0)
   105b4:	00178793          	addi	a5,a5,1
   105b8:	fcf43c23          	sd	a5,-40(s0)
   105bc:	f09ff06f          	j	104c4 <strtol+0x12c>
   105c0:	00000013          	nop
   105c4:	fc043783          	ld	a5,-64(s0)
   105c8:	00078863          	beqz	a5,105d8 <strtol+0x240>
   105cc:	fc043783          	ld	a5,-64(s0)
   105d0:	fd843703          	ld	a4,-40(s0)
   105d4:	00e7b023          	sd	a4,0(a5)
   105d8:	fe744783          	lbu	a5,-25(s0)
   105dc:	0ff7f793          	zext.b	a5,a5
   105e0:	00078863          	beqz	a5,105f0 <strtol+0x258>
   105e4:	fe843783          	ld	a5,-24(s0)
   105e8:	40f007b3          	neg	a5,a5
   105ec:	0080006f          	j	105f4 <strtol+0x25c>
   105f0:	fe843783          	ld	a5,-24(s0)
   105f4:	00078513          	mv	a0,a5
   105f8:	04813083          	ld	ra,72(sp)
   105fc:	04013403          	ld	s0,64(sp)
   10600:	05010113          	addi	sp,sp,80
   10604:	00008067          	ret

0000000000010608 <puts_wo_nl>:
   10608:	fd010113          	addi	sp,sp,-48
   1060c:	02113423          	sd	ra,40(sp)
   10610:	02813023          	sd	s0,32(sp)
   10614:	03010413          	addi	s0,sp,48
   10618:	fca43c23          	sd	a0,-40(s0)
   1061c:	fcb43823          	sd	a1,-48(s0)
   10620:	fd043783          	ld	a5,-48(s0)
   10624:	00079863          	bnez	a5,10634 <puts_wo_nl+0x2c>
   10628:	00001797          	auipc	a5,0x1
   1062c:	cc878793          	addi	a5,a5,-824 # 112f0 <printf+0x130>
   10630:	fcf43823          	sd	a5,-48(s0)
   10634:	fd043783          	ld	a5,-48(s0)
   10638:	fef43423          	sd	a5,-24(s0)
   1063c:	0240006f          	j	10660 <puts_wo_nl+0x58>
   10640:	fe843783          	ld	a5,-24(s0)
   10644:	00178713          	addi	a4,a5,1
   10648:	fee43423          	sd	a4,-24(s0)
   1064c:	0007c783          	lbu	a5,0(a5)
   10650:	0007871b          	sext.w	a4,a5
   10654:	fd843783          	ld	a5,-40(s0)
   10658:	00070513          	mv	a0,a4
   1065c:	000780e7          	jalr	a5
   10660:	fe843783          	ld	a5,-24(s0)
   10664:	0007c783          	lbu	a5,0(a5)
   10668:	fc079ce3          	bnez	a5,10640 <puts_wo_nl+0x38>
   1066c:	fe843703          	ld	a4,-24(s0)
   10670:	fd043783          	ld	a5,-48(s0)
   10674:	40f707b3          	sub	a5,a4,a5
   10678:	0007879b          	sext.w	a5,a5
   1067c:	00078513          	mv	a0,a5
   10680:	02813083          	ld	ra,40(sp)
   10684:	02013403          	ld	s0,32(sp)
   10688:	03010113          	addi	sp,sp,48
   1068c:	00008067          	ret

0000000000010690 <print_dec_int>:
   10690:	f9010113          	addi	sp,sp,-112
   10694:	06113423          	sd	ra,104(sp)
   10698:	06813023          	sd	s0,96(sp)
   1069c:	07010413          	addi	s0,sp,112
   106a0:	faa43423          	sd	a0,-88(s0)
   106a4:	fab43023          	sd	a1,-96(s0)
   106a8:	00060793          	mv	a5,a2
   106ac:	f8d43823          	sd	a3,-112(s0)
   106b0:	f8f40fa3          	sb	a5,-97(s0)
   106b4:	f9f44783          	lbu	a5,-97(s0)
   106b8:	0ff7f793          	zext.b	a5,a5
   106bc:	02078863          	beqz	a5,106ec <print_dec_int+0x5c>
   106c0:	fa043703          	ld	a4,-96(s0)
   106c4:	fff00793          	li	a5,-1
   106c8:	03f79793          	slli	a5,a5,0x3f
   106cc:	02f71063          	bne	a4,a5,106ec <print_dec_int+0x5c>
   106d0:	00001597          	auipc	a1,0x1
   106d4:	c2858593          	addi	a1,a1,-984 # 112f8 <printf+0x138>
   106d8:	fa843503          	ld	a0,-88(s0)
   106dc:	00000097          	auipc	ra,0x0
   106e0:	f2c080e7          	jalr	-212(ra) # 10608 <puts_wo_nl>
   106e4:	00050793          	mv	a5,a0
   106e8:	2c80006f          	j	109b0 <print_dec_int+0x320>
   106ec:	f9043783          	ld	a5,-112(s0)
   106f0:	00c7a783          	lw	a5,12(a5)
   106f4:	00079a63          	bnez	a5,10708 <print_dec_int+0x78>
   106f8:	fa043783          	ld	a5,-96(s0)
   106fc:	00079663          	bnez	a5,10708 <print_dec_int+0x78>
   10700:	00000793          	li	a5,0
   10704:	2ac0006f          	j	109b0 <print_dec_int+0x320>
   10708:	fe0407a3          	sb	zero,-17(s0)
   1070c:	f9f44783          	lbu	a5,-97(s0)
   10710:	0ff7f793          	zext.b	a5,a5
   10714:	02078063          	beqz	a5,10734 <print_dec_int+0xa4>
   10718:	fa043783          	ld	a5,-96(s0)
   1071c:	0007dc63          	bgez	a5,10734 <print_dec_int+0xa4>
   10720:	00100793          	li	a5,1
   10724:	fef407a3          	sb	a5,-17(s0)
   10728:	fa043783          	ld	a5,-96(s0)
   1072c:	40f007b3          	neg	a5,a5
   10730:	faf43023          	sd	a5,-96(s0)
   10734:	fe042423          	sw	zero,-24(s0)
   10738:	f9f44783          	lbu	a5,-97(s0)
   1073c:	0ff7f793          	zext.b	a5,a5
   10740:	02078863          	beqz	a5,10770 <print_dec_int+0xe0>
   10744:	fef44783          	lbu	a5,-17(s0)
   10748:	0ff7f793          	zext.b	a5,a5
   1074c:	00079e63          	bnez	a5,10768 <print_dec_int+0xd8>
   10750:	f9043783          	ld	a5,-112(s0)
   10754:	0057c783          	lbu	a5,5(a5)
   10758:	00079863          	bnez	a5,10768 <print_dec_int+0xd8>
   1075c:	f9043783          	ld	a5,-112(s0)
   10760:	0047c783          	lbu	a5,4(a5)
   10764:	00078663          	beqz	a5,10770 <print_dec_int+0xe0>
   10768:	00100793          	li	a5,1
   1076c:	0080006f          	j	10774 <print_dec_int+0xe4>
   10770:	00000793          	li	a5,0
   10774:	fcf40ba3          	sb	a5,-41(s0)
   10778:	fd744783          	lbu	a5,-41(s0)
   1077c:	0017f793          	andi	a5,a5,1
   10780:	fcf40ba3          	sb	a5,-41(s0)
   10784:	fa043683          	ld	a3,-96(s0)
   10788:	00001797          	auipc	a5,0x1
   1078c:	b8878793          	addi	a5,a5,-1144 # 11310 <printf+0x150>
   10790:	0007b783          	ld	a5,0(a5)
   10794:	02f6b7b3          	mulhu	a5,a3,a5
   10798:	0037d713          	srli	a4,a5,0x3
   1079c:	00070793          	mv	a5,a4
   107a0:	00279793          	slli	a5,a5,0x2
   107a4:	00e787b3          	add	a5,a5,a4
   107a8:	00179793          	slli	a5,a5,0x1
   107ac:	40f68733          	sub	a4,a3,a5
   107b0:	0ff77713          	zext.b	a4,a4
   107b4:	fe842783          	lw	a5,-24(s0)
   107b8:	0017869b          	addiw	a3,a5,1
   107bc:	fed42423          	sw	a3,-24(s0)
   107c0:	0307071b          	addiw	a4,a4,48
   107c4:	0ff77713          	zext.b	a4,a4
   107c8:	ff078793          	addi	a5,a5,-16
   107cc:	008787b3          	add	a5,a5,s0
   107d0:	fce78423          	sb	a4,-56(a5)
   107d4:	fa043703          	ld	a4,-96(s0)
   107d8:	00001797          	auipc	a5,0x1
   107dc:	b3878793          	addi	a5,a5,-1224 # 11310 <printf+0x150>
   107e0:	0007b783          	ld	a5,0(a5)
   107e4:	02f737b3          	mulhu	a5,a4,a5
   107e8:	0037d793          	srli	a5,a5,0x3
   107ec:	faf43023          	sd	a5,-96(s0)
   107f0:	fa043783          	ld	a5,-96(s0)
   107f4:	f80798e3          	bnez	a5,10784 <print_dec_int+0xf4>
   107f8:	f9043783          	ld	a5,-112(s0)
   107fc:	00c7a703          	lw	a4,12(a5)
   10800:	fff00793          	li	a5,-1
   10804:	02f71063          	bne	a4,a5,10824 <print_dec_int+0x194>
   10808:	f9043783          	ld	a5,-112(s0)
   1080c:	0037c783          	lbu	a5,3(a5)
   10810:	00078a63          	beqz	a5,10824 <print_dec_int+0x194>
   10814:	f9043783          	ld	a5,-112(s0)
   10818:	0087a703          	lw	a4,8(a5)
   1081c:	f9043783          	ld	a5,-112(s0)
   10820:	00e7a623          	sw	a4,12(a5)
   10824:	fe042223          	sw	zero,-28(s0)
   10828:	f9043783          	ld	a5,-112(s0)
   1082c:	0087a703          	lw	a4,8(a5)
   10830:	fe842783          	lw	a5,-24(s0)
   10834:	fcf42823          	sw	a5,-48(s0)
   10838:	f9043783          	ld	a5,-112(s0)
   1083c:	00c7a783          	lw	a5,12(a5)
   10840:	fcf42623          	sw	a5,-52(s0)
   10844:	fd042783          	lw	a5,-48(s0)
   10848:	00078593          	mv	a1,a5
   1084c:	fcc42783          	lw	a5,-52(s0)
   10850:	00078613          	mv	a2,a5
   10854:	0006069b          	sext.w	a3,a2
   10858:	0005879b          	sext.w	a5,a1
   1085c:	00f6d463          	bge	a3,a5,10864 <print_dec_int+0x1d4>
   10860:	00058613          	mv	a2,a1
   10864:	0006079b          	sext.w	a5,a2
   10868:	40f707bb          	subw	a5,a4,a5
   1086c:	0007871b          	sext.w	a4,a5
   10870:	fd744783          	lbu	a5,-41(s0)
   10874:	0007879b          	sext.w	a5,a5
   10878:	40f707bb          	subw	a5,a4,a5
   1087c:	fef42023          	sw	a5,-32(s0)
   10880:	0280006f          	j	108a8 <print_dec_int+0x218>
   10884:	fa843783          	ld	a5,-88(s0)
   10888:	02000513          	li	a0,32
   1088c:	000780e7          	jalr	a5
   10890:	fe442783          	lw	a5,-28(s0)
   10894:	0017879b          	addiw	a5,a5,1
   10898:	fef42223          	sw	a5,-28(s0)
   1089c:	fe042783          	lw	a5,-32(s0)
   108a0:	fff7879b          	addiw	a5,a5,-1
   108a4:	fef42023          	sw	a5,-32(s0)
   108a8:	fe042783          	lw	a5,-32(s0)
   108ac:	0007879b          	sext.w	a5,a5
   108b0:	fcf04ae3          	bgtz	a5,10884 <print_dec_int+0x1f4>
   108b4:	fd744783          	lbu	a5,-41(s0)
   108b8:	0ff7f793          	zext.b	a5,a5
   108bc:	04078463          	beqz	a5,10904 <print_dec_int+0x274>
   108c0:	fef44783          	lbu	a5,-17(s0)
   108c4:	0ff7f793          	zext.b	a5,a5
   108c8:	00078663          	beqz	a5,108d4 <print_dec_int+0x244>
   108cc:	02d00793          	li	a5,45
   108d0:	01c0006f          	j	108ec <print_dec_int+0x25c>
   108d4:	f9043783          	ld	a5,-112(s0)
   108d8:	0057c783          	lbu	a5,5(a5)
   108dc:	00078663          	beqz	a5,108e8 <print_dec_int+0x258>
   108e0:	02b00793          	li	a5,43
   108e4:	0080006f          	j	108ec <print_dec_int+0x25c>
   108e8:	02000793          	li	a5,32
   108ec:	fa843703          	ld	a4,-88(s0)
   108f0:	00078513          	mv	a0,a5
   108f4:	000700e7          	jalr	a4
   108f8:	fe442783          	lw	a5,-28(s0)
   108fc:	0017879b          	addiw	a5,a5,1
   10900:	fef42223          	sw	a5,-28(s0)
   10904:	fe842783          	lw	a5,-24(s0)
   10908:	fcf42e23          	sw	a5,-36(s0)
   1090c:	0280006f          	j	10934 <print_dec_int+0x2a4>
   10910:	fa843783          	ld	a5,-88(s0)
   10914:	03000513          	li	a0,48
   10918:	000780e7          	jalr	a5
   1091c:	fe442783          	lw	a5,-28(s0)
   10920:	0017879b          	addiw	a5,a5,1
   10924:	fef42223          	sw	a5,-28(s0)
   10928:	fdc42783          	lw	a5,-36(s0)
   1092c:	0017879b          	addiw	a5,a5,1
   10930:	fcf42e23          	sw	a5,-36(s0)
   10934:	f9043783          	ld	a5,-112(s0)
   10938:	00c7a703          	lw	a4,12(a5)
   1093c:	fd744783          	lbu	a5,-41(s0)
   10940:	0007879b          	sext.w	a5,a5
   10944:	40f707bb          	subw	a5,a4,a5
   10948:	0007879b          	sext.w	a5,a5
   1094c:	fdc42703          	lw	a4,-36(s0)
   10950:	0007071b          	sext.w	a4,a4
   10954:	faf74ee3          	blt	a4,a5,10910 <print_dec_int+0x280>
   10958:	fe842783          	lw	a5,-24(s0)
   1095c:	fff7879b          	addiw	a5,a5,-1
   10960:	fcf42c23          	sw	a5,-40(s0)
   10964:	03c0006f          	j	109a0 <print_dec_int+0x310>
   10968:	fd842783          	lw	a5,-40(s0)
   1096c:	ff078793          	addi	a5,a5,-16
   10970:	008787b3          	add	a5,a5,s0
   10974:	fc87c783          	lbu	a5,-56(a5)
   10978:	0007871b          	sext.w	a4,a5
   1097c:	fa843783          	ld	a5,-88(s0)
   10980:	00070513          	mv	a0,a4
   10984:	000780e7          	jalr	a5
   10988:	fe442783          	lw	a5,-28(s0)
   1098c:	0017879b          	addiw	a5,a5,1
   10990:	fef42223          	sw	a5,-28(s0)
   10994:	fd842783          	lw	a5,-40(s0)
   10998:	fff7879b          	addiw	a5,a5,-1
   1099c:	fcf42c23          	sw	a5,-40(s0)
   109a0:	fd842783          	lw	a5,-40(s0)
   109a4:	0007879b          	sext.w	a5,a5
   109a8:	fc07d0e3          	bgez	a5,10968 <print_dec_int+0x2d8>
   109ac:	fe442783          	lw	a5,-28(s0)
   109b0:	00078513          	mv	a0,a5
   109b4:	06813083          	ld	ra,104(sp)
   109b8:	06013403          	ld	s0,96(sp)
   109bc:	07010113          	addi	sp,sp,112
   109c0:	00008067          	ret

00000000000109c4 <vprintfmt>:
   109c4:	f4010113          	addi	sp,sp,-192
   109c8:	0a113c23          	sd	ra,184(sp)
   109cc:	0a813823          	sd	s0,176(sp)
   109d0:	0c010413          	addi	s0,sp,192
   109d4:	f4a43c23          	sd	a0,-168(s0)
   109d8:	f4b43823          	sd	a1,-176(s0)
   109dc:	f4c43423          	sd	a2,-184(s0)
   109e0:	f8043023          	sd	zero,-128(s0)
   109e4:	f8043423          	sd	zero,-120(s0)
   109e8:	fe042623          	sw	zero,-20(s0)
   109ec:	7b00006f          	j	1119c <vprintfmt+0x7d8>
   109f0:	f8044783          	lbu	a5,-128(s0)
   109f4:	74078463          	beqz	a5,1113c <vprintfmt+0x778>
   109f8:	f5043783          	ld	a5,-176(s0)
   109fc:	0007c783          	lbu	a5,0(a5)
   10a00:	00078713          	mv	a4,a5
   10a04:	02300793          	li	a5,35
   10a08:	00f71863          	bne	a4,a5,10a18 <vprintfmt+0x54>
   10a0c:	00100793          	li	a5,1
   10a10:	f8f40123          	sb	a5,-126(s0)
   10a14:	77c0006f          	j	11190 <vprintfmt+0x7cc>
   10a18:	f5043783          	ld	a5,-176(s0)
   10a1c:	0007c783          	lbu	a5,0(a5)
   10a20:	00078713          	mv	a4,a5
   10a24:	03000793          	li	a5,48
   10a28:	00f71863          	bne	a4,a5,10a38 <vprintfmt+0x74>
   10a2c:	00100793          	li	a5,1
   10a30:	f8f401a3          	sb	a5,-125(s0)
   10a34:	75c0006f          	j	11190 <vprintfmt+0x7cc>
   10a38:	f5043783          	ld	a5,-176(s0)
   10a3c:	0007c783          	lbu	a5,0(a5)
   10a40:	00078713          	mv	a4,a5
   10a44:	06c00793          	li	a5,108
   10a48:	04f70063          	beq	a4,a5,10a88 <vprintfmt+0xc4>
   10a4c:	f5043783          	ld	a5,-176(s0)
   10a50:	0007c783          	lbu	a5,0(a5)
   10a54:	00078713          	mv	a4,a5
   10a58:	07a00793          	li	a5,122
   10a5c:	02f70663          	beq	a4,a5,10a88 <vprintfmt+0xc4>
   10a60:	f5043783          	ld	a5,-176(s0)
   10a64:	0007c783          	lbu	a5,0(a5)
   10a68:	00078713          	mv	a4,a5
   10a6c:	07400793          	li	a5,116
   10a70:	00f70c63          	beq	a4,a5,10a88 <vprintfmt+0xc4>
   10a74:	f5043783          	ld	a5,-176(s0)
   10a78:	0007c783          	lbu	a5,0(a5)
   10a7c:	00078713          	mv	a4,a5
   10a80:	06a00793          	li	a5,106
   10a84:	00f71863          	bne	a4,a5,10a94 <vprintfmt+0xd0>
   10a88:	00100793          	li	a5,1
   10a8c:	f8f400a3          	sb	a5,-127(s0)
   10a90:	7000006f          	j	11190 <vprintfmt+0x7cc>
   10a94:	f5043783          	ld	a5,-176(s0)
   10a98:	0007c783          	lbu	a5,0(a5)
   10a9c:	00078713          	mv	a4,a5
   10aa0:	02b00793          	li	a5,43
   10aa4:	00f71863          	bne	a4,a5,10ab4 <vprintfmt+0xf0>
   10aa8:	00100793          	li	a5,1
   10aac:	f8f402a3          	sb	a5,-123(s0)
   10ab0:	6e00006f          	j	11190 <vprintfmt+0x7cc>
   10ab4:	f5043783          	ld	a5,-176(s0)
   10ab8:	0007c783          	lbu	a5,0(a5)
   10abc:	00078713          	mv	a4,a5
   10ac0:	02000793          	li	a5,32
   10ac4:	00f71863          	bne	a4,a5,10ad4 <vprintfmt+0x110>
   10ac8:	00100793          	li	a5,1
   10acc:	f8f40223          	sb	a5,-124(s0)
   10ad0:	6c00006f          	j	11190 <vprintfmt+0x7cc>
   10ad4:	f5043783          	ld	a5,-176(s0)
   10ad8:	0007c783          	lbu	a5,0(a5)
   10adc:	00078713          	mv	a4,a5
   10ae0:	02a00793          	li	a5,42
   10ae4:	00f71e63          	bne	a4,a5,10b00 <vprintfmt+0x13c>
   10ae8:	f4843783          	ld	a5,-184(s0)
   10aec:	00878713          	addi	a4,a5,8
   10af0:	f4e43423          	sd	a4,-184(s0)
   10af4:	0007a783          	lw	a5,0(a5)
   10af8:	f8f42423          	sw	a5,-120(s0)
   10afc:	6940006f          	j	11190 <vprintfmt+0x7cc>
   10b00:	f5043783          	ld	a5,-176(s0)
   10b04:	0007c783          	lbu	a5,0(a5)
   10b08:	00078713          	mv	a4,a5
   10b0c:	03000793          	li	a5,48
   10b10:	04e7f863          	bgeu	a5,a4,10b60 <vprintfmt+0x19c>
   10b14:	f5043783          	ld	a5,-176(s0)
   10b18:	0007c783          	lbu	a5,0(a5)
   10b1c:	00078713          	mv	a4,a5
   10b20:	03900793          	li	a5,57
   10b24:	02e7ee63          	bltu	a5,a4,10b60 <vprintfmt+0x19c>
   10b28:	f5043783          	ld	a5,-176(s0)
   10b2c:	f5040713          	addi	a4,s0,-176
   10b30:	00a00613          	li	a2,10
   10b34:	00070593          	mv	a1,a4
   10b38:	00078513          	mv	a0,a5
   10b3c:	00000097          	auipc	ra,0x0
   10b40:	85c080e7          	jalr	-1956(ra) # 10398 <strtol>
   10b44:	00050793          	mv	a5,a0
   10b48:	0007879b          	sext.w	a5,a5
   10b4c:	f8f42423          	sw	a5,-120(s0)
   10b50:	f5043783          	ld	a5,-176(s0)
   10b54:	fff78793          	addi	a5,a5,-1
   10b58:	f4f43823          	sd	a5,-176(s0)
   10b5c:	6340006f          	j	11190 <vprintfmt+0x7cc>
   10b60:	f5043783          	ld	a5,-176(s0)
   10b64:	0007c783          	lbu	a5,0(a5)
   10b68:	00078713          	mv	a4,a5
   10b6c:	02e00793          	li	a5,46
   10b70:	06f71a63          	bne	a4,a5,10be4 <vprintfmt+0x220>
   10b74:	f5043783          	ld	a5,-176(s0)
   10b78:	00178793          	addi	a5,a5,1
   10b7c:	f4f43823          	sd	a5,-176(s0)
   10b80:	f5043783          	ld	a5,-176(s0)
   10b84:	0007c783          	lbu	a5,0(a5)
   10b88:	00078713          	mv	a4,a5
   10b8c:	02a00793          	li	a5,42
   10b90:	00f71e63          	bne	a4,a5,10bac <vprintfmt+0x1e8>
   10b94:	f4843783          	ld	a5,-184(s0)
   10b98:	00878713          	addi	a4,a5,8
   10b9c:	f4e43423          	sd	a4,-184(s0)
   10ba0:	0007a783          	lw	a5,0(a5)
   10ba4:	f8f42623          	sw	a5,-116(s0)
   10ba8:	5e80006f          	j	11190 <vprintfmt+0x7cc>
   10bac:	f5043783          	ld	a5,-176(s0)
   10bb0:	f5040713          	addi	a4,s0,-176
   10bb4:	00a00613          	li	a2,10
   10bb8:	00070593          	mv	a1,a4
   10bbc:	00078513          	mv	a0,a5
   10bc0:	fffff097          	auipc	ra,0xfffff
   10bc4:	7d8080e7          	jalr	2008(ra) # 10398 <strtol>
   10bc8:	00050793          	mv	a5,a0
   10bcc:	0007879b          	sext.w	a5,a5
   10bd0:	f8f42623          	sw	a5,-116(s0)
   10bd4:	f5043783          	ld	a5,-176(s0)
   10bd8:	fff78793          	addi	a5,a5,-1
   10bdc:	f4f43823          	sd	a5,-176(s0)
   10be0:	5b00006f          	j	11190 <vprintfmt+0x7cc>
   10be4:	f5043783          	ld	a5,-176(s0)
   10be8:	0007c783          	lbu	a5,0(a5)
   10bec:	00078713          	mv	a4,a5
   10bf0:	07800793          	li	a5,120
   10bf4:	02f70663          	beq	a4,a5,10c20 <vprintfmt+0x25c>
   10bf8:	f5043783          	ld	a5,-176(s0)
   10bfc:	0007c783          	lbu	a5,0(a5)
   10c00:	00078713          	mv	a4,a5
   10c04:	05800793          	li	a5,88
   10c08:	00f70c63          	beq	a4,a5,10c20 <vprintfmt+0x25c>
   10c0c:	f5043783          	ld	a5,-176(s0)
   10c10:	0007c783          	lbu	a5,0(a5)
   10c14:	00078713          	mv	a4,a5
   10c18:	07000793          	li	a5,112
   10c1c:	30f71063          	bne	a4,a5,10f1c <vprintfmt+0x558>
   10c20:	f5043783          	ld	a5,-176(s0)
   10c24:	0007c783          	lbu	a5,0(a5)
   10c28:	00078713          	mv	a4,a5
   10c2c:	07000793          	li	a5,112
   10c30:	00f70663          	beq	a4,a5,10c3c <vprintfmt+0x278>
   10c34:	f8144783          	lbu	a5,-127(s0)
   10c38:	00078663          	beqz	a5,10c44 <vprintfmt+0x280>
   10c3c:	00100793          	li	a5,1
   10c40:	0080006f          	j	10c48 <vprintfmt+0x284>
   10c44:	00000793          	li	a5,0
   10c48:	faf403a3          	sb	a5,-89(s0)
   10c4c:	fa744783          	lbu	a5,-89(s0)
   10c50:	0017f793          	andi	a5,a5,1
   10c54:	faf403a3          	sb	a5,-89(s0)
   10c58:	fa744783          	lbu	a5,-89(s0)
   10c5c:	0ff7f793          	zext.b	a5,a5
   10c60:	00078c63          	beqz	a5,10c78 <vprintfmt+0x2b4>
   10c64:	f4843783          	ld	a5,-184(s0)
   10c68:	00878713          	addi	a4,a5,8
   10c6c:	f4e43423          	sd	a4,-184(s0)
   10c70:	0007b783          	ld	a5,0(a5)
   10c74:	01c0006f          	j	10c90 <vprintfmt+0x2cc>
   10c78:	f4843783          	ld	a5,-184(s0)
   10c7c:	00878713          	addi	a4,a5,8
   10c80:	f4e43423          	sd	a4,-184(s0)
   10c84:	0007a783          	lw	a5,0(a5)
   10c88:	02079793          	slli	a5,a5,0x20
   10c8c:	0207d793          	srli	a5,a5,0x20
   10c90:	fef43023          	sd	a5,-32(s0)
   10c94:	f8c42783          	lw	a5,-116(s0)
   10c98:	02079463          	bnez	a5,10cc0 <vprintfmt+0x2fc>
   10c9c:	fe043783          	ld	a5,-32(s0)
   10ca0:	02079063          	bnez	a5,10cc0 <vprintfmt+0x2fc>
   10ca4:	f5043783          	ld	a5,-176(s0)
   10ca8:	0007c783          	lbu	a5,0(a5)
   10cac:	00078713          	mv	a4,a5
   10cb0:	07000793          	li	a5,112
   10cb4:	00f70663          	beq	a4,a5,10cc0 <vprintfmt+0x2fc>
   10cb8:	f8040023          	sb	zero,-128(s0)
   10cbc:	4d40006f          	j	11190 <vprintfmt+0x7cc>
   10cc0:	f5043783          	ld	a5,-176(s0)
   10cc4:	0007c783          	lbu	a5,0(a5)
   10cc8:	00078713          	mv	a4,a5
   10ccc:	07000793          	li	a5,112
   10cd0:	00f70a63          	beq	a4,a5,10ce4 <vprintfmt+0x320>
   10cd4:	f8244783          	lbu	a5,-126(s0)
   10cd8:	00078a63          	beqz	a5,10cec <vprintfmt+0x328>
   10cdc:	fe043783          	ld	a5,-32(s0)
   10ce0:	00078663          	beqz	a5,10cec <vprintfmt+0x328>
   10ce4:	00100793          	li	a5,1
   10ce8:	0080006f          	j	10cf0 <vprintfmt+0x32c>
   10cec:	00000793          	li	a5,0
   10cf0:	faf40323          	sb	a5,-90(s0)
   10cf4:	fa644783          	lbu	a5,-90(s0)
   10cf8:	0017f793          	andi	a5,a5,1
   10cfc:	faf40323          	sb	a5,-90(s0)
   10d00:	fc042e23          	sw	zero,-36(s0)
   10d04:	f5043783          	ld	a5,-176(s0)
   10d08:	0007c783          	lbu	a5,0(a5)
   10d0c:	00078713          	mv	a4,a5
   10d10:	05800793          	li	a5,88
   10d14:	00f71863          	bne	a4,a5,10d24 <vprintfmt+0x360>
   10d18:	00000797          	auipc	a5,0x0
   10d1c:	60078793          	addi	a5,a5,1536 # 11318 <upperxdigits.1>
   10d20:	00c0006f          	j	10d2c <vprintfmt+0x368>
   10d24:	00000797          	auipc	a5,0x0
   10d28:	60c78793          	addi	a5,a5,1548 # 11330 <lowerxdigits.0>
   10d2c:	f8f43c23          	sd	a5,-104(s0)
   10d30:	fe043783          	ld	a5,-32(s0)
   10d34:	00f7f793          	andi	a5,a5,15
   10d38:	f9843703          	ld	a4,-104(s0)
   10d3c:	00f70733          	add	a4,a4,a5
   10d40:	fdc42783          	lw	a5,-36(s0)
   10d44:	0017869b          	addiw	a3,a5,1
   10d48:	fcd42e23          	sw	a3,-36(s0)
   10d4c:	00074703          	lbu	a4,0(a4)
   10d50:	ff078793          	addi	a5,a5,-16
   10d54:	008787b3          	add	a5,a5,s0
   10d58:	f8e78023          	sb	a4,-128(a5)
   10d5c:	fe043783          	ld	a5,-32(s0)
   10d60:	0047d793          	srli	a5,a5,0x4
   10d64:	fef43023          	sd	a5,-32(s0)
   10d68:	fe043783          	ld	a5,-32(s0)
   10d6c:	fc0792e3          	bnez	a5,10d30 <vprintfmt+0x36c>
   10d70:	f8c42703          	lw	a4,-116(s0)
   10d74:	fff00793          	li	a5,-1
   10d78:	02f71663          	bne	a4,a5,10da4 <vprintfmt+0x3e0>
   10d7c:	f8344783          	lbu	a5,-125(s0)
   10d80:	02078263          	beqz	a5,10da4 <vprintfmt+0x3e0>
   10d84:	f8842703          	lw	a4,-120(s0)
   10d88:	fa644783          	lbu	a5,-90(s0)
   10d8c:	0007879b          	sext.w	a5,a5
   10d90:	0017979b          	slliw	a5,a5,0x1
   10d94:	0007879b          	sext.w	a5,a5
   10d98:	40f707bb          	subw	a5,a4,a5
   10d9c:	0007879b          	sext.w	a5,a5
   10da0:	f8f42623          	sw	a5,-116(s0)
   10da4:	f8842703          	lw	a4,-120(s0)
   10da8:	fa644783          	lbu	a5,-90(s0)
   10dac:	0007879b          	sext.w	a5,a5
   10db0:	0017979b          	slliw	a5,a5,0x1
   10db4:	0007879b          	sext.w	a5,a5
   10db8:	40f707bb          	subw	a5,a4,a5
   10dbc:	0007871b          	sext.w	a4,a5
   10dc0:	fdc42783          	lw	a5,-36(s0)
   10dc4:	f8f42a23          	sw	a5,-108(s0)
   10dc8:	f8c42783          	lw	a5,-116(s0)
   10dcc:	f8f42823          	sw	a5,-112(s0)
   10dd0:	f9442783          	lw	a5,-108(s0)
   10dd4:	00078593          	mv	a1,a5
   10dd8:	f9042783          	lw	a5,-112(s0)
   10ddc:	00078613          	mv	a2,a5
   10de0:	0006069b          	sext.w	a3,a2
   10de4:	0005879b          	sext.w	a5,a1
   10de8:	00f6d463          	bge	a3,a5,10df0 <vprintfmt+0x42c>
   10dec:	00058613          	mv	a2,a1
   10df0:	0006079b          	sext.w	a5,a2
   10df4:	40f707bb          	subw	a5,a4,a5
   10df8:	fcf42c23          	sw	a5,-40(s0)
   10dfc:	0280006f          	j	10e24 <vprintfmt+0x460>
   10e00:	f5843783          	ld	a5,-168(s0)
   10e04:	02000513          	li	a0,32
   10e08:	000780e7          	jalr	a5
   10e0c:	fec42783          	lw	a5,-20(s0)
   10e10:	0017879b          	addiw	a5,a5,1
   10e14:	fef42623          	sw	a5,-20(s0)
   10e18:	fd842783          	lw	a5,-40(s0)
   10e1c:	fff7879b          	addiw	a5,a5,-1
   10e20:	fcf42c23          	sw	a5,-40(s0)
   10e24:	fd842783          	lw	a5,-40(s0)
   10e28:	0007879b          	sext.w	a5,a5
   10e2c:	fcf04ae3          	bgtz	a5,10e00 <vprintfmt+0x43c>
   10e30:	fa644783          	lbu	a5,-90(s0)
   10e34:	0ff7f793          	zext.b	a5,a5
   10e38:	04078463          	beqz	a5,10e80 <vprintfmt+0x4bc>
   10e3c:	f5843783          	ld	a5,-168(s0)
   10e40:	03000513          	li	a0,48
   10e44:	000780e7          	jalr	a5
   10e48:	f5043783          	ld	a5,-176(s0)
   10e4c:	0007c783          	lbu	a5,0(a5)
   10e50:	00078713          	mv	a4,a5
   10e54:	05800793          	li	a5,88
   10e58:	00f71663          	bne	a4,a5,10e64 <vprintfmt+0x4a0>
   10e5c:	05800793          	li	a5,88
   10e60:	0080006f          	j	10e68 <vprintfmt+0x4a4>
   10e64:	07800793          	li	a5,120
   10e68:	f5843703          	ld	a4,-168(s0)
   10e6c:	00078513          	mv	a0,a5
   10e70:	000700e7          	jalr	a4
   10e74:	fec42783          	lw	a5,-20(s0)
   10e78:	0027879b          	addiw	a5,a5,2
   10e7c:	fef42623          	sw	a5,-20(s0)
   10e80:	fdc42783          	lw	a5,-36(s0)
   10e84:	fcf42a23          	sw	a5,-44(s0)
   10e88:	0280006f          	j	10eb0 <vprintfmt+0x4ec>
   10e8c:	f5843783          	ld	a5,-168(s0)
   10e90:	03000513          	li	a0,48
   10e94:	000780e7          	jalr	a5
   10e98:	fec42783          	lw	a5,-20(s0)
   10e9c:	0017879b          	addiw	a5,a5,1
   10ea0:	fef42623          	sw	a5,-20(s0)
   10ea4:	fd442783          	lw	a5,-44(s0)
   10ea8:	0017879b          	addiw	a5,a5,1
   10eac:	fcf42a23          	sw	a5,-44(s0)
   10eb0:	f8c42783          	lw	a5,-116(s0)
   10eb4:	fd442703          	lw	a4,-44(s0)
   10eb8:	0007071b          	sext.w	a4,a4
   10ebc:	fcf748e3          	blt	a4,a5,10e8c <vprintfmt+0x4c8>
   10ec0:	fdc42783          	lw	a5,-36(s0)
   10ec4:	fff7879b          	addiw	a5,a5,-1
   10ec8:	fcf42823          	sw	a5,-48(s0)
   10ecc:	03c0006f          	j	10f08 <vprintfmt+0x544>
   10ed0:	fd042783          	lw	a5,-48(s0)
   10ed4:	ff078793          	addi	a5,a5,-16
   10ed8:	008787b3          	add	a5,a5,s0
   10edc:	f807c783          	lbu	a5,-128(a5)
   10ee0:	0007871b          	sext.w	a4,a5
   10ee4:	f5843783          	ld	a5,-168(s0)
   10ee8:	00070513          	mv	a0,a4
   10eec:	000780e7          	jalr	a5
   10ef0:	fec42783          	lw	a5,-20(s0)
   10ef4:	0017879b          	addiw	a5,a5,1
   10ef8:	fef42623          	sw	a5,-20(s0)
   10efc:	fd042783          	lw	a5,-48(s0)
   10f00:	fff7879b          	addiw	a5,a5,-1
   10f04:	fcf42823          	sw	a5,-48(s0)
   10f08:	fd042783          	lw	a5,-48(s0)
   10f0c:	0007879b          	sext.w	a5,a5
   10f10:	fc07d0e3          	bgez	a5,10ed0 <vprintfmt+0x50c>
   10f14:	f8040023          	sb	zero,-128(s0)
   10f18:	2780006f          	j	11190 <vprintfmt+0x7cc>
   10f1c:	f5043783          	ld	a5,-176(s0)
   10f20:	0007c783          	lbu	a5,0(a5)
   10f24:	00078713          	mv	a4,a5
   10f28:	06400793          	li	a5,100
   10f2c:	02f70663          	beq	a4,a5,10f58 <vprintfmt+0x594>
   10f30:	f5043783          	ld	a5,-176(s0)
   10f34:	0007c783          	lbu	a5,0(a5)
   10f38:	00078713          	mv	a4,a5
   10f3c:	06900793          	li	a5,105
   10f40:	00f70c63          	beq	a4,a5,10f58 <vprintfmt+0x594>
   10f44:	f5043783          	ld	a5,-176(s0)
   10f48:	0007c783          	lbu	a5,0(a5)
   10f4c:	00078713          	mv	a4,a5
   10f50:	07500793          	li	a5,117
   10f54:	08f71263          	bne	a4,a5,10fd8 <vprintfmt+0x614>
   10f58:	f8144783          	lbu	a5,-127(s0)
   10f5c:	00078c63          	beqz	a5,10f74 <vprintfmt+0x5b0>
   10f60:	f4843783          	ld	a5,-184(s0)
   10f64:	00878713          	addi	a4,a5,8
   10f68:	f4e43423          	sd	a4,-184(s0)
   10f6c:	0007b783          	ld	a5,0(a5)
   10f70:	0140006f          	j	10f84 <vprintfmt+0x5c0>
   10f74:	f4843783          	ld	a5,-184(s0)
   10f78:	00878713          	addi	a4,a5,8
   10f7c:	f4e43423          	sd	a4,-184(s0)
   10f80:	0007a783          	lw	a5,0(a5)
   10f84:	faf43423          	sd	a5,-88(s0)
   10f88:	fa843583          	ld	a1,-88(s0)
   10f8c:	f5043783          	ld	a5,-176(s0)
   10f90:	0007c783          	lbu	a5,0(a5)
   10f94:	0007871b          	sext.w	a4,a5
   10f98:	07500793          	li	a5,117
   10f9c:	40f707b3          	sub	a5,a4,a5
   10fa0:	00f037b3          	snez	a5,a5
   10fa4:	0ff7f793          	zext.b	a5,a5
   10fa8:	f8040713          	addi	a4,s0,-128
   10fac:	00070693          	mv	a3,a4
   10fb0:	00078613          	mv	a2,a5
   10fb4:	f5843503          	ld	a0,-168(s0)
   10fb8:	fffff097          	auipc	ra,0xfffff
   10fbc:	6d8080e7          	jalr	1752(ra) # 10690 <print_dec_int>
   10fc0:	00050793          	mv	a5,a0
   10fc4:	fec42703          	lw	a4,-20(s0)
   10fc8:	00f707bb          	addw	a5,a4,a5
   10fcc:	fef42623          	sw	a5,-20(s0)
   10fd0:	f8040023          	sb	zero,-128(s0)
   10fd4:	1bc0006f          	j	11190 <vprintfmt+0x7cc>
   10fd8:	f5043783          	ld	a5,-176(s0)
   10fdc:	0007c783          	lbu	a5,0(a5)
   10fe0:	00078713          	mv	a4,a5
   10fe4:	06e00793          	li	a5,110
   10fe8:	04f71c63          	bne	a4,a5,11040 <vprintfmt+0x67c>
   10fec:	f8144783          	lbu	a5,-127(s0)
   10ff0:	02078463          	beqz	a5,11018 <vprintfmt+0x654>
   10ff4:	f4843783          	ld	a5,-184(s0)
   10ff8:	00878713          	addi	a4,a5,8
   10ffc:	f4e43423          	sd	a4,-184(s0)
   11000:	0007b783          	ld	a5,0(a5)
   11004:	faf43823          	sd	a5,-80(s0)
   11008:	fec42703          	lw	a4,-20(s0)
   1100c:	fb043783          	ld	a5,-80(s0)
   11010:	00e7b023          	sd	a4,0(a5)
   11014:	0240006f          	j	11038 <vprintfmt+0x674>
   11018:	f4843783          	ld	a5,-184(s0)
   1101c:	00878713          	addi	a4,a5,8
   11020:	f4e43423          	sd	a4,-184(s0)
   11024:	0007b783          	ld	a5,0(a5)
   11028:	faf43c23          	sd	a5,-72(s0)
   1102c:	fb843783          	ld	a5,-72(s0)
   11030:	fec42703          	lw	a4,-20(s0)
   11034:	00e7a023          	sw	a4,0(a5)
   11038:	f8040023          	sb	zero,-128(s0)
   1103c:	1540006f          	j	11190 <vprintfmt+0x7cc>
   11040:	f5043783          	ld	a5,-176(s0)
   11044:	0007c783          	lbu	a5,0(a5)
   11048:	00078713          	mv	a4,a5
   1104c:	07300793          	li	a5,115
   11050:	04f71063          	bne	a4,a5,11090 <vprintfmt+0x6cc>
   11054:	f4843783          	ld	a5,-184(s0)
   11058:	00878713          	addi	a4,a5,8
   1105c:	f4e43423          	sd	a4,-184(s0)
   11060:	0007b783          	ld	a5,0(a5)
   11064:	fcf43023          	sd	a5,-64(s0)
   11068:	fc043583          	ld	a1,-64(s0)
   1106c:	f5843503          	ld	a0,-168(s0)
   11070:	fffff097          	auipc	ra,0xfffff
   11074:	598080e7          	jalr	1432(ra) # 10608 <puts_wo_nl>
   11078:	00050793          	mv	a5,a0
   1107c:	fec42703          	lw	a4,-20(s0)
   11080:	00f707bb          	addw	a5,a4,a5
   11084:	fef42623          	sw	a5,-20(s0)
   11088:	f8040023          	sb	zero,-128(s0)
   1108c:	1040006f          	j	11190 <vprintfmt+0x7cc>
   11090:	f5043783          	ld	a5,-176(s0)
   11094:	0007c783          	lbu	a5,0(a5)
   11098:	00078713          	mv	a4,a5
   1109c:	06300793          	li	a5,99
   110a0:	02f71e63          	bne	a4,a5,110dc <vprintfmt+0x718>
   110a4:	f4843783          	ld	a5,-184(s0)
   110a8:	00878713          	addi	a4,a5,8
   110ac:	f4e43423          	sd	a4,-184(s0)
   110b0:	0007a783          	lw	a5,0(a5)
   110b4:	fcf42623          	sw	a5,-52(s0)
   110b8:	fcc42703          	lw	a4,-52(s0)
   110bc:	f5843783          	ld	a5,-168(s0)
   110c0:	00070513          	mv	a0,a4
   110c4:	000780e7          	jalr	a5
   110c8:	fec42783          	lw	a5,-20(s0)
   110cc:	0017879b          	addiw	a5,a5,1
   110d0:	fef42623          	sw	a5,-20(s0)
   110d4:	f8040023          	sb	zero,-128(s0)
   110d8:	0b80006f          	j	11190 <vprintfmt+0x7cc>
   110dc:	f5043783          	ld	a5,-176(s0)
   110e0:	0007c783          	lbu	a5,0(a5)
   110e4:	00078713          	mv	a4,a5
   110e8:	02500793          	li	a5,37
   110ec:	02f71263          	bne	a4,a5,11110 <vprintfmt+0x74c>
   110f0:	f5843783          	ld	a5,-168(s0)
   110f4:	02500513          	li	a0,37
   110f8:	000780e7          	jalr	a5
   110fc:	fec42783          	lw	a5,-20(s0)
   11100:	0017879b          	addiw	a5,a5,1
   11104:	fef42623          	sw	a5,-20(s0)
   11108:	f8040023          	sb	zero,-128(s0)
   1110c:	0840006f          	j	11190 <vprintfmt+0x7cc>
   11110:	f5043783          	ld	a5,-176(s0)
   11114:	0007c783          	lbu	a5,0(a5)
   11118:	0007871b          	sext.w	a4,a5
   1111c:	f5843783          	ld	a5,-168(s0)
   11120:	00070513          	mv	a0,a4
   11124:	000780e7          	jalr	a5
   11128:	fec42783          	lw	a5,-20(s0)
   1112c:	0017879b          	addiw	a5,a5,1
   11130:	fef42623          	sw	a5,-20(s0)
   11134:	f8040023          	sb	zero,-128(s0)
   11138:	0580006f          	j	11190 <vprintfmt+0x7cc>
   1113c:	f5043783          	ld	a5,-176(s0)
   11140:	0007c783          	lbu	a5,0(a5)
   11144:	00078713          	mv	a4,a5
   11148:	02500793          	li	a5,37
   1114c:	02f71063          	bne	a4,a5,1116c <vprintfmt+0x7a8>
   11150:	f8043023          	sd	zero,-128(s0)
   11154:	f8043423          	sd	zero,-120(s0)
   11158:	00100793          	li	a5,1
   1115c:	f8f40023          	sb	a5,-128(s0)
   11160:	fff00793          	li	a5,-1
   11164:	f8f42623          	sw	a5,-116(s0)
   11168:	0280006f          	j	11190 <vprintfmt+0x7cc>
   1116c:	f5043783          	ld	a5,-176(s0)
   11170:	0007c783          	lbu	a5,0(a5)
   11174:	0007871b          	sext.w	a4,a5
   11178:	f5843783          	ld	a5,-168(s0)
   1117c:	00070513          	mv	a0,a4
   11180:	000780e7          	jalr	a5
   11184:	fec42783          	lw	a5,-20(s0)
   11188:	0017879b          	addiw	a5,a5,1
   1118c:	fef42623          	sw	a5,-20(s0)
   11190:	f5043783          	ld	a5,-176(s0)
   11194:	00178793          	addi	a5,a5,1
   11198:	f4f43823          	sd	a5,-176(s0)
   1119c:	f5043783          	ld	a5,-176(s0)
   111a0:	0007c783          	lbu	a5,0(a5)
   111a4:	840796e3          	bnez	a5,109f0 <vprintfmt+0x2c>
   111a8:	fec42783          	lw	a5,-20(s0)
   111ac:	00078513          	mv	a0,a5
   111b0:	0b813083          	ld	ra,184(sp)
   111b4:	0b013403          	ld	s0,176(sp)
   111b8:	0c010113          	addi	sp,sp,192
   111bc:	00008067          	ret

00000000000111c0 <printf>:
   111c0:	f8010113          	addi	sp,sp,-128
   111c4:	02113c23          	sd	ra,56(sp)
   111c8:	02813823          	sd	s0,48(sp)
   111cc:	04010413          	addi	s0,sp,64
   111d0:	fca43423          	sd	a0,-56(s0)
   111d4:	00b43423          	sd	a1,8(s0)
   111d8:	00c43823          	sd	a2,16(s0)
   111dc:	00d43c23          	sd	a3,24(s0)
   111e0:	02e43023          	sd	a4,32(s0)
   111e4:	02f43423          	sd	a5,40(s0)
   111e8:	03043823          	sd	a6,48(s0)
   111ec:	03143c23          	sd	a7,56(s0)
   111f0:	fe042623          	sw	zero,-20(s0)
   111f4:	04040793          	addi	a5,s0,64
   111f8:	fcf43023          	sd	a5,-64(s0)
   111fc:	fc043783          	ld	a5,-64(s0)
   11200:	fc878793          	addi	a5,a5,-56
   11204:	fcf43823          	sd	a5,-48(s0)
   11208:	fd043783          	ld	a5,-48(s0)
   1120c:	00078613          	mv	a2,a5
   11210:	fc843583          	ld	a1,-56(s0)
   11214:	fffff517          	auipc	a0,0xfffff
   11218:	0ac50513          	addi	a0,a0,172 # 102c0 <putc>
   1121c:	fffff097          	auipc	ra,0xfffff
   11220:	7a8080e7          	jalr	1960(ra) # 109c4 <vprintfmt>
   11224:	00050793          	mv	a5,a0
   11228:	fef42623          	sw	a5,-20(s0)
   1122c:	00100793          	li	a5,1
   11230:	fef43023          	sd	a5,-32(s0)
   11234:	00001797          	auipc	a5,0x1
   11238:	dd078793          	addi	a5,a5,-560 # 12004 <tail>
   1123c:	0007a783          	lw	a5,0(a5)
   11240:	0017871b          	addiw	a4,a5,1
   11244:	0007069b          	sext.w	a3,a4
   11248:	00001717          	auipc	a4,0x1
   1124c:	dbc70713          	addi	a4,a4,-580 # 12004 <tail>
   11250:	00d72023          	sw	a3,0(a4)
   11254:	00001717          	auipc	a4,0x1
   11258:	db470713          	addi	a4,a4,-588 # 12008 <buffer>
   1125c:	00f707b3          	add	a5,a4,a5
   11260:	00078023          	sb	zero,0(a5)
   11264:	00001797          	auipc	a5,0x1
   11268:	da078793          	addi	a5,a5,-608 # 12004 <tail>
   1126c:	0007a603          	lw	a2,0(a5)
   11270:	fe043703          	ld	a4,-32(s0)
   11274:	00001697          	auipc	a3,0x1
   11278:	d9468693          	addi	a3,a3,-620 # 12008 <buffer>
   1127c:	fd843783          	ld	a5,-40(s0)
   11280:	04000893          	li	a7,64
   11284:	00070513          	mv	a0,a4
   11288:	00068593          	mv	a1,a3
   1128c:	00060613          	mv	a2,a2
   11290:	00000073          	ecall
   11294:	00050793          	mv	a5,a0
   11298:	fcf43c23          	sd	a5,-40(s0)
   1129c:	00001797          	auipc	a5,0x1
   112a0:	d6878793          	addi	a5,a5,-664 # 12004 <tail>
   112a4:	0007a023          	sw	zero,0(a5)
   112a8:	fec42783          	lw	a5,-20(s0)
   112ac:	00078513          	mv	a0,a5
   112b0:	03813083          	ld	ra,56(sp)
   112b4:	03013403          	ld	s0,48(sp)
   112b8:	08010113          	addi	sp,sp,128
   112bc:	00008067          	ret
