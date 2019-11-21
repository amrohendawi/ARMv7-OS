#ifndef INTERRUPTS_HANDLER_H
#define INTERRUPTS_HANDLER_H

void reset_handler();
void undefined_instruction_handler();
void software_interrupt_handler();
void prefetch_abort_handler();
void data_abort_handler();
void irq_handler();
void fiq_handler();

void set_IRQ_DEBUG(int value);


#endif
