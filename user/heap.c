#include <usr_kprintf.h>
#include <stddef.h>             // important for types definitions such as size_t
#include <heap.h>

#define HEAP_BASE 0x700000
#define RB_HEADER_SIZE  8
#define FB_HEADER_SIZE  12
#define MB_HEXA 0x100000

int heap_initialized = 1;           // 1 bedeutet uninitialized , sonst initialized
void * first_free_block = (void *) HEAP_BASE;

int round_up(size_t n){
    return n%4 == 0 ? n : n+4-(n%4);
}

int draw_heah_flag = 1;
int counter = 1;
int merge_flag = 1;
int top_block_flag = 1;
int no_free_space = 1;
/*
 * given address of certain block returns:
 * 0 if block is reserved
 * 1 if block is free
 */
int BLOCK_IS_FREE(void * BLOCK_ADDRESS){
    union  heap_block * HB  = ( union heap_block *) BLOCK_ADDRESS;
    if ((HB->RB.ctrl & FREE_BLOCK) > 0) return 1;
    return 0;
}

/*
 * given address of certain block returns:
 * 0 if block is not top
 * 1 if block is top
 */
int BLOCK_IS_TOP(void * BLOCK_ADDRESS){
    union  heap_block * HB  = ( union heap_block *) BLOCK_ADDRESS;
    return (HB->RB.ctrl & TOP_BLOCK);
}

 

void debug_heap(void * ptr){
    volatile union  heap_block * freeHB  = (volatile union heap_block *) first_free_block;
    volatile union  heap_block * HB  = (volatile union heap_block *) ptr;
    void * pre_ptr = ptr - HB->RB.prev_size - RB_HEADER_SIZE;
    volatile union heap_block * prev_HB = (volatile union heap_block *) pre_ptr;
    volatile union heap_block * next_HB = (volatile union heap_block *) (ptr + (HB->RB.ctrl & BLOCK_SIZE_BITS)+RB_HEADER_SIZE);
    
    usr_kprintf("memory available: %i\tfirst_free_block %p\n", freeHB->FB.ctrl & BLOCK_SIZE_BITS,first_free_block);
    usr_kprintf("Block at %p\t size %i\t FREE %i TOP %i\t prev_size %i\n",HB, HB->RB.ctrl &BLOCK_SIZE_BITS, HB->RB.ctrl & FREE_BLOCK, HB->RB.ctrl & TOP_BLOCK, HB->RB.prev_size);
    usr_kprintf("Prev at %p\t size %i\t FREE %i TOP %i\t prev_size %i\n",prev_HB, prev_HB->RB.ctrl &BLOCK_SIZE_BITS, prev_HB->RB.ctrl & FREE_BLOCK, prev_HB->RB.ctrl & TOP_BLOCK, prev_HB->RB.prev_size);
    usr_kprintf("Next at %p\t size %i\t FREE %i TOP %i\t prev_size %i\n\n",next_HB, (next_HB->RB.ctrl &BLOCK_SIZE_BITS), next_HB->RB.ctrl & FREE_BLOCK, next_HB->RB.ctrl & TOP_BLOCK, next_HB->RB.prev_size);
}

void draw_heap(){
    volatile union  heap_block * HB  = (volatile union heap_block *) HEAP_BASE;
    volatile union  heap_block * HB_next  = (volatile union heap_block *) ((void *) HB + (HB->RB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE);
    void * ptr = (void *) HEAP_BASE;
    do{
        if(BLOCK_IS_TOP((void *) HB)){
            draw_heah_flag = 2;
        }
        if(BLOCK_IS_FREE((void *) HB)){
            usr_kprintf("block at %p           -----------\t\t next_free at %p\n",HB,HB->FB.next_free);
            usr_kprintf("size %i p_size %i    [        ]\n",(HB->RB.ctrl&BLOCK_SIZE_BITS),HB->RB.prev_size);
            usr_kprintf("TOP %i                         ----------- next %p size %i\n",HB->RB.ctrl & TOP_BLOCK,(void *) HB_next, HB_next->RB.ctrl & BLOCK_SIZE_BITS);
        }else{
            usr_kprintf("block at %p        -----------\n",HB);
            usr_kprintf("size %i p_size %i    [xxxxxxxxx]\n",(HB->RB.ctrl&BLOCK_SIZE_BITS),HB->RB.prev_size);
            usr_kprintf("TOP %i                         ----------- next %p size %i\n",HB->RB.ctrl & TOP_BLOCK,(void *) HB_next, HB_next->RB.ctrl & BLOCK_SIZE_BITS);
        }
        HB = (volatile union heap_block *) (ptr + (HB->RB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE);
        HB_next  = (volatile union heap_block *) ((void *) HB + (HB->RB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE);
        ptr = (void *) HB;

    }while(draw_heah_flag != 2);
    draw_heah_flag = 1;
}


void assign_new_top_block( union  heap_block * oldBlock,  union  heap_block * newBlock){
    if(oldBlock->FB.ctrl & TOP_BLOCK) newBlock->FB.ctrl |= TOP_BLOCK;
}



void * find_next_free(void * ptr){
     union  heap_block * next_HB = ( union heap_block *) ptr;
    if(BLOCK_IS_TOP(ptr)) return NULL;
    next_HB = ( union heap_block *) (ptr + (next_HB->RB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE);
        if(counter > 15)
    while(!BLOCK_IS_FREE((void *) next_HB)){
        ptr = (void *) next_HB;
        next_HB = ( union heap_block *) (ptr + (next_HB->RB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE);
    }
    return (void *) next_HB;
}

void * find_prev_free(void * ptr){
    volatile union  heap_block * prev_HB = (volatile union heap_block *) ptr;
    while((void *) prev_HB >= (void *) HEAP_BASE && BLOCK_IS_FREE((void *) prev_HB) == 0){
        ptr = (void *) prev_HB;

        if((ptr - (prev_HB->RB.prev_size) - RB_HEADER_SIZE) < (void *) HEAP_BASE || (ptr - (prev_HB->RB.prev_size) - RB_HEADER_SIZE) > (void *) HEAP_BASE + MB_HEXA) return NULL;
        prev_HB = (volatile union heap_block *) (ptr - (prev_HB->RB.prev_size) - RB_HEADER_SIZE);
        if((void *) prev_HB > (void *) HEAP_BASE + MB_HEXA) return NULL;
    }
    return (void *) prev_HB >= (void *) HEAP_BASE ? (void *) prev_HB : NULL;
}

void update_first_free_block(){
     union  heap_block * HB  = ( union heap_block *) HEAP_BASE;
    void * ptr = (void *) HEAP_BASE;

    while(!BLOCK_IS_FREE((void *) HB) && !BLOCK_IS_TOP((void *) HB)){
        ptr += (HB->RB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE;
        if(BLOCK_IS_TOP((void *) HB)){
            first_free_block = 0x0;
            no_free_space = 2;
            return;
        }
        HB  = ( union heap_block *) ptr;
    }
    first_free_block = (void *) HB;
}


/* allocates memory in heap and returns a pointer to the block of nbytes heap space */
void *malloc (size_t nbytes){ 
    if(no_free_space == 2) return NULL;
    unsigned int n = round_up(nbytes);
    if(heap_initialized == 1){
         union  heap_block * HB  = ( union heap_block *) HEAP_BASE;
        HB->RB.ctrl = n & BLOCK_SIZE_BITS;
        HB->RB.prev_size = 0;
        
         union  heap_block * hb_top = ( union heap_block *) (HEAP_BASE + n + RB_HEADER_SIZE);
        hb_top->FB.ctrl = ((MB_HEXA - n - RB_HEADER_SIZE) & BLOCK_SIZE_BITS) + FREE_BLOCK + TOP_BLOCK;
        hb_top->FB.prev_size = n;
        hb_top->FB.next_free = NULL;
        first_free_block = (void *) hb_top;
        heap_initialized = 2;
        
        return (void *) HB;
    }else{
         union  heap_block * HB  = ( union heap_block *) first_free_block;
        // loop searching for the first fitting free block. return NULL when reaching NULL next_free pointer
        while(n > (HB->FB.ctrl & BLOCK_SIZE_BITS)){
            if(BLOCK_IS_TOP((void *) HB)) return NULL;
            HB  = ( union heap_block *) HB->FB.next_free;
        }
        void * ptrr = (void *) HB;
        void * HB_ptr = (ptrr - HB->RB.prev_size - RB_HEADER_SIZE);
         union heap_block * prev_HB = ( union heap_block *) HB_ptr;

        // if free block > required space to allocate -> create new free block on top of it
         union heap_block * hb_above = NULL;
        int rest = (HB->FB.ctrl & BLOCK_SIZE_BITS) - n;
        if(n < (HB->FB.ctrl & BLOCK_SIZE_BITS) && rest >= 12){
            hb_above = ( union heap_block *) (ptrr + n + RB_HEADER_SIZE);
            hb_above->FB.ctrl = ((HB->FB.ctrl & BLOCK_SIZE_BITS) - n - RB_HEADER_SIZE) + FREE_BLOCK;
            assign_new_top_block(HB,hb_above);
            hb_above->FB.prev_size = n;
            void * nn_ptr = (void *) hb_above;
             union heap_block * next_next_HB = ( union heap_block *) (nn_ptr + (hb_above->FB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE);
            next_next_HB->RB.prev_size = (hb_above->FB.ctrl & BLOCK_SIZE_BITS);

            void * p = find_prev_free((void *) HB_ptr);
             union heap_block * prev_HB2 = ( union heap_block *) p;
            prev_HB2->FB.next_free = (void *) hb_above;            
            if(BLOCK_IS_TOP((void *) HB)){
                hb_above->FB.next_free = NULL;
                hb_above->FB.ctrl |= TOP_BLOCK;

            }else{ 
                void * p = find_next_free((void *) hb_above);
                hb_above->FB.next_free = p;
            }
        }
        if(BLOCK_IS_TOP((void *) HB) && n >= (HB->FB.ctrl & BLOCK_SIZE_BITS)) top_block_flag = 2;
        HB->RB.ctrl = n & BLOCK_SIZE_BITS;
        if((void *) HB != (void *) HEAP_BASE)
            HB->RB.prev_size = prev_HB->RB.ctrl & BLOCK_SIZE_BITS;

        void * prev_ptr = find_prev_free((void *) HB);
        if(rest < 12){
            HB->RB.ctrl += rest;
            if(top_block_flag == 2) HB->RB.ctrl += TOP_BLOCK;
        }
        if(prev_ptr != NULL){
            prev_HB = ( union heap_block *) prev_ptr;

            void * next_prev_ptr = find_next_free(prev_ptr);
            prev_HB->FB.next_free = next_prev_ptr;
        }
        update_first_free_block();
        counter++;
        return (void *) HB;
    }
    top_block_flag = 1;
    return NULL;
}


void check_merge_with_top(void * ptr){
     union  heap_block * HB_to_free = ( union heap_block *) ptr;
    
     union heap_block * next_HB = ( union heap_block *) (ptr + (HB_to_free->RB.ctrl & BLOCK_SIZE_BITS)+RB_HEADER_SIZE);
    void * next_ptrr =  (void *) next_HB;
     union heap_block * next_next_HB = ( union heap_block *) (next_ptrr + (next_HB->RB.ctrl & BLOCK_SIZE_BITS)+RB_HEADER_SIZE);
    if(!BLOCK_IS_FREE((void *) next_HB)) return;
    if(BLOCK_IS_TOP((void *) next_HB)){
        first_free_block = (void *) HB_to_free;
        HB_to_free->FB.ctrl += TOP_BLOCK;
    }
    HB_to_free->FB.ctrl += (next_HB->FB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE;
    if(BLOCK_IS_TOP((void *) next_HB)){
        next_HB->FB.ctrl &= ~TOP_BLOCK;
        HB_to_free->FB.next_free = NULL;
    }else{
        void * next_free_ptr = find_next_free((void *) next_HB);
        HB_to_free->FB.next_free = next_free_ptr;
    }
    next_next_HB->RB.prev_size = HB_to_free->RB.ctrl & BLOCK_SIZE_BITS;
    void * p = find_prev_free((void *) HB_to_free);
     union heap_block * prev_HB2 = ( union heap_block *) p;
    prev_HB2->FB.next_free = (void *) HB_to_free;            
}

void check_merge_with_bottom(void * ptr){
     union  heap_block * HB_to_free = ( union heap_block *) ptr;

    void * pre_ptr = ptr - HB_to_free->RB.prev_size - RB_HEADER_SIZE;
     union heap_block * prev_HB = ( union heap_block *) pre_ptr;
    
    if((void *) prev_HB < (void *) HEAP_BASE || !BLOCK_IS_FREE((void *) prev_HB)) return;
    prev_HB->FB.ctrl += (HB_to_free->RB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE;
    HB_to_free->FB.next_free = NULL;
    HB_to_free->FB.ctrl |= FREE_BLOCK;
    if(BLOCK_IS_TOP((void *) HB_to_free)){
        HB_to_free->FB.ctrl &= ~ TOP_BLOCK;
        prev_HB->FB.ctrl |= TOP_BLOCK;
    }else{
         union  heap_block * next_HB = ( union heap_block *) (ptr + (HB_to_free->RB.ctrl & BLOCK_SIZE_BITS) + RB_HEADER_SIZE);
        next_HB->RB.prev_size = prev_HB->FB.ctrl & BLOCK_SIZE_BITS;
    }
    merge_flag = 2;
    

}

/* frees the block at ptr */
void free (void *ptr){
    if(ptr == NULL){
//         usr_kprintf("free: NULL pointer !! not doing anything\n");
        return;
    }
    if( BLOCK_IS_FREE(ptr) ){
//         usr_kprintf("\n --- block at %p already free.. not freeing again ---\n", ptr);
        return;
    }
    
    
     union  heap_block * HB_to_free = ( union heap_block *) ptr;

    void * pre_ptr = ptr - HB_to_free->RB.prev_size - RB_HEADER_SIZE;
     union heap_block * prev_HB = ( union heap_block *) pre_ptr;
     union heap_block * next_HB = ( union heap_block *) (ptr + (HB_to_free->RB.ctrl & BLOCK_SIZE_BITS)+RB_HEADER_SIZE);

    HB_to_free->RB.ctrl += FREE_BLOCK;

    if (BLOCK_IS_TOP(ptr) && HB_to_free->RB.prev_size == 0){
        first_free_block = (void *) HEAP_BASE;
        HB_to_free->FB.ctrl += (next_HB->FB.ctrl & BLOCK_SIZE_BITS);
        return;
    }else{
        check_merge_with_top(ptr);
        check_merge_with_bottom(ptr);
    }
    if(merge_flag == 2) ptr = pre_ptr;

    void * ptt = find_next_free(ptr);
    HB_to_free->FB.next_free = ptt;
    ptt = find_prev_free((void *) prev_HB);
    if(ptt != NULL){
         union  heap_block * HB_prev = ( union heap_block *) ptt;
        void * next_free_p = find_next_free(ptt);
        HB_prev->FB.next_free = next_free_p;
    }
    update_first_free_block();

    top_block_flag = 1;
    no_free_space = 1;
    merge_flag = 1;
}
