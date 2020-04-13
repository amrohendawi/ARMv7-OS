#ifndef _EXCEPTIONS_H_
#define _EXCEPTIONS_H_

/* RESET und FIQ sind nicht unterstützt */
enum EXCEPTION_MODE{
	E_UND  = 1, // Undefined Instruction
	E_SWI  = 2, // Software Interrupt
	E_PABT = 3, // Prefetch Abort
	E_DABT = 4, // Data Abort
	E_IRQ  = 6  // Interrupt
};

enum SYSCALL_ID{
	EXIT  = 0,
	EXEC  = 1,
	PUTC  = 2,
	GETC  = 3,
	SLEEP = 4
};

/* Register des User/System Modus */
struct regs{
	unsigned int r0;
	unsigned int r1;
	unsigned int r2;
	unsigned int r3;
	unsigned int r4;
	unsigned int r5;
	unsigned int r6;
	unsigned int r7;
	unsigned int r8;
	unsigned int r9;
	unsigned int r10;
	unsigned int r11;
	unsigned int r12;

	/* immer sp und lr des User/System Modus */
	unsigned int sp;
	unsigned int lr;

	/* PSR aus dem Modus vor dem aufgetretenen
	 * Interrupt (SPSR). Wird beim verlassen der
	 * Exception wieder her gestellt */
	unsigned int psr;

	/* lr Register des Exception Modus,
	 * hierhin wird zurück gesprungen */
	unsigned int pc;
};

/* !DEPRECATED! Wird von kernel_init übernommen
 *
 * Setzt die Vektor Base.
 * Aufrufen bevor die erste Exception aufgetretenen kann
 */
void set_vector_base();

/* Dies Funktion selber implementieren!
 * Diese Funktion wird aufgerufen nachdem ein Byte im Uart per irq
 * behandelt wurde.
 * Soll zurück geben:
 *    0 falls das Byte NICHT konsumiert wurde
 *    1 falls das Byte konsumiert wurde
 */
 int exception_on_uart_irq();

/* Dies Funktion selber implementieren!
 * Hier landen alle Exceptions außer irq und svc. Dieser werden bereits
 * behandelt. Falls ein svc mit einer unbekannten id aufgerufen wird,
 * wird dieser Aufruf an diese Funktion weitergeleitet und kann selbst
 * behandelt werden*/
extern void exception(enum EXCEPTION_MODE, struct regs *);

#endif /* _EXCEPTIONS_H_ */
