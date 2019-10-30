#ifndef _IVT_H_
#define _IVT_H_
#include <kprintf.h>
#include <uart.h>
#include <interrupts_handler.h>


// extern unsigned int vbar();
// extern unsigned int ivt();



void delay_some_time()
{
    for (int i = 0; i < 10; i++)
        kprintf("nop\n");
}

// handler only in irq case
void reset_handler() {
    kprintf("reset handler  is activated\n");
    delay_some_time();
}
void undefined_instruction_handler() {
    kprintf("undefined_instruction_handler is activated\n");
    delay_some_time();
}
void software_interrupt_handler() {
    kprintf("software_interrupt_handler is activated\n");
    delay_some_time();
}
void prefetch_abort_handler() {
    kprintf("prefetch_abort_handler is activated\n");
    delay_some_time();
}
void data_abort_handler() {
    kprintf("data_abort_handler is activated\n");
    delay_some_time();
}
void not_used_handler() {
    kprintf("not_used_handler is activated\n");
    delay_some_time();
}
void irq_handler() {
    kprintf("irq_handler is activated\n");
    delay_some_time();
    while(1);
}
void fiq_handler() {
    kprintf("fiq_handler is activated\n");
    delay_some_time();
}




#endif
