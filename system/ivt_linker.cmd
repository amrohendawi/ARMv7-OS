00000000 <_start>:
0: ea00000d b 3c <reset>
4: e59ff014 ldr pc, [pc,#20] ;20 <_undefined_instruction>
8: e59ff014 ldr pc, [pc,#20] ;24 <_software_interrupt>
c: e59ff014 ldr pc, [pc,#20] ;28 <_prefetch_abort>
10: e59ff014 ldr pc, [pc,#20] ;2c <_data_abort>
14: e59ff014 ldr pc, [pc,#20] ;30 <_not_used>
18: e59ff014 ldr pc, [pc,#20] ;34 <_irq>
1c: e59ff014 ldr pc, [pc,#20] ;38 <_fiq>
00000020 <_undefined_instruction>:
20: 00000000 andeq r0, r0, r0
00000024 <_software_interrupt>:
24: 00000000 andeq r0, r0, r0
00000028 <_prefetch_abort>:
28: 00000000 andeq r0, r0, r0
0000002c <_data_abort>:
2c: 00000000 andeq r0, r0, r0
00000030 <_not_used>:
30: 00000000 andeq r0, r0, r0
00000034 <_irq>:
34: 00000000 andeq r0, r0, r0
00000038 <_fiq>:
38: 00000000 andeq r0, r0, r0