#ifndef _DEBUG_H_
#define _DEBUG_H_

#include <exceptions.h>
#include <cpu.h>

/* Gibt die übergebenen Register aus
 * Für struct regs siehe exceptions.h
 */
void debug_print_register(struct regs * registers);

/*  Gibt Informationen über das gegebene psr aus
 */
void debug_print_psr(unsigned int psr);

/* Gibt die banked Register des angegebenen Modus aus
 * Für PSR_MODE siehe cpu.h
 */
void debug_print_banked(enum PSR_MODE mode);

#endif
