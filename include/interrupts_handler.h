#ifndef INTERRUPTS_HANDLER_H
#define INTERRUPTS_HANDLER_H

void __attribute__(interrupt(enable_IRQs_1)) delay_some_time();

#endif
