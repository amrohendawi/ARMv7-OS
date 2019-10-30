#ifndef INTERRUPTS_HANDLER_H
#define INTERRUPTS_HANDLER_H
#define INTERRUPT_BASE (0x7E00B000 + 0x200 - 0x3F000000)

struct interrupts_base {
    volatile unsigned int IRQ_basic_pending;
    volatile unsigned int IRQ_pending_1;
    volatile unsigned int IRQ_pending_2;
    volatile unsigned int FIQ_control;
    volatile unsigned int enable_IRQs_1;
    volatile unsigned int enable_IRQs_2;
    volatile unsigned int enable_basic_IRQs;
    volatile unsigned int disable_IRQs_1;
    volatile unsigned int disable_IRQs_2;
    volatile unsigned int disable_basic_IRQs;
    
};

static volatile struct interrupts_base * const _interrupts = (struct interrupts_base *)INTERRUPT_BASE;
void reset_handler();
void irq_handler();
void fiq_handler();


#endif
