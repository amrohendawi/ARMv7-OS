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
//    kprintf("char %c | string %s | hexa %x | int %i | unint %u | pointer %p | %% | undefined %blabla\n",'x',"dummy string",'c',-15,15,15,"not gonna be printed");
    while (_uart->fr & (1 << 4));
    unsigned int input = _uart->dr;
    //kprintf("address of n is %p\n", uar->dr);
    kprintf("%c is in hexa %x\n",input,input);
    if(input == 'i'){
        kprintf("i was pressed ! interrupts enabled.. exiting\n");
        return _uart->dr;
    }
    return _uart->dr;
}




