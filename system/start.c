#include <led.h>
#include <uart.h>
#include <kprintf.h>
#include <kscanf.h>

void start_kernel(void)
{ 
//     char * str;
//     char input;
	while(1){
        sendChar(recvChar());
//         kprintf("please enter a string and hit enter \n");
//         kscanf("%c",&input);
//         kprintf("char %c | string %s | hexa %x | int %i | unint %u | pointer %p | %% | undefined %blabla\n",input,input,input,input,input,input,"not gonna be printed");
//         kprintf("12345678912345678912345678912345678912345678912345678 still running 12345678912345678912345678912345678912345678912345678 12345678912345678912345678912345678912345678912345678 12345678912345678912345678912345678912345678912345678 still runnig sdadasdsda %s\n second time !!!!!!! 12345678912345678912345678912345678912345678912345678 still running 12345678912345678912345678912345678912345678912345678 12345678912345678912345678912345678912345678912345678 12345678912345678912345678912345678912345678912345678 still runnig sdadasdsda %s\n","stringstringstringstringstringstringstringstringstringstringstring123123123","stringstringstringstringstringstringstringstringstringstringstring123123123stringstringstringstringstringstringstringstringstringstringstring123123123stringstringstringstringstringstringstringstringstringstringstring123123123stringstringstringstringstringstringstringstringstringstringstring123123123stringstringstringstringstringstringstringstringstringstringstring123123123");
        
    }
}

