#define UART_BASE (0x7E201000 - 0x3F000000)
#include <kprintf.h>
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


void sendChar(char input){
    while (_uart->FR & TXFF);
    _uart->DR = input;
}

char recvChar(void){
    
    while (_uart->FR & RXFE);
    char input = (char) _uart->DR;
    return input;
}




