#define INTERRUPT_BASE (0x7E00B000 + 0x200)
#ifndef _IVT_H_
#define _IVT_H_

#include <kprintf.h>

extern unsigned int vbar();
extern unsigned int ivt();


// struct ivt {
//     volatile unsigned int IRQ_basic_pending;
//     volatile unsigned int IRQ_pending_1;
//     volatile unsigned int IRQ_pending_2;
//     volatile unsigned int FIQ_control;
//     volatile unsigned int enable_IRQs_1;
//     volatile unsigned int enable_IRQs_2;
//     volatile unsigned int enable_basic_IRQs;
//     volatile unsigned int disable_IRQs_1;
//     volatile unsigned int disable_IRQs_12;
//     volatile unsigned int disable_basic_IRQs;
//     
// };



// struct interrupts {
//     unsigned int cpsr;
// };
// 
// static volatile struct interrupts * const interrupts = (struct interrupts *)INTERRUPT_BASE;

// function that halts the processor for 10000 nops according to specific modi
void delay_some_time()
{
    for (int i = 0; i < 10000; i++)
        kprintf("nop\n");
}

// handler only in irq case
__irq void IRQHandler (void)
{
    volatile unsigned int *base = (unsigned int *) 0x7E00B000;

    if (*base == 1)          // which interrupt was it?
        delay_some_time();
        
    *(base+1) = 0;           // clear the interrupt
}



#endif
