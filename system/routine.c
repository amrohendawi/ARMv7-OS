#include <kprintf.h>
#include <interrupts_handler.h>
// #include <led.h>
#include <uart.h>
#include <timer.h>

extern int cause_data_abort();

struct uart {
    unsigned int DR;
    unsigned int RSRECR;
    unsigned int unused[4];
    unsigned int FR;
    unsigned int unused2[2];
    unsigned int IBRD;
    unsigned int FBRD;
    unsigned int LCRH;
    unsigned int CR;
    unsigned int IFLS;
    unsigned int IMSC;
    unsigned int RIS;
    unsigned int MIS;
    unsigned int ICR;
    unsigned int DMACR;
    unsigned int unused4[9];
    unsigned int ITCR;
    unsigned int ITIP;
    unsigned int ITOP;
    unsigned int TDR;
    
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

void cause_IRQ(){
        // enalbe IRQ
        asm("cpsie i");
        //warte bis Transmission fertig ist
        while(_uart->FR & BUSY);
        // enable uart_int interrupt
        _interrupts->enable_IRQs_2 |= (1<<25);        
        // disable UART
        _uart->CR &= ~(1);
        //disable FIFO
        _uart->LCRH &= ~(1<<4);
        // setzt RXIM bit auf 1 --> Receive interrupt mask is set
        _uart->IMSC |= (1<<4);
        // UART enable
        _uart->CR |= 1;
}


void cause_FIQ(){
            // disable RIQ
        asm("cpsid i");
        // enable FIQ
        asm("cpsie f");
        
        _interrupts->FIQ_control |= (1<<7);
        //warte bis Transmission fertig ist
        while(_uart->FR & BUSY);
        // enable uart_int interrupt
        _interrupts->enable_IRQs_2 |= (1<<25);        
        // disable UART
        _uart->CR &= ~(1);
        //disable FIFO
        _uart->LCRH &= ~(1<<4);
        // setzt RXIM bit auf 1 --> Receive interrupt mask is set
        _uart->IMSC |= (1<<4);
        // UART enable
        _uart->CR |= 1;
}



void interrupt_check(char input){
    
    kprintf("char %c | string %s | hexa %x | int %i | unint %u | pointer %p | %% | undefined %blabla\n\n",input,input,input,input,input,input,"not gonna be printed");
    
    if(input == 'd')
        set_IRQ_DEBUG(1);
    
    if(input == 'i'){
        kprintf("%c is pressed !! one more button to activate the interrupt \n\n", input);
        asm("cpsie i");
        setTime(999999999);
        timer_en_irq();
    }
    if(input == 's')
        asm("SWI 0");
    
    if(input == 'u'){
//         kprintf("##################################\nundefined interrupt should be released \n\n");

        asm volatile (".word 0xf7f0a000");
    }
    if(input == 'a'){
        kprintf("##################################\ndata abort interrupt should be released \n\n");
//         asm volatile ("mov  r0, #0x00000000\n\t"
//                     "push {r0}");
        cause_data_abort();
   }
    if(input == 'f'){
        kprintf("%c is pressed !! one more button to activate the interrupt \n\n", input);
        cause_FIQ();
    }

//     kprintf("back to the game\n");
    
//     return 0;
}

