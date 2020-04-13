#include <kprint.h>
#include <scheduler.h>
#include <syscall.h>
#include <process.h>
#include <mmu.h>

int scheduler_pid;

// TODO: kill process when all threads of process terminated so it can be used again later
void scheduler_on_exit(int id){
    if(id != -1 && id != 1){
        int pid = get_process_id(id);
        process_array[pid].threads_active--;
        if(process_array[pid].threads_active <= 0){
            free_process(get_process_id(id));
        }
        reset_thread_process_relation(id);
    }
}



int scheduler_on_create(int id, unsigned int flags){
    if(id == -1){
        return 0;
    }
    
    if(flags == PARENT){
        int pid = process_create(id);
        process_array[pid].threads_active++;
        if(pid == -1){
            return -1;
        }
        
        scheduler_pid = pid;

    }
    else if(flags == CHILD && scheduler_pid != -1){
        thread_process_arr[id] = scheduler_pid;
        process_array[scheduler_pid].threads_active++;
    }

    return 0;
}


void scheduler_on_schedule(int old, int next){
    if(next == -1){
        return;
    }
    int old_pid = get_process_id(old);
    int next_pid = get_process_id(next);
    
    if(old_pid == next_pid){
        return;
    }

    process_switch(next_pid);
    
    // TODO: heap_switch(next_pid);
}
