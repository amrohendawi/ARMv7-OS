#include <timer.h>
#include <uart.h>
#include <cpu.h>
#include <kprint.h>
#include <scheduler.h>
#include <usr_start.h>
#include <syscall.h>
#include <kernel.h>
#include <mmu.h>
#include <process.h>

#define     STACK_BASE 0xF0000
#define     STACK_SIZE 1024
#define     STACK_IRQ (STACK_BASE + STACK_SIZE*0)
#define     STACK_SYS (STACK_BASE + STACK_SIZE*1)
#define     STACK_UND (STACK_BASE + STACK_SIZE*2+STACK_SIZE*32)
#define     STACK_ABT (STACK_BASE + STACK_SIZE*3+STACK_SIZE*32)
#define     STACK_SVC (STACK_BASE + STACK_SIZE*4+STACK_SIZE*32)
// #define     TASKS_STACK_BASE 0xF000000


void start_kernel(void)
{ 
    struct stack_setup stacks = {
        . abt_sp = STACK_ABT,
        . svc_sp = STACK_SVC,
        . und_sp = STACK_UND,
        . irq_sp = STACK_IRQ,
        . tasks_sp = STACK_SYS,
        . tasks_sp_size = STACK_SIZE,
        . tasks_same_stack = 0
    };
    
    kernel_setup(&stacks);
    kernel_init();

}

void init(void){
    kprintf("\033[1;33m initialize essentials \033[0m\n");
    mmu_init();
    process_init();
//     heap_init();
    uart_irq_enable();
    timer_start();
    syscall_exec(start_usr,(void *)0,0,0);
}
