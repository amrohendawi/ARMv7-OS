#ifndef _HEAP_H_
#define _HEAP_H_
#include <stddef.h>             // important for types definitions such as size_t
#define NULL ((void *)0)


// #define MAX_HEAP_BLOCKS 8
#define FREE_BLOCK (1<<1)
#define TOP_BLOCK  1
#define MB         100000
#define BLOCK_SIZE_BITS 0xfffffffc


/*
 * heap block header represented in two different layouts
 * 1- free_block for free block which has pointer to next_free block
 * 2- reserved_block which doesnt have pointer to next_free block
 */
union heap_block{
    struct free_block{
        unsigned int ctrl;
        unsigned int prev_size;
        void * next_free;
    } FB;
    struct reserved_block{
        unsigned int ctrl;
        unsigned int prev_size;
    } RB;
};


/* allocates memory in heap and returns a pointer to the block of nbytes heap space */
void *malloc (size_t nbytes);

/* frees the block at ptr
 * returns NULL if ptr == NULL or if BLOCK at ptr is already free
 */
void free (void *ptr);

/*
 * Diese Funktion printet info über die aktuellsten Allokation für einfaches Debugging
 */
void debug_heap(void * ptr);

/*
 * diese Funktion dient dazu, den aktuellen Heap user-friendly auszuprinten, um das Debugging zu vereinfachen
 */
void draw_heap();

#endif
