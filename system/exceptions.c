#include <exceptions.h>
#include <kprint.h>
#include <uart.h>
#include <timer.h>
#include <debug.h>
#include <scheduler.h>
#include <syscall.h>
#include <cpu.h>
#include <process.h>

#define LS_BYTE 0xFF

#define SVC_EXIT    0
#define SVC_EXEC    1
#define SVC_PUTC    2
#define SVC_GETC    3
#define SVC_SLEEP   4
#define MODUS_BITS 0x1F

unsigned int time = 0;
int id = 0;
char test_read=0;
int bigS_flag = 0;


/*
 * 
 */
int exception_on_uart_irq(){
    
    return 0;
}

#define USR    (0x10)
#define FIQ    (0x11)
#define IRQ    (0x12)
#define SVC    (0x13)
#define ABT    (0x17)
#define UND    (0x1B)
#define SYS    (0x1F)
#define FIRST5 (0x1F)

int user_responsible(){
    unsigned int spsr = 0;
    asm("mrs %[result], spsr" : [result] "=r" (spsr));
    return ((spsr & FIRST5) == USR) ? 1 : 0;
}



/*
 * Aufgabe 8: es wird im Kernel, aus der UART-Interrupt Behandlung, eine Zugriffsverletzung ausgelöst
 */
void uart_interrupt_cases(){
    if(uart_read_available()){
        char c = uart_peekc();
        switch(c){
            case 'N':
                kprintf("%c pressed. activate lesender Zugriff auf Null-Pointer\n",c);
                c = *(volatile char*)0;
                break;
            case 'P':
                kprintf("%c pressed. activate Sprung auf Null-Pointer.\n",c);
                void (*foo)(void) = 0x0;
                foo();
                break;
            case 'C':
                kprintf("%c pressed. activate schreibender Zugriff auf eigenen Code.\n",c);
                break;
            case 'U':
                kprintf("%c pressed. activate esender Zugriff auf nicht zugeordnete Adresse.\n",c);
                c = *(volatile char*) 0xFFFFFFF1;
                kprintf("not supposed to read anything %c\n",c);
                break;
            case 'X':
                kprintf("%c pressed. activate Sprung auf User Code.\n",c);
                break;
        }
    }
}

extern void exception(enum EXCEPTION_MODE mode, struct regs * regs_pointer){
    volatile struct regs * regs = (struct regs *) regs_pointer;
    char c=0;
    switch (mode){
        case E_UND:
            break;
            
        case E_SWI:
            kprintf("## SWI released ##\n");

            switch(regs->r7 & LS_BYTE){
                case SVC_EXIT:
                    scheduler_end_current_thread(regs_pointer);
                    scheduler_round_robin(regs_pointer);
                    break;
                    
                case SVC_EXEC:
                    // erstellt einen neuen thread mit func in r0, arg in r1, args_size in r2, übergebene syscall in r3
                    scheduler_new_thread((void *)regs->r0, (const void *) regs->r1, regs->r2, regs->r7);
                    
                    break;
                case SVC_SLEEP:
                    time = regs->r0;
                    id = scheduler_get_current_thread();
                    if(id != -1){
                        scheduler_schedule_next(regs_pointer);
                    }else{
                        scheduler_current_sleep(scheduler_get_regs(id),time);
                    }
                    time = 0;
                    break;
                case SVC_GETC:
                    c = uart_getc();
                    regs->r0 = c;
                    break;
                    
                case SVC_PUTC:
                    uart_putc(regs->r0);
                    break;
                    
                default:
                    kprintf(" ** Unknown SWI convention %i **\n", mode);
                    debug_print_register(regs_pointer);
                    debug_print_psr(regs->psr);
                    debug_print_banked(PSR_SYS);
                    debug_print_banked(PSR_SVC);
                    debug_print_banked(PSR_ABT);
                    debug_print_banked(PSR_IRQ);
                    debug_print_banked(PSR_UND);
                    scheduler_end_current_thread(regs_pointer);
                    scheduler_round_robin(regs_pointer); 
            }
            break;
            
        case E_PABT:
            kprintf("## Prefetch Abort released by thread %i ##\n", scheduler_get_current_thread());
            debug_print_register(regs_pointer);
            debug_print_banked(mode);
            debug_print_psr(regs->psr);
            if(user_responsible()){
                kprintf("User Responsible for the Abort\n");
                scheduler_end_current_thread(regs_pointer);
            }else{
                kprintf("Kernel Responsible for the Abort !! System angehalten\n");
                while(1);
            }
            break;
            
        case E_DABT:
            kprintf("## Data Abort released ##\n");
            if(user_responsible()){
                kprintf("User Responsible for the Abort\n");
                scheduler_end_current_thread(regs_pointer);
            }
            break;
            
        case E_IRQ:
            if(uart_irq_pending()){
                kprintf("## IRQ released ##\n");
                uart_interrupt_cases();
            }
            if(timer_pending_irq()){
                kprintf("## Timer IRQ released ##\n");

            }
            break;
        default:
            kprintf("unknown exeption\n");
    }

}
