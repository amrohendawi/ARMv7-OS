
/* Mit dieser Implementierung kann der UART in folgenden
 * Modi betrieben werden:
 *
 * - NOT_INIT:
 *	Der Startzustand des UART. Nicht funktionsfähig.
 *	Um den UART zu nutzen zuerat uart_init aufrufen.
 *
 * - POLL:
 *	Das Lesen (RX) findet ohne Interrupts statt.
 *	Die FIFO des UARTS zum Empfangen wird genutzt.
 *
 * - IRQ:
 *	Das Lesen (RX) findet mit Interrupts statt.
 *	Die FIFO des UARTS zum Empfangen wird nicht genutzt,
 *	dafür jedoch ein Buffer um die Zeichen zwischen zu
 *	speichern. Um das Zeichen aus dem UART Data Register
 *	in den Buffer zu übertragen die Funktion uart_handle_irq
 *	nutzen. Falls der Buffer voll ist, wird das Zeichen
 *	verworfen.
 *
 * - Gleich bei bei POLL und IRQ:
 *	Schreiben (TX) findet ohne Interrupts statt.
 *	Die FIFO des UARTS zum Senden wird genutzt.
 */


#ifndef _UART_H_
#define _UART_H_

/* !DEPRECATED! Wird von kernel_init übernommen
 *
 * Initialisiert den UART
 * Der Modus nach dem Initialisieren ist POLL
 */
void uart_init(void);


/* Blockierend!
 *
 * Liest in einer aktiven Schleife das Flag Register
 * aus, ob ein Byte geschrieben werden kann. Sobald Platz
 * in der Fifo, wird das Byte in die Fifo eingefügt
 */
void uart_putc(char chr);


/* Blockierend!
 *
 * -- POLL --
 * Liest in einer aktiven Schleife das Flag Register
 * aus, ob ein Byte gelesen werden kann. Sobald ein Byte
 * vorhanden ist in der FIFO, wird das Byte ausgelesen und
 * zurück gegeben.
 *
 * -- IRQ  --
 * Überprüft in einer aktiven Schleife ob ein Byte im
 * Buffer vorhanden ist. Sobald ein Byte vorhande ist,
 * wird es zurück gegeben und aus dem Buffer entfernt.
 *
 * Wenn sicher gestellt werden
 * soll, dass dies Funktion nicht blockiert zuerst mit
 * uart_read_available überprüfen ob ein Byte gelesen
 * werden kann.
 */
char uart_getc(void);

/* Blockierend!
 *
 * -- POLL --
 * Wie uart_getc
 *
 * -- IRQ  --
 * Wie uart_getc, jedoch wird das gelesene Zeichen nicht aus dem
 * Buffer entfernt
 *
 * Wenn sicher gestellt werden
 * soll, dass dies Funktion nicht blockiert zuerst mit
 * uart_read_available überprüfen ob ein Byte gelesen
 * werden kann.
 */
char uart_peekc(void);

/* Überprüft, ob ein Byte mit uart_getc gelesen werden
 * kann. Gibt zurück:
 * 1 -> Falls Byte vorhanden.
 * 0 -> Sonst.
 */
int uart_read_available();


/* ! Achtung beim umschalten der Modi gehen alle nicht !
 * ! Verarbeiteten Bytes verloren.                     !
 *
 * Hält den UART zwischenzeitig an, löscht alle
 * Interrupts und empfangenen bzw. zu versendenden Bytes
 * und stellt den UART auf IRQ Modus um.
 */
void uart_irq_enable();


/* ! Achtung beim umschalten der Modi gehen alle nicht !
 * ! Verarbeiteten Bytes verloren.                     !
 *
 * Hält den UART zwischenzeitig an, löscht alle
 * Interrupts und empfangenen bzw. zu versendenden Bytes
 * und stellt den UART auf POLL Modus um.
 */
void uart_irq_disable();


/* Nur im IRQ Modus!
 * Gibt an ob ein UART spezifischer Interrupt aufgetreten ist.
 * Gibt zurück:
 * 1 -> Falls irq aufgetreten
 * 0 -> Sonst
 */
int uart_irq_pending();


/* Nur im IRQ Modus!
 * Aufrufen um aufgetretenen UART Interrupt zu behandeln
 * Liest das angekommene Byte (falls vorhanden) und fügt
 * es dem Buffer hinzu. Falls der Buffer voll ist, wird
 * das Byte verworfen.
 */
void uart_handle_irq();

#endif /* _UART_H_ */
