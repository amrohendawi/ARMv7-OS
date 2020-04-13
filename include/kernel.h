#ifndef _KERNEL_H_
#define _KERNEL_H_

struct stack_setup{
	unsigned int abt_sp;           //Stack Pointer für Aborts
	unsigned int svc_sp;           //Stack Pointer für Supervisor
	unsigned int und_sp;           //Stack Pointer für Undefined
	unsigned int irq_sp;           //Stack Pointer für IRQ
	unsigned int tasks_sp;         //Stack Pointer für Tasks
	unsigned int tasks_sp_size;    //Stack Pointer Größe pro Tasks
	unsigned int tasks_same_stack; //Flag Tasks all get the same Stack
};

/* Initialer Thread. Intern als weak definiert. Soll überschrieben werden.
 * Dieser Thread läuft als erster Thread im Sys Mode und hat somit
 * noch privilegierte Rechte um weiteres Setup (wie z.B. MMU) vorzunehmen
 */
extern void init(void);

/* Nimmt Initialisierungen für alle Stacks vor.
 *
 * Muss aus dem Supervisor Modus heraus aufgerufen werden.
 *
 * @stacks -> Pointer auf ein struct stack_setup, welches Informationen
 *            über euer Memory Layout enthalten muss.
 */
void kernel_setup(struct stack_setup * stacks);

/* Davor muss kernel_setup aufgerufen werden!
 *
 * Initialisiert alle Peripherie (außer MMU) und Trampoline und startet
 * den init Thread. Der Timer ist danach bereits
 * initialisiert aber noch nicht gestartet.
 *
 * Muss aus dem Supervisor Modus heraus aufgerufen werden.
 */
__attribute__((noreturn)) void kernel_init();

#endif
