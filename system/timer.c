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
    lt->LTC |= INT_EN;               // interrupt enable
    lt->LTC |= TIMER_EN;             // timer enable
    lt->LIR &= ~CORE_0;             // set first 3 bits to 0 --> route IRQ to Core 0
}

unsigned int everytime = 0;

void clear_timer(){
    lt->LT_IRQ |= (1<<31);
    lt->LT_IRQ |= (1<<30);
}

void setTime(int time){
    everytime = time;
    lt->LTC |= (time & RELOAD_VALUE);              // max int = 268435455
}

void resetTimer(){
    lt->LT_IRQ |= (1<<31);
//     lt->LT_IRQ |= (1<<30);
//     lt->LT_IRQ |= (everytime & RELOAD_VALUE);
//     lt->LTC |= INT_EN;             // interrupt enable
//     lt->LTC |= TIMER_EN;             // timer enable
}


