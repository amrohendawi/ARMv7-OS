#ifndef _KPRINT_H_
#define _KPRINT_H_


/* Einfache printf ähnliche Funktion wie aus stdio.h
 * Vorhanden:
 * %c
 * %s
 * %u
 * %i
 * %p
 * %x
 * %%
 */
void kprintf(char *format, ...) __attribute__ ((format(printf,1,2)));

#endif /* _KPRINT_H_ */
