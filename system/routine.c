#include <kprintf.h>
#include <interrupts_handler.h>
#include <led.h>
#include <uart.h>
#include <timer.h>
#include <regcheck.h>

extern int cause_data_abort();
int interactive_on = 0;

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

void enable_uart_IRQ(){
        //warte bis Transmission fertig ist
        while(_uart->FR & BUSY);
        // enable uart_int interrupt
        _interrupts->enable_IRQs_2 |= (1<<25);        
        // setzt RXIM bit auf 1 --> Receive interrupt mask is set
        _uart->IMSC |= (1<<4);
}


void cause_FIQ(){
        // disable RIQ
        asm("cpsid i");
        // enable FIQ
        asm("cpsie f");
        _interrupts->FIQ_control |= (1<<7);
        //warte bis Transmission fertig ist
        while(_uart->FR & BUSY);
        // setzt RXIM bit auf 1 --> Receive interrupt mask is set
        _uart->IMSC |= (1<<4);
}


void activate_interactive(void){
    interactive_on = 1;
}

void lazyOutput(char input){
    for(int w=0;w<50;w++){
        for(int i=0;i<59999;i++){
            yellow_on();
        }
        sendChar(input);
    }
}


void call_routine(char input){

    switch(input){
        case 'd':
            set_IRQ_DEBUG(1);
            break;
        case 's':
            asm("SWI 0");
            break;
        case 'u':
            asm volatile ("UDF");
            break;
        case 'a':
            cause_data_abort();
            break;
        case 'f':
            cause_FIQ();
            break;
        case 'c':
            register_checker();
            break;
            
        case 'e':
            kprintf("interactive under-program is activate\n");
            activate_interactive();
            break;     
        default:
            if(interactive_on){
                lazyOutput(input);
            }else{
                sendChar(input);
            }
    }


}

