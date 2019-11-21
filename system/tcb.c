#define MAX_SIZE 32
#define THREAD_BASE     0xF00000
#define THREAD_SIZE     (4096*8)
#define USER_MODUS      (0b10011)

struct list_elem{
    struct list_elem *prev;
    struct list_elem *next;
}


typedef struct tcb {
    unsigned int r0;                    //args_size reinschreiben ???
    unsigned int r1;
    unsigned int r2;
    unsigned int r3;
    unsigned int r4;
    unsigned int r5;
    unsigned int r6;
    unsigned int r7;
    unsigned int r8;
    unsigned int r9;
    unsigned int r10;
    unsigned int r11;
    unsigned int r12;
    unsigned int sp;                   // SP r13
    unsigned int lr;                   // LR r14 (link zu kill thread ?)
    unsigned int * pc;                   // PC r15 adresse zur funktion     void *func; 
    unsigned int CPSR;
    char status;                      // r:ready , c: currently running , p:pending , d:done
    void * args;
    unsigned int args_size;
    unsigned int id;
    struct list_elem rq;
}thread;


struct tcb tcbs[MAX_SIZE];
struct list_elem *runqueue;


unsigned int marshall_CPSR(){
    unsigned int CPSR = 0;
    CPSR |= USER_MODUS;
    return CPSR;
}

void set_neighbours(thread new_thread){
    new_thread->rq->prev = NULL;    
    new_thread->rq->next = NULL;
    if(new_thread->id > 0)
        new_thread->rq->prev = tcbs[new_thread->id-1];

    if(new_thread->id < 31)
        new_thread->rq->next = tcbs[new_thread->id+1];
}


void kill_thread(unsigned int id){
    thread to_kill = tcbs[i];
    tcbs[i]->r0 = NULL;
}

thread _create(thread_function thread_func, const void * args, unsigned int args_size){
    int i=0;
    while(tcbs[i] != NULL){
        i++;
        if(i >= 32){
            kprintf("max Anzahl an Threads erreicht !! muss warten bis ein Platz frei ist\n");      // print error
            return NULL;
        }
    }
    static volatile thread * const new_thread = (struct tcb *) (THREAD_BASE+THREAD_SIZE*i);
    new_thread->status = 'r';
    new_thread->pc = pc;
    new_thread->id = i;
    new_thread->lr = (unsigned int) kill_thread(new_thread->id);
    new_thread->args = args;
    new_thread->args_size = args_size;
    new_thread->CPSR = marshall_CPSR();
    set_neighbours(new_thread);
    
    return new_thread;
}


int main(){
    thread new_thread = _create(kprintf(),"ABC",3);
}

void context_switch(void){
    
}


void kill_thread(unsigned int id){
    
}
//thread killen wenn lr auf pc springt, das bedeutet dass prozess fertig ist
