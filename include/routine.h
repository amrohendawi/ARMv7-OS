#ifndef ROUTINE_H
#define ROUTINE_H

// #define INTERRUPT_BASE (0x7E00B000 + 0x200 - 0x3F000000)

// static volatile struct interrupts_base * const _interrupts = (struct interrupts_base *)INTERRUPT_BASE;
void interrupt_check(char input);

#endif
