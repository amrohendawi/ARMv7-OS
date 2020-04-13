#include <usr_kprintf.h>
#include <syscall.h>
#include <user_thread_routine.h>
#define LOOP_LENGTH 15
#include <user_thread.h>

volatile unsigned int global_counter=0;
volatile char global_char=0;

void child_runner(void * c){
    int local_counter = 0;
    char ch = global_char;
    while(global_counter < LOOP_LENGTH){
        local_counter++;
        global_counter++;
        usr_kprintf("%c:%x (%c:%i)\n",ch ,global_counter,*(char *) c,local_counter);
        syscall_sleep(1);
    }
    
}


void user_parent_runner(void * c){
    global_counter = 0;
    global_char = *(char *) c;
    int local_counter = 0;
    char id1 = '1', id2= '2', id3= '3';
    syscall_exec(child_runner, &id2, 1, 1);
    syscall_exec(child_runner, &id3, 1, 1);
    
    while(global_counter < LOOP_LENGTH){
        local_counter++;
        global_counter++;
        usr_kprintf("%c:%x (%c:%i)\n",*(char *) c,global_counter,id1,local_counter);
        syscall_sleep(1);
    }
}
