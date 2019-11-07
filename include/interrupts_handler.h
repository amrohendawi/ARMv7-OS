#ifndef INTERRUPTS_HANDLER_H
#define INTERRUPTS_HANDLER_H
#define INTERRUPT_BASE (0x7E00B000 + 0x200 - 0x3F000000)

static volatile struct interrupts_base * const _interrupts = (struct interrupts_base *)INTERRUPT_BASE;

void reset_handler();
void undefined_instruction_handler();
void software_interrupt_handler();
void prefetch_abort_handler();
void data_abort_handler();
void irq_handler();
void fiq_handler();

void set_IRQ_DEBUG(int value);


#endif
