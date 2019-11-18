
kernel:     file format elf32-littlearm


Disassembly of section .init:

00008000 <_start>:
    8000:	e10f0000 	mrs	r0, CPSR
    8004:	e200001f 	and	r0, r0, #31
    8008:	e3a0101a 	mov	r1, #26
    800c:	e1500001 	cmp	r0, r1
    8010:	0a00000a 	beq	8040 <_exitHyper>

00008014 <_loopCores>:
    8014:	ee100fb0 	mrc	15, 0, r0, cr0, cr0, {5}
    8018:	e3100003 	tst	r0, #3
    801c:	1a000005 	bne	8038 <_bsprak+0x18>

00008020 <_bsprak>:
    8020:	e3a0d802 	mov	sp, #131072	; 0x20000
    8024:	ee100fb0 	mrc	15, 0, r0, cr0, cr0, {5}
    8028:	eb00000b 	bl	805c <init_int>
    802c:	e59f0078 	ldr	r0, [pc, #120]	; 80ac <init_int+0x50>
    8030:	ee0c0f10 	mcr	15, 0, r0, cr12, cr0, {0}
    8034:	eb000021 	bl	80c0 <start_kernel>
    8038:	e320f003 	wfi
    803c:	eafffffd 	b	8038 <_bsprak+0x18>

00008040 <_exitHyper>:
    8040:	e59fe068 	ldr	lr, [pc, #104]	; 80b0 <init_int+0x54>
    8044:	e12ef30e 	msr	ELR_hyp, lr
    8048:	e10f0000 	mrs	r0, CPSR
    804c:	e3c0001f 	bic	r0, r0, #31
    8050:	e3800013 	orr	r0, r0, #19
    8054:	e16ef300 	msr	SPSR_hyp, r0
    8058:	e160006e 	eret

0000805c <init_int>:
    805c:	e3a0d80f 	mov	sp, #983040	; 0xf0000
    8060:	e3a0080f 	mov	r0, #983040	; 0xf0000
    8064:	e3a01c02 	mov	r1, #512	; 0x200
    8068:	f1020011 	cps	#17
    806c:	e0800001 	add	r0, r0, r1
    8070:	e1a0d000 	mov	sp, r0
    8074:	f1020012 	cps	#18
    8078:	e0800001 	add	r0, r0, r1
    807c:	e1a0d000 	mov	sp, r0
    8080:	f102001f 	cps	#31
    8084:	e0800001 	add	r0, r0, r1
    8088:	e1a0d000 	mov	sp, r0
    808c:	f102001b 	cps	#27
    8090:	e0800001 	add	r0, r0, r1
    8094:	e1a0d000 	mov	sp, r0
    8098:	f1020017 	cps	#23
    809c:	e0800001 	add	r0, r0, r1
    80a0:	e1a0d000 	mov	sp, r0
    80a4:	f1020013 	cps	#19
    80a8:	e1a0f00e 	mov	pc, lr
    80ac:	000088c0 	andeq	r8, r0, r0, asr #17
    80b0:	00008014 	andeq	r8, r0, r4, lsl r0

Disassembly of section .text:

000080c0 <start_kernel>:
    80c0:	e30e00ff 	movw	r0, #57599	; 0xe0ff
    80c4:	e92d4010 	push	{r4, lr}
    80c8:	e34005f5 	movt	r0, #1525	; 0x5f5
    80cc:	eb00033f 	bl	8dd0 <start_timer_interrupt>
    80d0:	eb0002b8 	bl	8bb8 <enable_uart_IRQ>
    80d4:	eb00067d 	bl	9ad0 <read_and_write>
    80d8:	eafffffd 	b	80d4 <start_kernel+0x14>

000080dc <set_IRQ_DEBUG>:
    80dc:	e30a37d0 	movw	r3, #42960	; 0xa7d0
    80e0:	e3403000 	movt	r3, #0
    80e4:	e5830000 	str	r0, [r3]
    80e8:	e12fff1e 	bx	lr

000080ec <rORw>:
    80ec:	e3092bdc 	movw	r2, #39900	; 0x9bdc
    80f0:	e3093be4 	movw	r3, #39908	; 0x9be4
    80f4:	e3402000 	movt	r2, #0
    80f8:	e3100b02 	tst	r0, #2048	; 0x800
    80fc:	e3403000 	movt	r3, #0
    8100:	11a00002 	movne	r0, r2
    8104:	01a00003 	moveq	r0, r3
    8108:	e12fff1e 	bx	lr

0000810c <da_report>:
    810c:	e3093be4 	movw	r3, #39908	; 0x9be4
    8110:	e3091bdc 	movw	r1, #39900	; 0x9bdc
    8114:	e3403000 	movt	r3, #0
    8118:	e3090bf0 	movw	r0, #39920	; 0x9bf0
    811c:	e92d4010 	push	{r4, lr}
    8120:	ee154f10 	mrc	15, 0, r4, cr5, cr0, {0}
    8124:	e3401000 	movt	r1, #0
    8128:	e3140b02 	tst	r4, #2048	; 0x800
    812c:	e3400000 	movt	r0, #0
    8130:	01a01003 	moveq	r1, r3
    8134:	ee162f10 	mrc	15, 0, r2, cr6, cr0, {0}
    8138:	eb0004cb 	bl	946c <kprintf>
    813c:	e204301f 	and	r3, r4, #31
    8140:	e3530017 	cmp	r3, #23
    8144:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    8148:	ea000017 	b	81ac <da_report+0xa0>
    814c:	000081e0 	andeq	r8, r0, r0, ror #3
    8150:	000081f0 	strdeq	r8, [r0], -r0
    8154:	00008200 	andeq	r8, r0, r0, lsl #4
    8158:	00008210 	andeq	r8, r0, r0, lsl r2
    815c:	00008220 	andeq	r8, r0, r0, lsr #4
    8160:	00008230 	andeq	r8, r0, r0, lsr r2
    8164:	00008240 	andeq	r8, r0, r0, asr #4
    8168:	00008250 	andeq	r8, r0, r0, asr r2
    816c:	00008260 	andeq	r8, r0, r0, ror #4
    8170:	00008270 	andeq	r8, r0, r0, ror r2
    8174:	00008280 	andeq	r8, r0, r0, lsl #5
    8178:	00008290 	muleq	r0, r0, r2
    817c:	000082a0 	andeq	r8, r0, r0, lsr #5
    8180:	000082b0 			; <UNDEFINED> instruction: 0x000082b0
    8184:	000082c0 	andeq	r8, r0, r0, asr #5
    8188:	000082d0 	ldrdeq	r8, [r0], -r0
    818c:	000081ac 	andeq	r8, r0, ip, lsr #3
    8190:	000081ac 	andeq	r8, r0, ip, lsr #3
    8194:	000081ac 	andeq	r8, r0, ip, lsr #3
    8198:	000081ac 	andeq	r8, r0, ip, lsr #3
    819c:	000081ac 	andeq	r8, r0, ip, lsr #3
    81a0:	000081ac 	andeq	r8, r0, ip, lsr #3
    81a4:	000082e0 	andeq	r8, r0, r0, ror #5
    81a8:	000081d0 	ldrdeq	r8, [r0], -r0
    81ac:	e204301c 	and	r3, r4, #28
    81b0:	e3530010 	cmp	r3, #16
    81b4:	0a000005 	beq	81d0 <da_report+0xc4>
    81b8:	e204301e 	and	r3, r4, #30
    81bc:	e3530014 	cmp	r3, #20
    81c0:	0a000002 	beq	81d0 <da_report+0xc4>
    81c4:	e2044018 	and	r4, r4, #24
    81c8:	e3540018 	cmp	r4, #24
    81cc:	18bd8010 	popne	{r4, pc}
    81d0:	e3090e94 	movw	r0, #40596	; 0x9e94
    81d4:	e3400000 	movt	r0, #0
    81d8:	e8bd4010 	pop	{r4, lr}
    81dc:	ea0004a2 	b	946c <kprintf>
    81e0:	e3090c10 	movw	r0, #39952	; 0x9c10
    81e4:	e3400000 	movt	r0, #0
    81e8:	e8bd4010 	pop	{r4, lr}
    81ec:	ea00049e 	b	946c <kprintf>
    81f0:	e3090c34 	movw	r0, #39988	; 0x9c34
    81f4:	e3400000 	movt	r0, #0
    81f8:	e8bd4010 	pop	{r4, lr}
    81fc:	ea00049a 	b	946c <kprintf>
    8200:	e3090c50 	movw	r0, #40016	; 0x9c50
    8204:	e3400000 	movt	r0, #0
    8208:	e8bd4010 	pop	{r4, lr}
    820c:	ea000496 	b	946c <kprintf>
    8210:	e3090c6c 	movw	r0, #40044	; 0x9c6c
    8214:	e3400000 	movt	r0, #0
    8218:	e8bd4010 	pop	{r4, lr}
    821c:	ea000492 	b	946c <kprintf>
    8220:	e3090c94 	movw	r0, #40084	; 0x9c94
    8224:	e3400000 	movt	r0, #0
    8228:	e8bd4010 	pop	{r4, lr}
    822c:	ea00048e 	b	946c <kprintf>
    8230:	e3090cc4 	movw	r0, #40132	; 0x9cc4
    8234:	e3400000 	movt	r0, #0
    8238:	e8bd4010 	pop	{r4, lr}
    823c:	ea00048a 	b	946c <kprintf>
    8240:	e3090cec 	movw	r0, #40172	; 0x9cec
    8244:	e3400000 	movt	r0, #0
    8248:	e8bd4010 	pop	{r4, lr}
    824c:	ea000486 	b	946c <kprintf>
    8250:	e3090d10 	movw	r0, #40208	; 0x9d10
    8254:	e3400000 	movt	r0, #0
    8258:	e8bd4010 	pop	{r4, lr}
    825c:	ea000482 	b	946c <kprintf>
    8260:	e3090d34 	movw	r0, #40244	; 0x9d34
    8264:	e3400000 	movt	r0, #0
    8268:	e8bd4010 	pop	{r4, lr}
    826c:	ea00047e 	b	946c <kprintf>
    8270:	e3090d58 	movw	r0, #40280	; 0x9d58
    8274:	e3400000 	movt	r0, #0
    8278:	e8bd4010 	pop	{r4, lr}
    827c:	ea00047a 	b	946c <kprintf>
    8280:	e3090d7c 	movw	r0, #40316	; 0x9d7c
    8284:	e3400000 	movt	r0, #0
    8288:	e8bd4010 	pop	{r4, lr}
    828c:	ea000476 	b	946c <kprintf>
    8290:	e3090d94 	movw	r0, #40340	; 0x9d94
    8294:	e3400000 	movt	r0, #0
    8298:	e8bd4010 	pop	{r4, lr}
    829c:	ea000472 	b	946c <kprintf>
    82a0:	e3090db4 	movw	r0, #40372	; 0x9db4
    82a4:	e3400000 	movt	r0, #0
    82a8:	e8bd4010 	pop	{r4, lr}
    82ac:	ea00046e 	b	946c <kprintf>
    82b0:	e3090dec 	movw	r0, #40428	; 0x9dec
    82b4:	e3400000 	movt	r0, #0
    82b8:	e8bd4010 	pop	{r4, lr}
    82bc:	ea00046a 	b	946c <kprintf>
    82c0:	e3090e14 	movw	r0, #40468	; 0x9e14
    82c4:	e3400000 	movt	r0, #0
    82c8:	e8bd4010 	pop	{r4, lr}
    82cc:	ea000466 	b	946c <kprintf>
    82d0:	e3090e4c 	movw	r0, #40524	; 0x9e4c
    82d4:	e3400000 	movt	r0, #0
    82d8:	e8bd4010 	pop	{r4, lr}
    82dc:	ea000462 	b	946c <kprintf>
    82e0:	e3090e70 	movw	r0, #40560	; 0x9e70
    82e4:	e3400000 	movt	r0, #0
    82e8:	e8bd4010 	pop	{r4, lr}
    82ec:	ea00045e 	b	946c <kprintf>

000082f0 <bitsToLetters>:
    82f0:	e92d4010 	push	{r4, lr}
    82f4:	e1a04000 	mov	r4, r0
    82f8:	e30a07d4 	movw	r0, #42964	; 0xa7d4
    82fc:	e3a0100a 	mov	r1, #10
    8300:	e3400000 	movt	r0, #0
    8304:	eb000338 	bl	8fec <kmemset>
    8308:	e30a37d4 	movw	r3, #42964	; 0xa7d4
    830c:	e3540000 	cmp	r4, #0
    8310:	e3403000 	movt	r3, #0
    8314:	b3a0104e 	movlt	r1, #78	; 0x4e
    8318:	a3a0105f 	movge	r1, #95	; 0x5f
    831c:	e3140101 	tst	r4, #1073741824	; 0x40000000
    8320:	e5c31000 	strb	r1, [r3]
    8324:	13a0105a 	movne	r1, #90	; 0x5a
    8328:	03a0105f 	moveq	r1, #95	; 0x5f
    832c:	e3140202 	tst	r4, #536870912	; 0x20000000
    8330:	e5c31001 	strb	r1, [r3, #1]
    8334:	13a01043 	movne	r1, #67	; 0x43
    8338:	03a0105f 	moveq	r1, #95	; 0x5f
    833c:	e3140201 	tst	r4, #268435456	; 0x10000000
    8340:	e5c31002 	strb	r1, [r3, #2]
    8344:	13a01056 	movne	r1, #86	; 0x56
    8348:	03a0105f 	moveq	r1, #95	; 0x5f
    834c:	e3140c02 	tst	r4, #512	; 0x200
    8350:	e5c31003 	strb	r1, [r3, #3]
    8354:	13a01045 	movne	r1, #69	; 0x45
    8358:	03a0105f 	moveq	r1, #95	; 0x5f
    835c:	e3140080 	tst	r4, #128	; 0x80
    8360:	e5c31005 	strb	r1, [r3, #5]
    8364:	13a01049 	movne	r1, #73	; 0x49
    8368:	03a0105f 	moveq	r1, #95	; 0x5f
    836c:	e3140040 	tst	r4, #64	; 0x40
    8370:	e5c31007 	strb	r1, [r3, #7]
    8374:	13a01046 	movne	r1, #70	; 0x46
    8378:	03a0105f 	moveq	r1, #95	; 0x5f
    837c:	e3140020 	tst	r4, #32
    8380:	e5c31008 	strb	r1, [r3, #8]
    8384:	e3a02020 	mov	r2, #32
    8388:	e5c32004 	strb	r2, [r3, #4]
    838c:	13a01054 	movne	r1, #84	; 0x54
    8390:	e5c32006 	strb	r2, [r3, #6]
    8394:	03a0105f 	moveq	r1, #95	; 0x5f
    8398:	e5c31009 	strb	r1, [r3, #9]
    839c:	e8bd8010 	pop	{r4, pc}

000083a0 <modusbits>:
    83a0:	e200001f 	and	r0, r0, #31
    83a4:	e2400010 	sub	r0, r0, #16
    83a8:	e350000f 	cmp	r0, #15
    83ac:	93093b7c 	movwls	r3, #39804	; 0x9b7c
    83b0:	93403000 	movtls	r3, #0
    83b4:	97930100 	ldrls	r0, [r3, r0, lsl #2]
    83b8:	83090eac 	movwhi	r0, #40620	; 0x9eac
    83bc:	83400000 	movthi	r0, #0
    83c0:	e12fff1e 	bx	lr

000083c4 <reg_snapshot_print>:
    83c4:	e92d4010 	push	{r4, lr}
    83c8:	e1a0c002 	mov	ip, r2
    83cc:	e24dd038 	sub	sp, sp, #56	; 0x38
    83d0:	e58d1034 	str	r1, [sp, #52]	; 0x34
    83d4:	e1a01000 	mov	r1, r0
    83d8:	e5922000 	ldr	r2, [r2]
    83dc:	e3090ebc 	movw	r0, #40636	; 0x9ebc
    83e0:	e59c3020 	ldr	r3, [ip, #32]
    83e4:	e59c4004 	ldr	r4, [ip, #4]
    83e8:	e59ce024 	ldr	lr, [ip, #36]	; 0x24
    83ec:	e3400000 	movt	r0, #0
    83f0:	e88d4010 	stm	sp, {r4, lr}
    83f4:	e59c4008 	ldr	r4, [ip, #8]
    83f8:	e59ce028 	ldr	lr, [ip, #40]	; 0x28
    83fc:	e58d4008 	str	r4, [sp, #8]
    8400:	e58de00c 	str	lr, [sp, #12]
    8404:	e59ce00c 	ldr	lr, [ip, #12]
    8408:	e58de010 	str	lr, [sp, #16]
    840c:	e59c402c 	ldr	r4, [ip, #44]	; 0x2c
    8410:	e59ce010 	ldr	lr, [ip, #16]
    8414:	e58d4014 	str	r4, [sp, #20]
    8418:	e58de018 	str	lr, [sp, #24]
    841c:	e59c4030 	ldr	r4, [ip, #48]	; 0x30
    8420:	e59ce014 	ldr	lr, [ip, #20]
    8424:	e58d401c 	str	r4, [sp, #28]
    8428:	e58de020 	str	lr, [sp, #32]
    842c:	e59c4018 	ldr	r4, [ip, #24]
    8430:	e59ce034 	ldr	lr, [ip, #52]	; 0x34
    8434:	e59cc01c 	ldr	ip, [ip, #28]
    8438:	e58d4028 	str	r4, [sp, #40]	; 0x28
    843c:	e58dc030 	str	ip, [sp, #48]	; 0x30
    8440:	e58de02c 	str	lr, [sp, #44]	; 0x2c
    8444:	e1a0c00d 	mov	ip, sp
    8448:	e58dc024 	str	ip, [sp, #36]	; 0x24
    844c:	eb000406 	bl	946c <kprintf>
    8450:	e28dd038 	add	sp, sp, #56	; 0x38
    8454:	e8bd8010 	pop	{r4, pc}

00008458 <SPSR_print>:
    8458:	e1a01000 	mov	r1, r0
    845c:	e3090f8c 	movw	r0, #40844	; 0x9f8c
    8460:	e92d4010 	push	{r4, lr}
    8464:	e10f4000 	mrs	r4, CPSR
    8468:	e3400000 	movt	r0, #0
    846c:	eb0003fe 	bl	946c <kprintf>
    8470:	e1a00004 	mov	r0, r4
    8474:	ebffff9d 	bl	82f0 <bitsToLetters>
    8478:	e204201f 	and	r2, r4, #31
    847c:	e30a17d4 	movw	r1, #42964	; 0xa7d4
    8480:	e3401000 	movt	r1, #0
    8484:	e2422010 	sub	r2, r2, #16
    8488:	e352000f 	cmp	r2, #15
    848c:	e3090fb4 	movw	r0, #40884	; 0x9fb4
    8490:	e3400000 	movt	r0, #0
    8494:	93093b7c 	movwls	r3, #39804	; 0x9b7c
    8498:	93403000 	movtls	r3, #0
    849c:	83092eac 	movwhi	r2, #40620	; 0x9eac
    84a0:	83402000 	movthi	r2, #0
    84a4:	97932102 	ldrls	r2, [r3, r2, lsl #2]
    84a8:	e1a03004 	mov	r3, r4
    84ac:	eb0003ee 	bl	946c <kprintf>
    84b0:	e14f4000 	mrs	r4, SPSR
    84b4:	e1a00004 	mov	r0, r4
    84b8:	ebffff8c 	bl	82f0 <bitsToLetters>
    84bc:	e204201f 	and	r2, r4, #31
    84c0:	e30a17d4 	movw	r1, #42964	; 0xa7d4
    84c4:	e3401000 	movt	r1, #0
    84c8:	e2422010 	sub	r2, r2, #16
    84cc:	e352000f 	cmp	r2, #15
    84d0:	e3090fcc 	movw	r0, #40908	; 0x9fcc
    84d4:	e3400000 	movt	r0, #0
    84d8:	93093b7c 	movwls	r3, #39804	; 0x9b7c
    84dc:	93403000 	movtls	r3, #0
    84e0:	83092eac 	movwhi	r2, #40620	; 0x9eac
    84e4:	83402000 	movthi	r2, #0
    84e8:	97932102 	ldrls	r2, [r3, r2, lsl #2]
    84ec:	e1a03004 	mov	r3, r4
    84f0:	e8bd4010 	pop	{r4, lr}
    84f4:	ea0003dc 	b	946c <kprintf>

000084f8 <amr_print>:
    84f8:	e3092fe4 	movw	r2, #40932	; 0x9fe4
    84fc:	e3091fe8 	movw	r1, #40936	; 0x9fe8
    8500:	e3402000 	movt	r2, #0
    8504:	e3090fec 	movw	r0, #40940	; 0x9fec
    8508:	e92d4070 	push	{r4, r5, r6, lr}
    850c:	e24dd008 	sub	sp, sp, #8
    8510:	e3401000 	movt	r1, #0
    8514:	e3400000 	movt	r0, #0
    8518:	eb0003d3 	bl	946c <kprintf>
    851c:	eb00026f 	bl	8ee0 <get_lr_usr>
    8520:	e1a04000 	mov	r4, r0
    8524:	eb000279 	bl	8f10 <get_sp_usr>
    8528:	e1a02000 	mov	r2, r0
    852c:	e30a002c 	movw	r0, #41004	; 0xa02c
    8530:	e3400000 	movt	r0, #0
    8534:	e1a01004 	mov	r1, r4
    8538:	eb0003cb 	bl	946c <kprintf>
    853c:	eb00027f 	bl	8f40 <get_spsr_svc>
    8540:	ebffff6a 	bl	82f0 <bitsToLetters>
    8544:	eb000267 	bl	8ee8 <get_lr_svc>
    8548:	e1a05000 	mov	r5, r0
    854c:	eb000271 	bl	8f18 <get_sp_svc>
    8550:	e1a06000 	mov	r6, r0
    8554:	eb000279 	bl	8f40 <get_spsr_svc>
    8558:	e200001f 	and	r0, r0, #31
    855c:	e2400010 	sub	r0, r0, #16
    8560:	e350000f 	cmp	r0, #15
    8564:	93093b7c 	movwls	r3, #39804	; 0x9b7c
    8568:	83094eac 	movwhi	r4, #40620	; 0x9eac
    856c:	93403000 	movtls	r3, #0
    8570:	83404000 	movthi	r4, #0
    8574:	97934100 	ldrls	r4, [r3, r0, lsl #2]
    8578:	eb000270 	bl	8f40 <get_spsr_svc>
    857c:	e58d0004 	str	r0, [sp, #4]
    8580:	e30a37d4 	movw	r3, #42964	; 0xa7d4
    8584:	e58d4000 	str	r4, [sp]
    8588:	e30a0048 	movw	r0, #41032	; 0xa048
    858c:	e3403000 	movt	r3, #0
    8590:	e1a02006 	mov	r2, r6
    8594:	e3400000 	movt	r0, #0
    8598:	e1a01005 	mov	r1, r5
    859c:	eb0003b2 	bl	946c <kprintf>
    85a0:	eb000268 	bl	8f48 <get_spsr_abt>
    85a4:	ebffff51 	bl	82f0 <bitsToLetters>
    85a8:	eb000250 	bl	8ef0 <get_lr_abt>
    85ac:	e1a05000 	mov	r5, r0
    85b0:	eb00025a 	bl	8f20 <get_sp_abt>
    85b4:	e1a06000 	mov	r6, r0
    85b8:	eb000262 	bl	8f48 <get_spsr_abt>
    85bc:	e200001f 	and	r0, r0, #31
    85c0:	e2400010 	sub	r0, r0, #16
    85c4:	e350000f 	cmp	r0, #15
    85c8:	93093b7c 	movwls	r3, #39804	; 0x9b7c
    85cc:	83094eac 	movwhi	r4, #40620	; 0x9eac
    85d0:	93403000 	movtls	r3, #0
    85d4:	83404000 	movthi	r4, #0
    85d8:	97934100 	ldrls	r4, [r3, r0, lsl #2]
    85dc:	eb000259 	bl	8f48 <get_spsr_abt>
    85e0:	e58d0004 	str	r0, [sp, #4]
    85e4:	e30a37d4 	movw	r3, #42964	; 0xa7d4
    85e8:	e58d4000 	str	r4, [sp]
    85ec:	e30a0074 	movw	r0, #41076	; 0xa074
    85f0:	e3403000 	movt	r3, #0
    85f4:	e1a02006 	mov	r2, r6
    85f8:	e3400000 	movt	r0, #0
    85fc:	e1a01005 	mov	r1, r5
    8600:	eb000399 	bl	946c <kprintf>
    8604:	eb000251 	bl	8f50 <get_spsr_fiq>
    8608:	ebffff38 	bl	82f0 <bitsToLetters>
    860c:	eb000239 	bl	8ef8 <get_lr_fiq>
    8610:	e1a05000 	mov	r5, r0
    8614:	eb000243 	bl	8f28 <get_sp_fiq>
    8618:	e1a06000 	mov	r6, r0
    861c:	eb00024b 	bl	8f50 <get_spsr_fiq>
    8620:	e200001f 	and	r0, r0, #31
    8624:	e2400010 	sub	r0, r0, #16
    8628:	e350000f 	cmp	r0, #15
    862c:	93093b7c 	movwls	r3, #39804	; 0x9b7c
    8630:	83094eac 	movwhi	r4, #40620	; 0x9eac
    8634:	93403000 	movtls	r3, #0
    8638:	83404000 	movthi	r4, #0
    863c:	97934100 	ldrls	r4, [r3, r0, lsl #2]
    8640:	eb000242 	bl	8f50 <get_spsr_fiq>
    8644:	e58d0004 	str	r0, [sp, #4]
    8648:	e30a37d4 	movw	r3, #42964	; 0xa7d4
    864c:	e3403000 	movt	r3, #0
    8650:	e30a009c 	movw	r0, #41116	; 0xa09c
    8654:	e58d4000 	str	r4, [sp]
    8658:	e1a02006 	mov	r2, r6
    865c:	e3400000 	movt	r0, #0
    8660:	e1a01005 	mov	r1, r5
    8664:	eb000380 	bl	946c <kprintf>
    8668:	eb00023a 	bl	8f58 <get_spsr_irq>
    866c:	ebffff1f 	bl	82f0 <bitsToLetters>
    8670:	eb000222 	bl	8f00 <get_lr_irq>
    8674:	e1a05000 	mov	r5, r0
    8678:	eb00022c 	bl	8f30 <get_sp_irq>
    867c:	e1a06000 	mov	r6, r0
    8680:	eb000234 	bl	8f58 <get_spsr_irq>
    8684:	e200001f 	and	r0, r0, #31
    8688:	e2400010 	sub	r0, r0, #16
    868c:	e350000f 	cmp	r0, #15
    8690:	93093b7c 	movwls	r3, #39804	; 0x9b7c
    8694:	83094eac 	movwhi	r4, #40620	; 0x9eac
    8698:	93403000 	movtls	r3, #0
    869c:	83404000 	movthi	r4, #0
    86a0:	97934100 	ldrls	r4, [r3, r0, lsl #2]
    86a4:	eb00022b 	bl	8f58 <get_spsr_irq>
    86a8:	e58d0004 	str	r0, [sp, #4]
    86ac:	e30a37d4 	movw	r3, #42964	; 0xa7d4
    86b0:	e3403000 	movt	r3, #0
    86b4:	e30a00c0 	movw	r0, #41152	; 0xa0c0
    86b8:	e58d4000 	str	r4, [sp]
    86bc:	e1a02006 	mov	r2, r6
    86c0:	e3400000 	movt	r0, #0
    86c4:	e1a01005 	mov	r1, r5
    86c8:	eb000367 	bl	946c <kprintf>
    86cc:	eb000223 	bl	8f60 <get_spsr_und>
    86d0:	ebffff06 	bl	82f0 <bitsToLetters>
    86d4:	eb00020b 	bl	8f08 <get_lr_und>
    86d8:	e1a05000 	mov	r5, r0
    86dc:	eb000215 	bl	8f38 <get_sp_und>
    86e0:	e1a06000 	mov	r6, r0
    86e4:	eb00021d 	bl	8f60 <get_spsr_und>
    86e8:	e200001f 	and	r0, r0, #31
    86ec:	e2400010 	sub	r0, r0, #16
    86f0:	e350000f 	cmp	r0, #15
    86f4:	93093b7c 	movwls	r3, #39804	; 0x9b7c
    86f8:	83094eac 	movwhi	r4, #40620	; 0x9eac
    86fc:	93403000 	movtls	r3, #0
    8700:	83404000 	movthi	r4, #0
    8704:	97934100 	ldrls	r4, [r3, r0, lsl #2]
    8708:	eb000214 	bl	8f60 <get_spsr_und>
    870c:	e58d0004 	str	r0, [sp, #4]
    8710:	e30a37d4 	movw	r3, #42964	; 0xa7d4
    8714:	e58d4000 	str	r4, [sp]
    8718:	e30a00e4 	movw	r0, #41188	; 0xa0e4
    871c:	e3403000 	movt	r3, #0
    8720:	e1a02006 	mov	r2, r6
    8724:	e3400000 	movt	r0, #0
    8728:	e1a01005 	mov	r1, r5
    872c:	eb00034e 	bl	946c <kprintf>
    8730:	e28dd008 	add	sp, sp, #8
    8734:	e8bd8070 	pop	{r4, r5, r6, pc}

00008738 <general_handler>:
    8738:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
    873c:	e1a05000 	mov	r5, r0
    8740:	e30a010c 	movw	r0, #41228	; 0xa10c
    8744:	e1a06002 	mov	r6, r2
    8748:	e3400000 	movt	r0, #0
    874c:	e1a07003 	mov	r7, r3
    8750:	e5952034 	ldr	r2, [r5, #52]	; 0x34
    8754:	e1a04001 	mov	r4, r1
    8758:	eb000343 	bl	946c <kprintf>
    875c:	e3560000 	cmp	r6, #0
    8760:	1a000013 	bne	87b4 <general_handler+0x7c>
    8764:	e5d43000 	ldrb	r3, [r4]
    8768:	e3530049 	cmp	r3, #73	; 0x49
    876c:	1a000004 	bne	8784 <general_handler+0x4c>
    8770:	e30a37d0 	movw	r3, #42960	; 0xa7d0
    8774:	e3403000 	movt	r3, #0
    8778:	e5933000 	ldr	r3, [r3]
    877c:	e3530000 	cmp	r3, #0
    8780:	0a000003 	beq	8794 <general_handler+0x5c>
    8784:	e1a02005 	mov	r2, r5
    8788:	e1a01007 	mov	r1, r7
    878c:	e1a00004 	mov	r0, r4
    8790:	ebffff0b 	bl	83c4 <reg_snapshot_print>
    8794:	e1a00004 	mov	r0, r4
    8798:	ebffff2e 	bl	8458 <SPSR_print>
    879c:	ebffff55 	bl	84f8 <amr_print>
    87a0:	e30a0170 	movw	r0, #41328	; 0xa170
    87a4:	e3400000 	movt	r0, #0
    87a8:	eb00032f 	bl	946c <kprintf>
    87ac:	e8bd41f0 	pop	{r4, r5, r6, r7, r8, lr}
    87b0:	ea000181 	b	8dbc <resetTimer>
    87b4:	ebfffe54 	bl	810c <da_report>
    87b8:	eaffffe9 	b	8764 <general_handler+0x2c>

000087bc <reset_handler>:
    87bc:	e1a03001 	mov	r3, r1
    87c0:	e30a1184 	movw	r1, #41348	; 0xa184
    87c4:	e92d4010 	push	{r4, lr}
    87c8:	e3a02000 	mov	r2, #0
    87cc:	e3401000 	movt	r1, #0
    87d0:	ebffffd8 	bl	8738 <general_handler>
    87d4:	e8bd4010 	pop	{r4, lr}
    87d8:	eafffe08 	b	8000 <_start>

000087dc <undefined_instruction_handler>:
    87dc:	e1a03001 	mov	r3, r1
    87e0:	e30a118c 	movw	r1, #41356	; 0xa18c
    87e4:	e92d4010 	push	{r4, lr}
    87e8:	e3a02000 	mov	r2, #0
    87ec:	e3401000 	movt	r1, #0
    87f0:	ebffffd0 	bl	8738 <general_handler>
    87f4:	eafffffe 	b	87f4 <undefined_instruction_handler+0x18>

000087f8 <software_interrupt_handler>:
    87f8:	e1a03001 	mov	r3, r1
    87fc:	e30a11a4 	movw	r1, #41380	; 0xa1a4
    8800:	e92d4010 	push	{r4, lr}
    8804:	e3a02000 	mov	r2, #0
    8808:	e3401000 	movt	r1, #0
    880c:	ebffffc9 	bl	8738 <general_handler>
    8810:	eafffffe 	b	8810 <software_interrupt_handler+0x18>

00008814 <prefetch_abort_handler>:
    8814:	e1a03001 	mov	r3, r1
    8818:	e30a11b8 	movw	r1, #41400	; 0xa1b8
    881c:	e3401000 	movt	r1, #0
    8820:	e3a02000 	mov	r2, #0
    8824:	eaffffc3 	b	8738 <general_handler>

00008828 <data_abort_handler>:
    8828:	e1a03001 	mov	r3, r1
    882c:	e30a11c8 	movw	r1, #41416	; 0xa1c8
    8830:	e92d4010 	push	{r4, lr}
    8834:	e3a02001 	mov	r2, #1
    8838:	e3401000 	movt	r1, #0
    883c:	ebffffbd 	bl	8738 <general_handler>
    8840:	eafffffe 	b	8840 <data_abort_handler+0x18>

00008844 <irq_handler>:
    8844:	e3a02101 	mov	r2, #1073741824	; 0x40000000
    8848:	e92d4010 	push	{r4, lr}
    884c:	e5922034 	ldr	r2, [r2, #52]	; 0x34
    8850:	e3520000 	cmp	r2, #0
    8854:	ba00000e 	blt	8894 <irq_handler+0x50>
    8858:	e30a47d0 	movw	r4, #42960	; 0xa7d0
    885c:	e1a03001 	mov	r3, r1
    8860:	e3404000 	movt	r4, #0
    8864:	e30a11d8 	movw	r1, #41432	; 0xa1d8
    8868:	e3401000 	movt	r1, #0
    886c:	e5942000 	ldr	r2, [r4]
    8870:	e3520000 	cmp	r2, #0
    8874:	e3a02001 	mov	r2, #1
    8878:	0a000003 	beq	888c <irq_handler+0x48>
    887c:	ebffffad 	bl	8738 <general_handler>
    8880:	e3a03000 	mov	r3, #0
    8884:	e5843000 	str	r3, [r4]
    8888:	e8bd8010 	pop	{r4, pc}
    888c:	e8bd4010 	pop	{r4, lr}
    8890:	eaffffa8 	b	8738 <general_handler>
    8894:	e30a01d4 	movw	r0, #41428	; 0xa1d4
    8898:	e3400000 	movt	r0, #0
    889c:	eb0002f2 	bl	946c <kprintf>
    88a0:	e8bd4010 	pop	{r4, lr}
    88a4:	ea000144 	b	8dbc <resetTimer>

000088a8 <fiq_handler>:
    88a8:	e1a03001 	mov	r3, r1
    88ac:	e30a11dc 	movw	r1, #41436	; 0xa1dc
    88b0:	e3401000 	movt	r1, #0
    88b4:	e3a02000 	mov	r2, #0
    88b8:	eaffff9e 	b	8738 <general_handler>
    88bc:	00000000 	andeq	r0, r0, r0

000088c0 <ivt>:
    88c0:	ea000006 	b	88e0 <_reset>
    88c4:	e59ff018 	ldr	pc, [pc, #24]	; 88e4 <_undefined_instruction>
    88c8:	e59ff018 	ldr	pc, [pc, #24]	; 88e8 <_software_interrupt>
    88cc:	e59ff018 	ldr	pc, [pc, #24]	; 88ec <_prefetch_abort>
    88d0:	e59ff018 	ldr	pc, [pc, #24]	; 88f0 <_data_abort>
    88d4:	e59ff018 	ldr	pc, [pc, #24]	; 88f4 <_not_used>
    88d8:	e59ff018 	ldr	pc, [pc, #24]	; 88f8 <_irq>
    88dc:	e59ff018 	ldr	pc, [pc, #24]	; 88fc <_fiq>

000088e0 <_reset>:
    88e0:	00008900 	andeq	r8, r0, r0, lsl #18

000088e4 <_undefined_instruction>:
    88e4:	00008904 	andeq	r8, r0, r4, lsl #18

000088e8 <_software_interrupt>:
    88e8:	00008920 	andeq	r8, r0, r0, lsr #18

000088ec <_prefetch_abort>:
    88ec:	0000893c 	andeq	r8, r0, ip, lsr r9

000088f0 <_data_abort>:
    88f0:	00008958 	andeq	r8, r0, r8, asr r9

000088f4 <_not_used>:
    88f4:	00008974 	andeq	r8, r0, r4, ror r9

000088f8 <_irq>:
    88f8:	00008974 	andeq	r8, r0, r4, ror r9

000088fc <_fiq>:
    88fc:	00008990 	muleq	r0, r0, r9

00008900 <reset>:
    8900:	eaffffad 	b	87bc <reset_handler>

00008904 <undefined_instruction>:
    8904:	e24ee004 	sub	lr, lr, #4
    8908:	e88d5fff 	stm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    890c:	e1a0000d 	mov	r0, sp
    8910:	e1a0100f 	mov	r1, pc
    8914:	ebffffb0 	bl	87dc <undefined_instruction_handler>
    8918:	e89d5fff 	ldm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    891c:	e1b0f00e 	movs	pc, lr

00008920 <software_interrupt>:
    8920:	e24ee004 	sub	lr, lr, #4
    8924:	e88d5fff 	stm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    8928:	e1a0000d 	mov	r0, sp
    892c:	e1a0100f 	mov	r1, pc
    8930:	ebffffb0 	bl	87f8 <software_interrupt_handler>
    8934:	e89d5fff 	ldm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    8938:	e1b0f00e 	movs	pc, lr

0000893c <prefetch_abort>:
    893c:	e24ee004 	sub	lr, lr, #4
    8940:	e88d5fff 	stm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    8944:	e1a0000d 	mov	r0, sp
    8948:	e1a0100f 	mov	r1, pc
    894c:	ebffffb0 	bl	8814 <prefetch_abort_handler>
    8950:	e89d5fff 	ldm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    8954:	e1b0f00e 	movs	pc, lr

00008958 <data_abort>:
    8958:	e24ee008 	sub	lr, lr, #8
    895c:	e88d5fff 	stm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    8960:	e1a0000d 	mov	r0, sp
    8964:	e1a0100f 	mov	r1, pc
    8968:	ebffffae 	bl	8828 <data_abort_handler>
    896c:	e8dd5fff 	ldm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}^
    8970:	e1b0f00e 	movs	pc, lr

00008974 <irq>:
    8974:	e24ee008 	sub	lr, lr, #8
    8978:	e88d5fff 	stm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    897c:	e1a0000d 	mov	r0, sp
    8980:	e1a0100f 	mov	r1, pc
    8984:	ebffffae 	bl	8844 <irq_handler>
    8988:	e89d5fff 	ldm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    898c:	e1b0f00e 	movs	pc, lr

00008990 <fiq>:
    8990:	e24ee008 	sub	lr, lr, #8
    8994:	e88d5fff 	stm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    8998:	e1a0000d 	mov	r0, sp
    899c:	e1a0100f 	mov	r1, pc
    89a0:	ebffffc0 	bl	88a8 <fiq_handler>
    89a4:	e89d5fff 	ldm	sp, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    89a8:	e1b0f00e 	movs	pc, lr

000089ac <_check_return_jump>:
    89ac:	e3a00502 	mov	r0, #8388608	; 0x800000
    89b0:	ea00000c 	b	89e8 <_check_return_jump+0x3c>
    89b4:	e7ffffff 	udf	#65535	; 0xffff
    89b8:	e7ffffff 	udf	#65535	; 0xffff
    89bc:	e7ffffff 	udf	#65535	; 0xffff
    89c0:	e7ffffff 	udf	#65535	; 0xffff
    89c4:	e7ffffff 	udf	#65535	; 0xffff
    89c8:	e7ffffff 	udf	#65535	; 0xffff
    89cc:	ea000005 	b	89e8 <_check_return_jump+0x3c>
    89d0:	e7ffffff 	udf	#65535	; 0xffff
    89d4:	e7ffffff 	udf	#65535	; 0xffff
    89d8:	e7ffffff 	udf	#65535	; 0xffff
    89dc:	e7ffffff 	udf	#65535	; 0xffff
    89e0:	e7ffffff 	udf	#65535	; 0xffff
    89e4:	e7ffffff 	udf	#65535	; 0xffff
    89e8:	e2500001 	subs	r0, r0, #1
    89ec:	1afffff6 	bne	89cc <_check_return_jump+0x20>
    89f0:	012fff1e 	bxeq	lr
    89f4:	e7ffffff 	udf	#65535	; 0xffff
    89f8:	e7ffffff 	udf	#65535	; 0xffff
    89fc:	e7ffffff 	udf	#65535	; 0xffff
    8a00:	e7ffffff 	udf	#65535	; 0xffff
    8a04:	e7ffffff 	udf	#65535	; 0xffff

00008a08 <_check_registers>:
    8a08:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
    8a0c:	e3a00001 	mov	r0, #1
    8a10:	e1a07000 	mov	r7, r0
    8a14:	e1a01008 	mov	r1, r8
    8a18:	e1a02009 	mov	r2, r9
    8a1c:	e1a0300a 	mov	r3, sl
    8a20:	e1a0400b 	mov	r4, fp
    8a24:	e1a0500c 	mov	r5, ip
    8a28:	e1a0600d 	mov	r6, sp
    8a2c:	e1a0e00d 	mov	lr, sp
    8a30:	e2800f71 	add	r0, r0, #452	; 0x1c4
    8a34:	e2811f71 	add	r1, r1, #452	; 0x1c4
    8a38:	e2822f71 	add	r2, r2, #452	; 0x1c4
    8a3c:	e2833f71 	add	r3, r3, #452	; 0x1c4
    8a40:	e2844f71 	add	r4, r4, #452	; 0x1c4
    8a44:	e2855f71 	add	r5, r5, #452	; 0x1c4
    8a48:	e2866f71 	add	r6, r6, #452	; 0x1c4
    8a4c:	e1500007 	cmp	r0, r7
    8a50:	07ffffff 			; <UNDEFINED> instruction: 0x07ffffff
    8a54:	e1510008 	cmp	r1, r8
    8a58:	07ffffff 			; <UNDEFINED> instruction: 0x07ffffff
    8a5c:	e1520009 	cmp	r2, r9
    8a60:	07ffffff 			; <UNDEFINED> instruction: 0x07ffffff
    8a64:	e153000a 	cmp	r3, sl
    8a68:	07ffffff 			; <UNDEFINED> instruction: 0x07ffffff
    8a6c:	e154000b 	cmp	r4, fp
    8a70:	07ffffff 			; <UNDEFINED> instruction: 0x07ffffff
    8a74:	e155000c 	cmp	r5, ip
    8a78:	07ffffff 			; <UNDEFINED> instruction: 0x07ffffff
    8a7c:	e156000e 	cmp	r6, lr
    8a80:	07ffffff 			; <UNDEFINED> instruction: 0x07ffffff
    8a84:	e156000d 	cmp	r6, sp
    8a88:	07ffffff 			; <UNDEFINED> instruction: 0x07ffffff
    8a8c:	e2877f71 	add	r7, r7, #452	; 0x1c4
    8a90:	e2888f71 	add	r8, r8, #452	; 0x1c4
    8a94:	e2899f71 	add	r9, r9, #452	; 0x1c4
    8a98:	e28aaf71 	add	sl, sl, #452	; 0x1c4
    8a9c:	e28bbf71 	add	fp, fp, #452	; 0x1c4
    8aa0:	e28ccf71 	add	ip, ip, #452	; 0x1c4
    8aa4:	e28ddf71 	add	sp, sp, #452	; 0x1c4
    8aa8:	e28eef71 	add	lr, lr, #452	; 0x1c4
    8aac:	e1500007 	cmp	r0, r7
    8ab0:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8ab4:	e1510008 	cmp	r1, r8
    8ab8:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8abc:	e1520009 	cmp	r2, r9
    8ac0:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8ac4:	e153000a 	cmp	r3, sl
    8ac8:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8acc:	e154000b 	cmp	r4, fp
    8ad0:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8ad4:	e155000c 	cmp	r5, ip
    8ad8:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8adc:	e156000e 	cmp	r6, lr
    8ae0:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8ae4:	e156000d 	cmp	r6, sp
    8ae8:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8aec:	e3700010 	cmn	r0, #16
    8af0:	9affffce 	bls	8a30 <_check_registers+0x28>
    8af4:	e28dd010 	add	sp, sp, #16
    8af8:	e8bd4ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
    8afc:	e12fff1e 	bx	lr

00008b00 <_check_cpsr>:
    8b00:	e52d4004 	push	{r4}		; (str r4, [sp, #-4]!)
    8b04:	e3a00000 	mov	r0, #0
    8b08:	e10f4000 	mrs	r4, CPSR
    8b0c:	e1a03004 	mov	r3, r4
    8b10:	e383301f 	orr	r3, r3, #31
    8b14:	e129f003 	msr	CPSR_fc, r3
    8b18:	e1a01003 	mov	r1, r3
    8b1c:	e2833201 	add	r3, r3, #268435456	; 0x10000000
    8b20:	e2800001 	add	r0, r0, #1
    8b24:	e10f2000 	mrs	r2, CPSR
    8b28:	e1520001 	cmp	r2, r1
    8b2c:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8b30:	e2102010 	ands	r2, r0, #16
    8b34:	02233080 	eoreq	r3, r3, #128	; 0x80
    8b38:	e2102020 	ands	r2, r0, #32
    8b3c:	02233040 	eoreq	r3, r3, #64	; 0x40
    8b40:	e2102040 	ands	r2, r0, #64	; 0x40
    8b44:	02233008 	eoreq	r3, r3, #8
    8b48:	e3500401 	cmp	r0, #16777216	; 0x1000000
    8b4c:	1afffff0 	bne	8b14 <_check_cpsr+0x14>
    8b50:	e129f004 	msr	CPSR_fc, r4
    8b54:	e49d4004 	pop	{r4}		; (ldr r4, [sp], #4)
    8b58:	e12fff1e 	bx	lr

00008b5c <_check_spsr>:
    8b5c:	e52d4004 	push	{r4}		; (str r4, [sp, #-4]!)
    8b60:	e3a00000 	mov	r0, #0
    8b64:	e14f4000 	mrs	r4, SPSR
    8b68:	e1a03004 	mov	r3, r4
    8b6c:	e383301f 	orr	r3, r3, #31
    8b70:	e169f003 	msr	SPSR_fc, r3
    8b74:	e1a01003 	mov	r1, r3
    8b78:	e2833201 	add	r3, r3, #268435456	; 0x10000000
    8b7c:	e2800001 	add	r0, r0, #1
    8b80:	e14f2000 	mrs	r2, SPSR
    8b84:	e1520001 	cmp	r2, r1
    8b88:	17ffffff 			; <UNDEFINED> instruction: 0x17ffffff
    8b8c:	e2102010 	ands	r2, r0, #16
    8b90:	02233080 	eoreq	r3, r3, #128	; 0x80
    8b94:	e2102020 	ands	r2, r0, #32
    8b98:	02233040 	eoreq	r3, r3, #64	; 0x40
    8b9c:	e2102040 	ands	r2, r0, #64	; 0x40
    8ba0:	02233008 	eoreq	r3, r3, #8
    8ba4:	e3500401 	cmp	r0, #16777216	; 0x1000000
    8ba8:	1afffff0 	bne	8b70 <_check_spsr+0x14>
    8bac:	e169f004 	msr	SPSR_fc, r4
    8bb0:	e49d4004 	pop	{r4}		; (ldr r4, [sp], #4)
    8bb4:	e12fff1e 	bx	lr

00008bb8 <enable_uart_IRQ>:
    8bb8:	e3a02a01 	mov	r2, #4096	; 0x1000
    8bbc:	e3432f20 	movt	r2, #16160	; 0x3f20
    8bc0:	e5923018 	ldr	r3, [r2, #24]
    8bc4:	e3130008 	tst	r3, #8
    8bc8:	1afffffc 	bne	8bc0 <enable_uart_IRQ+0x8>
    8bcc:	e3a03cb2 	mov	r3, #45568	; 0xb200
    8bd0:	e3433f00 	movt	r3, #16128	; 0x3f00
    8bd4:	e5931014 	ldr	r1, [r3, #20]
    8bd8:	e3811402 	orr	r1, r1, #33554432	; 0x2000000
    8bdc:	e5831014 	str	r1, [r3, #20]
    8be0:	e5923038 	ldr	r3, [r2, #56]	; 0x38
    8be4:	e3833010 	orr	r3, r3, #16
    8be8:	e5823038 	str	r3, [r2, #56]	; 0x38
    8bec:	e12fff1e 	bx	lr

00008bf0 <cause_FIQ>:
    8bf0:	f10c0080 	cpsid	i
    8bf4:	f1080040 	cpsie	f
    8bf8:	e3a03cb2 	mov	r3, #45568	; 0xb200
    8bfc:	e3a02a01 	mov	r2, #4096	; 0x1000
    8c00:	e3433f00 	movt	r3, #16128	; 0x3f00
    8c04:	e3432f20 	movt	r2, #16160	; 0x3f20
    8c08:	e593100c 	ldr	r1, [r3, #12]
    8c0c:	e3811080 	orr	r1, r1, #128	; 0x80
    8c10:	e583100c 	str	r1, [r3, #12]
    8c14:	e5923018 	ldr	r3, [r2, #24]
    8c18:	e3130008 	tst	r3, #8
    8c1c:	1afffffc 	bne	8c14 <cause_FIQ+0x24>
    8c20:	e5923038 	ldr	r3, [r2, #56]	; 0x38
    8c24:	e3833010 	orr	r3, r3, #16
    8c28:	e5823038 	str	r3, [r2, #56]	; 0x38
    8c2c:	e12fff1e 	bx	lr

00008c30 <activate_interactive>:
    8c30:	e30a37e0 	movw	r3, #42976	; 0xa7e0
    8c34:	e3a02001 	mov	r2, #1
    8c38:	e3403000 	movt	r3, #0
    8c3c:	e5832000 	str	r2, [r3]
    8c40:	e12fff1e 	bx	lr

00008c44 <lazyOutput>:
    8c44:	e92d4070 	push	{r4, r5, r6, lr}
    8c48:	e1a06000 	mov	r6, r0
    8c4c:	e3a05032 	mov	r5, #50	; 0x32
    8c50:	e30e4a5f 	movw	r4, #59999	; 0xea5f
    8c54:	eb0000c3 	bl	8f68 <yellow_on>
    8c58:	e2544001 	subs	r4, r4, #1
    8c5c:	1afffffc 	bne	8c54 <lazyOutput+0x10>
    8c60:	e1a00006 	mov	r0, r6
    8c64:	eb0000c6 	bl	8f84 <sendChar>
    8c68:	e2555001 	subs	r5, r5, #1
    8c6c:	1afffff7 	bne	8c50 <lazyOutput+0xc>
    8c70:	e8bd8070 	pop	{r4, r5, r6, pc}

00008c74 <call_routine>:
    8c74:	e2403061 	sub	r3, r0, #97	; 0x61
    8c78:	e3530014 	cmp	r3, #20
    8c7c:	979ff103 	ldrls	pc, [pc, r3, lsl #2]
    8c80:	ea000035 	b	8d5c <call_routine+0xe8>
    8c84:	00008ce0 	andeq	r8, r0, r0, ror #25
    8c88:	00008d5c 	andeq	r8, r0, ip, asr sp
    8c8c:	00008ce4 	andeq	r8, r0, r4, ror #25
    8c90:	00008ce8 	andeq	r8, r0, r8, ror #25
    8c94:	00008cf0 	strdeq	r8, [r0], -r0
    8c98:	00008d14 	andeq	r8, r0, r4, lsl sp
    8c9c:	00008d5c 	andeq	r8, r0, ip, asr sp
    8ca0:	00008d5c 	andeq	r8, r0, ip, asr sp
    8ca4:	00008d5c 	andeq	r8, r0, ip, asr sp
    8ca8:	00008d5c 	andeq	r8, r0, ip, asr sp
    8cac:	00008d5c 	andeq	r8, r0, ip, asr sp
    8cb0:	00008d5c 	andeq	r8, r0, ip, asr sp
    8cb4:	00008d5c 	andeq	r8, r0, ip, asr sp
    8cb8:	00008d5c 	andeq	r8, r0, ip, asr sp
    8cbc:	00008d5c 	andeq	r8, r0, ip, asr sp
    8cc0:	00008d5c 	andeq	r8, r0, ip, asr sp
    8cc4:	00008d5c 	andeq	r8, r0, ip, asr sp
    8cc8:	00008d5c 	andeq	r8, r0, ip, asr sp
    8ccc:	00008d54 	andeq	r8, r0, r4, asr sp
    8cd0:	00008d5c 	andeq	r8, r0, ip, asr sp
    8cd4:	00008cd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    8cd8:	e7f000f0 	udf	#0
    8cdc:	e12fff1e 	bx	lr
    8ce0:	ea000078 	b	8ec8 <cause_data_abort>
    8ce4:	ea000049 	b	8e10 <register_checker>
    8ce8:	e3a00001 	mov	r0, #1
    8cec:	eafffcfa 	b	80dc <set_IRQ_DEBUG>
    8cf0:	e30a0210 	movw	r0, #41488	; 0xa210
    8cf4:	e92d4010 	push	{r4, lr}
    8cf8:	e3400000 	movt	r0, #0
    8cfc:	eb0001da 	bl	946c <kprintf>
    8d00:	e30a37e0 	movw	r3, #42976	; 0xa7e0
    8d04:	e3a02001 	mov	r2, #1
    8d08:	e3403000 	movt	r3, #0
    8d0c:	e5832000 	str	r2, [r3]
    8d10:	e8bd8010 	pop	{r4, pc}
    8d14:	f10c0080 	cpsid	i
    8d18:	f1080040 	cpsie	f
    8d1c:	e3a03cb2 	mov	r3, #45568	; 0xb200
    8d20:	e3a02a01 	mov	r2, #4096	; 0x1000
    8d24:	e3433f00 	movt	r3, #16128	; 0x3f00
    8d28:	e3432f20 	movt	r2, #16160	; 0x3f20
    8d2c:	e593100c 	ldr	r1, [r3, #12]
    8d30:	e3811080 	orr	r1, r1, #128	; 0x80
    8d34:	e583100c 	str	r1, [r3, #12]
    8d38:	e5923018 	ldr	r3, [r2, #24]
    8d3c:	e3130008 	tst	r3, #8
    8d40:	1afffffc 	bne	8d38 <call_routine+0xc4>
    8d44:	e5923038 	ldr	r3, [r2, #56]	; 0x38
    8d48:	e3833010 	orr	r3, r3, #16
    8d4c:	e5823038 	str	r3, [r2, #56]	; 0x38
    8d50:	e12fff1e 	bx	lr
    8d54:	ef000000 	svc	0x00000000
    8d58:	e12fff1e 	bx	lr
    8d5c:	e30a37e0 	movw	r3, #42976	; 0xa7e0
    8d60:	e3403000 	movt	r3, #0
    8d64:	e5933000 	ldr	r3, [r3]
    8d68:	e3530000 	cmp	r3, #0
    8d6c:	0a000000 	beq	8d74 <call_routine+0x100>
    8d70:	eaffffb3 	b	8c44 <lazyOutput>
    8d74:	ea000082 	b	8f84 <sendChar>

00008d78 <timer_en_irq>:
    8d78:	e3a03101 	mov	r3, #1073741824	; 0x40000000
    8d7c:	e5932034 	ldr	r2, [r3, #52]	; 0x34
    8d80:	e3822202 	orr	r2, r2, #536870912	; 0x20000000
    8d84:	e5832034 	str	r2, [r3, #52]	; 0x34
    8d88:	e5932034 	ldr	r2, [r3, #52]	; 0x34
    8d8c:	e3822201 	orr	r2, r2, #268435456	; 0x10000000
    8d90:	e5832034 	str	r2, [r3, #52]	; 0x34
    8d94:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    8d98:	e3c22007 	bic	r2, r2, #7
    8d9c:	e5832024 	str	r2, [r3, #36]	; 0x24
    8da0:	e12fff1e 	bx	lr

00008da4 <setTime>:
    8da4:	e3c0020f 	bic	r0, r0, #-268435456	; 0xf0000000
    8da8:	e3a03101 	mov	r3, #1073741824	; 0x40000000
    8dac:	e5932034 	ldr	r2, [r3, #52]	; 0x34
    8db0:	e1800002 	orr	r0, r0, r2
    8db4:	e5830034 	str	r0, [r3, #52]	; 0x34
    8db8:	e12fff1e 	bx	lr

00008dbc <resetTimer>:
    8dbc:	e3a02101 	mov	r2, #1073741824	; 0x40000000
    8dc0:	e5923038 	ldr	r3, [r2, #56]	; 0x38
    8dc4:	e3833102 	orr	r3, r3, #-2147483648	; 0x80000000
    8dc8:	e5823038 	str	r3, [r2, #56]	; 0x38
    8dcc:	e12fff1e 	bx	lr

00008dd0 <start_timer_interrupt>:
    8dd0:	f1080080 	cpsie	i
    8dd4:	e3c0020f 	bic	r0, r0, #-268435456	; 0xf0000000
    8dd8:	e3a03101 	mov	r3, #1073741824	; 0x40000000
    8ddc:	e5932034 	ldr	r2, [r3, #52]	; 0x34
    8de0:	e1800002 	orr	r0, r0, r2
    8de4:	e5830034 	str	r0, [r3, #52]	; 0x34
    8de8:	e5932034 	ldr	r2, [r3, #52]	; 0x34
    8dec:	e3822202 	orr	r2, r2, #536870912	; 0x20000000
    8df0:	e5832034 	str	r2, [r3, #52]	; 0x34
    8df4:	e5932034 	ldr	r2, [r3, #52]	; 0x34
    8df8:	e3822201 	orr	r2, r2, #268435456	; 0x10000000
    8dfc:	e5832034 	str	r2, [r3, #52]	; 0x34
    8e00:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    8e04:	e3c22007 	bic	r2, r2, #7
    8e08:	e5832024 	str	r2, [r3, #36]	; 0x24
    8e0c:	e12fff1e 	bx	lr

00008e10 <register_checker>:
    8e10:	e30a0238 	movw	r0, #41528	; 0xa238
    8e14:	e92d4010 	push	{r4, lr}
    8e18:	e10f4000 	mrs	r4, CPSR
    8e1c:	e3400000 	movt	r0, #0
    8e20:	e204401f 	and	r4, r4, #31
    8e24:	eb000190 	bl	946c <kprintf>
    8e28:	e3540012 	cmp	r4, #18
    8e2c:	0a000021 	beq	8eb8 <register_checker+0xa8>
    8e30:	e30a0548 	movw	r0, #42312	; 0xa548
    8e34:	e3400000 	movt	r0, #0
    8e38:	eb00018b 	bl	946c <kprintf>
    8e3c:	ebfffeda 	bl	89ac <_check_return_jump>
    8e40:	e30a0580 	movw	r0, #42368	; 0xa580
    8e44:	e3400000 	movt	r0, #0
    8e48:	eb000187 	bl	946c <kprintf>
    8e4c:	ebfffeed 	bl	8a08 <_check_registers>
    8e50:	e3540010 	cmp	r4, #16
    8e54:	0a00000d 	beq	8e90 <register_checker+0x80>
    8e58:	e30a0658 	movw	r0, #42584	; 0xa658
    8e5c:	e3400000 	movt	r0, #0
    8e60:	eb000181 	bl	946c <kprintf>
    8e64:	ebffff25 	bl	8b00 <_check_cpsr>
    8e68:	e354001f 	cmp	r4, #31
    8e6c:	0a00000a 	beq	8e9c <register_checker+0x8c>
    8e70:	e30a0730 	movw	r0, #42800	; 0xa730
    8e74:	e3400000 	movt	r0, #0
    8e78:	eb00017b 	bl	946c <kprintf>
    8e7c:	ebffff36 	bl	8b5c <_check_spsr>
    8e80:	e30a0760 	movw	r0, #42848	; 0xa760
    8e84:	e3400000 	movt	r0, #0
    8e88:	e8bd4010 	pop	{r4, lr}
    8e8c:	ea000176 	b	946c <kprintf>
    8e90:	e30a05bc 	movw	r0, #42428	; 0xa5bc
    8e94:	e3400000 	movt	r0, #0
    8e98:	eb000173 	bl	946c <kprintf>
    8e9c:	e30a0688 	movw	r0, #42632	; 0xa688
    8ea0:	e3400000 	movt	r0, #0
    8ea4:	eb000170 	bl	946c <kprintf>
    8ea8:	e30a0760 	movw	r0, #42848	; 0xa760
    8eac:	e3400000 	movt	r0, #0
    8eb0:	e8bd4010 	pop	{r4, lr}
    8eb4:	ea00016c 	b	946c <kprintf>
    8eb8:	e30a04ac 	movw	r0, #42156	; 0xa4ac
    8ebc:	e3400000 	movt	r0, #0
    8ec0:	e8bd4010 	pop	{r4, lr}
    8ec4:	ea000168 	b	946c <kprintf>

00008ec8 <cause_data_abort>:
    8ec8:	ee111f10 	mrc	15, 0, r1, cr1, cr0, {0}
    8ecc:	e3811002 	orr	r1, r1, #2
    8ed0:	ee011f10 	mcr	15, 0, r1, cr1, cr0, {0}
    8ed4:	e3a01001 	mov	r1, #1
    8ed8:	e5911000 	ldr	r1, [r1]
    8edc:	e1a0f00e 	mov	pc, lr

00008ee0 <get_lr_usr>:
    8ee0:	e1060200 	mrs	r0, LR_usr
    8ee4:	e1a0f00e 	mov	pc, lr

00008ee8 <get_lr_svc>:
    8ee8:	e1020300 	mrs	r0, LR_svc
    8eec:	e1a0f00e 	mov	pc, lr

00008ef0 <get_lr_abt>:
    8ef0:	e1040300 	mrs	r0, LR_abt
    8ef4:	e1a0f00e 	mov	pc, lr

00008ef8 <get_lr_fiq>:
    8ef8:	e10e0200 	mrs	r0, LR_fiq
    8efc:	e1a0f00e 	mov	pc, lr

00008f00 <get_lr_irq>:
    8f00:	e1000300 	mrs	r0, LR_irq
    8f04:	e1a0f00e 	mov	pc, lr

00008f08 <get_lr_und>:
    8f08:	e1060300 	mrs	r0, LR_und
    8f0c:	e1a0f00e 	mov	pc, lr

00008f10 <get_sp_usr>:
    8f10:	e1050200 	mrs	r0, SP_usr
    8f14:	e1a0f00e 	mov	pc, lr

00008f18 <get_sp_svc>:
    8f18:	e1030300 	mrs	r0, SP_svc
    8f1c:	e1a0f00e 	mov	pc, lr

00008f20 <get_sp_abt>:
    8f20:	e1050300 	mrs	r0, SP_abt
    8f24:	e1a0f00e 	mov	pc, lr

00008f28 <get_sp_fiq>:
    8f28:	e10d0200 	mrs	r0, SP_fiq
    8f2c:	e1a0f00e 	mov	pc, lr

00008f30 <get_sp_irq>:
    8f30:	e1010300 	mrs	r0, SP_irq
    8f34:	e1a0f00e 	mov	pc, lr

00008f38 <get_sp_und>:
    8f38:	e1070300 	mrs	r0, SP_und
    8f3c:	e1a0f00e 	mov	pc, lr

00008f40 <get_spsr_svc>:
    8f40:	e1420300 	mrs	r0, SPSR_svc
    8f44:	e1a0f00e 	mov	pc, lr

00008f48 <get_spsr_abt>:
    8f48:	e1440300 	mrs	r0, SPSR_abt
    8f4c:	e1a0f00e 	mov	pc, lr

00008f50 <get_spsr_fiq>:
    8f50:	e14e0200 	mrs	r0, SPSR_fiq
    8f54:	e1a0f00e 	mov	pc, lr

00008f58 <get_spsr_irq>:
    8f58:	e1400300 	mrs	r0, SPSR_irq
    8f5c:	e1a0f00e 	mov	pc, lr

00008f60 <get_spsr_und>:
    8f60:	e1460300 	mrs	r0, SPSR_und
    8f64:	e1a0f00e 	mov	pc, lr

00008f68 <yellow_on>:
    8f68:	e3a03000 	mov	r3, #0
    8f6c:	e3a01602 	mov	r1, #2097152	; 0x200000
    8f70:	e3433f20 	movt	r3, #16160	; 0x3f20
    8f74:	e3a02080 	mov	r2, #128	; 0x80
    8f78:	e5831000 	str	r1, [r3]
    8f7c:	e583201c 	str	r2, [r3, #28]
    8f80:	e12fff1e 	bx	lr

00008f84 <sendChar>:
    8f84:	e3a02a01 	mov	r2, #4096	; 0x1000
    8f88:	e3432f20 	movt	r2, #16160	; 0x3f20
    8f8c:	e5923018 	ldr	r3, [r2, #24]
    8f90:	e3130020 	tst	r3, #32
    8f94:	1afffffc 	bne	8f8c <sendChar+0x8>
    8f98:	e5820000 	str	r0, [r2]
    8f9c:	e12fff1e 	bx	lr

00008fa0 <recvChar>:
    8fa0:	e3a02a01 	mov	r2, #4096	; 0x1000
    8fa4:	e3432f20 	movt	r2, #16160	; 0x3f20
    8fa8:	e5923018 	ldr	r3, [r2, #24]
    8fac:	e3130010 	tst	r3, #16
    8fb0:	1afffffc 	bne	8fa8 <recvChar+0x8>
    8fb4:	e5920000 	ldr	r0, [r2]
    8fb8:	e6ef0070 	uxtb	r0, r0
    8fbc:	e12fff1e 	bx	lr

00008fc0 <strcpy.part.0>:
    8fc0:	e5d13000 	ldrb	r3, [r1]
    8fc4:	e1a02000 	mov	r2, r0
    8fc8:	e3530000 	cmp	r3, #0
    8fcc:	0a000003 	beq	8fe0 <strcpy.part.0+0x20>
    8fd0:	e4c23001 	strb	r3, [r2], #1
    8fd4:	e5f13001 	ldrb	r3, [r1, #1]!
    8fd8:	e3530000 	cmp	r3, #0
    8fdc:	1afffffb 	bne	8fd0 <strcpy.part.0+0x10>
    8fe0:	e3a03000 	mov	r3, #0
    8fe4:	e5c23000 	strb	r3, [r2]
    8fe8:	e12fff1e 	bx	lr

00008fec <kmemset>:
    8fec:	e3510000 	cmp	r1, #0
    8ff0:	d12fff1e 	bxle	lr
    8ff4:	e2400001 	sub	r0, r0, #1
    8ff8:	e3a03000 	mov	r3, #0
    8ffc:	e0801001 	add	r1, r0, r1
    9000:	e5e03001 	strb	r3, [r0, #1]!
    9004:	e1500001 	cmp	r0, r1
    9008:	1afffffc 	bne	9000 <kmemset+0x14>
    900c:	e12fff1e 	bx	lr

00009010 <kstrlen>:
    9010:	e5d03000 	ldrb	r3, [r0]
    9014:	e3530000 	cmp	r3, #0
    9018:	0a000005 	beq	9034 <kstrlen+0x24>
    901c:	e1a03000 	mov	r3, r0
    9020:	e5f32001 	ldrb	r2, [r3, #1]!
    9024:	e3520000 	cmp	r2, #0
    9028:	1afffffc 	bne	9020 <kstrlen+0x10>
    902c:	e0430000 	sub	r0, r3, r0
    9030:	e12fff1e 	bx	lr
    9034:	e1a00003 	mov	r0, r3
    9038:	e12fff1e 	bx	lr

0000903c <strcpy>:
    903c:	e3700001 	cmn	r0, #1
    9040:	012fff1e 	bxeq	lr
    9044:	eaffffdd 	b	8fc0 <strcpy.part.0>

00009048 <decToHexStr>:
    9048:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
    904c:	e24ddf85 	sub	sp, sp, #532	; 0x214
    9050:	e28dc010 	add	ip, sp, #16
    9054:	e1a0e001 	mov	lr, r1
    9058:	e28d1f83 	add	r1, sp, #524	; 0x20c
    905c:	e1a05002 	mov	r5, r2
    9060:	e1a04000 	mov	r4, r0
    9064:	e24c3001 	sub	r3, ip, #1
    9068:	e2811003 	add	r1, r1, #3
    906c:	e3a02000 	mov	r2, #0
    9070:	e5e32001 	strb	r2, [r3, #1]!
    9074:	e1530001 	cmp	r3, r1
    9078:	1afffffc 	bne	9070 <decToHexStr+0x28>
    907c:	e28e2f7f 	add	r2, lr, #508	; 0x1fc
    9080:	e24e3001 	sub	r3, lr, #1
    9084:	e2822003 	add	r2, r2, #3
    9088:	e3a01000 	mov	r1, #0
    908c:	e5e31001 	strb	r1, [r3, #1]!
    9090:	e1530002 	cmp	r3, r2
    9094:	1afffffc 	bne	908c <decToHexStr+0x44>
    9098:	e3093bbc 	movw	r3, #39868	; 0x9bbc
    909c:	e1a0600d 	mov	r6, sp
    90a0:	e3403000 	movt	r3, #0
    90a4:	e3540000 	cmp	r4, #0
    90a8:	e893000f 	ldm	r3, {r0, r1, r2, r3}
    90ac:	e886000f 	stm	r6, {r0, r1, r2, r3}
    90b0:	0a000037 	beq	9194 <decToHexStr+0x14c>
    90b4:	e1a0200c 	mov	r2, ip
    90b8:	e3a00000 	mov	r0, #0
    90bc:	ea000000 	b	90c4 <decToHexStr+0x7c>
    90c0:	e1a00001 	mov	r0, r1
    90c4:	e204300f 	and	r3, r4, #15
    90c8:	e28d6e21 	add	r6, sp, #528	; 0x210
    90cc:	e0863003 	add	r3, r6, r3
    90d0:	e2801001 	add	r1, r0, #1
    90d4:	e1b04224 	lsrs	r4, r4, #4
    90d8:	e5533210 	ldrb	r3, [r3, #-528]	; 0xfffffdf0
    90dc:	e4c23001 	strb	r3, [r2], #1
    90e0:	1afffff6 	bne	90c0 <decToHexStr+0x78>
    90e4:	e5dd7010 	ldrb	r7, [sp, #16]
    90e8:	e3550000 	cmp	r5, #0
    90ec:	e30a67e4 	movw	r6, #42980	; 0xa7e4
    90f0:	13a03030 	movne	r3, #48	; 0x30
    90f4:	e3406000 	movt	r6, #0
    90f8:	13a05002 	movne	r5, #2
    90fc:	15ce3000 	strbne	r3, [lr]
    9100:	e2454001 	sub	r4, r5, #1
    9104:	e08e4004 	add	r4, lr, r4
    9108:	13a03078 	movne	r3, #120	; 0x78
    910c:	15ce3001 	strbne	r3, [lr, #1]
    9110:	e26e8001 	rsb	r8, lr, #1
    9114:	e5961000 	ldr	r1, [r6]
    9118:	e3a09030 	mov	r9, #48	; 0x30
    911c:	e0885004 	add	r5, r8, r4
    9120:	e3570000 	cmp	r7, #0
    9124:	0a000005 	beq	9140 <decToHexStr+0xf8>
    9128:	e1a0300c 	mov	r3, ip
    912c:	e5f32001 	ldrb	r2, [r3, #1]!
    9130:	e3520000 	cmp	r2, #0
    9134:	1afffffc 	bne	912c <decToHexStr+0xe4>
    9138:	e043300c 	sub	r3, r3, ip
    913c:	e0411003 	sub	r1, r1, r3
    9140:	e3510000 	cmp	r1, #0
    9144:	da000004 	ble	915c <decToHexStr+0x114>
    9148:	e5e49001 	strb	r9, [r4, #1]!
    914c:	e5961000 	ldr	r1, [r6]
    9150:	e2411001 	sub	r1, r1, #1
    9154:	e5861000 	str	r1, [r6]
    9158:	eaffffef 	b	911c <decToHexStr+0xd4>
    915c:	e3700001 	cmn	r0, #1
    9160:	12803001 	addne	r3, r0, #1
    9164:	12455001 	subne	r5, r5, #1
    9168:	108c3003 	addne	r3, ip, r3
    916c:	108ee005 	addne	lr, lr, r5
    9170:	0a000003 	beq	9184 <decToHexStr+0x13c>
    9174:	e5732001 	ldrb	r2, [r3, #-1]!
    9178:	e153000c 	cmp	r3, ip
    917c:	e5ee2001 	strb	r2, [lr, #1]!
    9180:	1afffffb 	bne	9174 <decToHexStr+0x12c>
    9184:	e3a03000 	mov	r3, #0
    9188:	e5863000 	str	r3, [r6]
    918c:	e28ddf85 	add	sp, sp, #532	; 0x214
    9190:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}
    9194:	e3e00000 	mvn	r0, #0
    9198:	eaffffd1 	b	90e4 <decToHexStr+0x9c>

0000919c <intToStr>:
    919c:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
    91a0:	e24ddf85 	sub	sp, sp, #532	; 0x214
    91a4:	e28dc010 	add	ip, sp, #16
    91a8:	e1a0e001 	mov	lr, r1
    91ac:	e28d1f83 	add	r1, sp, #524	; 0x20c
    91b0:	e1a05000 	mov	r5, r0
    91b4:	e24c3001 	sub	r3, ip, #1
    91b8:	e2811003 	add	r1, r1, #3
    91bc:	e3a02000 	mov	r2, #0
    91c0:	e5e32001 	strb	r2, [r3, #1]!
    91c4:	e1530001 	cmp	r3, r1
    91c8:	1afffffc 	bne	91c0 <intToStr+0x24>
    91cc:	e28e2f7f 	add	r2, lr, #508	; 0x1fc
    91d0:	e24e3001 	sub	r3, lr, #1
    91d4:	e2822003 	add	r2, r2, #3
    91d8:	e3a01000 	mov	r1, #0
    91dc:	e5e31001 	strb	r1, [r3, #1]!
    91e0:	e1530002 	cmp	r3, r2
    91e4:	1afffffc 	bne	91dc <intToStr+0x40>
    91e8:	e59f2110 	ldr	r2, [pc, #272]	; 9300 <intToStr+0x164>
    91ec:	e28d3004 	add	r3, sp, #4
    91f0:	e3550000 	cmp	r5, #0
    91f4:	e8920007 	ldm	r2, {r0, r1, r2}
    91f8:	e8a30003 	stmia	r3!, {r0, r1}
    91fc:	e1c320b0 	strh	r2, [r3]
    9200:	ba000036 	blt	92e0 <intToStr+0x144>
    9204:	13a04000 	movne	r4, #0
    9208:	0a000039 	beq	92f4 <intToStr+0x158>
    920c:	e30c7ccd 	movw	r7, #52429	; 0xcccd
    9210:	e1a0100c 	mov	r1, ip
    9214:	e34c7ccc 	movt	r7, #52428	; 0xcccc
    9218:	e3a00000 	mov	r0, #0
    921c:	e3a0800a 	mov	r8, #10
    9220:	ea000000 	b	9228 <intToStr+0x8c>
    9224:	e1a00006 	mov	r0, r6
    9228:	e0832597 	umull	r2, r3, r7, r5
    922c:	e2806001 	add	r6, r0, #1
    9230:	e1a031a3 	lsr	r3, r3, #3
    9234:	e0625398 	mls	r2, r8, r3, r5
    9238:	e28d5e21 	add	r5, sp, #528	; 0x210
    923c:	e0852002 	add	r2, r5, r2
    9240:	e2535000 	subs	r5, r3, #0
    9244:	e552320c 	ldrb	r3, [r2, #-524]	; 0xfffffdf4
    9248:	e4c13001 	strb	r3, [r1], #1
    924c:	1afffff4 	bne	9224 <intToStr+0x88>
    9250:	e5dd7010 	ldrb	r7, [sp, #16]
    9254:	e30a57e4 	movw	r5, #42980	; 0xa7e4
    9258:	e3405000 	movt	r5, #0
    925c:	e2444001 	sub	r4, r4, #1
    9260:	e08e4004 	add	r4, lr, r4
    9264:	e26e8001 	rsb	r8, lr, #1
    9268:	e5951000 	ldr	r1, [r5]
    926c:	e3a09030 	mov	r9, #48	; 0x30
    9270:	e0886004 	add	r6, r8, r4
    9274:	e3570000 	cmp	r7, #0
    9278:	0a000005 	beq	9294 <intToStr+0xf8>
    927c:	e1a0300c 	mov	r3, ip
    9280:	e5f32001 	ldrb	r2, [r3, #1]!
    9284:	e3520000 	cmp	r2, #0
    9288:	1afffffc 	bne	9280 <intToStr+0xe4>
    928c:	e043300c 	sub	r3, r3, ip
    9290:	e0411003 	sub	r1, r1, r3
    9294:	e3510000 	cmp	r1, #0
    9298:	da000004 	ble	92b0 <intToStr+0x114>
    929c:	e5e49001 	strb	r9, [r4, #1]!
    92a0:	e5951000 	ldr	r1, [r5]
    92a4:	e2411001 	sub	r1, r1, #1
    92a8:	e5851000 	str	r1, [r5]
    92ac:	eaffffef 	b	9270 <intToStr+0xd4>
    92b0:	e3700001 	cmn	r0, #1
    92b4:	0a000007 	beq	92d8 <intToStr+0x13c>
    92b8:	e2803001 	add	r3, r0, #1
    92bc:	e2466001 	sub	r6, r6, #1
    92c0:	e08c3003 	add	r3, ip, r3
    92c4:	e08ee006 	add	lr, lr, r6
    92c8:	e5732001 	ldrb	r2, [r3, #-1]!
    92cc:	e153000c 	cmp	r3, ip
    92d0:	e5ee2001 	strb	r2, [lr, #1]!
    92d4:	1afffffb 	bne	92c8 <intToStr+0x12c>
    92d8:	e28ddf85 	add	sp, sp, #532	; 0x214
    92dc:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}
    92e0:	e2655000 	rsb	r5, r5, #0
    92e4:	e3a0302d 	mov	r3, #45	; 0x2d
    92e8:	e5ce3000 	strb	r3, [lr]
    92ec:	e3a04001 	mov	r4, #1
    92f0:	eaffffc5 	b	920c <intToStr+0x70>
    92f4:	e1a04005 	mov	r4, r5
    92f8:	e3e00000 	mvn	r0, #0
    92fc:	eaffffd3 	b	9250 <intToStr+0xb4>
    9300:	00009bd0 	ldrdeq	r9, [r0], -r0

00009304 <unintToStr>:
    9304:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
    9308:	e24ddf81 	sub	sp, sp, #516	; 0x204
    930c:	e1a0400d 	mov	r4, sp
    9310:	e28dcf7f 	add	ip, sp, #508	; 0x1fc
    9314:	e2443001 	sub	r3, r4, #1
    9318:	e28cc003 	add	ip, ip, #3
    931c:	e3a02000 	mov	r2, #0
    9320:	e5e32001 	strb	r2, [r3, #1]!
    9324:	e153000c 	cmp	r3, ip
    9328:	1afffffc 	bne	9320 <unintToStr+0x1c>
    932c:	e2415001 	sub	r5, r1, #1
    9330:	e2812f7f 	add	r2, r1, #508	; 0x1fc
    9334:	e1a03005 	mov	r3, r5
    9338:	e2822003 	add	r2, r2, #3
    933c:	e3a0c000 	mov	ip, #0
    9340:	e5e3c001 	strb	ip, [r3, #1]!
    9344:	e1530002 	cmp	r3, r2
    9348:	1afffffc 	bne	9340 <unintToStr+0x3c>
    934c:	e2403030 	sub	r3, r0, #48	; 0x30
    9350:	e3530009 	cmp	r3, #9
    9354:	9a000033 	bls	9428 <unintToStr+0x124>
    9358:	e3500000 	cmp	r0, #0
    935c:	0a000035 	beq	9438 <unintToStr+0x134>
    9360:	e30c7ccd 	movw	r7, #52429	; 0xcccd
    9364:	e1a0e004 	mov	lr, r4
    9368:	e34c7ccc 	movt	r7, #52428	; 0xcccc
    936c:	e3a0c000 	mov	ip, #0
    9370:	e3a0800a 	mov	r8, #10
    9374:	ea000000 	b	937c <unintToStr+0x78>
    9378:	e1a0c006 	mov	ip, r6
    937c:	e0832097 	umull	r2, r3, r7, r0
    9380:	e3500009 	cmp	r0, #9
    9384:	e28c6001 	add	r6, ip, #1
    9388:	e1a031a3 	lsr	r3, r3, #3
    938c:	e0620398 	mls	r2, r8, r3, r0
    9390:	e1a00003 	mov	r0, r3
    9394:	e2823030 	add	r3, r2, #48	; 0x30
    9398:	e4ce3001 	strb	r3, [lr], #1
    939c:	8afffff5 	bhi	9378 <unintToStr+0x74>
    93a0:	e5dde000 	ldrb	lr, [sp]
    93a4:	e30a67e4 	movw	r6, #42980	; 0xa7e4
    93a8:	e2618001 	rsb	r8, r1, #1
    93ac:	e3406000 	movt	r6, #0
    93b0:	e3a09030 	mov	r9, #48	; 0x30
    93b4:	e5960000 	ldr	r0, [r6]
    93b8:	e0887005 	add	r7, r8, r5
    93bc:	e35e0000 	cmp	lr, #0
    93c0:	0a000005 	beq	93dc <unintToStr+0xd8>
    93c4:	e1a03004 	mov	r3, r4
    93c8:	e5f32001 	ldrb	r2, [r3, #1]!
    93cc:	e3520000 	cmp	r2, #0
    93d0:	1afffffc 	bne	93c8 <unintToStr+0xc4>
    93d4:	e0433004 	sub	r3, r3, r4
    93d8:	e0400003 	sub	r0, r0, r3
    93dc:	e3500000 	cmp	r0, #0
    93e0:	da000004 	ble	93f8 <unintToStr+0xf4>
    93e4:	e5e59001 	strb	r9, [r5, #1]!
    93e8:	e5960000 	ldr	r0, [r6]
    93ec:	e2400001 	sub	r0, r0, #1
    93f0:	e5860000 	str	r0, [r6]
    93f4:	eaffffef 	b	93b8 <unintToStr+0xb4>
    93f8:	e37c0001 	cmn	ip, #1
    93fc:	0a000007 	beq	9420 <unintToStr+0x11c>
    9400:	e28c3001 	add	r3, ip, #1
    9404:	e2477001 	sub	r7, r7, #1
    9408:	e0843003 	add	r3, r4, r3
    940c:	e0811007 	add	r1, r1, r7
    9410:	e5732001 	ldrb	r2, [r3, #-1]!
    9414:	e1530004 	cmp	r3, r4
    9418:	e5e12001 	strb	r2, [r1, #1]!
    941c:	1afffffb 	bne	9410 <unintToStr+0x10c>
    9420:	e28ddf81 	add	sp, sp, #516	; 0x204
    9424:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}
    9428:	e6efe070 	uxtb	lr, r0
    942c:	e3a0c000 	mov	ip, #0
    9430:	e5cde000 	strb	lr, [sp]
    9434:	eaffffda 	b	93a4 <unintToStr+0xa0>
    9438:	e5dde000 	ldrb	lr, [sp]
    943c:	e3e0c000 	mvn	ip, #0
    9440:	eaffffd7 	b	93a4 <unintToStr+0xa0>

00009444 <fwrite>:
    9444:	e92d4070 	push	{r4, r5, r6, lr}
    9448:	e2515000 	subs	r5, r1, #0
    944c:	d8bd8070 	pople	{r4, r5, r6, pc}
    9450:	e2404001 	sub	r4, r0, #1
    9454:	e0845005 	add	r5, r4, r5
    9458:	e5f40001 	ldrb	r0, [r4, #1]!
    945c:	ebfffec8 	bl	8f84 <sendChar>
    9460:	e1540005 	cmp	r4, r5
    9464:	1afffffb 	bne	9458 <fwrite+0x14>
    9468:	e8bd8070 	pop	{r4, r5, r6, pc}

0000946c <kprintf>:
    946c:	e92d000f 	push	{r0, r1, r2, r3}
    9470:	e3a02000 	mov	r2, #0
    9474:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
    9478:	e24dd00c 	sub	sp, sp, #12
    947c:	e59f3454 	ldr	r3, [pc, #1108]	; 98d8 <kprintf+0x46c>
    9480:	e59d4030 	ldr	r4, [sp, #48]	; 0x30
    9484:	e2831c02 	add	r1, r3, #512	; 0x200
    9488:	e5e32001 	strb	r2, [r3, #1]!
    948c:	e1510003 	cmp	r1, r3
    9490:	1afffffc 	bne	9488 <kprintf+0x1c>
    9494:	e30a6bec 	movw	r6, #44012	; 0xabec
    9498:	e30a59e8 	movw	r5, #43496	; 0xa9e8
    949c:	e3406000 	movt	r6, #0
    94a0:	e3540000 	cmp	r4, #0
    94a4:	e3405000 	movt	r5, #0
    94a8:	e28d3034 	add	r3, sp, #52	; 0x34
    94ac:	e5862000 	str	r2, [r6]
    94b0:	e5852000 	str	r2, [r5]
    94b4:	e58d3004 	str	r3, [sp, #4]
    94b8:	0a000092 	beq	9708 <kprintf+0x29c>
    94bc:	e5d42000 	ldrb	r2, [r4]
    94c0:	e3a03000 	mov	r3, #0
    94c4:	e1a01004 	mov	r1, r4
    94c8:	e1520003 	cmp	r2, r3
    94cc:	0a00008d 	beq	9708 <kprintf+0x29c>
    94d0:	e30a79ec 	movw	r7, #43500	; 0xa9ec
    94d4:	e30aa7e4 	movw	sl, #42980	; 0xa7e4
    94d8:	e3407000 	movt	r7, #0
    94dc:	e30ab7e8 	movw	fp, #42984	; 0xa7e8
    94e0:	e340a000 	movt	sl, #0
    94e4:	e340b000 	movt	fp, #0
    94e8:	ea00000b 	b	951c <kprintf+0xb0>
    94ec:	e5952000 	ldr	r2, [r5]
    94f0:	e5963000 	ldr	r3, [r6]
    94f4:	e2820001 	add	r0, r2, #1
    94f8:	e5850000 	str	r0, [r5]
    94fc:	e5d11000 	ldrb	r1, [r1]
    9500:	e7c71002 	strb	r1, [r7, r2]
    9504:	e2833001 	add	r3, r3, #1
    9508:	e5863000 	str	r3, [r6]
    950c:	e7d42003 	ldrb	r2, [r4, r3]
    9510:	e0841003 	add	r1, r4, r3
    9514:	e3520000 	cmp	r2, #0
    9518:	0a00007a 	beq	9708 <kprintf+0x29c>
    951c:	e3520025 	cmp	r2, #37	; 0x25
    9520:	1afffff1 	bne	94ec <kprintf+0x80>
    9524:	e2833001 	add	r3, r3, #1
    9528:	e2648001 	rsb	r8, r4, #1
    952c:	e5863000 	str	r3, [r6]
    9530:	e3a0e00a 	mov	lr, #10
    9534:	e7d42003 	ldrb	r2, [r4, r3]
    9538:	e3520070 	cmp	r2, #112	; 0x70
    953c:	0a00001a 	beq	95ac <kprintf+0x140>
    9540:	8a000037 	bhi	9624 <kprintf+0x1b8>
    9544:	e3520063 	cmp	r2, #99	; 0x63
    9548:	0a000095 	beq	97a4 <kprintf+0x338>
    954c:	e3520069 	cmp	r2, #105	; 0x69
    9550:	0a0000a9 	beq	97fc <kprintf+0x390>
    9554:	e3520025 	cmp	r2, #37	; 0x25
    9558:	0a0000a2 	beq	97e8 <kprintf+0x37c>
    955c:	e0840003 	add	r0, r4, r3
    9560:	e2422030 	sub	r2, r2, #48	; 0x30
    9564:	e3520009 	cmp	r2, #9
    9568:	8a0000d1 	bhi	98b4 <kprintf+0x448>
    956c:	e59a1000 	ldr	r1, [sl]
    9570:	e240c001 	sub	ip, r0, #1
    9574:	e001019e 	mul	r1, lr, r1
    9578:	e0883000 	add	r3, r8, r0
    957c:	e58a1000 	str	r1, [sl]
    9580:	e5fc2001 	ldrb	r2, [ip, #1]!
    9584:	e5863000 	str	r3, [r6]
    9588:	e2422030 	sub	r2, r2, #48	; 0x30
    958c:	e0821001 	add	r1, r2, r1
    9590:	e58a1000 	str	r1, [sl]
    9594:	e5f02001 	ldrb	r2, [r0, #1]!
    9598:	e2429030 	sub	r9, r2, #48	; 0x30
    959c:	e3590009 	cmp	r9, #9
    95a0:	9afffff3 	bls	9574 <kprintf+0x108>
    95a4:	e3520070 	cmp	r2, #112	; 0x70
    95a8:	1affffe4 	bne	9540 <kprintf+0xd4>
    95ac:	e59d3004 	ldr	r3, [sp, #4]
    95b0:	e30a17e8 	movw	r1, #42984	; 0xa7e8
    95b4:	e3401000 	movt	r1, #0
    95b8:	e3a02001 	mov	r2, #1
    95bc:	e5930000 	ldr	r0, [r3]
    95c0:	e2833004 	add	r3, r3, #4
    95c4:	e58d3004 	str	r3, [sp, #4]
    95c8:	ebfffe9e 	bl	9048 <decToHexStr>
    95cc:	e5951000 	ldr	r1, [r5]
    95d0:	e0870001 	add	r0, r7, r1
    95d4:	e3700001 	cmn	r0, #1
    95d8:	0a000002 	beq	95e8 <kprintf+0x17c>
    95dc:	e1a0100b 	mov	r1, fp
    95e0:	ebfffe76 	bl	8fc0 <strcpy.part.0>
    95e4:	e5951000 	ldr	r1, [r5]
    95e8:	e5db3000 	ldrb	r3, [fp]
    95ec:	e3530000 	cmp	r3, #0
    95f0:	0a000006 	beq	9610 <kprintf+0x1a4>
    95f4:	e30a37e8 	movw	r3, #42984	; 0xa7e8
    95f8:	e3403000 	movt	r3, #0
    95fc:	e5f32001 	ldrb	r2, [r3, #1]!
    9600:	e3520000 	cmp	r2, #0
    9604:	1afffffc 	bne	95fc <kprintf+0x190>
    9608:	e043300b 	sub	r3, r3, fp
    960c:	e0811003 	add	r1, r1, r3
    9610:	e5851000 	str	r1, [r5]
    9614:	e3a03000 	mov	r3, #0
    9618:	e58a3000 	str	r3, [sl]
    961c:	e5963000 	ldr	r3, [r6]
    9620:	eaffffb7 	b	9504 <kprintf+0x98>
    9624:	e3520075 	cmp	r2, #117	; 0x75
    9628:	0a00008a 	beq	9858 <kprintf+0x3ec>
    962c:	e3520078 	cmp	r2, #120	; 0x78
    9630:	0a000043 	beq	9744 <kprintf+0x2d8>
    9634:	e3520073 	cmp	r2, #115	; 0x73
    9638:	1affffc7 	bne	955c <kprintf+0xf0>
    963c:	e59d3004 	ldr	r3, [sp, #4]
    9640:	e37b0001 	cmn	fp, #1
    9644:	e2832004 	add	r2, r3, #4
    9648:	e58d2004 	str	r2, [sp, #4]
    964c:	0a000002 	beq	965c <kprintf+0x1f0>
    9650:	e5931000 	ldr	r1, [r3]
    9654:	e1a0000b 	mov	r0, fp
    9658:	ebfffe58 	bl	8fc0 <strcpy.part.0>
    965c:	e595c000 	ldr	ip, [r5]
    9660:	e087000c 	add	r0, r7, ip
    9664:	e3700001 	cmn	r0, #1
    9668:	0a000002 	beq	9678 <kprintf+0x20c>
    966c:	e1a0100b 	mov	r1, fp
    9670:	ebfffe52 	bl	8fc0 <strcpy.part.0>
    9674:	e595c000 	ldr	ip, [r5]
    9678:	e5db8000 	ldrb	r8, [fp]
    967c:	e3580000 	cmp	r8, #0
    9680:	0a000006 	beq	96a0 <kprintf+0x234>
    9684:	e30a37e8 	movw	r3, #42984	; 0xa7e8
    9688:	e3403000 	movt	r3, #0
    968c:	e5f32001 	ldrb	r2, [r3, #1]!
    9690:	e3520000 	cmp	r2, #0
    9694:	1afffffc 	bne	968c <kprintf+0x220>
    9698:	e043300b 	sub	r3, r3, fp
    969c:	e08cc003 	add	ip, ip, r3
    96a0:	e59ae000 	ldr	lr, [sl]
    96a4:	e1a0100c 	mov	r1, ip
    96a8:	e585c000 	str	ip, [r5]
    96ac:	e24cc001 	sub	ip, ip, #1
    96b0:	e08ee001 	add	lr, lr, r1
    96b4:	e3a09000 	mov	r9, #0
    96b8:	e087c00c 	add	ip, r7, ip
    96bc:	e58d4030 	str	r4, [sp, #48]	; 0x30
    96c0:	e04e0001 	sub	r0, lr, r1
    96c4:	e3580000 	cmp	r8, #0
    96c8:	e1a04001 	mov	r4, r1
    96cc:	0a000006 	beq	96ec <kprintf+0x280>
    96d0:	e30a37e8 	movw	r3, #42984	; 0xa7e8
    96d4:	e3403000 	movt	r3, #0
    96d8:	e5f32001 	ldrb	r2, [r3, #1]!
    96dc:	e3520000 	cmp	r2, #0
    96e0:	1afffffc 	bne	96d8 <kprintf+0x26c>
    96e4:	e043300b 	sub	r3, r3, fp
    96e8:	e0400003 	sub	r0, r0, r3
    96ec:	e3500000 	cmp	r0, #0
    96f0:	e2811001 	add	r1, r1, #1
    96f4:	da000033 	ble	97c8 <kprintf+0x35c>
    96f8:	e3a03020 	mov	r3, #32
    96fc:	e3a09001 	mov	r9, #1
    9700:	e5ec3001 	strb	r3, [ip, #1]!
    9704:	eaffffed 	b	96c0 <kprintf+0x254>
    9708:	e5950000 	ldr	r0, [r5]
    970c:	e3500000 	cmp	r0, #0
    9710:	c30a49ec 	movwgt	r4, #43500	; 0xa9ec
    9714:	c3404000 	movtgt	r4, #0
    9718:	c0806004 	addgt	r6, r0, r4
    971c:	da000004 	ble	9734 <kprintf+0x2c8>
    9720:	e4d40001 	ldrb	r0, [r4], #1
    9724:	ebfffe16 	bl	8f84 <sendChar>
    9728:	e1560004 	cmp	r6, r4
    972c:	1afffffb 	bne	9720 <kprintf+0x2b4>
    9730:	e5950000 	ldr	r0, [r5]
    9734:	e28dd00c 	add	sp, sp, #12
    9738:	e8bd4ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
    973c:	e28dd010 	add	sp, sp, #16
    9740:	e12fff1e 	bx	lr
    9744:	e59d3004 	ldr	r3, [sp, #4]
    9748:	e30a17e8 	movw	r1, #42984	; 0xa7e8
    974c:	e3401000 	movt	r1, #0
    9750:	e3a02000 	mov	r2, #0
    9754:	e5930000 	ldr	r0, [r3]
    9758:	e2833004 	add	r3, r3, #4
    975c:	e58d3004 	str	r3, [sp, #4]
    9760:	ebfffe38 	bl	9048 <decToHexStr>
    9764:	e5951000 	ldr	r1, [r5]
    9768:	e0870001 	add	r0, r7, r1
    976c:	e3700001 	cmn	r0, #1
    9770:	0a000002 	beq	9780 <kprintf+0x314>
    9774:	e1a0100b 	mov	r1, fp
    9778:	ebfffe10 	bl	8fc0 <strcpy.part.0>
    977c:	e5951000 	ldr	r1, [r5]
    9780:	e5db3000 	ldrb	r3, [fp]
    9784:	e3530000 	cmp	r3, #0
    9788:	0affffa0 	beq	9610 <kprintf+0x1a4>
    978c:	e30a37e8 	movw	r3, #42984	; 0xa7e8
    9790:	e3403000 	movt	r3, #0
    9794:	e5f32001 	ldrb	r2, [r3, #1]!
    9798:	e3520000 	cmp	r2, #0
    979c:	1afffffc 	bne	9794 <kprintf+0x328>
    97a0:	eaffff98 	b	9608 <kprintf+0x19c>
    97a4:	e59d2004 	ldr	r2, [sp, #4]
    97a8:	e5951000 	ldr	r1, [r5]
    97ac:	e5920000 	ldr	r0, [r2]
    97b0:	e2822004 	add	r2, r2, #4
    97b4:	e58d2004 	str	r2, [sp, #4]
    97b8:	e2812001 	add	r2, r1, #1
    97bc:	e7c70001 	strb	r0, [r7, r1]
    97c0:	e5852000 	str	r2, [r5]
    97c4:	eaffff4e 	b	9504 <kprintf+0x98>
    97c8:	e1a03004 	mov	r3, r4
    97cc:	e3590000 	cmp	r9, #0
    97d0:	15853000 	strne	r3, [r5]
    97d4:	e3a02000 	mov	r2, #0
    97d8:	e59d4030 	ldr	r4, [sp, #48]	; 0x30
    97dc:	e5963000 	ldr	r3, [r6]
    97e0:	e58a2000 	str	r2, [sl]
    97e4:	eaffff46 	b	9504 <kprintf+0x98>
    97e8:	e5951000 	ldr	r1, [r5]
    97ec:	e7c72001 	strb	r2, [r7, r1]
    97f0:	e2811001 	add	r1, r1, #1
    97f4:	e5851000 	str	r1, [r5]
    97f8:	eaffff41 	b	9504 <kprintf+0x98>
    97fc:	e59d3004 	ldr	r3, [sp, #4]
    9800:	e30a17e8 	movw	r1, #42984	; 0xa7e8
    9804:	e3401000 	movt	r1, #0
    9808:	e5930000 	ldr	r0, [r3]
    980c:	e2833004 	add	r3, r3, #4
    9810:	e58d3004 	str	r3, [sp, #4]
    9814:	ebfffe60 	bl	919c <intToStr>
    9818:	e5951000 	ldr	r1, [r5]
    981c:	e0870001 	add	r0, r7, r1
    9820:	e3700001 	cmn	r0, #1
    9824:	0a000002 	beq	9834 <kprintf+0x3c8>
    9828:	e1a0100b 	mov	r1, fp
    982c:	ebfffde3 	bl	8fc0 <strcpy.part.0>
    9830:	e5951000 	ldr	r1, [r5]
    9834:	e5db3000 	ldrb	r3, [fp]
    9838:	e3530000 	cmp	r3, #0
    983c:	0affff73 	beq	9610 <kprintf+0x1a4>
    9840:	e30a37e8 	movw	r3, #42984	; 0xa7e8
    9844:	e3403000 	movt	r3, #0
    9848:	e5f32001 	ldrb	r2, [r3, #1]!
    984c:	e3520000 	cmp	r2, #0
    9850:	1afffffc 	bne	9848 <kprintf+0x3dc>
    9854:	eaffff6b 	b	9608 <kprintf+0x19c>
    9858:	e59d3004 	ldr	r3, [sp, #4]
    985c:	e30a17e8 	movw	r1, #42984	; 0xa7e8
    9860:	e3401000 	movt	r1, #0
    9864:	e5930000 	ldr	r0, [r3]
    9868:	e2833004 	add	r3, r3, #4
    986c:	e58d3004 	str	r3, [sp, #4]
    9870:	ebfffea3 	bl	9304 <unintToStr>
    9874:	e5951000 	ldr	r1, [r5]
    9878:	e0870001 	add	r0, r7, r1
    987c:	e3700001 	cmn	r0, #1
    9880:	0a000002 	beq	9890 <kprintf+0x424>
    9884:	e1a0100b 	mov	r1, fp
    9888:	ebfffdcc 	bl	8fc0 <strcpy.part.0>
    988c:	e5951000 	ldr	r1, [r5]
    9890:	e5db3000 	ldrb	r3, [fp]
    9894:	e3530000 	cmp	r3, #0
    9898:	0affff5c 	beq	9610 <kprintf+0x1a4>
    989c:	e30a37e8 	movw	r3, #42984	; 0xa7e8
    98a0:	e3403000 	movt	r3, #0
    98a4:	e5f32001 	ldrb	r2, [r3, #1]!
    98a8:	e3520000 	cmp	r2, #0
    98ac:	1afffffc 	bne	98a4 <kprintf+0x438>
    98b0:	eaffff54 	b	9608 <kprintf+0x19c>
    98b4:	e5951000 	ldr	r1, [r5]
    98b8:	e1a02007 	mov	r2, r7
    98bc:	e3a0c025 	mov	ip, #37	; 0x25
    98c0:	e7e2c001 	strb	ip, [r2, r1]!
    98c4:	e2811002 	add	r1, r1, #2
    98c8:	e5851000 	str	r1, [r5]
    98cc:	e5d01000 	ldrb	r1, [r0]
    98d0:	e5c21001 	strb	r1, [r2, #1]
    98d4:	eaffff0a 	b	9504 <kprintf+0x98>
    98d8:	0000a7e7 	andeq	sl, r0, r7, ror #15

000098dc <fread>:
    98dc:	e5c01000 	strb	r1, [r0]
    98e0:	e1a00001 	mov	r0, r1
    98e4:	e12fff1e 	bx	lr

000098e8 <kscanf>:
    98e8:	e92d000f 	push	{r0, r1, r2, r3}
    98ec:	e3a01064 	mov	r1, #100	; 0x64
    98f0:	e92d4070 	push	{r4, r5, r6, lr}
    98f4:	e24dd068 	sub	sp, sp, #104	; 0x68
    98f8:	e28d0004 	add	r0, sp, #4
    98fc:	e3a06000 	mov	r6, #0
    9900:	e59d4078 	ldr	r4, [sp, #120]	; 0x78
    9904:	ebfffdb8 	bl	8fec <kmemset>
    9908:	ebfffda4 	bl	8fa0 <recvChar>
    990c:	e2505000 	subs	r5, r0, #0
    9910:	0afffffc 	beq	9908 <kscanf+0x20>
    9914:	e28d3068 	add	r3, sp, #104	; 0x68
    9918:	e0833006 	add	r3, r3, r6
    991c:	e2866001 	add	r6, r6, #1
    9920:	e5435064 	strb	r5, [r3, #-100]	; 0xffffff9c
    9924:	ebfffd96 	bl	8f84 <sendChar>
    9928:	e355000a 	cmp	r5, #10
    992c:	1afffff5 	bne	9908 <kscanf+0x20>
    9930:	e3540000 	cmp	r4, #0
    9934:	e28d307c 	add	r3, sp, #124	; 0x7c
    9938:	e58d3000 	str	r3, [sp]
    993c:	01a00004 	moveq	r0, r4
    9940:	0a000022 	beq	99d0 <kscanf+0xe8>
    9944:	e5d43000 	ldrb	r3, [r4]
    9948:	e3530000 	cmp	r3, #0
    994c:	0a00002c 	beq	9a04 <kscanf+0x11c>
    9950:	e3a00000 	mov	r0, #0
    9954:	e1a02000 	mov	r2, r0
    9958:	e1a01000 	mov	r1, r0
    995c:	ea000005 	b	9978 <kscanf+0x90>
    9960:	e5453064 	strb	r3, [r5, #-100]	; 0xffffff9c
    9964:	e2822001 	add	r2, r2, #1
    9968:	e1a0100c 	mov	r1, ip
    996c:	e1a0300e 	mov	r3, lr
    9970:	e3530000 	cmp	r3, #0
    9974:	0a000015 	beq	99d0 <kscanf+0xe8>
    9978:	e28dc068 	add	ip, sp, #104	; 0x68
    997c:	e3530025 	cmp	r3, #37	; 0x25
    9980:	e08c5002 	add	r5, ip, r2
    9984:	e281c001 	add	ip, r1, #1
    9988:	e7d4e00c 	ldrb	lr, [r4, ip]
    998c:	1afffff3 	bne	9960 <kscanf+0x78>
    9990:	e35e0025 	cmp	lr, #37	; 0x25
    9994:	e2811002 	add	r1, r1, #2
    9998:	e084c001 	add	ip, r4, r1
    999c:	0a00000f 	beq	99e0 <kscanf+0xf8>
    99a0:	e35e0063 	cmp	lr, #99	; 0x63
    99a4:	02822001 	addeq	r2, r2, #1
    99a8:	02800001 	addeq	r0, r0, #1
    99ac:	059d3000 	ldreq	r3, [sp]
    99b0:	05555064 	ldrbeq	r5, [r5, #-100]	; 0xffffff9c
    99b4:	0593e000 	ldreq	lr, [r3]
    99b8:	02833004 	addeq	r3, r3, #4
    99bc:	058d3000 	streq	r3, [sp]
    99c0:	05ce5000 	strbeq	r5, [lr]
    99c4:	e5dc3000 	ldrb	r3, [ip]
    99c8:	e3530000 	cmp	r3, #0
    99cc:	1affffe9 	bne	9978 <kscanf+0x90>
    99d0:	e28dd068 	add	sp, sp, #104	; 0x68
    99d4:	e8bd4070 	pop	{r4, r5, r6, lr}
    99d8:	e28dd010 	add	sp, sp, #16
    99dc:	e12fff1e 	bx	lr
    99e0:	e59dc000 	ldr	ip, [sp]
    99e4:	e2822001 	add	r2, r2, #1
    99e8:	e2800001 	add	r0, r0, #1
    99ec:	e59ce000 	ldr	lr, [ip]
    99f0:	e28cc004 	add	ip, ip, #4
    99f4:	e58dc000 	str	ip, [sp]
    99f8:	e5ce3000 	strb	r3, [lr]
    99fc:	e7d43001 	ldrb	r3, [r4, r1]
    9a00:	eaffffda 	b	9970 <kscanf+0x88>
    9a04:	e1a00003 	mov	r0, r3
    9a08:	eafffff0 	b	99d0 <kscanf+0xe8>

00009a0c <getLength>:
    9a0c:	e30a3bf0 	movw	r3, #44016	; 0xabf0
    9a10:	e3403000 	movt	r3, #0
    9a14:	e5930000 	ldr	r0, [r3]
    9a18:	e12fff1e 	bx	lr

00009a1c <enqueue>:
    9a1c:	e30a3bf0 	movw	r3, #44016	; 0xabf0
    9a20:	e3403000 	movt	r3, #0
    9a24:	e92d4010 	push	{r4, lr}
    9a28:	e5932000 	ldr	r2, [r3]
    9a2c:	e352007f 	cmp	r2, #127	; 0x7f
    9a30:	ca000007 	bgt	9a54 <enqueue+0x38>
    9a34:	e30a1bf4 	movw	r1, #44020	; 0xabf4
    9a38:	e282e001 	add	lr, r2, #1
    9a3c:	e3401000 	movt	r1, #0
    9a40:	e1a0c000 	mov	ip, r0
    9a44:	e583e000 	str	lr, [r3]
    9a48:	e7c10002 	strb	r0, [r1, r2]
    9a4c:	e1a0000c 	mov	r0, ip
    9a50:	e8bd8010 	pop	{r4, pc}
    9a54:	e30a0798 	movw	r0, #42904	; 0xa798
    9a58:	e3400000 	movt	r0, #0
    9a5c:	ebfffe82 	bl	946c <kprintf>
    9a60:	e3a0c000 	mov	ip, #0
    9a64:	e1a0000c 	mov	r0, ip
    9a68:	e8bd8010 	pop	{r4, pc}

00009a6c <dequeue>:
    9a6c:	e30a3bf0 	movw	r3, #44016	; 0xabf0
    9a70:	e3403000 	movt	r3, #0
    9a74:	e5932000 	ldr	r2, [r3]
    9a78:	e3520000 	cmp	r2, #0
    9a7c:	0a000011 	beq	9ac8 <dequeue+0x5c>
    9a80:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
    9a84:	e30acbf4 	movw	ip, #44020	; 0xabf4
    9a88:	e340c000 	movt	ip, #0
    9a8c:	e242e001 	sub	lr, r2, #1
    9a90:	e583e000 	str	lr, [r3]
    9a94:	e35e0000 	cmp	lr, #0
    9a98:	e5dc0000 	ldrb	r0, [ip]
    9a9c:	da000006 	ble	9abc <dequeue+0x50>
    9aa0:	e24c1001 	sub	r1, ip, #1
    9aa4:	e1a0300c 	mov	r3, ip
    9aa8:	e0811002 	add	r1, r1, r2
    9aac:	e5d32001 	ldrb	r2, [r3, #1]
    9ab0:	e4c32001 	strb	r2, [r3], #1
    9ab4:	e1530001 	cmp	r3, r1
    9ab8:	1afffffb 	bne	9aac <dequeue+0x40>
    9abc:	e3a03000 	mov	r3, #0
    9ac0:	e7cc300e 	strb	r3, [ip, lr]
    9ac4:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)
    9ac8:	e1a00002 	mov	r0, r2
    9acc:	e12fff1e 	bx	lr

00009ad0 <read_and_write>:
    9ad0:	e92d4070 	push	{r4, r5, r6, lr}
    9ad4:	e30a6bf0 	movw	r6, #44016	; 0xabf0
    9ad8:	e3406000 	movt	r6, #0
    9adc:	ebfffd2f 	bl	8fa0 <recvChar>
    9ae0:	e5963000 	ldr	r3, [r6]
    9ae4:	e353007f 	cmp	r3, #127	; 0x7f
    9ae8:	ca00001c 	bgt	9b60 <read_and_write+0x90>
    9aec:	e2832001 	add	r2, r3, #1
    9af0:	e30a4bf4 	movw	r4, #44020	; 0xabf4
    9af4:	e3404000 	movt	r4, #0
    9af8:	e3520000 	cmp	r2, #0
    9afc:	e5862000 	str	r2, [r6]
    9b00:	e7c40003 	strb	r0, [r4, r3]
    9b04:	d8bd8070 	pople	{r4, r5, r6, pc}
    9b08:	e30a4bf4 	movw	r4, #44020	; 0xabf4
    9b0c:	e3a05000 	mov	r5, #0
    9b10:	e3404000 	movt	r4, #0
    9b14:	e5d40000 	ldrb	r0, [r4]
    9b18:	e242c001 	sub	ip, r2, #1
    9b1c:	e586c000 	str	ip, [r6]
    9b20:	e35c0000 	cmp	ip, #0
    9b24:	130a3bf4 	movwne	r3, #44020	; 0xabf4
    9b28:	13403000 	movtne	r3, #0
    9b2c:	12431001 	subne	r1, r3, #1
    9b30:	10811002 	addne	r1, r1, r2
    9b34:	0a000003 	beq	9b48 <read_and_write+0x78>
    9b38:	e5d32001 	ldrb	r2, [r3, #1]
    9b3c:	e4c32001 	strb	r2, [r3], #1
    9b40:	e1530001 	cmp	r3, r1
    9b44:	1afffffb 	bne	9b38 <read_and_write+0x68>
    9b48:	e7c4500c 	strb	r5, [r4, ip]
    9b4c:	ebfffc48 	bl	8c74 <call_routine>
    9b50:	e5962000 	ldr	r2, [r6]
    9b54:	e3520000 	cmp	r2, #0
    9b58:	caffffed 	bgt	9b14 <read_and_write+0x44>
    9b5c:	e8bd8070 	pop	{r4, r5, r6, pc}
    9b60:	e30a0798 	movw	r0, #42904	; 0xa798
    9b64:	e3400000 	movt	r0, #0
    9b68:	ebfffe3f 	bl	946c <kprintf>
    9b6c:	e5962000 	ldr	r2, [r6]
    9b70:	e3520000 	cmp	r2, #0
    9b74:	caffffe3 	bgt	9b08 <read_and_write+0x38>
    9b78:	e8bd8070 	pop	{r4, r5, r6, pc}

Disassembly of section .rodata:

00009b7c <CSWTCH.12>:
    9b7c:	0000a1e0 	andeq	sl, r0, r0, ror #3
    9b80:	0000a1dc 	ldrdeq	sl, [r0], -ip
    9b84:	0000a1d8 	ldrdeq	sl, [r0], -r8
    9b88:	0000a1e8 	andeq	sl, r0, r8, ror #3
    9b8c:	00009eac 	andeq	r9, r0, ip, lsr #29
    9b90:	00009eac 	andeq	r9, r0, ip, lsr #29
    9b94:	00009eac 	andeq	r9, r0, ip, lsr #29
    9b98:	0000a1f4 	strdeq	sl, [r0], -r4
    9b9c:	00009eac 	andeq	r9, r0, ip, lsr #29
    9ba0:	00009eac 	andeq	r9, r0, ip, lsr #29
    9ba4:	00009eac 	andeq	r9, r0, ip, lsr #29
    9ba8:	0000a1fc 	strdeq	sl, [r0], -ip
    9bac:	00009eac 	andeq	r9, r0, ip, lsr #29
    9bb0:	00009eac 	andeq	r9, r0, ip, lsr #29
    9bb4:	00009eac 	andeq	r9, r0, ip, lsr #29
    9bb8:	0000a208 	andeq	sl, r0, r8, lsl #4

00009bbc <.LANCHOR0>:
    9bbc:	33323130 	teqcc	r2, #48, 2
    9bc0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9bc4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9bc8:	46454443 	strbmi	r4, [r5], -r3, asr #8
    9bcc:	00000000 	andeq	r0, r0, r0
    9bd0:	33323130 	teqcc	r2, #48, 2
    9bd4:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9bd8:	Address 0x0000000000009bd8 is out of bounds.


Disassembly of section .rodata.str1.4:

00009bdc <.rodata.str1.4>:
    9bdc:	6573656c 	ldrbvs	r6, [r3, #-1388]!	; 0xfffffa94
    9be0:	0000646e 	andeq	r6, r0, lr, ror #8
    9be4:	72686373 	rsbvc	r6, r8, #-872415231	; 0xcc000001
    9be8:	65626965 	strbvs	r6, [r2, #-2405]!	; 0xfffff69b
    9bec:	0000646e 	andeq	r6, r0, lr, ror #8
    9bf0:	7267755a 	rsbvc	r7, r7, #377487360	; 0x16800000
    9bf4:	3a666669 	bcc	19a35a0 <STACK_BASE+0x18b35a0>
    9bf8:	20732520 	rsbscs	r2, r3, r0, lsr #10
    9bfc:	20667561 	rsbcs	r7, r6, r1, ror #10
    9c00:	65726441 	ldrbvs	r6, [r2, #-1089]!	; 0xfffffbbf
    9c04:	20657373 	rsbcs	r7, r5, r3, ror r3
    9c08:	70383025 	eorsvc	r3, r8, r5, lsr #32
    9c0c:	0000000a 	andeq	r0, r0, sl
    9c10:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9c14:	203a7265 	eorscs	r7, sl, r5, ror #4
    9c18:	66206f4e 	strtvs	r6, [r0], -lr, asr #30
    9c1c:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
    9c20:	2c6e6f69 	stclcs	15, cr6, [lr], #-420	; 0xfffffe5c
    9c24:	73657220 	cmnvc	r5, #32, 4
    9c28:	76207465 	strtvc	r7, [r0], -r5, ror #8
    9c2c:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
    9c30:	00000a0a 	andeq	r0, r0, sl, lsl #20
    9c34:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9c38:	203a7265 	eorscs	r7, sl, r5, ror #4
    9c3c:	67696c41 	strbvs	r6, [r9, -r1, asr #24]!
    9c40:	6e656d6e 	cdpvs	13, 6, cr6, cr5, cr14, {3}
    9c44:	61662074 	smcvs	25092	; 0x6204
    9c48:	0a746c75 	beq	1d24e24 <STACK_BASE+0x1c34e24>
    9c4c:	0000000a 	andeq	r0, r0, sl
    9c50:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9c54:	443a7265 	ldrtmi	r7, [sl], #-613	; 0xfffffd9b
    9c58:	67756265 	ldrbvs	r6, [r5, -r5, ror #4]!
    9c5c:	65766520 	ldrbvs	r6, [r6, #-1312]!	; 0xfffffae0
    9c60:	6620746e 	strtvs	r7, [r0], -lr, ror #8
    9c64:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    9c68:	00000a0a 	andeq	r0, r0, sl, lsl #20
    9c6c:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9c70:	203a7265 	eorscs	r7, sl, r5, ror #4
    9c74:	65636341 	strbvs	r6, [r3, #-833]!	; 0xfffffcbf
    9c78:	46207373 			; <UNDEFINED> instruction: 0x46207373
    9c7c:	2067616c 	rsbcs	r6, r7, ip, ror #2
    9c80:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    9c84:	6e6f2074 	mcrvs	0, 3, r2, cr15, cr4, {3}
    9c88:	63655320 	cmnvs	r5, #32, 6	; 0x80000000
    9c8c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    9c90:	00000a0a 	andeq	r0, r0, sl, lsl #20
    9c94:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9c98:	203a7265 	eorscs	r7, sl, r5, ror #4
    9c9c:	68636143 	stmdavs	r3!, {r0, r1, r6, r8, sp, lr}^
    9ca0:	616d2065 	cmnvs	sp, r5, rrx
    9ca4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    9ca8:	636e616e 	cmnvs	lr, #-2147483621	; 0x8000001b
    9cac:	706f2065 	rsbvc	r2, pc, r5, rrx
    9cb0:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    9cb4:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    9cb8:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    9cbc:	5d625b74 	vstmdbpl	r2!, {d21-<overflow reg d78>}
    9cc0:	00000a0a 	andeq	r0, r0, sl, lsl #20
    9cc4:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9cc8:	203a7265 	eorscs	r7, sl, r5, ror #4
    9ccc:	6e617254 	mcrvs	2, 3, r7, cr1, cr4, {2}
    9cd0:	74616c73 	strbtvc	r6, [r1], #-3187	; 0xfffff38d
    9cd4:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    9cd8:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    9cdc:	6e6f2074 	mcrvs	0, 3, r2, cr15, cr4, {3}
    9ce0:	63655320 	cmnvs	r5, #32, 6	; 0x80000000
    9ce4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    9ce8:	00000a0a 	andeq	r0, r0, sl, lsl #20
    9cec:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9cf0:	203a7265 	eorscs	r7, sl, r5, ror #4
    9cf4:	65636341 	strbvs	r6, [r3, #-833]!	; 0xfffffcbf
    9cf8:	46207373 			; <UNDEFINED> instruction: 0x46207373
    9cfc:	2067616c 	rsbcs	r6, r7, ip, ror #2
    9d00:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    9d04:	6e6f2074 	mcrvs	0, 3, r2, cr15, cr4, {3}
    9d08:	67615020 	strbvs	r5, [r1, -r0, lsr #32]!
    9d0c:	000a0a65 	andeq	r0, sl, r5, ror #20
    9d10:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9d14:	203a7265 	eorscs	r7, sl, r5, ror #4
    9d18:	6e617254 	mcrvs	2, 3, r7, cr1, cr4, {2}
    9d1c:	74616c73 	strbtvc	r6, [r1], #-3187	; 0xfffff38d
    9d20:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    9d24:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    9d28:	6e6f2074 	mcrvs	0, 3, r2, cr15, cr4, {3}
    9d2c:	67615020 	strbvs	r5, [r1, -r0, lsr #32]!
    9d30:	000a0a65 	andeq	r0, sl, r5, ror #20
    9d34:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9d38:	203a7265 	eorscs	r7, sl, r5, ror #4
    9d3c:	63657250 	cmnvs	r5, #80, 4
    9d40:	20657369 	rsbcs	r7, r5, r9, ror #6
    9d44:	65747845 	ldrbvs	r7, [r4, #-2117]!	; 0xfffff7bb
    9d48:	6c616e72 	stclvs	14, cr6, [r1], #-456	; 0xfffffe38
    9d4c:	6f624120 	svcvs	0x00624120
    9d50:	0a0a7472 	beq	2a6f20 <STACK_BASE+0x1b6f20>
    9d54:	00000000 	andeq	r0, r0, r0
    9d58:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9d5c:	203a7265 	eorscs	r7, sl, r5, ror #4
    9d60:	616d6f44 	cmnvs	sp, r4, asr #30
    9d64:	66206e69 	strtvs	r6, [r0], -r9, ror #28
    9d68:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    9d6c:	206e6f20 	rsbcs	r6, lr, r0, lsr #30
    9d70:	74636553 	strbtvc	r6, [r3], #-1363	; 0xfffffaad
    9d74:	0a6e6f69 	beq	1ba5b20 <STACK_BASE+0x1ab5b20>
    9d78:	0000000a 	andeq	r0, r0, sl
    9d7c:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9d80:	203a7265 	eorscs	r7, sl, r5, ror #4
    9d84:	66206f4e 	strtvs	r6, [r0], -lr, asr #30
    9d88:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
    9d8c:	0a6e6f69 	beq	1ba5b38 <STACK_BASE+0x1ab5b38>
    9d90:	0000000a 	andeq	r0, r0, sl
    9d94:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9d98:	203a7265 	eorscs	r7, sl, r5, ror #4
    9d9c:	616d6f44 	cmnvs	sp, r4, asr #30
    9da0:	66206e69 	strtvs	r6, [r0], -r9, ror #28
    9da4:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    9da8:	206e6f20 	rsbcs	r6, lr, r0, lsr #30
    9dac:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    9db0:	00000a0a 	andeq	r0, r0, sl, lsl #20
    9db4:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9db8:	203a7265 	eorscs	r7, sl, r5, ror #4
    9dbc:	65747845 	ldrbvs	r7, [r4, #-2117]!	; 0xfffff7bb
    9dc0:	6c616e72 	stclvs	14, cr6, [r1], #-456	; 0xfffffe38
    9dc4:	6f626120 	svcvs	0x00626120
    9dc8:	6f207472 	svcvs	0x00207472
    9dcc:	7274206e 	rsbsvc	r2, r4, #110	; 0x6e
    9dd0:	6c736e61 	ldclvs	14, cr6, [r3], #-388	; 0xfffffe7c
    9dd4:	6f697461 	svcvs	0x00697461
    9dd8:	66202c6e 	strtvs	r2, [r0], -lr, ror #24
    9ddc:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
    9de0:	76656c20 	strbtvc	r6, [r5], -r0, lsr #24
    9de4:	0a0a6c65 	beq	2a4f80 <STACK_BASE+0x1b4f80>
    9de8:	00000000 	andeq	r0, r0, r0
    9dec:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9df0:	203a7265 	eorscs	r7, sl, r5, ror #4
    9df4:	6d726550 	cfldr64vs	mvdx6, [r2, #-320]!	; 0xfffffec0
    9df8:	69737369 	ldmdbvs	r3!, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
    9dfc:	66206e6f 	strtvs	r6, [r0], -pc, ror #28
    9e00:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    9e04:	206e6f20 	rsbcs	r6, lr, r0, lsr #30
    9e08:	74636553 	strbtvc	r6, [r3], #-1363	; 0xfffffaad
    9e0c:	0a6e6f69 	beq	1ba5bb8 <STACK_BASE+0x1ab5bb8>
    9e10:	0000000a 	andeq	r0, r0, sl
    9e14:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9e18:	203a7265 	eorscs	r7, sl, r5, ror #4
    9e1c:	65747845 	ldrbvs	r7, [r4, #-2117]!	; 0xfffff7bb
    9e20:	6c616e72 	stclvs	14, cr6, [r1], #-456	; 0xfffffe38
    9e24:	6f626120 	svcvs	0x00626120
    9e28:	6f207472 	svcvs	0x00207472
    9e2c:	7274206e 	rsbsvc	r2, r4, #110	; 0x6e
    9e30:	6c736e61 	ldclvs	14, cr6, [r3], #-388	; 0xfffffe7c
    9e34:	6f697461 	svcvs	0x00697461
    9e38:	73202c6e 			; <UNDEFINED> instruction: 0x73202c6e
    9e3c:	6e6f6365 	cdpvs	3, 6, cr6, cr15, cr5, {3}
    9e40:	656c2064 	strbvs	r2, [ip, #-100]!	; 0xffffff9c
    9e44:	0a6c6576 	beq	1b23424 <STACK_BASE+0x1a33424>
    9e48:	0000000a 	andeq	r0, r0, sl
    9e4c:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9e50:	203a7265 	eorscs	r7, sl, r5, ror #4
    9e54:	6d726550 	cfldr64vs	mvdx6, [r2, #-320]!	; 0xfffffec0
    9e58:	69737369 	ldmdbvs	r3!, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
    9e5c:	66206e6f 	strtvs	r6, [r0], -pc, ror #28
    9e60:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    9e64:	206e6f20 	rsbcs	r6, lr, r0, lsr #30
    9e68:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    9e6c:	00000a0a 	andeq	r0, r0, sl, lsl #20
    9e70:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9e74:	203a7265 	eorscs	r7, sl, r5, ror #4
    9e78:	72706d49 	rsbsvc	r6, r0, #4672	; 0x1240
    9e7c:	73696365 	cmnvc	r9, #-1811939327	; 0x94000001
    9e80:	78452065 	stmdavc	r5, {r0, r2, r5, r6, sp}^
    9e84:	6e726574 	mrcvs	5, 3, r6, cr2, cr4, {3}
    9e88:	41206c61 			; <UNDEFINED> instruction: 0x41206c61
    9e8c:	74726f62 	ldrbtvc	r6, [r2], #-3938	; 0xfffff09e
    9e90:	00000a0a 	andeq	r0, r0, sl, lsl #20
    9e94:	6c686546 	cfstr64vs	mvdx6, [r8], #-280	; 0xfffffee8
    9e98:	203a7265 	eorscs	r7, sl, r5, ror #4
    9e9c:	66206f4e 	strtvs	r6, [r0], -lr, asr #30
    9ea0:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
    9ea4:	0a6e6f69 	beq	1ba5c50 <STACK_BASE+0x1ab5c50>
    9ea8:	00000000 	andeq	r0, r0, r0
    9eac:	6e6b6e55 	mcrvs	14, 3, r6, cr11, cr5, {2}
    9eb0:	206e776f 	rsbcs	r7, lr, pc, ror #14
    9eb4:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
    9eb8:	00000000 	andeq	r0, r0, r0
    9ebc:	3e3e3e0a 	cdpcc	14, 3, cr3, cr14, cr10, {0}
    9ec0:	6552203e 	ldrbvs	r2, [r2, #-62]	; 0xffffffc2
    9ec4:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
    9ec8:	63737265 	cmnvs	r3, #1342177286	; 0x50000006
    9ecc:	70616e68 	rsbvc	r6, r1, r8, ror #28
    9ed0:	68637370 	stmdavs	r3!, {r4, r5, r6, r8, r9, ip, sp, lr}^
    9ed4:	20737375 	rsbscs	r7, r3, r5, ror r3
    9ed8:	29732528 	ldmdbcs	r3!, {r3, r5, r8, sl, sp}^
    9edc:	3c3c3c20 	ldccc	12, cr3, [ip], #-128	; 0xffffff80
    9ee0:	30520a3c 	subscc	r0, r2, ip, lsr sl
    9ee4:	2520203a 	strcs	r2, [r0, #-58]!	; 0xffffffc6
    9ee8:	20703830 	rsbscs	r3, r0, r0, lsr r8
    9eec:	3a385220 	bcc	e1e774 <STACK_BASE+0xd2e774>
    9ef0:	30252020 	eorcc	r2, r5, r0, lsr #32
    9ef4:	520a7038 	andpl	r7, sl, #56	; 0x38
    9ef8:	20203a31 	eorcs	r3, r0, r1, lsr sl
    9efc:	70383025 	eorsvc	r3, r8, r5, lsr #32
    9f00:	39522020 	ldmdbcc	r2, {r5, sp}^
    9f04:	2520203a 	strcs	r2, [r0, #-58]!	; 0xffffffc6
    9f08:	0a703830 	beq	1c17fd0 <STACK_BASE+0x1b27fd0>
    9f0c:	203a3252 	eorscs	r3, sl, r2, asr r2
    9f10:	38302520 	ldmdacc	r0!, {r5, r8, sl, sp}
    9f14:	52202070 	eorpl	r2, r0, #112	; 0x70
    9f18:	203a3031 	eorscs	r3, sl, r1, lsr r0
    9f1c:	70383025 	eorsvc	r3, r8, r5, lsr #32
    9f20:	3a33520a 	bcc	cde750 <STACK_BASE+0xbee750>
    9f24:	30252020 	eorcc	r2, r5, r0, lsr #32
    9f28:	20207038 	eorcs	r7, r0, r8, lsr r0
    9f2c:	3a313152 	bcc	c5647c <STACK_BASE+0xb6647c>
    9f30:	38302520 	ldmdacc	r0!, {r5, r8, sl, sp}
    9f34:	34520a70 	ldrbcc	r0, [r2], #-2672	; 0xfffff590
    9f38:	2520203a 	strcs	r2, [r0, #-58]!	; 0xffffffc6
    9f3c:	20703830 	rsbscs	r3, r0, r0, lsr r8
    9f40:	32315220 	eorscc	r5, r1, #32, 4
    9f44:	3025203a 	eorcc	r2, r5, sl, lsr r0
    9f48:	520a7038 	andpl	r7, sl, #56	; 0x38
    9f4c:	20203a35 	eorcs	r3, r0, r5, lsr sl
    9f50:	70383025 	eorsvc	r3, r8, r5, lsr #32
    9f54:	50532020 	subspl	r2, r3, r0, lsr #32
    9f58:	2520203a 	strcs	r2, [r0, #-58]!	; 0xffffffc6
    9f5c:	0a703830 	beq	1c18024 <STACK_BASE+0x1b28024>
    9f60:	203a3652 	eorscs	r3, sl, r2, asr r6
    9f64:	38302520 	ldmdacc	r0!, {r5, r8, sl, sp}
    9f68:	4c202070 	stcmi	0, cr2, [r0], #-448	; 0xfffffe40
    9f6c:	20203a52 	eorcs	r3, r0, r2, asr sl
    9f70:	70383025 	eorsvc	r3, r8, r5, lsr #32
    9f74:	3a37520a 	bcc	dde7a4 <STACK_BASE+0xcee7a4>
    9f78:	30252020 	eorcc	r2, r5, r0, lsr #32
    9f7c:	20207038 	eorcs	r7, r0, r8, lsr r0
    9f80:	203a4350 	eorscs	r4, sl, r0, asr r3
    9f84:	38302520 	ldmdacc	r0!, {r5, r8, sl, sp}
    9f88:	000a0a70 	andeq	r0, sl, r0, ror sl
    9f8c:	203e3e3e 	eorscs	r3, lr, lr, lsr lr
    9f90:	75746b41 	ldrbvc	r6, [r4, #-2881]!	; 0xfffff4bf
    9f94:	656c6c65 	strbvs	r6, [ip, #-3173]!	; 0xfffff39b
    9f98:	61745320 	cmnvs	r4, r0, lsr #6
    9f9c:	72737574 	rsbsvc	r7, r3, #116, 10	; 0x1d000000
    9fa0:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    9fa4:	20726574 	rsbscs	r6, r2, r4, ror r5
    9fa8:	29732528 	ldmdbcs	r3!, {r3, r5, r8, sl, sp}^
    9fac:	3c3c3c20 	ldccc	12, cr3, [ip], #-128	; 0xffffff80
    9fb0:	0000000a 	andeq	r0, r0, sl
    9fb4:	52535043 	subspl	r5, r3, #67	; 0x43
    9fb8:	3125203a 			; <UNDEFINED> instruction: 0x3125203a
    9fbc:	25207332 	strcs	r7, [r0, #-818]!	; 0xfffffcce
    9fc0:	28733231 	ldmdacs	r3!, {r0, r4, r5, r9, ip, sp}^
    9fc4:	70383025 	eorsvc	r3, r8, r5, lsr #32
    9fc8:	00000a29 	andeq	r0, r0, r9, lsr #20
    9fcc:	52535053 	subspl	r5, r3, #83	; 0x53
    9fd0:	3125203a 			; <UNDEFINED> instruction: 0x3125203a
    9fd4:	25207332 	strcs	r7, [r0, #-818]!	; 0xfffffcce
    9fd8:	28733231 	ldmdacs	r3!, {r0, r4, r5, r9, ip, sp}^
    9fdc:	70383025 	eorsvc	r3, r8, r5, lsr #32
    9fe0:	00000a29 	andeq	r0, r0, r9, lsr #20
    9fe4:	00005053 	andeq	r5, r0, r3, asr r0
    9fe8:	0000524c 	andeq	r5, r0, ip, asr #4
    9fec:	3e3e3e0a 	cdpcc	14, 3, cr3, cr14, cr10, {0}
    9ff0:	746b4120 	strbtvc	r4, [fp], #-288	; 0xfffffee0
    9ff4:	6c6c6575 	cfstr64vs	mvdx6, [ip], #-468	; 0xfffffe2c
    9ff8:	6f6d2065 	svcvs	0x006d2065
    9ffc:	73737564 	cmnvc	r3, #100, 10	; 0x19000000
    a000:	697a6570 	ldmdbvs	sl!, {r4, r5, r6, r8, sl, sp, lr}^
    a004:	63736966 	cmnvs	r3, #1671168	; 0x198000
    a008:	52206568 	eorpl	r6, r0, #104, 10	; 0x1a000000
    a00c:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    a010:	20726574 	rsbscs	r6, r2, r4, ror r5
    a014:	0a3c3c3c 	beq	f1910c <STACK_BASE+0xe2910c>
    a018:	31250909 			; <UNDEFINED> instruction: 0x31250909
    a01c:	31257332 			; <UNDEFINED> instruction: 0x31257332
    a020:	20207332 	eorcs	r7, r0, r2, lsr r3
    a024:	52535053 	subspl	r5, r3, #83	; 0x53
    a028:	0000000a 	andeq	r0, r0, sl
    a02c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
    a030:	7379532f 	cmnvc	r9, #-1140850688	; 0xbc000000
    a034:	3a6d6574 	bcc	1b6360c <STACK_BASE+0x1a7360c>
    a038:	38302509 	ldmdacc	r0!, {r0, r3, r8, sl, sp}
    a03c:	25202070 	strcs	r2, [r0, #-112]!	; 0xffffff90
    a040:	0a703830 	beq	1c18108 <STACK_BASE+0x1b28108>
    a044:	00000000 	andeq	r0, r0, r0
    a048:	65707553 	ldrbvs	r7, [r0, #-1363]!	; 0xfffffaad
    a04c:	73697672 	cmnvc	r9, #119537664	; 0x7200000
    a050:	093a726f 	ldmdbeq	sl!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
    a054:	70383025 	eorsvc	r3, r8, r5, lsr #32
    a058:	30252020 	eorcc	r2, r5, r0, lsr #32
    a05c:	25097038 	strcs	r7, [r9, #-56]	; 0xffffffc8
    a060:	20733231 	rsbscs	r3, r3, r1, lsr r2
    a064:	32312520 	eorscc	r2, r1, #32, 10	; 0x8000000
    a068:	28202073 	stmdacs	r0!, {r0, r1, r4, r5, r6, sp}
    a06c:	29703825 	ldmdbcs	r0!, {r0, r2, r5, fp, ip, sp}^
    a070:	0000000a 	andeq	r0, r0, sl
    a074:	726f6241 	rsbvc	r6, pc, #268435460	; 0x10000004
    a078:	09093a74 	stmdbeq	r9, {r2, r4, r5, r6, r9, fp, ip, sp}
    a07c:	70383025 	eorsvc	r3, r8, r5, lsr #32
    a080:	30252020 	eorcc	r2, r5, r0, lsr #32
    a084:	25097038 	strcs	r7, [r9, #-56]	; 0xffffffc8
    a088:	20733231 	rsbscs	r3, r3, r1, lsr r2
    a08c:	32312520 	eorscc	r2, r1, #32, 10	; 0x8000000
    a090:	28202073 	stmdacs	r0!, {r0, r1, r4, r5, r6, sp}
    a094:	29703825 	ldmdbcs	r0!, {r0, r2, r5, fp, ip, sp}^
    a098:	0000000a 	andeq	r0, r0, sl
    a09c:	3a514946 	bcc	145c5bc <STACK_BASE+0x136c5bc>
    a0a0:	30250909 	eorcc	r0, r5, r9, lsl #18
    a0a4:	20207038 	eorcs	r7, r0, r8, lsr r0
    a0a8:	70383025 	eorsvc	r3, r8, r5, lsr #32
    a0ac:	32312509 	eorscc	r2, r1, #37748736	; 0x2400000
    a0b0:	25202073 	strcs	r2, [r0, #-115]!	; 0xffffff8d
    a0b4:	20733231 	rsbscs	r3, r3, r1, lsr r2
    a0b8:	38252820 	stmdacc	r5!, {r5, fp, sp}
    a0bc:	000a2970 	andeq	r2, sl, r0, ror r9
    a0c0:	3a515249 	bcc	145e9ec <STACK_BASE+0x136e9ec>
    a0c4:	30250909 	eorcc	r0, r5, r9, lsl #18
    a0c8:	20207038 	eorcs	r7, r0, r8, lsr r0
    a0cc:	70383025 	eorsvc	r3, r8, r5, lsr #32
    a0d0:	32312509 	eorscc	r2, r1, #37748736	; 0x2400000
    a0d4:	25202073 	strcs	r2, [r0, #-115]!	; 0xffffff8d
    a0d8:	20733231 	rsbscs	r3, r3, r1, lsr r2
    a0dc:	38252820 	stmdacc	r5!, {r5, fp, sp}
    a0e0:	000a2970 	andeq	r2, sl, r0, ror r9
    a0e4:	65646e55 	strbvs	r6, [r4, #-3669]!	; 0xfffff1ab
    a0e8:	656e6966 	strbvs	r6, [lr, #-2406]!	; 0xfffff69a
    a0ec:	25093a64 	strcs	r3, [r9, #-2660]	; 0xfffff59c
    a0f0:	20207038 	eorcs	r7, r0, r8, lsr r0
    a0f4:	09703825 	ldmdbeq	r0!, {r0, r2, r5, fp, ip, sp}^
    a0f8:	73323125 	teqvc	r2, #1073741833	; 0x40000009
    a0fc:	31252020 			; <UNDEFINED> instruction: 0x31252020
    a100:	20207332 	eorcs	r7, r0, r2, lsr r3
    a104:	70382528 	eorsvc	r2, r8, r8, lsr #10
    a108:	00000a29 	andeq	r0, r0, r9, lsr #20
    a10c:	2323230a 			; <UNDEFINED> instruction: 0x2323230a
    a110:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a114:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a118:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a11c:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a120:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a124:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a128:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a12c:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a130:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a134:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a138:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a13c:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a140:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a144:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a148:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a14c:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a150:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a154:	23232323 			; <UNDEFINED> instruction: 0x23232323
    a158:	2073250a 	rsbscs	r2, r3, sl, lsl #10
    a15c:	41207461 			; <UNDEFINED> instruction: 0x41207461
    a160:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    a164:	25206573 	strcs	r6, [r0, #-1395]!	; 0xfffffa8d
    a168:	0a703830 	beq	1c18230 <STACK_BASE+0x1b28230>
    a16c:	00000000 	andeq	r0, r0, r0
    a170:	7379530a 	cmnvc	r9, #671088640	; 0x28000000
    a174:	206d6574 	rsbcs	r6, sp, r4, ror r5
    a178:	65676e61 	strbvs	r6, [r7, #-3681]!	; 0xfffff19f
    a17c:	746c6168 	strbtvc	r6, [ip], #-360	; 0xfffffe98
    a180:	000a6e65 	andeq	r6, sl, r5, ror #28
    a184:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
    a188:	00000074 	andeq	r0, r0, r4, ror r0
    a18c:	65646e55 	strbvs	r6, [r4, #-3669]!	; 0xfffff1ab
    a190:	656e6966 	strbvs	r6, [lr, #-2406]!	; 0xfffff69a
    a194:	6e492064 	cdpvs	0, 4, cr2, cr9, cr4, {3}
    a198:	75727473 	ldrbvc	r7, [r2, #-1139]!	; 0xfffffb8d
    a19c:	6f697463 	svcvs	0x00697463
    a1a0:	0000006e 	andeq	r0, r0, lr, rrx
    a1a4:	74666f53 	strbtvc	r6, [r6], #-3923	; 0xfffff0ad
    a1a8:	65726177 	ldrbvs	r6, [r2, #-375]!	; 0xfffffe89
    a1ac:	746e4920 	strbtvc	r4, [lr], #-2336	; 0xfffff6e0
    a1b0:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    a1b4:	00007470 	andeq	r7, r0, r0, ror r4
    a1b8:	66657250 			; <UNDEFINED> instruction: 0x66657250
    a1bc:	68637465 	stmdavs	r3!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    a1c0:	6f624120 	svcvs	0x00624120
    a1c4:	00007472 	andeq	r7, r0, r2, ror r4
    a1c8:	61746144 	cmnvs	r4, r4, asr #2
    a1cc:	6f626120 	svcvs	0x00626120
    a1d0:	00007472 	andeq	r7, r0, r2, ror r4
    a1d4:	00000a21 	andeq	r0, r0, r1, lsr #20
    a1d8:	00515249 	subseq	r5, r1, r9, asr #4
    a1dc:	00514946 	subseq	r4, r1, r6, asr #18
    a1e0:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
    a1e4:	00000000 	andeq	r0, r0, r0
    a1e8:	65707553 	ldrbvs	r7, [r0, #-1363]!	; 0xfffffaad
    a1ec:	73697672 	cmnvc	r9, #119537664	; 0x7200000
    a1f0:	0000726f 	andeq	r7, r0, pc, ror #4
    a1f4:	726f6241 	rsbvc	r6, pc, #268435460	; 0x10000004
    a1f8:	00000074 	andeq	r0, r0, r4, ror r0
    a1fc:	65646e55 	strbvs	r6, [r4, #-3669]!	; 0xfffff1ab
    a200:	656e6966 	strbvs	r6, [lr, #-2406]!	; 0xfffff69a
    a204:	00000064 	andeq	r0, r0, r4, rrx
    a208:	74737953 	ldrbtvc	r7, [r3], #-2387	; 0xfffff6ad
    a20c:	00006d65 	andeq	r6, r0, r5, ror #26
    a210:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    a214:	74636172 	strbtvc	r6, [r3], #-370	; 0xfffffe8e
    a218:	20657669 	rsbcs	r7, r5, r9, ror #12
    a21c:	65646e75 	strbvs	r6, [r4, #-3701]!	; 0xfffff18b
    a220:	72702d72 	rsbsvc	r2, r0, #7296	; 0x1c80
    a224:	6172676f 	cmnvs	r2, pc, ror #14
    a228:	7369206d 	cmnvc	r9, #109	; 0x6d
    a22c:	74636120 	strbtvc	r6, [r3], #-288	; 0xfffffee0
    a230:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    a234:	00000a65 	andeq	r0, r0, r5, ror #20
    a238:	7469420a 	strbtvc	r4, [r9], #-522	; 0xfffffdf6
    a23c:	73206574 			; <UNDEFINED> instruction: 0x73206574
    a240:	65686369 	strbvs	r6, [r8, #-873]!	; 0xfffffc97
    a244:	65747372 	ldrbvs	r7, [r4, #-882]!	; 0xfffffc8e
    a248:	6e656c6c 	cdpvs	12, 6, cr6, cr5, cr12, {3}
    a24c:	6164202c 	cmnvs	r4, ip, lsr #32
    a250:	77207373 			; <UNDEFINED> instruction: 0x77207373
    a254:	72686561 	rsbvc	r6, r8, #406847488	; 0x18400000
    a258:	20646e65 	rsbcs	r6, r4, r5, ror #28
    a25c:	20726564 	rsbscs	r6, r2, r4, ror #10
    a260:	74736554 	ldrbtvc	r6, [r3], #-1364	; 0xfffffaac
    a264:	6e492073 	mcrvs	0, 2, r2, cr9, cr3, {3}
    a268:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    a26c:	73747075 	cmnvc	r4, #117	; 0x75
    a270:	206e6920 	rsbcs	r6, lr, r0, lsr #18
    a274:	72737561 	rsbsvc	r7, r3, #406847488	; 0x18400000
    a278:	68636965 	stmdavs	r3!, {r0, r2, r5, r6, r8, fp, sp, lr}^
    a27c:	65646e65 	strbvs	r6, [r4, #-3685]!	; 0xfffff19b
    a280:	654d0a72 	strbvs	r0, [sp, #-2674]	; 0xfffff58e
    a284:	2065676e 	rsbcs	r6, r5, lr, ror #14
    a288:	74667561 	strbtvc	r7, [r6], #-1377	; 0xfffffa9f
    a28c:	65746572 	ldrbvs	r6, [r4, #-1394]!	; 0xfffffa8e
    a290:	6e75206e 	cdpvs	0, 7, cr2, cr5, cr14, {3}
    a294:	75612064 	strbvc	r2, [r1, #-100]!	; 0xffffff9c
    a298:	64206863 	strtvs	r6, [r0], #-2147	; 0xfffff79d
    a29c:	68637275 	stmdavs	r3!, {r0, r2, r4, r5, r6, r9, ip, sp, lr}^
    a2a0:	63756520 	cmnvs	r5, #32, 10	; 0x8000000
    a2a4:	65622068 	strbvs	r2, [r2, #-104]!	; 0xffffff98
    a2a8:	646e6168 	strbtvs	r6, [lr], #-360	; 0xfffffe98
    a2ac:	20746c65 	rsbscs	r6, r4, r5, ror #24
    a2b0:	64726577 	ldrbtvs	r6, [r2], #-1399	; 0xfffffa89
    a2b4:	0a216e65 	beq	865c50 <STACK_BASE+0x775c50>
    a2b8:	6569440a 	strbvs	r4, [r9, #-1034]!	; 0xfffffbf6
    a2bc:	75614420 	strbvc	r4, [r1, #-1056]!	; 0xfffffbe0
    a2c0:	6a207265 	bvs	826c5c <STACK_BASE+0x736c5c>
    a2c4:	73656465 	cmnvc	r5, #1694498816	; 0x65000000
    a2c8:	73655420 	cmnvc	r5, #32, 8	; 0x20000000
    a2cc:	69207374 	stmdbvs	r0!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    a2d0:	61207473 			; <UNDEFINED> instruction: 0x61207473
    a2d4:	6765676e 	strbvs	r6, [r5, -lr, ror #14]!
    a2d8:	6e656265 	cdpvs	2, 6, cr6, cr5, cr5, {3}
    a2dc:	6557202e 	ldrbvs	r2, [r7, #-46]	; 0xffffffd2
    a2e0:	74686369 	strbtvc	r6, [r8], #-873	; 0xfffffc97
    a2e4:	65697320 	strbvs	r7, [r9, #-800]!	; 0xfffffce0
    a2e8:	61747320 	cmnvs	r4, r0, lsr #6
    a2ec:	61206b72 			; <UNDEFINED> instruction: 0x61206b72
    a2f0:	68202c62 	stmdavs	r0!, {r1, r5, r6, sl, fp, sp}
    a2f4:	20746261 	rsbscs	r6, r4, r1, ror #4
    a2f8:	0a726869 	beq	1ca44a4 <STACK_BASE+0x1bb44a4>
    a2fc:	72686177 	rsbvc	r6, r8, #-1073741795	; 0xc000001d
    a300:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    a304:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    a308:	65206863 	strvs	r6, [r0, #-2147]!	; 0xfffff79d
    a30c:	6e206e69 	cdpvs	14, 2, cr6, cr0, cr9, {3}
    a310:	74686369 	strbtvc	r6, [r8], #-873	; 0xfffffc97
    a314:	72756420 	rsbsvc	r6, r5, #32, 8	; 0x20000000
    a318:	64206863 	strtvs	r6, [r0], #-2147	; 0xfffff79d
    a31c:	54206569 	strtpl	r6, [r0], #-1385	; 0xfffffa97
    a320:	73747365 	cmnvc	r4, #-1811939327	; 0x94000001
    a324:	67626120 	strbvs	r6, [r2, -r0, lsr #2]!
    a328:	63656465 	cmnvs	r5, #1694498816	; 0x65000000
    a32c:	7365746b 	cmnvc	r5, #1795162112	; 0x6b000000
    a330:	6f725020 	svcvs	0x00725020
    a334:	6d656c62 	stclvs	12, cr6, [r5, #-392]!	; 0xfffffe78
    a338:	5a28202e 	bpl	a123f8 <STACK_BASE+0x9223f8>
    a33c:	6d656475 	cfstrdvs	mvd6, [r5, #-468]!	; 0xfffffe2c
    a340:	65616820 	strbvs	r6, [r1, #-2080]!	; 0xfffff7e0
    a344:	6e65676e 	cdpvs	7, 6, cr6, cr5, cr14, {3}
    a348:	5350430a 	cmppl	r0, #671088640	; 0x28000000
    a34c:	75202d52 	strvc	r2, [r0, #-3410]!	; 0xfffff2ae
    a350:	4720646e 	strmi	r6, [r0, -lr, ror #8]!
    a354:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    a358:	502d6c61 	eorpl	r6, sp, r1, ror #24
    a35c:	6f707275 	svcvs	0x00707275
    a360:	522d6573 	eorpl	r6, sp, #482344960	; 0x1cc00000
    a364:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    a368:	2d726574 	cfldr64cs	mvdx6, [r2, #-464]!	; 0xfffffe30
    a36c:	74736554 	ldrbtvc	r6, [r3], #-1364	; 0xfffffaac
    a370:	68657320 	stmdavs	r5!, {r5, r8, r9, ip, sp, lr}^
    a374:	6f762072 	svcvs	0x00762072
    a378:	6e69656e 	cdpvs	5, 6, cr6, cr9, cr14, {3}
    a37c:	65646e61 	strbvs	r6, [r4, #-3681]!	; 0xfffff19f
    a380:	62612072 	rsbvs	r2, r1, #114	; 0x72
    a384:	5043203a 	subpl	r2, r3, sl, lsr r0
    a388:	542d5253 	strtpl	r5, [sp], #-595	; 0xfffffdad
    a38c:	20747365 	rsbscs	r7, r4, r5, ror #6
    a390:	75617262 	strbvc	r7, [r1, #-610]!	; 0xfffffd9e
    a394:	0a746863 	beq	1d24528 <STACK_BASE+0x1c34528>
    a398:	69676552 	stmdbvs	r7!, {r1, r4, r6, r8, sl, sp, lr}^
    a39c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    a3a0:	6552202c 	ldrbvs	r2, [r2, #-44]	; 0xffffffd4
    a3a4:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
    a3a8:	542d7265 	strtpl	r7, [sp], #-613	; 0xfffffd9b
    a3ac:	20747365 	rsbscs	r7, r4, r5, ror #6
    a3b0:	75617262 	strbvc	r7, [r1, #-610]!	; 0xfffffd9e
    a3b4:	46206863 	strtmi	r6, [r0], -r3, ror #16
    a3b8:	7367616c 	cmnvc	r7, #108, 2
    a3bc:	6c41202e 	mcrrvs	0, 2, r2, r1, cr14
    a3c0:	52206f73 	eorpl	r6, r0, #460	; 0x1cc
    a3c4:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    a3c8:	64726574 	ldrbtvs	r6, [r2], #-1396	; 0xfffffa8c
    a3cc:	20706d75 	rsbscs	r6, r0, r5, ror sp
    a3d0:	7469726b 	strbtvc	r7, [r9], #-619	; 0xfffffd95
    a3d4:	68637369 	stmdavs	r3!, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
    a3d8:	74656220 	strbtvc	r6, [r5], #-544	; 0xfffffde0
    a3dc:	68636172 	stmdavs	r3!, {r1, r4, r5, r6, r8, sp, lr}^
    a3e0:	2e6e6574 	mcrcs	5, 3, r6, cr14, cr4, {3}
    a3e4:	570a0a29 	strpl	r0, [sl, -r9, lsr #20]
    a3e8:	206e6e65 	rsbcs	r6, lr, r5, ror #28
    a3ec:	656e6965 	strbvs	r6, [lr, #-2405]!	; 0xfffff69b
    a3f0:	73694d20 	cmnvc	r9, #32, 26	; 0x800
    a3f4:	61747373 	cmnvs	r4, r3, ror r3
    a3f8:	6620646e 	strtvs	r6, [r0], -lr, ror #8
    a3fc:	67747365 	ldrbvs	r7, [r4, -r5, ror #6]!
    a400:	65747365 	ldrbvs	r7, [r4, #-869]!	; 0xfffffc9b
    a404:	20746c6c 	rsbscs	r6, r4, ip, ror #24
    a408:	64726977 	ldrbtvs	r6, [r2], #-2423	; 0xfffff689
    a40c:	6977202c 	ldmdbvs	r7!, {r2, r3, r5, sp}^
    a410:	65206472 	strvs	r6, [r0, #-1138]!	; 0xfffffb8e
    a414:	20656e69 	rsbcs	r6, r5, r9, ror #28
    a418:	65646e55 	strbvs	r6, [r4, #-3669]!	; 0xfffff1ab
    a41c:	78452d66 	stmdavc	r5, {r1, r2, r5, r6, r8, sl, fp, sp}^
    a420:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
    a424:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    a428:	67737561 	ldrbvs	r7, [r3, -r1, ror #10]!
    a42c:	b6c36c65 	strblt	r6, [r3], r5, ror #24
    a430:	0a2e7473 	beq	ba7604 <STACK_BASE+0xab7604>
    a434:	7474694d 	ldrbtvc	r6, [r4], #-2381	; 0xfffff6b3
    a438:	20736c65 	rsbscs	r6, r3, r5, ror #24
    a43c:	646a626f 	strbtvs	r6, [sl], #-623	; 0xfffffd91
    a440:	2c706d75 	ldclcs	13, cr6, [r0], #-468	; 0xfffffe2c
    a444:	65755120 	ldrbvs	r5, [r5, #-288]!	; 0xfffffee0
    a448:	6e656c6c 	cdpvs	12, 6, cr6, cr5, cr12, {3}
    a44c:	646e7520 	strbtvs	r7, [lr], #-1312	; 0xfffffae0
    a450:	67655220 	strbvs	r5, [r5, -r0, lsr #4]!
    a454:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    a458:	74617372 	strbtvc	r7, [r1], #-882	; 0xfffffc8e
    a45c:	6f73207a 	svcvs	0x0073207a
    a460:	65746c6c 	ldrbvs	r6, [r4, #-3180]!	; 0xfffff394
    a464:	63697320 	cmnvs	r9, #32, 6	; 0x80000000
    a468:	61642068 	cmnvs	r4, r8, rrx
    a46c:	72502073 	subsvc	r2, r0, #115	; 0x73
    a470:	656c626f 	strbvs	r6, [ip, #-623]!	; 0xfffffd91
    a474:	6965206d 	stmdbvs	r5!, {r0, r2, r3, r5, r6, sp}^
    a478:	65726b6e 	ldrbvs	r6, [r2, #-2926]!	; 0xfffff492
    a47c:	6e657369 	cdpvs	3, 6, cr7, cr5, cr9, {3}
    a480:	73616c0a 	cmnvc	r1, #2560	; 0xa00
    a484:	2e6e6573 	mcrcs	5, 3, r6, cr14, cr3, {3}
    a488:	41280a0a 			; <UNDEFINED> instruction: 0x41280a0a
    a48c:	20656c6c 	rsbcs	r6, r5, ip, ror #24
    a490:	61676e41 	cmnvs	r7, r1, asr #28
    a494:	206e6562 	rsbcs	r6, lr, r2, ror #10
    a498:	656e686f 	strbvs	r6, [lr, #-2159]!	; 0xfffff791
    a49c:	77654720 	strbvc	r4, [r5, -r0, lsr #14]!
    a4a0:	72686561 	rsbvc	r6, r8, #406847488	; 0x18400000
    a4a4:	0a0a292e 	beq	294964 <STACK_BASE+0x1a4964>
    a4a8:	00000000 	andeq	r0, r0, r0
    a4ac:	203e3e3e 	eorscs	r3, lr, lr, lsr lr
    a4b0:	7a6f7250 	bvc	1be6df8 <STACK_BASE+0x1af6df8>
    a4b4:	6f737365 	svcvs	0x00737365
    a4b8:	73692072 	cmnvc	r9, #114	; 0x72
    a4bc:	6d692074 	stclvs	0, cr2, [r9, #-464]!	; 0xfffffe30
    a4c0:	51524920 	cmppl	r2, r0, lsr #18
    a4c4:	646f4d2d 	strbtvs	r4, [pc], #-3373	; a4cc <.LANCHOR0+0x910>
    a4c8:	3d207375 	stccc	3, cr7, [r0, #-468]!	; 0xfffffe2c
    a4cc:	524c203e 	subpl	r2, ip, #62	; 0x3e
    a4d0:	646e7520 	strbtvs	r7, [lr], #-1312	; 0xfffffae0
    a4d4:	53505320 	cmppl	r0, #32, 6	; 0x80000000
    a4d8:	65762052 	ldrbvs	r2, [r6, #-82]!	; 0xffffffae
    a4dc:	726f6c72 	rsbvc	r6, pc, #29184	; 0x7200
    a4e0:	6e206e65 	cdpvs	14, 2, cr6, cr0, cr5, {3}
    a4e4:	20686361 	rsbcs	r6, r8, r1, ror #6
    a4e8:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    a4ec:	70757272 	rsbsvc	r7, r5, r2, ror r2
    a4f0:	3e3e0a74 			; <UNDEFINED> instruction: 0x3e3e0a74
    a4f4:	4928203e 	stmdbmi	r8!, {r1, r2, r3, r4, r5, sp}
    a4f8:	6562736e 	strbvs	r7, [r2, #-878]!	; 0xfffffc92
    a4fc:	646e6f73 	strbtvs	r6, [lr], #-3955	; 0xfffff08d
    a500:	20657265 	rsbcs	r7, r5, r5, ror #4
    a504:	74686567 	strbtvc	r6, [r8], #-1383	; 0xfffffa99
    a508:	72656420 	rsbvc	r6, r5, #32, 8	; 0x20000000
    a50c:	bcc35220 	sfmlt	f5, 2, [r3], {32}
    a510:	70736b63 	rsbsvc	r6, r3, r3, ror #22
    a514:	676e7572 			; <UNDEFINED> instruction: 0x676e7572
    a518:	73756120 	cmnvc	r5, #32, 2
    a51c:	6d656420 	cfstrdvs	mvd6, [r5, #-128]!	; 0xffffff80
    a520:	73726520 	cmnvc	r2, #32, 10	; 0x8000000
    a524:	206e6574 	rsbcs	r6, lr, r4, ror r5
    a528:	74736554 	ldrbtvc	r6, [r3], #-1364	; 0xfffffaac
    a52c:	68637320 	stmdavs	r3!, {r5, r8, r9, ip, sp, lr}^
    a530:	2e666569 	cdpcs	5, 6, cr6, cr6, cr9, {3}
    a534:	3e0a0a29 	vmlacc.f32	s0, s20, s19
    a538:	41203e3e 			; <UNDEFINED> instruction: 0x41203e3e
    a53c:	75726262 	ldrbvc	r6, [r2, #-610]!	; 0xfffffd9e
    a540:	0a216863 	beq	8646d4 <STACK_BASE+0x7746d4>
    a544:	00000000 	andeq	r0, r0, r0
    a548:	65757250 	ldrbvs	r7, [r5, #-592]!	; 0xfffffdb0
    a54c:	72206566 	eorvc	r6, r0, #427819008	; 0x19800000
    a550:	74686369 	strbtvc	r6, [r8], #-873	; 0xfffffc97
    a554:	20656769 	rsbcs	r6, r5, r9, ror #14
    a558:	63657552 	cmnvs	r5, #343932928	; 0x14800000
    a55c:	7270736b 	rsbsvc	r7, r0, #-1409286143	; 0xac000001
    a560:	2d676e75 	stclcs	14, cr6, [r7, #-468]!	; 0xfffffe2c
    a564:	65726441 	ldrbvs	r6, [r2, #-1089]!	; 0xfffffbbf
    a568:	20657373 	rsbcs	r7, r5, r3, ror r3
    a56c:	2e616328 	cdpcs	3, 6, cr6, cr1, cr8, {1}
    a570:	53203520 			; <UNDEFINED> instruction: 0x53203520
    a574:	6e756b65 	vsubvs.f64	d22, d5, d21
    a578:	296e6564 	stmdbcs	lr!, {r2, r5, r6, r8, sl, sp, lr}^
    a57c:	0000000a 	andeq	r0, r0, sl
    a580:	65757250 	ldrbvs	r7, [r5, #-592]!	; 0xfffffdb0
    a584:	61206566 			; <UNDEFINED> instruction: 0x61206566
    a588:	52206675 	eorpl	r6, r0, #122683392	; 0x7500000
    a58c:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    a590:	2d726574 	cfldr64cs	mvdx6, [r2, #-464]!	; 0xfffffe30
    a594:	646e6541 	strbtvs	r6, [lr], #-1345	; 0xfffffabf
    a598:	6e757265 	cdpvs	2, 7, cr7, cr5, cr5, {3}
    a59c:	206e6567 	rsbcs	r6, lr, r7, ror #10
    a5a0:	2d305228 	lfmcs	f5, 4, [r0, #-160]!	; 0xffffff60
    a5a4:	2c343152 	ldfcss	f3, [r4], #-328	; 0xfffffeb8
    a5a8:	2e616320 	cdpcs	3, 6, cr6, cr1, cr0, {1}
    a5ac:	20303120 	eorscs	r3, r0, r0, lsr #2
    a5b0:	756b6553 	strbvc	r6, [fp, #-1363]!	; 0xfffffaad
    a5b4:	6e65646e 	cdpvs	4, 6, cr6, cr5, cr14, {3}
    a5b8:	00000a29 	andeq	r0, r0, r9, lsr #20
    a5bc:	3e3e3e0a 	cdpcc	14, 3, cr3, cr14, cr10, {0}
    a5c0:	6f725020 	svcvs	0x00725020
    a5c4:	7373657a 	cmnvc	r3, #511705088	; 0x1e800000
    a5c8:	6920726f 	stmdbvs	r0!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
    a5cc:	69207473 	stmdbvs	r0!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}
    a5d0:	7355206d 	cmpvc	r5, #109	; 0x6d
    a5d4:	4d2d7265 	sfmmi	f7, 4, [sp, #-404]!	; 0xfffffe6c
    a5d8:	7375646f 	cmnvc	r5, #1862270976	; 0x6f000000
    a5dc:	203e3d20 	eorscs	r3, lr, r0, lsr #26
    a5e0:	6e69654b 	cdpvs	5, 6, cr6, cr9, cr11, {2}
    a5e4:	72502065 	subsvc	r2, r0, #101	; 0x65
    a5e8:	75666575 	strbvc	r6, [r6, #-1397]!	; 0xfffffa8b
    a5ec:	6120676e 			; <UNDEFINED> instruction: 0x6120676e
    a5f0:	43206675 			; <UNDEFINED> instruction: 0x43206675
    a5f4:	2d525350 	ldclcs	3, cr5, [r2, #-320]	; 0xfffffec0
    a5f8:	646e6541 	strbtvs	r6, [lr], #-1345	; 0xfffffabf
    a5fc:	6e757265 	cdpvs	2, 7, cr7, cr5, cr5, {3}
    a600:	2c6e6567 	cfstr64cs	mvdx6, [lr], #-412	; 0xfffffe64
    a604:	3e3e3e0a 	cdpcc	14, 3, cr3, cr14, cr10, {0}
    a608:	20616420 	rsbcs	r6, r1, r0, lsr #8
    a60c:	74726f64 	ldrbtvc	r6, [r2], #-3940	; 0xfffff09c
    a610:	646f4d20 	strbtvs	r4, [pc], #-3360	; a618 <.LANCHOR0+0xa5c>
    a614:	422d7375 	eormi	r7, sp, #-738197503	; 0xd4000001
    a618:	20737469 	rsbscs	r7, r3, r9, ror #8
    a61c:	a4c36567 	strbge	r6, [r3], #1383	; 0x567
    a620:	7265646e 	rsbvc	r6, r5, #1845493760	; 0x6e000000
    a624:	65772074 	ldrbvs	r2, [r7, #-116]!	; 0xffffff8c
    a628:	6e656472 	mcrvs	4, 3, r6, cr5, cr2, {3}
    a62c:	5728202e 	strpl	r2, [r8, -lr, lsr #32]!
    a630:	77206569 	strvc	r6, [r0, -r9, ror #10]!
    a634:	6572a4c3 	ldrbvs	sl, [r2, #-1219]!	; 0xfffffb3d
    a638:	20736520 	rsbscs	r6, r3, r0, lsr #10
    a63c:	2074696d 	rsbscs	r6, r4, sp, ror #18
    a640:	206d6564 	rsbcs	r6, sp, r4, ror #10
    a644:	74737953 	ldrbtvc	r7, [r3], #-2387	; 0xfffff6ad
    a648:	4d2d6d65 	stcmi	13, cr6, [sp, #-404]!	; 0xfffffe6c
    a64c:	7375646f 	cmnvc	r5, #1862270976	; 0x6f000000
    a650:	0a0a293f 	beq	294b54 <STACK_BASE+0x1a4b54>
    a654:	00000000 	andeq	r0, r0, r0
    a658:	65757250 	ldrbvs	r7, [r5, #-592]!	; 0xfffffdb0
    a65c:	61206566 			; <UNDEFINED> instruction: 0x61206566
    a660:	43206675 			; <UNDEFINED> instruction: 0x43206675
    a664:	2d525350 	ldclcs	3, cr5, [r2, #-320]	; 0xfffffec0
    a668:	646e6541 	strbtvs	r6, [lr], #-1345	; 0xfffffabf
    a66c:	6e757265 	cdpvs	2, 7, cr7, cr5, cr5, {3}
    a670:	206e6567 	rsbcs	r6, lr, r7, ror #10
    a674:	2e616328 	cdpcs	3, 6, cr6, cr1, cr8, {1}
    a678:	20353120 	eorscs	r3, r5, r0, lsr #2
    a67c:	756b6553 	strbvc	r6, [fp, #-1363]!	; 0xfffffaad
    a680:	6e65646e 	cdpvs	4, 6, cr6, cr5, cr14, {3}
    a684:	00000a29 	andeq	r0, r0, r9, lsr #20
    a688:	3e3e3e0a 	cdpcc	14, 3, cr3, cr14, cr10, {0}
    a68c:	6f725020 	svcvs	0x00725020
    a690:	7373657a 	cmnvc	r3, #511705088	; 0x1e800000
    a694:	6920726f 	stmdbvs	r0!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
    a698:	69207473 	stmdbvs	r0!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}
    a69c:	7355206d 	cmpvc	r5, #109	; 0x6d
    a6a0:	202d7265 	eorcs	r7, sp, r5, ror #4
    a6a4:	7265646f 	rsbvc	r6, r5, #1862270976	; 0x6f000000
    a6a8:	73795320 	cmnvc	r9, #32, 6	; 0x80000000
    a6ac:	2d6d6574 	cfstr64cs	mvdx6, [sp, #-464]!	; 0xfffffe30
    a6b0:	75646f4d 	strbvc	r6, [r4, #-3917]!	; 0xfffff0b3
    a6b4:	3e3d2073 	mrccc	0, 1, r2, cr13, cr3, {3}
    a6b8:	69654b20 	stmdbvs	r5!, {r5, r8, r9, fp, lr}^
    a6bc:	5020656e 	eorpl	r6, r0, lr, ror #10
    a6c0:	66657572 			; <UNDEFINED> instruction: 0x66657572
    a6c4:	20676e75 	rsbcs	r6, r7, r5, ror lr
    a6c8:	20667561 	rsbcs	r7, r6, r1, ror #10
    a6cc:	52535053 	subspl	r5, r3, #83	; 0x53
    a6d0:	6e65412d 	powvssp	f4, f5, #5.0
    a6d4:	75726564 	ldrbvc	r6, [r2, #-1380]!	; 0xfffffa9c
    a6d8:	6e65676e 	cdpvs	7, 6, cr6, cr5, cr14, {3}
    a6dc:	3e3e0a2c 	vaddcc.f32	s0, s28, s25
    a6e0:	6164203e 	cmnvs	r4, lr, lsr r0
    a6e4:	20736520 	rsbscs	r6, r3, r0, lsr #10
    a6e8:	73656964 	cmnvc	r5, #100, 18	; 0x190000
    a6ec:	52207365 	eorpl	r7, r0, #-1811939327	; 0x94000001
    a6f0:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    a6f4:	20726574 	rsbscs	r6, r2, r4, ror r5
    a6f8:	6863696e 	stmdavs	r3!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
    a6fc:	69672074 	stmdbvs	r7!, {r2, r4, r5, r6, sp}^
    a700:	202e7462 	eorcs	r7, lr, r2, ror #8
    a704:	65695728 	strbvs	r5, [r9, #-1832]!	; 0xfffff8d8
    a708:	a4c37720 	strbge	r7, [r3], #1824	; 0x720
    a70c:	65206572 	strvs	r6, [r0, #-1394]!	; 0xfffffa8e
    a710:	696d2073 	stmdbvs	sp!, {r0, r1, r4, r5, r6, sp}^
    a714:	65642074 	strbvs	r2, [r4, #-116]!	; 0xffffff8c
    a718:	7553206d 	ldrbvc	r2, [r3, #-109]	; 0xffffff93
    a71c:	76726570 			; <UNDEFINED> instruction: 0x76726570
    a720:	726f7369 	rsbvc	r7, pc, #-1543503871	; 0xa4000001
    a724:	646f4d2d 	strbtvs	r4, [pc], #-3373	; a72c <.LANCHOR0+0xb70>
    a728:	293f7375 	ldmdbcs	pc!, {r0, r2, r4, r5, r6, r8, r9, ip, sp, lr}	; <UNPREDICTABLE>
    a72c:	00000a0a 	andeq	r0, r0, sl, lsl #20
    a730:	65757250 	ldrbvs	r7, [r5, #-592]!	; 0xfffffdb0
    a734:	61206566 			; <UNDEFINED> instruction: 0x61206566
    a738:	53206675 			; <UNDEFINED> instruction: 0x53206675
    a73c:	2d525350 	ldclcs	3, cr5, [r2, #-320]	; 0xfffffec0
    a740:	646e6541 	strbtvs	r6, [lr], #-1345	; 0xfffffabf
    a744:	6e757265 	cdpvs	2, 7, cr7, cr5, cr5, {3}
    a748:	206e6567 	rsbcs	r6, lr, r7, ror #10
    a74c:	2e616328 	cdpcs	3, 6, cr6, cr1, cr8, {1}
    a750:	20353120 	eorscs	r3, r5, r0, lsr #2
    a754:	756b6553 	strbvc	r6, [fp, #-1363]!	; 0xfffffaad
    a758:	6e65646e 	cdpvs	4, 6, cr6, cr5, cr14, {3}
    a75c:	00000a29 	andeq	r0, r0, r9, lsr #20
    a760:	74726546 	ldrbtvc	r6, [r2], #-1350	; 0xfffffaba
    a764:	20216769 	eorcs	r6, r1, r9, ror #14
    a768:	5f207345 	svcpl	0x00207345
    a76c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    a770:	5f746e69 	svcpl	0x00746e69
    a774:	2c6f7320 	stclcs	3, cr7, [pc], #-128	; a6fc <.LANCHOR0+0xb40>
    a778:	736c6120 	cmnvc	ip, #32, 2
    a77c:	65757720 	ldrbvs	r7, [r5, #-1824]!	; 0xfffff8e0
    a780:	20656472 	rsbcs	r6, r5, r2, ror r4
    a784:	66207365 	strtvs	r7, [r0], -r5, ror #6
    a788:	746b6e75 	strbtvc	r6, [fp], #-3701	; 0xfffff18b
    a78c:	696e6f69 	stmdbvs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    a790:	6e657265 	cdpvs	2, 6, cr7, cr5, cr5, {3}
    a794:	00000a2e 	andeq	r0, r0, lr, lsr #20
    a798:	66667542 	strbtvs	r7, [r6], -r2, asr #10
    a79c:	76207265 	strtvc	r7, [r0], -r5, ror #4
    a7a0:	206c6c6f 	rsbcs	r6, ip, pc, ror #24
    a7a4:	6b202121 	blvs	812c30 <STACK_BASE+0x722c30>
    a7a8:	206e6e61 	rsbcs	r6, lr, r1, ror #28
    a7ac:	6e69656b 	cdpvs	5, 6, cr6, cr9, cr11, {3}
    a7b0:	65772065 	ldrbvs	r2, [r7, #-101]!	; 0xffffff9b
    a7b4:	72657469 	rsbvc	r7, r5, #1761607680	; 0x69000000
    a7b8:	5a206e65 	bpl	826154 <STACK_BASE+0x736154>
    a7bc:	68636965 	stmdavs	r3!, {r0, r2, r5, r6, r8, fp, sp, lr}^
    a7c0:	73206e65 			; <UNDEFINED> instruction: 0x73206e65
    a7c4:	63696570 	cmnvs	r9, #112, 10	; 0x1c000000
    a7c8:	6e726568 	cdpvs	5, 7, cr6, cr2, cr8, {3}
    a7cc:	0000000a 	andeq	r0, r0, sl

Disassembly of section .bss:

0000a7d0 <IRQ_Debug>:
    a7d0:	00000000 	andeq	r0, r0, r0

0000a7d4 <str>:
	...

0000a7e0 <interactive_on>:
    a7e0:	00000000 	andeq	r0, r0, r0

0000a7e4 <offset>:
    a7e4:	00000000 	andeq	r0, r0, r0

0000a7e8 <tmp>:
	...

0000a9e8 <j>:
    a9e8:	00000000 	andeq	r0, r0, r0

0000a9ec <buff>:
	...

0000abec <i>:
    abec:	00000000 	andeq	r0, r0, r0

0000abf0 <len>:
    abf0:	00000000 	andeq	r0, r0, r0

0000abf4 <buf>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00003041 	andeq	r3, r0, r1, asr #32
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000026 	andeq	r0, r0, r6, lsr #32
  10:	45563705 	ldrbmi	r3, [r6, #-1797]	; 0xfffff8fb
  14:	070a0600 	streq	r0, [sl, -r0, lsl #12]
  18:	09010841 	stmdbeq	r1, {r0, r6, fp}
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <buf+0x3b444>
  28:	2a012201 	bcs	48834 <buf+0x3dc40>
  2c:	44022c01 	strmi	r2, [r2], #-3073	; 0xfffff3ff
  30:	Address 0x0000000000000030 is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <STACK_BASE+0xfe0d24>
   4:	4e472820 	cdpmi	8, 4, cr2, cr7, cr0, {1}
   8:	38202955 	stmdacc	r0!, {r0, r2, r4, r6, r8, fp, sp}
   c:	302e332e 	eorcc	r3, lr, lr, lsr #6
	...
