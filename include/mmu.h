#ifndef _MMU_H_
#define _MMU_H_

/* Gibt den Wert des DFSR Register aus */
unsigned int mmu_get_dfsr(void);

/* Gibt den Wert des Fault Register aus */
unsigned int mmu_get_fault_address(void);

/* Gibt Eine Beschreibung des letzen verursachten
 * Data Aborts zurück
 */
char * mmu_get_dfsr_str(void);

void copy_userdata_template(int index);

void mmu_init();
void debug_L1_Table();


/*
 * TLB related Assembly Funktions
 */
extern unsigned int read_SCTLR(void);
extern void write_SCTLR(unsigned int x);

extern unsigned int read_TTBR0(void);
extern void write_TTBR0(unsigned int x);

extern unsigned int read_TTBCR(void);
extern void write_TTBCR(unsigned int x);

extern unsigned int read_DACR(void);
extern void write_DACR(unsigned int x);


void map_userdata_to(int new);
unsigned int return_heap_address();

#endif
