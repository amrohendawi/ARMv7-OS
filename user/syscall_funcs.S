.global create
.global write
.global read
.global sleep
.global exit
.global unknown

.equ   SVC_EXIT,    0x1
.equ   SVC_CREATE,  0x2
.equ   SVC_SLEEP,   0x3
.equ   SVC_READ,    0x4
.equ   SVC_WRITE,   0x5
.equ   SVC_UNKNOWN, 0x6




/*
* Die SYSCALL Konvention liegt immer in r3 und wird von SWI Seite gelesen
*/


/*
* create(r0: void (* func) (void *), r1: const void *arg, r2: unsigned int arg_size)
* diese Funktion triggert syscall um einen neuen thread zu erstellen.
*/
create:
    MOV    r3  ,#SVC_CREATE
    SVC    #0
    MOV     pc, lr

/*
* write(r0: char to_write)
* diese Funktion triggert syscall um einen vom user übergebenen char schreiben zu lassen auf die kernel-Ebene
*/
write:
    MOV    r3  ,#SVC_WRITE
    SVC    #0
    MOV     pc, lr

/*
* char read(), wobei r0 hat den return Wert bzw. den char
* diese Funktion triggert syscall um einen char zu lesen und am user zurückgeben
*/
read:
    MOV     r3  ,#SVC_READ
    SVC     #0
/*    CMP     r0, #0
    BEQ     read*/
    MOV     pc,lr

/*
* sleep(r0: unsigned int time)
* diese Funktion triggert syscall um den aktuell laufenden Thread um (time) Zeitscheiben zu verzögern
*/
sleep:
    MOV     r3  ,#SVC_SLEEP
    SVC     #0
    MOV     pc,lr

/*
* exit(void)
* diese Funktion triggert syscall um den aktuell laufenden Thread zu beenden und zu neuem Thread zu wechseln
*/
exit:
    MOV     r3  ,#SVC_EXIT
    SVC     #0
    MOV     pc,lr

/*
* unknown(void)
* diese Funktion triggert syscall mit einer unbekannten Konvention. mehr nicht
*/
unknown:
    MOV     r3  ,#SVC_UNKNOWN
    SVC     #0
    MOV     pc,lr
    
    
    
.global cause_data_abort

cause_data_abort:
    mrc p15,0,r1,c1,c0,0
    orr r1, #2
    mcr p15,0,r1,c1,c0,0
    mov r1,#0x1
    ldr r1,[r1]
    mov pc,lr
