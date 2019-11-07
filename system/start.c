// #include <led.h>
#include <uart.h>
#include <routine.h>
#include <kprintf.h>
#include <interrupts_handler.h>
// #include <kscanf.h>

void start_kernel(void)
{ 

	while(1){
        char input = recvChar();
        sendChar(input);
        interrupt_check(input);
    }
}

