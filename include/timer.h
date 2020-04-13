#ifndef _TIMER_H_
#define _TIMER_H_

/* Startet den Timer */
void timer_start();

/* Stoppt den timer */
void timer_stop();

/* Gibt zurück, ob ein unbehandelter Timer interrupt
 * aufgetreten ist.
 * return:
 *  1 -> Interrupt aufgetreten
 *  0 -> kein Interrupt aufgetreten
 */
unsigned int timer_pending_irq();

/* Cleart den Interrupt. Diese Funktion sollte jedes mal,
 * nachdem ein Timer Interrupt behandelt wurde aufgerufen
 * werden
 */
void timer_clear_interrupt();

/* Setzt den Timer reload value auf den entsprechenden
 * Wert in Mikro Sekunden
 * Der Timer wird neu geladen und fängt von vorne an zu zählen,
 * es wird jedoch kein Interrupt verursacht.
 */
void timer_set_reload(unsigned int us);

/* Setzt den Timer zurück ohne ein Interrupt zu triggern */
void timer_reload();

/* !DEPRECATED! Wird von kernel_init übernommen
 *
 * Initialisiert den Timer und setzt ihn auf ca 1 Sekunde
 * Der Timer ist nach dem initialisieren noch nicht gestartet.
 * Interrupts sind aktiv.
 */
void timer_init();

#endif /* _TIMER_H_ */
