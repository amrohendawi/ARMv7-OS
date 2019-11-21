#include <kprintf.h>
#include <uart.h>
#include <interrupts_handler.h>
#include <timer.h>
#define timer_guilty (lt->LTC & (1<<31))
#define R_W    (1<<11)
#include <FIFO.h>
#include <routine.h>

#define USR    (0x10)
#define FIQ    (0x11)
#define IRQ    (0x12)
#define SVC    (0x13)
#define ABT    (0x17)
#define UND    (0x1B)
#define SYS    (0x1F)
#define FIRST5 (0x1F)
#define N_BIT   (1<< 31)
#define Z_BIT   (1<< 30)
#define C_BIT   (1<< 29)
#define V_BIT   (1<< 28)
#define E_BIT   (1<< 9)
#define I_BIT   (1<< 7)
#define F_BIT   (1<< 6)
#define T_BIT   (1<< 5)

extern int _start();

extern unsigned int get_lr_usr();
extern unsigned int get_lr_svc();
extern unsigned int get_lr_abt();
extern unsigned int get_lr_fiq();
extern unsigned int get_lr_irq();
extern unsigned int get_lr_und();

extern unsigned int get_sp_usr();
extern unsigned int get_sp_svc();
extern unsigned int get_sp_abt();
extern unsigned int get_sp_fiq();
extern unsigned int get_sp_irq();
extern unsigned int get_sp_und();

extern unsigned int get_spsr_svc();
extern unsigned int get_spsr_abt();
extern unsigned int get_spsr_fiq();
extern unsigned int get_spsr_irq();
extern unsigned int get_spsr_und();


char str[10];
int IRQ_Debug = 0;


void set_IRQ_DEBUG(int value){
    IRQ_Debug = value;
}

struct regStack{
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
  unsigned int lr;
};


struct interrupts_base {
    volatile unsigned int IRQ_basic_pending;
    volatile unsigned int IRQ_pending_1;
    volatile unsigned int IRQ_pending_2;
    volatile unsigned int FIQ_control;
    volatile unsigned int enable_IRQs_1;
    volatile unsigned int enable_IRQs_2;
    volatile unsigned int enable_basic_IRQs;
    volatile unsigned int disable_IRQs_1;
    volatile unsigned int disable_IRQs_2;
    volatile unsigned int disable_basic_IRQs;
};


struct lt_struct {
    unsigned int LIR;
    unsigned int unused[3];
    unsigned int LTC;
    unsigned int LT_IRQ;
};




char * rORw(unsigned int DFSR){
    return (DFSR & R_W) ? "lesend" : "schreibend";
}

void da_report(){
    unsigned int DFSR=0;
    asm("MRC p15, 0, %[result], c5, c0, 0" : [result] "=r" (DFSR));
    unsigned int DFAR=0;
    asm("MRC p15, 0, %[result], c6, c0, 0" : [result] "=r" (DFAR));
    
    kprintf("Zugriff: %s auf Adresse %08p\n",rORw(DFSR),DFAR);
    switch(DFSR & 31){
        case 0b00000:
            kprintf("Fehler: No function, reset value\n\n");
        break;
        
        case 0b00001:
            kprintf("Fehler: Alignment fault\n\n");
        break;
        
        case 0b00010:
            kprintf("Fehler:Debug event fault\n\n");
        break;
        
        case 0b00011:
            kprintf("Fehler: Access Flag fault on Section\n\n");
        break;
        
        case 0b00100:
            kprintf("Fehler: Cache maintenance operation fault[b]\n\n");
        break;
        
        case 0b00101:
            kprintf("Fehler: Translation fault on Section\n\n");
        break;
        
        case 0b00110:
            kprintf("Fehler: Access Flag fault on Page\n\n");
        break;
        
        case 0b00111:
            kprintf("Fehler: Translation fault on Page\n\n");
        break;
        
        case 0b01000:
            kprintf("Fehler: Precise External Abort\n\n");
        break;
        
        case 0b01001:
            kprintf("Fehler: Domain fault on Section\n\n");
        break;
        
        case 0b01010:
            kprintf("Fehler: No function\n\n");
        break;
        
        case 0b01011:
            kprintf("Fehler: Domain fault on Page\n\n");
        break;
        
        case 0b01100:
            kprintf("Fehler: External abort on translation, first level\n\n");
        break;
        
        case 0b01101:
            kprintf("Fehler: Permission fault on Section\n\n");
        break;
        
        case 0b01110:
            kprintf("Fehler: External abort on translation, second level\n\n");
        break;
        
        case 0b01111:
            kprintf("Fehler: Permission fault on Page\n\n");
        break;
        
        case 0b10110:
            kprintf("Fehler: Imprecise External Abort\n\n");
        break;
        
        case 0b10111:
            kprintf("Fehler: No function\n");
        break;
        
        default:
            if((DFSR & 28) == 0b10000)
                kprintf("Fehler: No function\n");
            else if((DFSR & 30) == 0b10100)
                kprintf("Fehler: No function\n");
            else if((DFSR & 24) == 0b11000)
                kprintf("Fehler: No function\n");
        break;
    }
}



void bitsToLetters(unsigned int bitstring){
    kmemset(str,10);
    
    str[0] = (bitstring & N_BIT) ? 'N' : '_';
    str[1] = (bitstring & Z_BIT) ? 'Z' : '_';
    str[2] = (bitstring & C_BIT) ? 'C' : '_';
    str[3] = (bitstring & V_BIT) ? 'V' : '_';
    str[4] = ' ';
    str[5] = (bitstring & E_BIT) ? 'E' : '_';
    str[6] = ' ';
    str[7] = (bitstring & I_BIT) ? 'I' : '_';
    str[8] = (bitstring & F_BIT) ? 'F' : '_';
    str[9] = (bitstring & T_BIT) ? 'T' : '_';
}

char * modusbits(unsigned int spsr){
    switch(spsr & FIRST5){
        case USR:
            return "User";
        case FIQ:
            return "FIQ";
        case IRQ:
            return "IRQ";
        case SVC:
            return "Supervisor";
        case ABT:
            return "Abort";
        case UND:
            return "Undefined";
        case SYS:
            return "System";
        default:
            return "Unknown Mode";
    }
}



void reg_snapshot_print(char * exc_type, unsigned int pc, const volatile struct regStack * const regs){
    unsigned SP = 0;
    asm("mov %[result], sp" : [result] "=r" (SP));
    kprintf("\n>>>> Registerschnappschuss (%s) <<<<\nR0:  %08p  R8:  %08p\nR1:  %08p  R9:  %08p\nR2:  %08p  R10: %08p\nR3:  %08p  R11: %08p\nR4:  %08p  R12: %08p\nR5:  %08p  SP:  %08p\nR6:  %08p  LR:  %08p\nR7:  %08p  PC:  %08p\n\n",exc_type,regs->r0,regs->r8,regs->r1,regs->r9,regs->r2,regs->r10,regs->r3,regs->r11,regs->r4,regs->r12,regs->r5,SP,regs->r6,regs->lr,regs->r7,pc);
}

void SPSR_print(char * exc_type){ 
    unsigned int cpsr=0,spsr=0;
    kprintf(">>> Aktuelle Statusregister (%s) <<<\n",exc_type);
    
    asm("mrs %[result], cpsr" : [result] "=r" (cpsr));
    bitsToLetters(cpsr);
    kprintf("CPSR: %12s %12s(%08p)\n",str,modusbits(cpsr),cpsr);
    
    asm("mrs %[result], spsr" : [result] "=r" (spsr));
    bitsToLetters(spsr);
    kprintf("SPSR: %12s %12s(%08p)\n",str,modusbits(spsr),spsr);
    
}

void amr_print(){
    unsigned int cpsr=0;

    asm("mrs %[result], cpsr" : [result] "=r" (cpsr));
    kprintf("\n>>> Aktuelle modusspezifische Register <<<\n\t\t%s%12s\t\t  SPSR\n","LR","SP");

    kprintf("User/System:\t%08p  %08p\n",get_lr_usr(),get_sp_usr());

    bitsToLetters(get_spsr_svc());
    kprintf("Supervisor:\t%08p  %08p\t%s  %12s  (%08p)\n",get_lr_svc(),get_sp_svc(),str,modusbits(get_spsr_svc()),get_spsr_svc());
    
    
    bitsToLetters(get_spsr_abt()); 
    kprintf("Abort:\t\t%08p  %08p\t%s  %12s  (%08p)\n",get_lr_abt(),get_sp_abt(),str,modusbits(get_spsr_abt()),get_spsr_abt());

    bitsToLetters(get_spsr_fiq());    
    kprintf("FIQ:\t\t%08p  %08p\t%s  %12s  (%08p)\n",get_lr_fiq(),get_sp_fiq(),str,modusbits(get_spsr_fiq()),get_spsr_fiq());
    
    bitsToLetters(get_spsr_irq());   
    kprintf("IRQ:\t\t%08p  %08p\t%s  %12s  (%08p)\n",get_lr_irq(),get_sp_irq(),str,modusbits(get_spsr_irq()),get_spsr_irq());
    
    bitsToLetters(get_spsr_und());   
    kprintf("Undefined:\t%08p  %08p\t%s  %12s  (%08p)\n",get_lr_und(),get_sp_und(),str,modusbits(get_spsr_und()),get_spsr_und());
}


void general_handler(unsigned int *p, char* type, int da_flag, unsigned int pc){
    const volatile struct regStack * const regs = (struct regStack *) p;
    kprintf("\n###########################################################################\n%s at Adresse %08p\n",type,regs->lr);
    
    if(da_flag)
        da_report();
    
    if( type[0] != 'I' || (IRQ_Debug && type[0] == 'I')){
        reg_snapshot_print(type,pc,regs);
    }

    SPSR_print(type);
    amr_print();
    kprintf("\nSystem angehalten\n");
    resetTimer();   
}




/*
 ************************ Handlers Section **************************
 */

void reset_handler(unsigned int *p, unsigned int pc) {
    general_handler(p,"Reset",0,pc);
    _start();
}

void undefined_instruction_handler(unsigned int *p, unsigned int pc) {
    general_handler(p,"Undefined Instruction",0,pc);
    while(1);
}

void software_interrupt_handler(unsigned int *p, unsigned int pc) {
    general_handler(p,"Software Interrupt",0,pc);
    while(1);
}

void prefetch_abort_handler(unsigned int *p, unsigned int pc) {
    general_handler(p,"Prefetch Abort",0,pc);
}

void data_abort_handler(unsigned int *p, unsigned int pc) {
    general_handler(p,"Data abort",1,pc);
    while(1);
}

void irq_handler(unsigned int *p, unsigned int pc) {
    if(timer_guilty){
        while(getLength() > 0){
            call_routine(dequeue());
        }
        kprintf("!\n");
        resetTimer();
    }
    else if(IRQ_Debug){
        general_handler(p,"IRQ",1,pc);
        set_IRQ_DEBUG(0);
    }else{
        general_handler(p,"IRQ",1,pc);
    }
}

void fiq_handler(unsigned int *p, unsigned int pc) {
    general_handler(p,"FIQ",0,pc);
}

