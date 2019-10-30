#ifndef _IVT_H_
#define _IVT_H_
#include <kprintf.h>
#include <uart.h>
#include <interrupts_handler.h>


// extern unsigned int vbar();
// extern unsigned int ivt();



void delay_some_time()
{
    for (int i = 0; i < 100; i++)
        kprintf("nop\n");
}

// handler only in irq case
void reset_handler() {
    kprintf("%c was catched reset handler  is activated\n", _uart->DR);
    delay_some_time();
}
void undefined_instruction_handler() {
    kprintf("%c was catched undefined_instruction_handler is activated\n", _uart->DR);
    delay_some_time();
}
void software_interrupt_handler() {
    kprintf("%c was catched software_interrupt_handler is activated\n", _uart->DR);
    delay_some_time();
}
void prefetch_abort_handler() {
    kprintf("%c was catched prefetch_abort_handler is activated\n", _uart->DR);
    delay_some_time();
}
void data_abort_handler() {
    kprintf("%c was catched data_abort_handler is activated\n", _uart->DR);
    delay_some_time();
}
void not_used_handler() {
    kprintf("%c was catched not_used_handler is activated\n", _uart->DR);
    delay_some_time();
}
void irq_handler() {
    kprintf("%c was catched irq_handler is activated\n", _uart->DR);
    delay_some_time();
    while(1);
}
void fiq_handler() {
    kprintf("%c was catched fiq_handler is activated\n", _uart->DR);
    delay_some_time();
}




#endif
