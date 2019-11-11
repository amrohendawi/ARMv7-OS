#ifndef TIMER_H
#define TIMER_H
#define LTC_BASE (0x40000024)
#define INTERRUPT_FLAG (1<<31)
#define LOCAL_TIMER_RELOAD (1<<30)
#define INT_EN (1<<29)
#define TIMER_EN (1<<28)
#define RELOAD_VALUE (0xFFFFFFF)
#define CORE_0 (0b111)

static volatile struct lt_struct * const lt = (struct lt_struct *)LTC_BASE;

void timer_en_irq();
void setTime(int time);
void resetTimer();
void clear_timer();

#endif
