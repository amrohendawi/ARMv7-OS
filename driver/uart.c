#define UART_BASE (0x7E201000 - 0x3F000000)
#include <kprintf.h>

struct uart {
    unsigned int dr;
    unsigned int unused[5];
    unsigned int fr;
};

static volatile struct uart * const _uart = (struct uart *)UART_BASE;

void sendChar(char c){
    while (_uart->fr & (1 << 5));
    _uart->dr = c;
}

char recvChar(void){
    while (_uart->fr & (1 << 4));
    kprintf('p',_uart->dr);

    return _uart->dr;
}




