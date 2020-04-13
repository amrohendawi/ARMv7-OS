#include <usr_kprintf.h>
#include <syscall.h>


void read_null_pointer(){
   char c = *(volatile char*)0;
   usr_kprintf("not supposed to read anything %c\n",c);
}

void stackOverFlow(){
    asm volatile("NOP");
    stackOverFlow(); 
}

void read_unordered_address(){
    char c = *(volatile char*) 0xFFFFFFF1;
   usr_kprintf("not supposed to read anything %c\n",c);
}

void create_security_breach(char c){
    switch(c){
        case 'n':
        {
            usr_kprintf("%c pressed. initiate Zugriff auf Null-Pointer\n",c);
            syscall_exec(read_null_pointer,(void *)0,0,0);
            char c = *(volatile char*)0;
            usr_kprintf("not supposed to read anything %c\n",c);
            break;
        }
        case 'p':
        {
            usr_kprintf("%c pressed. initiate Sprung auf Null-Pointer\n",c);
                void (*foo)(void) = 0x0;
                foo();
            break;
        }
        case 'd':
        {
            usr_kprintf("%c pressed. initiate lesender Zugriff auf Kernel-Daten\n",c);
            break;
        }
        case 'k':
        {
            usr_kprintf("%c pressed. initiate lesender Zugriff auf Kernel-Code\n",c);
            break;
        }
        case 'K':
        {
            usr_kprintf("%c pressed. initiate lesender Zugriff auf Kernel-Stack\n",c);
            break;
        }
        case 'g':
        {
            usr_kprintf("%c pressed. initiate lesender Zugriff auf Peripherie-Gerät\n",c);
            break;
        }
        case 'c':
        {
            usr_kprintf("%c pressed. initiate schreibender Zugriff auf eigenen Code\n",c);
            break;
        }
        case 's':
        {
            usr_kprintf("%c pressed. initiate stackOverFlow\n",c);
            stackOverFlow();
            break;
        }
        case 'u':
        {
            usr_kprintf("%c pressed. initiate lesender Zugriff auf nicht zugeordnete Adresse\n",c);
            syscall_exec(read_unordered_address,(void *)0,0,0);
            break;
        }
        case 'x':
        {
            usr_kprintf("%c pressed. Sprung auf eigene Daten oder Stack\n",c);
            break;
        }
    }
}


