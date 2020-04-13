#ifndef _PROCESS_H_
#define _PROCESS_H_
#define MAX_PROCESSES 8
#include <scheduler.h>


typedef struct __process{
    int id;
    int reserved;
    int data_address;
    int threads_active;
} _process;


enum thread_type {
	PARENT,
    CHILD
};

int thread_process_arr[MAX_THREADS];
_process process_array[MAX_PROCESSES];
int thread_stack_array[MAX_THREADS];

void set_as_parent_thread_in_array(int id);
int parent_thread_id(int id);

int get_process_id(int thread_id);


void process_switch(int new);

/*
 * creates new process.
 * returns -1 when it fails to create one or if there is no more free processes
 */
int process_create(int id);


void init_process_arrays();

void free_process(int id);

void process_init();
void reset_thread_process_relation();

#endif /* _PROCESS_H_ */
