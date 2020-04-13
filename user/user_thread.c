#include <usr_kprintf.h>
#include <syscall.h>
#include <user_thread_routine.h>
#include <user_thread_functions.h>
#define PTRS_ARRAY_LENGTH 64
#include <heap.h>

void * ptrs[PTRS_ARRAY_LENGTH];

void init_ptrs_array(){
    for(int i=0; i<PTRS_ARRAY_LENGTH; i++){
        ptrs[i] = malloc(0x20);
    }
}


unsigned int reduce_to_4_bit(void * ptr){
    unsigned int res = 0;
    for(int i=0; i<8; i++){
        res = res ^ (( ((unsigned int) ptr) >> i*4) & 0xf);
    }
    return res;
}


void malloc_loop(){
    init_ptrs_array();
    unsigned int i = 0;
    unsigned int X = 0;
    while(1){
        void * ptr = ptrs[i%PTRS_ARRAY_LENGTH];
        // free ptrs[i]
        free(ptr);
        // per XOR auf 4 Bit reduzieren
        X = reduce_to_4_bit(ptr);
        // X == 0 ? x = 0x1
        if(X == 0) X =  0x1;
        // X == 0xf ? free(ptr[i])
        else if(X ==  0xf) free(ptr);
        // per malloc versuchen X*256 + X*16 + X bytes zu alloziieren
        void * ptr2 = malloc(X*256 + X*16 + X);
        // Rückgabewert in prts[i] schreiben
        ptrs[i%PTRS_ARRAY_LENGTH] = ptr2;
        i++;
        
        // only for debugging reasons
/*        if(i>= 200000 && i%50000 == 0){
            debug_heap(ptrs[i%PTRS_ARRAY_LENGTH]); 
            draw_heap();
        }
        if(i >= 50000 && i%50000 == 0){
            usr_kprintf("%i\n",i);
            syscall_sleep(1);
                syscall_sleep(1);
        }      */  
        
    }
}

void anwendung(char c){
    if(c == 'm'){
        usr_kprintf("creating new process with malloc loop\n");
        syscall_exec(malloc_loop,0,0,0);
    }
    else{
        usr_kprintf("Anwendung: creating process for %c\n",c);
        syscall_exec(user_parent_runner,&c,1,0);
    }
}





