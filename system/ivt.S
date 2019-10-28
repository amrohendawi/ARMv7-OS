mcr p15, 0, r0, c12, c0, 0    @ set IVT address in r0

.global _start

_start:
      b     reset
      ldr   pc, _undefined_instruction
      ldr   pc, _software_interrupt
      ldr   pc, _prefetch_abort
      ldr   pc, _data_abort
      ldr   pc, _not_used
      ldr   pc, _irq
      ldr   pc, _fiq

_undefined_instruction: .word undefined_instruction
_software_interrupt:    .word software_interrupt
_prefetch_abort:        .word prefetch_abort
_data_abort:            .word data_abort
_not_used:              .word not_used
_irq:                   .word irq
_fiq:                   .word fiq
