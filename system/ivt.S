.global ivt
.balign 32

ivt:
      b     _reset
      ldr   pc, _undefined_instruction
      ldr   pc, _software_interrupt
      ldr   pc, _prefetch_abort
      ldr   pc, _data_abort
      ldr   pc, _not_used
      ldr   pc, _irq
      ldr   pc, _fiq

_reset:                 .word reset
_undefined_instruction: .word undefined_instruction
_software_interrupt:    .word software_interrupt
_prefetch_abort:        .word prefetch_abort
_data_abort:            .word data_abort
_not_used:              .word not_used
_irq:                   .word irq
_fiq:                   .word fiq


reset:
/*	mrc p15, 0, r0, c0, c0, 5*/
/*     ldr	sp,=0xA0000 */
    bl yellow_on
    b       reset_handler

undefined_instruction:
    ldr	sp,=0x20000
    bl yellow_on

/*    sub     lr, lr, #4
    push    {r0-r3, r12, lr}*/
    bl      undefined_instruction_handler
    ldmfd   sp!, {r1,lr}
    
software_interrupt:
    ldr	sp,=0x20000
    bl yellow_on
/*    sub     lr, lr, #4
    push    {r0-r3, r12, lr}
    and     r1, sp, #4
    sub     sp, sp, r1
    push    {r1}*/
    bl      software_interrupt_handler
/*    pop     {r1}
    add     sp, sp, r1
    pop     {r0-r3, r12, lr}
    rfeia   sp!*/
    
prefetch_abort:
    ldr	sp,=0x20000
    bl yellow_on
/*    sub     lr, lr, #4
    push    {r0-r3, r12, lr}
    and     r1, sp, #4
    sub     sp, sp, r1
    push    {r1}*/
    bl      prefetch_abort_handler
/*    pop     {r1}
    add     sp, sp, r1
    pop     {r0-r3, r12, lr}
    rfeia   sp!*/
    
data_abort:
    ldr	sp,=0x20000
    bl yellow_on
/*    sub     lr, lr, #4
    push    {r0-r3, r12, lr}
    and     r1, sp, #4
    sub     sp, sp, r1
    push    {r1}*/
    bl      data_abort_handler
/*    pop     {r1}
    add     sp, sp, r1
    pop     {r0-r3, r12, lr}
    rfeia   sp!*/
    
not_used:
    ldr	sp,=0x20000
    bl yellow_on
/*    sub     lr, lr, #4
    push    {r0-r3, r12, lr}
    and     r1, sp, #4
    sub     sp, sp, r1
    push    {r1}*/
    bl      not_used_handler
/*    pop     {r1}
    add     sp, sp, r1
    pop     {r0-r3, r12, lr}
    rfeia   sp!*/
    
irq:
    ldr	sp,=0x20000
    bl yellow_on
/*    sub     lr, lr, #4
    push    {r0-r3, r12, lr}
    and     r1, sp, #4
    sub     sp, sp, r1
    push    {r1}*/
    bl      irq_handler
/*    pop     {r1}
    add     sp, sp, r1
    pop     {r0-r3, r12, lr}
    rfeia   sp!*/

fiq:
    ldr	sp,=0x20000
    bl yellow_on

    bl      fiq_handler
    sub     lr, lr, #4
    push    {r0-r3, r12, lr}
