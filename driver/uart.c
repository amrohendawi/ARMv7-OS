#define UART_BASE (0x7E201000 - 0x3F000000)
#include <kprintf.h>
#include <uart.h>
#include <interrupts_handler.h>
#include <led.h>
extern int execute();

void sendChar(char c){
    while (_uart->FR & TXFF);
    _uart->DR = c;
}

char recvChar(void){
    while (_uart->FR & RXFE);
    char input = _uart->DR;
    kprintf("char %c | string %s | hexa %x | int %i | unint %u | pointer %p | %% | undefined %blabla\n\n",input,input,input,input,input,input,"not gonna be printed");
    
    
    // when interrupts are supposed to take action... Aufgabe 3 & 4
    if(input == 'i'){
//         kprintf("\n\nenable_IRQs_2: %x \n",(_interrupts->enable_IRQs_2 >> 25)&1);
        kprintf("%c is pressed !! one more button to activate the interrupt \n\n", input);
        //warte bis Transmission fertig ist
        while(_uart->FR & BUSY);
        // enable uart_int interrupt
        _interrupts->enable_IRQs_2 |= (1<<25);        
        // disable UART
        _uart->CR &= ~(1);
        //disable FIFO
        _uart->LCRH &= ~(1<<4);
        // setzt IFLS 5:0 bits auf 000000 --> Interrupt is triggered when FIFO gets 1/8 full receive and transmit
        _uart->IFLS &= ~(0b000000);
        // setzt RXIM bit auf 1 --> Receive interrupt mask is set
        _uart->IMSC |= (1<<4);
        // UART enable
        _uart->CR |= 1;
    }
    return input;
}




