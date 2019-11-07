#ifndef TIMER_H
#define TIMER_H
#define LTC_BASE (0x40000024)

static volatile struct lt_struct * const lt = (struct lt_struct *)LTC_BASE;

void timer_en_irq();
void setTime(int time);
void clear_timer();

#endif
