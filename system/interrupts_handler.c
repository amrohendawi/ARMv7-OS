#ifndef _IVT_H_
#define _IVT_H_
#include <kprintf.h>
#include <uart.h>
#include <interrupts_handler.h>
#include <timer.h>

extern int _start();
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
  unsigned int pc;
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

void da_report(){
    unsigned int DFSR=0,DFAR=0;
    asm("MRC p15, 0, %[result], c5, c0, 0" : [result] "=r" (DFSR));
    asm("MRC p15, 0, %[result], c6, c0, 0" : [result] "=r" (DFAR));
    
    kprintf("Zugriff: lesend auf Adresse %p\n",DFAR);
//     kprintf("DFSR : %x\n",DFSR);
    switch(DFSR & 31){
        case 0b00000:
            kprintf("Fehler: No function, reset value\n");
        break;
        
        case 0b00001:
            kprintf("Fehler: Alignment fault\n");
        break;
        
        case 0b00010:
            kprintf("Fehler:Debug event fault\n");
        break;
        
        case 0b00011:
            kprintf("Fehler: Access Flag fault on Section\n");
        break;
        
        case 0b00100:
            kprintf("Fehler: Cache maintenance operation fault[b]\n");
        break;
        
        case 0b00101:
            kprintf("Fehler: Translation fault on Section\n");
        break;
        
        case 0b00110:
            kprintf("Fehler: Access Flag fault on Page\n");
        break;
        
        case 0b00111:
            kprintf("Fehler: Translation fault on Page\n");
        break;
        
        case 0b01000:
            kprintf("Fehler: Precise External Abort\n");
        break;
        
        case 0b01001:
            kprintf("Fehler: Domain fault on Section\n");
        break;
        
        case 0b01010:
            kprintf("Fehler: No function\n");
        break;
        
        case 0b01011:
            kprintf("Fehler: Domain fault on Page\n");
        break;
        
        case 0b01100:
            kprintf("Fehler: External abort on translation, first level\n");
        break;
        
        case 0b01101:
            kprintf("Fehler: Permission fault on Section\n");
        break;
        
        case 0b01110:
            kprintf("Fehler: External abort on translation, second level\n");
        break;
        
        case 0b01111:
            kprintf("Fehler: Permission fault on Page\n");
        break;
        
        case 0b10110:
            kprintf("Fehler: Imprecise External Abort\n");
        break;
        
        case 0b10111:
            kprintf("Fehler: No function\n");
        break;
        
        default:
            if((DFSR & 28) == 0b100)
                kprintf("Fehler: No function\n");
            else if((DFSR & 30) == 0b1010)
                kprintf("Fehler: No function\n");
//             else if((DFSR & 24) == 0b11)
//                 kprintf("Fehler: No function\n");
        break;
    }
}




void bitsToLetters(unsigned int bitstring){
    kmemset(str,10);
    
    str[0] = (bitstring & (1<< 31)) ? 'N' : '_';
    str[1] = (bitstring & (1<< 30)) ? 'Z' : '_';
    str[2] = (bitstring & (1<< 29)) ? 'C' : '_';
    str[3] = (bitstring & (1<< 28)) ? 'V' : '_';
    str[4] = ' ';
    str[5] = (bitstring & (1<< 9)) ? 'E' : '_';
    str[6] = ' ';
    str[7] = (bitstring & (1<< 7)) ? 'I' : '_';
    str[8] = (bitstring & (1<< 6)) ? 'F' : '_';
    str[9] = (bitstring & (1<< 5)) ? 'T' : '_';
}

void amr_print(unsigned int spsr1){
    unsigned int cpsr=0,lr=0,sp=0,spsr=spsr1;
    asm("mrs %[result], cpsr" : [result] "=r" (cpsr));
    kprintf("\n>>> Aktuelle modusspezifische Register <<<\n\t\tLR\t\t   SP\t\t   SPSR\n");
    
    asm("mrs %[result], lr_usr" : [result] "=r" (lr));
    asm("mrs %[result], sp_usr" : [result] "=r" (sp));
    kprintf("User/System:\t%p\t\t   %p\n",lr,sp);
    
    asm("mrs %[result], lr_svc" : [result] "=r" (lr));
    asm("mrs %[result], sp_svc" : [result] "=r" (sp));
    bitsToLetters(spsr);
    kprintf("Supervisor:\t%p\t\t   %p\t%s\n",lr,sp,str);
    
    asm("mrs %[result], lr_abt" : [result] "=r" (lr));
    asm("mrs %[result], sp_abt" : [result] "=r" (sp));
    asm("mrs %[result], spsr_abt" : [result] "=r" (spsr));
    bitsToLetters(spsr);    
    kprintf("Abort:\t\t%p\t   %p\t%s\n",lr,sp,str);
    
    asm("mrs %[result], lr_fiq" : [result] "=r" (lr));
    asm("mrs %[result], sp_fiq" : [result] "=r" (sp));
    asm("mrs %[result], spsr_fiq" : [result] "=r" (spsr));
    bitsToLetters(spsr);    
    kprintf("FIQ:\t\t%p\t   %p\t%s\n",lr,sp,str);
    
    asm("mrs %[result], lr_irq" : [result] "=r" (lr));
    asm("mrs %[result], sp_irq" : [result] "=r" (sp));
    asm("mrs %[result], spsr_irq" : [result] "=r" (spsr));
    bitsToLetters(spsr);   
    kprintf("IRQ:\t\t%p\t   %p\t%s\n",lr,sp,str);
    
    asm("mrs %[result], lr_und" : [result] "=r" (lr));
    asm("mrs %[result], sp_und" : [result] "=r" (sp));
    asm("mrs %[result], spsr_und" : [result] "=r" (spsr));
    bitsToLetters(spsr);   
    kprintf("Undefined:\t%p\t   %p\t%s\n",lr,sp,str);
}


void reg_snapshot_print(char * exc_type, const volatile struct regStack * const regs){
    int SP = 0;
    int PC = 0;
    kprintf("\n>>>> Registerschnappschuss (%s) <<<<\nR0: %p\t\tR8: %p\nR1: %p\tR9: %p\nR2: %p\tR10: %p\nR3: %p\tR11: %p\nR4: %p\tR12: %p\nR5: %p\t\tSP: %p\nR6: %p\tLR: %p\nR7: %p\t\tPC: %p\n\n",exc_type,regs->r0,regs->r8,regs->r1,regs->r9,regs->r2,regs->r10,regs->r3,regs->r11,regs->r4,regs->r12,regs->r5,SP,regs->r6,regs->lr,regs->r7,PC);
}

void SPSR_print(char * exc_type, unsigned int spsr){
    unsigned int cpsr=0;
    
    asm("mrs %[result], cpsr" : [result] "=r" (cpsr));
//     asm("mrs %[result], spsr_svc" : [result] "=r" (spsr));
    bitsToLetters(cpsr);
    kprintf(">>> Aktuelle Statusregister (%s) <<<\n",exc_type);
    kprintf("CPSR: %s Abort \t\t (%p)\n",str,cpsr);
    bitsToLetters(spsr);
    kprintf("SPSR: %s Supervisor \t (%p)\n",str,spsr);
    
    
    //last section of report
    
}


void reset_handler() {
    kprintf("\n###########################################################################\nReset at Adresse 0x000080e0\n");
//     reg_snapshot_print("Reset",0);
    _start();
}
void undefined_instruction_handler(unsigned int *p) {
    const volatile struct regStack * const regs = (struct regStack *) p;
    kprintf("\n###########################################################################\nUndefinied Instruction at Adresse %p\n", *p);
    reg_snapshot_print("Undefined Instruction",regs);

}
void software_interrupt_handler(unsigned int *p, unsigned int sp, unsigned int spsr) {
    const volatile struct regStack * const regs = (struct regStack *) p;
    kprintf("sp %p : pc %p : spsr %p \n",sp,regs->pc,spsr);
    bitsToLetters(spsr);
    kprintf("\n###########################################################################\nSoftware Interrupt at Adresse %p\n",*p);

    reg_snapshot_print("Software Interrupt",regs);
    SPSR_print("IRQ",spsr);
    amr_print(spsr);

}
void prefetch_abort_handler(unsigned int *p) {
    const volatile struct regStack * const regs = (struct regStack *) p;
    kprintf("\n###########################################################################\nPrefetch Abort at Adresse 0x000080e0\n");
    reg_snapshot_print("Prefetch Abort",regs);

}
void data_abort_handler(unsigned int *p) {
    const volatile struct regStack * const regs = (struct regStack *) p;
    kprintf("\n###########################################################################\nData Abort at Adresse 0x000080e0\n");
    da_report();
    reg_snapshot_print("Data Abort",regs);
    while(1);
}
void irq_handler(unsigned int *p) {
    const volatile struct regStack * const regs = (struct regStack *) p;
    kprintf("\n###########################################################################\nIRQ at Adresse 0x000080e0\n");
    if(IRQ_Debug){
        reg_snapshot_print("IRQ",regs);
        set_IRQ_DEBUG(0);
    }
    if(lt->LTC & (1<<31))
        clear_timer();
    while(1);
}
void fiq_handler(unsigned int *p) {
    const volatile struct regStack * const regs = (struct regStack *) p;
    kprintf("\n###########################################################################\nFIQ at Adresse 0x000080e0\n");
    reg_snapshot_print("FIQ",regs);
}




#endif
