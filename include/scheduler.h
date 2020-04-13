#ifndef _SCHEDULER_H_
#define _SCHEDULER_H_

#include <exceptions.h>

/* Insgesamt gibt es die Möglichkeit 32 Threads parallel aktiv zu verwalten
 * Der Idle Thread ist hierbei separat und hat immer die die id -1
 */

/* Anzahl der verfügbaren Threads. Nicht verändern! */
#define MAX_THREADS (32)
/* Idle Thread id. Nicht verändern! */
#define IDLE_THREAD_ID (-1)

/*# ENUMS ##########################################*/
enum thread_status {
	FINISHED,
	READY,
	RUNNING,
	SLEEPING,
	WAITING,
	IS_IDLE,        // Gibt an, dass dies der Idle Thread ist
	OTHER,          // Wenn der Thread momentan extern verwaltet wird
	ERROR           // Bei Fehlern
};

enum waiting_for {
	NONE,           // Not waiting for anything
	RECEIVE_CHAR    // Waiting for char
};




/*# IMPLEMENT THIS! ################################*/
/*#                                                #*/
/*# Diese Funktionen sind als weak definiert und   #*/
/*# sollten/müssen von euch überschrieben werden   #*/
/*#                                                #*/
/*##################################################*/

/* Diese Funktion wird bei einem Kontextwechsel aufgerufen nachdem
 * die Register auf dem Stack ausgetauscht wurden.
 * Folglich kann und muss diese Funktion überschrieben werden.
 * Mögliche Anwendungen:
 * - Debugging
 * - Verwaltung
 * - MMU umkonfigurieren
 *
 * @old  -> the id of the old thread
 * @next -> the id of the next thread
 */
extern void scheduler_on_schedule(int old, int next);

/* Diese Funktion wird beid dem erstellen eines neuen Tasks aufgerufen
 * Dieser Aufruf findet vor dem erstellen des neuen Tasks statt.
 * Da anschließend die Argumente auf den neuen Stack übertragen werde, muss
 * sichergestellt werden, dass der Stack des momentan laufenden Tasks
 * für den kernel lesbar ist und der Stack des nächsten schreibbar
 * @id     -> Id des neu erstellten Threads
 * @flags  -> die übergebenen flags aus dem Syscall
 *
 * @return -> Soll 0 zurück geben falls OK.
 *            Bei !0 wird das erstellen des Tasks abgebrochen
 */
extern int scheduler_on_create(int id, unsigned int flags);

/* Diese Funktion wird nach dem beenden eines Threads aufgerufen
 * @id -> Id des beendeten Threads
 */
extern void scheduler_on_exit(int id);

/* Diese Funktion wird beim erstellen eines Threads in das
 * lr Register geschrieben und soll den Thread vernünftig
 * beenden.
 * Eine mögliche Implementierung ist bei den syscalls
 * bereits mitgeliefert
 */
__attribute__((noreturn)) extern void syscall_exit();




/*# FUNCTIONS ######################################*/
/*#                                                #*/
/*# Diese Funktion sind vorhanden müssen von euch  #*/
/*# jedoch nicht benutzt werden                    #*/
/*#                                                #*/
/*##################################################*/

/* !DEPRECATED! Wird von kernel_init übernommen
 *
 * Initialisiert den scheduler und startet den ersten Thread.
 * Sicher stellen, dass unterhalb von user_stack_begin insgesamt
 * user_stack_size * 32 Platzt ist, da dort die Stacks für die user
 * threads angelegt werden.
 *
 * @user_stack_begin -> Adresse wo user stacks beginnen (höchste addr)
 * @user_stack_size  -> Größe des Stacks für einen user thread
 * @user_same_stacks -> Falls true erhalten alle neuen Threads den
 *                      selben Stack
 */
void scheduler_init(
		unsigned int user_stack_begin,
		unsigned int user_stack_size,
		unsigned int user_same_stacks);

/* Gibt die maximale Anzahl an Threads zurück. Äquivalent zu MAX_THREADS */
unsigned int scheduler_get_max_threads(void);

/* Git die id des momentan aktiven Thread aus */
int scheduler_get_current_thread();

/* Gibt die momentan im tcb abgespeicherten Register des
 * Threads mit der angeforderten id zurück
 *
 * @id     -> Id des Threads
 * @return -> struct mit allen gespeicherten Registerwerten
 *            oder NULL falls invalide id
 */
struct regs * scheduler_get_regs(int id);

/* Gibt den Status des Threads mit der angeforderten id zurück
 *
 * @id     -> Id des Threads
 * @return -> Thread Status. Falls invalide id, dann ERROR
 */
enum thread_status scheduler_get_state(int id);

/* Gibt die Stack Basis des TCB mit der angeforderten id zurück.
 * Nicht den aktuellen Stack!
 *
 * @id     -> Id des Threads
 * @return -> Stack Basis
 */
unsigned int scheduler_get_stack_base(int id);

/* Wendet das Round Robin Verfahren an.
 * Die Register auf dem Stack werden im TCB des jeweiligen Threads
 * abgespeichert und die Registerwerte des nächsten Threads aus dem TCB
 * auf den Stack geladen.
 * Dabei wird der alte Thread wieder zurück in die ready Warteschlange gesetzt.
 *
 * @regs   -> Register auf dem Stack
 * @return -> Id des nächsten Threads
 */
int scheduler_round_robin(struct regs * regs);

/* Wie scheduler_round_robin, aber der alte Thread wird nicht zurück in
 * die ready Warteschlange geladen und bekommt den Status: OTHER.
 * Der Thread kann dann manuell verwaltet werden. Um den Thread wieder zurück
 * in die ready Warteschlange zu schieben können die Funktionen
 * scheduler_add_to_ready_* verwendet werden
 *
 * Falls der momentan aktive Thread bereits beendet wurde, verhält sich diese
 * Funktion wie scheduler_round_robin
 */
int scheduler_schedule_next(struct regs * regs);

/* Legt den momentanen Thread schlafen für die angegebene Anzahl an Cycles.
 * Diese Zeit kann nicht unterschritten werden, aber jedoch überschritten
 * werden. Es wird der nächste Thread im Round Robin Verfahren auf den Stack
 * geschrieben.
 *
 * @regs   -> Register auf dem Stack
 * @cycles -> Anzahl der Zeitscheiben die geschlafen werden sollen. Die
 *             Länge der Zeitscheibe ist abhängig von der Dauer zwischen
 *             zwei Timer Interrupts
 * @return -> Id des nächsten Threads
 */
int scheduler_current_sleep(struct regs * regs, unsigned int cycles);

/* Der Momentane Thread wird aus der Round Robin Warteschlange heraus
 * genommen und wartet auf das angeforderte Event. Sobald das Event
 * aufgetreten ist und die Bedingung für den Thread erfüllt ist, wird
 * dieser wieder in die Round Robin Warteschlange hinzu gefügt.
 * Es wird der nächste Thread im Round Robin Verfahren auf den Stack
 * geschrieben.
 *
 * @regs   -> Register auf dem Stack
 * @event  -> Das Event auf welches gewartet werden soll
 * @return -> Id des nächsten Threads
 */
int scheduler_current_wait(struct regs * regs, enum waiting_for event);

/* Informiert den Scheduler wenn ein neuer Char angekommen ist und falls
 * ein Thread auf einen Charakter wartet, wird im dieser übergeben und der
 * Thread zurück in die ready Warteschlange gesetzt.
 * @c -> der angekommen char
 * @return -> 1, falls ein Thread gefunden wurde
 *            0, falls kein Thread gefunden wurde
 */
int scheduler_notify_char(char c);

/* Initialisiert einen neuen Thread und fügt diesen in die
 * ready Warteschlange hinzu.
 *
 * @func     -> Start-adresse des Threads
 *
 * @arg      -> Pointer zu den Argumenten, diese werden auf den Stack
 *              geladen und r0 auf die Adresse auf dem Stack gesetzt
 *
 * @arg_size -> Größe der Daten zu den arg zeigt.
 *
 * @flags    -> Übergebene flags aus dem Syscall
 *
 * @return   -> -1:   Kein weiterer Thread möglich
 *              -2:   args zu groß
 *              0-31: sonst Id des neuen Threads
 */
int scheduler_new_thread(
	void (* func) (void *),
	const void *arg,
	unsigned int arg_size,
	unsigned int flags);

/*
 * Setzt den Status des momentanen Threads auf FINISHED.
 * Schlägt fehl, wenn der aktuelle Thread der Idle Thread ist.
 * @return -> id des nächsten Threads
 *            -2 bei Fehler
 */
int scheduler_end_current_thread(struct regs *);

#endif
