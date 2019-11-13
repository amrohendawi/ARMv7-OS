#define FLAG_CLEAR (1<<31)
#define RELOAD (1<<30)
#include <timer.h>
#include <kprintf.h>
#include <uart.h>


struct lt_struct {
    unsigned int LIR;
    unsigned int unused[3];
    unsigned int LTC;
    unsigned int LT_IRQ;
};

void timer_en_irq(){
    lt->LTC |= INT_EN;               // interrupt enable
    lt->LTC |= TIMER_EN;             // timer enable
    lt->LIR &= ~CORE_0;             // set first 3 bits to 0 --> route IRQ to Core 0
}


void setTime(int time){
    lt->LTC |= (time & RELOAD_VALUE);              // max int = 268435455
}

void resetTimer(){
    lt->LT_IRQ |= (1<<31);
}
    
    
void start_timer_interrupt(int time){
    asm("cpsie  i");
    setTime(time);
    timer_en_irq();
}
