#ifndef _CPU_H_
#define _CPU_H_

/* Aufgeschlüsselte Modusbits für PSR Register */
enum PSR_MODE {
	PSR_USR = 0x10,
	PSR_IRQ = 0x12,
	PSR_SVC = 0x13,
	PSR_ABT = 0x17,
	PSR_UND = 0x1b,
	PSR_SYS = 0x1f,
};

/* Gibt den momentanen CPU Mode zurück */
enum PSR_MODE cpu_get_psr_mode();

/* Setzt den Stack Pointer des angegebenen Modus auf den übergeben Wert */
void cpu_set_banked_sp(enum PSR_MODE mode, unsigned int val);

/* Gibt den Wert des Stack Pointer's des angegebenen Modus zurück */
unsigned int cpu_get_banked_sp(enum PSR_MODE mode);

/* Gibt den Wert des Link Register's des angegebenen Modus zurück */
unsigned int cpu_get_banked_lr(enum PSR_MODE mode);

/* Gibt den Wert des SPSR's des angegebenen Modus zurück */
unsigned int cpu_get_banked_spsr(enum PSR_MODE mode);

#endif
