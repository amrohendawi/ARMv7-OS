#define UART_BASE (0x7E201000 - 0x3F000000)
#include <led.h>
#include <stdarg.h>

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



void decToHex(int n){
    char res[50];
    int i = 0;
    
    while(n!=0){
        int temp = n%16;
        if(temp < 10) {
            res[i++] = temp + 48;
        }
        else{
            res[i++] = temp + 55;
        }
        n /= 16;
    }
    i--;
    while(i >= 0){
        sendChar(res[i--]);
    }
}


void kprintf(char type, ...){
    va_list v1;
    va_start(v1,type);
    sendChar('\n');

    char ch = (char)va_arg(v1,int);
    char * str;
    switch(type)
    {
        case 'c':
            sendChar(ch);
           str  = " is as a char ";
            while (str[0] != 0){
                sendChar(str[0]);
                str++;
            }
            sendChar(ch);
        break;
        case 's':
            sendChar(ch);
            str = " is as a string ";
            while (str[0] != 0){
                sendChar(str[0]);
                str++;
            }
            sendChar(ch);
        break;        
        case 'x':
            sendChar(ch);
            char * str = " is in hexadecimal 0x";
            while (str[0] != 0){
                sendChar(str[0]);
                str++;
            }
            decToHex(ch);
        break;        
    }
    
}

char recvChar(void){
    while (_uart->fr & (1 << 4));
    kprintf('x',_uart->dr);
    return _uart->dr;
}




