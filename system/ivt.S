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
/*     bl yellow_on */
    b       reset_handler

undefined_instruction:
    sub     lr, lr, #4
    stm     sp,{r0-r12, lr}
    mov     r0, sp
    mov     r1, r15
    bl      undefined_instruction_handler
    ldm     sp,{r0-r12, lr}
    movs         pc, lr
    
software_interrupt:
    sub     lr, lr, #4
    stm     sp,{r0-r12, lr}
    mov     r0, sp
    mov     r1, r15
    bl      software_interrupt_handler
    ldm     sp,{r0-r12,lr}
    movs         pc, lr
    
prefetch_abort:
    sub     lr, lr, #4
    stm     sp,{r0-r12, lr}
    mov     r0, sp
    mov     r1, r15
    bl      prefetch_abort_handler
    ldm     sp,{r0-r12,lr}
    movs         pc, lr
    
data_abort:
    sub     lr, lr, #8
    stm     sp,{r0-r12, lr}
    mov     r0, sp
    mov     r1, r15
    bl      data_abort_handler
    ldm     sp,{r0-r12,lr}^
    movs         pc, lr
    
/* leer*/
not_used:

    
irq:
    sub     lr, lr, #8
    stm     sp,{r0-r12, lr}
    mov     r0, sp
    mov     r1, r15
    bl      irq_handler
    ldm     sp,{r0-r12, lr}
    movs         pc, lr

fiq:
    sub     lr, lr, #8
    stm     sp,{r0-r12, lr}
    mov     r0, sp
    mov     r1, r15
    bl      fiq_handler
    ldm     sp,{r0-r12,lr}
    movs         pc, lr
    

    

