// #include <kprintf.h>
// #include <interrupts_handler.h>
#define FLAG_CLEAR (1<<31)
#define RELOAD (1<<30)
#include <timer.h>
#include <kprintf.h>


struct lt_struct {
    unsigned int LIR;
    unsigned int unused[3];
    unsigned int LTC;
    unsigned int LT_IRQ;
};

// unsigned int volatile  ltc = (unsigned int ) LTC_BASE;
// unsigned int volatile  lir = (unsigned int ) LIR_BASE;

void timer_en_irq(){
    lt->LTC |= (1<<29);             // interrupt enable
    lt->LTC |= (1<<28);             // timer enable
    lt->LIR &= ~(0b111);               // set first 3 bits to 0 --> route IRQ to Core 0
}

void setTime(int time){
    lt->LTC |= (time & 0xFFFFFFF);              // max int = 268435455
}

void clear_timer(){
    lt->LT_IRQ &= ~(0b11<<29);
}
