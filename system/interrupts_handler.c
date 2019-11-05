#ifndef _IVT_H_
#define _IVT_H_
#include <kprintf.h>
#include <uart.h>
#include <interrupts_handler.h>

extern int _start();
char str[10];

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


void bitsToLetters(unsigned int bitstring){
    kmemset(str,10);
    if(bitstring & (1<< 31))
        str[0] = 'N';
    else
        str[0] = '_';
    
    if(bitstring & (1<< 30))
        str[1] = 'Z';
    else
        str[1] = '_';
    
    if(bitstring & (1<< 29))
        str[2] = 'C';
    else
        str[2] = '_';
    
    if(bitstring & (1<< 28))
        str[3] = 'V';
    else
        str[3] = '_';
    
    str[4] = ' ';
    
    if(bitstring & (1<< 9))
        str[5] = 'E';
    else
        str[5] = '_';
    
    str[6] = ' ';
    
    if(bitstring & (1<< 7))
        str[7] = 'I';
    else
        str[7] = '_';
    
    if(bitstring & (1<< 6))
        str[8] = 'F';
    else
        str[8] = '_';
    
    if(bitstring & (1<< 5))
        str[9] = 'T';
    else
        str[9] = '_';
}

void amr_print(unsigned int spsr1){
    unsigned int cpsr=0,lr=0,sp=0,spsr=spsr1;
    asm("mrs %[result], cpsr" : [result] "=r" (cpsr));
    kprintf("\n>>> Aktuelle modusspezifische Register <<<\n\t\tLR\t\t   SP\t   SPSR\n");
    
    asm("mrs %[result], lr_usr" : [result] "=r" (lr));
    asm("mrs %[result], sp_usr" : [result] "=r" (sp));
    kprintf("User/System:\t%p     \t%p\n",lr,sp);
    
    asm("mrs %[result], lr_svc" : [result] "=r" (lr));
    asm("mrs %[result], sp_svc" : [result] "=r" (sp));
    bitsToLetters(spsr);
    kprintf("Supervisor:\t%p\t\t   %p\t%s\n",lr,sp,str);
    
    asm("mrs %[result], lr_abt" : [result] "=r" (lr));
    asm("mrs %[result], sp_abt" : [result] "=r" (sp));
    asm("mrs %[result], spsr_abt" : [result] "=r" (spsr));
    bitsToLetters(spsr);    
    kprintf("Abort:\t\t%p\t\t   %p\t%s\n",lr,sp,str);
    
    asm("mrs %[result], lr_fiq" : [result] "=r" (lr));
    asm("mrs %[result], sp_fiq" : [result] "=r" (sp));
    asm("mrs %[result], spsr_fiq" : [result] "=r" (spsr));
    bitsToLetters(spsr);    
    kprintf("FIQ:\t\t%p\t\t   %p\t%s\n",lr,sp,str);
    
    asm("mrs %[result], lr_irq" : [result] "=r" (lr));
    asm("mrs %[result], sp_irq" : [result] "=r" (sp));
    asm("mrs %[result], spsr_irq" : [result] "=r" (spsr));
    bitsToLetters(spsr);   
    kprintf("IRQ:\t\t%p\t\t   %p\t%s\n",lr,sp,str);
    
    asm("mrs %[result], lr_und" : [result] "=r" (lr));
    asm("mrs %[result], sp_und" : [result] "=r" (sp));
    asm("mrs %[result], spsr_und" : [result] "=r" (spsr));
    bitsToLetters(spsr);   
    kprintf("Undefined:\t%p\t\t   %p\t%s\n",lr,sp,str);
}


void reg_snapshot_print(char * exc_type, const volatile struct regStack * const regs){
    int r0 = regs->r0;
    int r1 = regs->r1;
    int r2 = regs->r2;
    int r3 = regs->r3;
    int r4 = regs->r4;
    int r5 = regs->r5;
    int r6 = regs->r6;
    int r7 = regs->r7;
    int r8 = regs->r8;
    int r9 = regs->r9;
    int r10 = regs->r10;
    int r11 = regs->r11;
    int r12 = regs->r12;
    int SP = 0;
    int LR = regs->lr;
    int PC = 0;
    kprintf("\n>>>> Registerschnappschuss (%s) <<<<\nR0: %p\t\tR8: %p\nR1: %p\tR9: %p\nR2: %p\tR10: %p\nR3: %p\tR11: %p\nR4: %p\tR12: %p\nR5: %p\t\tSP: %p\nR6: %p\tLR: %p\nR7: %p\t\tPC: %p\n\n",exc_type,r0,r8,r1,r9,r2,r10,r3,r11,r4,r12,r5,SP,r6,LR,r7,PC);
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
    reg_snapshot_print("Data Abort",regs);

}
void irq_handler(unsigned int *p) {
    const volatile struct regStack * const regs = (struct regStack *) p;
    kprintf("\n###########################################################################\nIRQ at Adresse 0x000080e0\n");
    reg_snapshot_print("IRQ",regs);
//     while(1);
}
void fiq_handler(unsigned int *p) {
    const volatile struct regStack * const regs = (struct regStack *) p;
    kprintf("\n###########################################################################\nFIQ at Adresse 0x000080e0\n");
    reg_snapshot_print("FIQ",regs);
}




#endif
