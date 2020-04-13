#include <user_thread.h>
#include <usr_kprintf.h>
#include <syscall.h>
#include <heap.h>

void start_usr()
{ 


    usr_kprintf(".\n.\n.... welcome to User Mode ....\n.\n.\n");
    usr_kprintf("press any button to start a normal Aufgabe 6 process \n");
    usr_kprintf("press m to start a malloc process\n");
    
    while(1){
        char c = syscall_getc();
        if(c>0 && c<128){
            anwendung(c);
        }
    }
}
