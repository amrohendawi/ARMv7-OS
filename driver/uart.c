#define UART_BASE (0x7E201000 - 0x3F000000)
#include <kprintf.h>
#include <uart.h>
#include <interrupts_handler.h>

void sendChar(char c){

    while (_uart->FR & UART_FR_TXFF);
    _uart->DR = c;
}

char recvChar(void){
//     kprintf("char %c | string %s | hexa %x | int %i | unint %u | pointer %p | %% | undefined %blabla\n",'x',"dummy string",'c',-15,15,15,"not gonna be printed");
    while (_uart->FR & UART_FR_RXFE);
    char input = _uart->DR;
//     kprintf("char %c | string %s | hexa %x | int %i | unint %u | pointer %p | %% | undefined %blabla\n",input,input,input,input,input,input,"not gonna be printed");
    
    if(input == 'i'){

        _interrupts->enable_IRQs_2 |= (1<<25);
        //warte bis Transmission fertig ist
//         while(_uart->FR & UART_FR_BUSY);
        // disable UART
        _uart->CR &= ~(1);
        _uart->LCRH &= ~(1<<4);

        // setzt IFLS 5:0 bits auf 000000 --> Interrupt is triggered when FIFO gets 1/8 full receive and transmit
//         _uart->IFLS &= ~(0b010010);

        // setzt RXIM bit auf 1 --> Receive interrupt mask is set
        _uart->IMSC &= ~(1<<4);
        
        // UART enable
        _uart->CR |= 1;
        
        kprintf("%i \n",(_interrupts->enable_IRQs_2 & (1<<25)) );

        kprintf("%c is pressed !! interrupt should be released \n", input);

    }
 

    return _uart->DR;
}




