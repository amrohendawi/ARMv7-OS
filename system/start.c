#include <FIFO.h>
#include <timer.h>
#include <uart.h>

void start_kernel(void)
{ 

    start_timer_interrupt(99999999);
    enable_uart_IRQ();
    
	while(1){
        read_and_write();
    }
    
    
}

