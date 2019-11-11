.section .init
.global _start

.equ    STACK_SIZE, 512
.equ    STACK_BASE, 0xF0000

.equ    PSR_USR, 0X10
.equ    PSR_FIQ, 0x11
.equ    PSR_IRQ, 0x12
.equ    PSR_SVC, 0x13
.equ    PSR_ABT, 0x17
.equ    PSR_UND, 0x1b
.equ    PSR_SYS, 0x1f

_start:
	/* Erkennen ob Hypervisor Mode aktiv */
	mrs r0, cpsr
	and r0, r0, #0x1F
	mov r1, #0x1A	//Modebits = 0x1A = Hypervisor Mode
	

	 
	cmp r0, r1		//Vergleichen und Statusbits setzen für bedingte Sprünge
	
	/* Wenn Hypemode erkannt: abschalten (sprung nach _exitHyper)
	 * wenn nicht erkannt: dann weitermachen (weiterlaufen nach _bsprak)
	 */
	beq _exitHyper

	/* Qemu startet immer alle 4 Kerne
	 * Wir lassen alle anderen Kerne endless loopen
	 */
_loopCores:
	/* Id des Cpu Cores Abfragen */
	mrc p15, 0, r0, c0, c0, 5
	/* Falls nicht core 0 -> Endless loop */
	tst r0, #3
	bne .Lend
    
_bsprak:
	/* Wir brauchen einen validen Stack für Qemu.
	 * Auf dem Pi wurde dieser zwar bereits durch U-Boot
	 * gesetzt, schadet aber auch nicht
	 */

	ldr	sp,=0x20000
	mrc p15, 0, r0, c0, c0, 5
	
    bl  init_int
    
    ldr r0, =ivt
    mcr   p15,0,r0,c12,c0,0

   /* add pc, r0, #24 */
   /* wenn die aktiv ist, springt er direkt in die nummer 24 in der ivt beim hochfahren, also direkt in ldr irq, dann leuchtet die lampe und er printet nops, der fehler ist also dass er keine interrupts wirft oder die nicht ankommen, der ivt und der interrupt handler ist korrekt*/
    /* Zu c Code springen */
	 

   	bl      start_kernel
   	
.Lend:  
	WFI
	b       .Lend

_exitHyper:

	/* Rücksprungadresse ins Hypervisor Rücksprungregister schreiben.
	 * Dies ist das Label _bsprak für die normale Programmausfürung.
	 */
	ldr lr, =_loopCores
	msr ELR_hyp, lr
	
	/* Der Hypervisor mode ist auch "nur" eine etwas kompliziertere Exception.
	 * Also springen wir aus dieser zurück.
	 * (Rücksprunge in Aufgabe 2 sind anders zu lösen!).
	 * Dazu zunächst das CPSR auslesen und die Modebits zum Supervisor ändern.
	 * Danach dies in das SPSR für den Rücksprung schreiben.
	 */
	 
	mrs r0, cpsr
	bic r0, r0, #0x1F
	orr r0, r0, #0x13	//Supervisormode
	msr spsr_hyp, r0
	eret
	
/* initialize interrupts handlers*/
init_int:
    mov    sp, #STACK_BASE
    mov    r0, #STACK_BASE
    mov    r1, #STACK_SIZE

    cps    PSR_FIQ
    add    r0,r0,r1
    mov    sp, r0
    
    cps    PSR_IRQ
    add    r0,r0,r1
    mov    sp, r0
    
    cps    PSR_SYS
    add    r0,r0,r1
    mov    sp, r0
    
    cps    PSR_UND
    add    r0,r0,r1
    mov    sp, r0
    
    cps    PSR_ABT
    add    r0,r0,r1
    mov    sp, r0
    
    cps    PSR_SVC
    mov pc, lr
