#include <led.h>
#include <uart.h>
void start_kernel(void)
{ 
	while(1){
        sendChar(recvChar());
    }
}
