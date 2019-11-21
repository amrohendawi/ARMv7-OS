#define UART_BASE (0x7E201000 - 0x3F000000)
#include <uart.h>
#include <led.h>

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


void sendChar(char input){
    while (_uart->FR & TXFF);
    _uart->DR = input;
}

char recvChar(void){
    while (_uart->FR & RXFE);
    return _uart->DR;
}




