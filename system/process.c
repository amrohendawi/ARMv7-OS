#include <kprint.h>
#include <process.h>
#include <mmu.h>
#include <scheduler.h>
#include <exceptions.h>

void process_switch(int new){
    map_userdata_to(process_array[new].data_address);
}


void free_process(int id){
    process_array[id].reserved = 0;
}


/*
 * returns the id of next free process or -1 if all 8 processes are reserved
 */
int find_free_process_address(void){
    for(int i=0; i<MAX_PROCESSES; i++){
        if(!process_array[i].reserved){
            return i;
        }
    }
    return -1;
}



int process_create(int parent_tid){
    
    int new_pid = find_free_process_address();
    if(new_pid == -1){
        return -1;
    }
    
    thread_process_arr[parent_tid] = new_pid;
    process_array[new_pid].reserved = 1;
    copy_userdata_template(process_array[new_pid].data_address);

    return new_pid;
}


/*
 * return -1 if no room left for a thread at the targeted process
 */
int get_process_id(int thread_id){
    if(thread_id < 0 || thread_id > 31) return -1;
    return thread_process_arr[thread_id];
}

/*
 * setzt einen thread auf keinen Prozess zurueck(-1)
 */
void reset_thread_process_relation(int id){
    thread_process_arr[id] = -1;
}

/*
 * initialisiert thread_process_arr die sagt welcher thread zu welchem Prozess gehört
 */
void init_thread_process_arr(){
    for(int i=0; i<MAX_THREADS; i++){
        thread_process_arr[i] = -1;
    }
}

/*
 * initialisiert struct _processes arrays
 */
void init_processes_array(){
    for(int i=0; i<MAX_PROCESSES; i++){
        process_array[i].id = i;
        process_array[i].reserved = 0;
        process_array[i].threads_active = 0;
        process_array[i].data_address = 8+i;
//         kprintf("\033[1;36m init_process:\033[0m id[%i] data_address[%i]\n", process_array[i].id, process_array[i].data_address);
    }
}

void init_thread_stack_arrays(){
    for(int i=0; i<MAX_THREADS; i++){
        thread_stack_array[i] = 8+i;
    }
}

void process_init(){
    kprintf("\033[1;30m ..... process init ....\033[0m\n");
    init_thread_process_arr();
    init_processes_array();
    init_thread_stack_arrays();
}
