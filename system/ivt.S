.section .text
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
    ldr sp,=0x20000
    bl yellow_on
    b       reset_handler

undefined_instruction:
    ldr	sp,=0x30000
    sub     lr, lr, #4
    stm     sp,{r0-r12, lr}^
    mov    r0, sp
    bl      undefined_instruction_handler
    ldm     sp,{r0-r12,lr}^
    movs         pc, lr
    
software_interrupt:
    ldr	sp,=0x40000
    sub     lr, lr, #4
    stm     sp,{r0-r12, lr,r15}
    mrs     r0, sp_svc
    mrs     r3, spsr_svc
    bl      software_interrupt_handler
    ldm     sp,{r0-r12,lr}^
    movs         pc, lr


    
prefetch_abort:
    ldr	sp,=0x50000
    sub     lr, lr, #4
    stm     sp,{r0-r12, lr}
    mov    r0, sp
    bl      prefetch_abort_handler
    ldm     sp,{r0-r12,lr}^
    movs         pc, lr
    
data_abort:
    ldr	sp,=0x60000
    sub     lr, lr, #8
    stm     sp,{r0-r12, lr}
    mov    r0, sp
    bl      data_abort_handler
    ldm     sp,{r0-r12,lr}^
    movs         pc, lr
/* leer*/
not_used:

    
irq:
    ldr	sp,=0x70000
    sub     lr, lr, #8
    stm     sp,{r0-r12, lr}
    mov    r0, sp
    bl      irq_handler
    ldm     sp,{r0-r12,lr}^
    movs         pc, lr

fiq:
    ldr	sp,=0x80000
    sub     lr, lr, #8
    stm     sp,{r0-r12, lr}
    mov    r0, sp
    bl      fiq_handler
    ldm     sp,{r0-r12,lr}^
    movs         pc, lr
    
    
