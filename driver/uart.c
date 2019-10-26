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
    kprintf("char %c | string %s | hexa %x | int %i | unint %u | pointer %p | %% \n", 'x',"xyz",15,-15,15,15);
    while (_uart->fr & (1 << 4));
    kprintf("%c hello\n",_uart->dr);

    return _uart->dr;
}




