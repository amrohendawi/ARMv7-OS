#include <kprint.h>
#include <scheduler.h>

#define BASE_ADDRESS_SECTION 0xFFF00000

#define AP_BITS                    0b1000110000000000
#define AP_ACTIVATE_FULL_ACCESS    0b0000110000000000
#define AP_ACTIVATE_SYS_ACCESS     0b0000010000000000
#define AP_ACTIVATE_SYS_READ_ONLY  0b1000010000000000
#define AP_ACTIVATE_BOTH_READ_ONLY 0b1000110000000000
#define AP_2                1 << 15
#define AP_1_0              0x11 << 10
#define AP_NO_ACCESS        0b000
#define AP_SYS_ACCESS       0b001
#define AP_SYS_READ_ONLY    0b101
#define AP_BOTH_READ_ONLY   0b111
#define AP_READ_ONLY        0b010
#define AP_FULL_ACCESS      0b011

#define XN_BIT      0b10000
#define PXN_BIT     1
#define PHYSICAL_ADDRESS_BITS 0xFFF00000
#define L1_TABLE_SIZE   4096

#define DACR_CLIENT 0b01

#define TTBCR_EAE_BIT   (1<<31)
#define TTBCR_N_BITS    (0b111)
#define SCTLR_ENABLE_MMU 0x1
#define SCTLR_CACHE_AND_ALIG_CHECK_DISABLE 0x3006

#define MB              10000
#define MAX_PROCESSES   8

#define USERDATA_TEMPLATE 4


#define KERNEL_INIT     1
#define KERNEL_TEXT     2
#define KERNEL_RODATA   3

#define USER_TEXT       4
#define USER_RODATA     5
#define USER_DATA       6
#define USER_HEAP       7


#define UART_TIMER      0x3F0
#define UART_LED        0x3F2
#define UART_PERI       0x400

#define L1_TABLE_Entry  2

// heap definitions
#define HEAP_BLOCKS_BASE     0x2400000

static unsigned int L1_TABLE[L1_TABLE_SIZE] __attribute__((aligned(4*L1_TABLE_SIZE)));


/*
 * TLB related Assembly Funktions
 */
extern unsigned int read_SCTLR(void);
extern void write_SCTLR(unsigned int x);

extern unsigned int read_TTBR0(void);
extern void write_TTBR0(unsigned int * x);

extern unsigned int read_TTBCR(void);
extern void write_TTBCR(unsigned int x);

extern unsigned int read_DACR(void);
extern void write_DACR(unsigned int x);

unsigned int template = 0;

void map_userdata_to(int new){
    asm volatile ("mcr p15, 0, r0, c8, c7, 0");
    L1_TABLE[USER_DATA] = L1_TABLE[new];         // USERDATA mapping
    L1_TABLE[USER_HEAP] = L1_TABLE[new+16];      // USERHEAP mapping 
}

unsigned int return_heap_address(){
    return L1_TABLE[USER_HEAP];
}


void kmemcpy(char *dest, char *src, int n) 
{ 
   for (int i=0; i<n; i++) 
       dest[i] = src[i]; 
}


/*
 * copies userdata to a specific address given as int
 */
void copy_userdata_template(int new_address){
    kmemcpy((char *) (L1_TABLE[new_address] & PHYSICAL_ADDRESS_BITS), (char *) (template & PHYSICAL_ADDRESS_BITS), MB);
}

/*
 * translates AP bits (15,11,10) to memory access case string
 */
char * translate_AP(int id){
    int AP = (L1_TABLE[id]>>15 & 1)<<2 | (L1_TABLE[id]>>10 & 3);           // aligns bit 15 and bits 11 and 10 beside each other
    switch(AP){
        case AP_NO_ACCESS:
            return "AP_NO_ACCESS";
            break;
        case AP_SYS_ACCESS:
            return "AP_SYS_ACCESS";
            break;
        case AP_SYS_READ_ONLY:
            return "AP_SYS_READ_ONLY";
            break;
        case AP_BOTH_READ_ONLY:
            return "AP_BOTH_READ_ONLY";
            break;
        case AP_READ_ONLY:
            return "AP_READ_ONLY";
            break;
        case AP_FULL_ACCESS:
            return "AP_FULL_ACCESS";
            break;
        default:
            return "UNKNOWN";
    }
}


void init_process_sections(void){
    // process data sectors accessible by both user and kernel
    for(int i=8; i<8 + MAX_PROCESSES; i++){
        L1_TABLE[i] |= AP_ACTIVATE_FULL_ACCESS;         
    }
    // process stack sectors accessible by both user and kernel
    for(int i=16; i<16 + MAX_THREADS; i++){             // 16 -> 47
        L1_TABLE[i] |= AP_ACTIVATE_FULL_ACCESS; 
    }
}

// allocate 8 MB for heap blocks 
void init_heap_sections(void){
    for(int i=16 + MAX_THREADS; i<24 + MAX_THREADS; i++){       // 48 -> 55
        L1_TABLE[i] |= AP_ACTIVATE_FULL_ACCESS;
    }
}

void L1_TABLE_init(void){
    // set all memory sectors to NO_ACCESS
    for(int i=0; i<L1_TABLE_SIZE; i++){
        L1_TABLE[i] = ((i<<20) & BASE_ADDRESS_SECTION) | L1_TABLE_Entry;
    }
//     set kernel sectors to only SYS_ACCESS
    L1_TABLE[0]           |= AP_ACTIVATE_FULL_ACCESS;                        // full access on first MB
    L1_TABLE[KERNEL_INIT] |= AP_ACTIVATE_SYS_ACCESS;                        // only kernel can access
    L1_TABLE[KERNEL_TEXT] |= AP_ACTIVATE_SYS_ACCESS;                        // only kernel can access
    L1_TABLE[KERNEL_RODATA] |= AP_ACTIVATE_SYS_ACCESS;                  // rodata only accessible by kernel
// 
//     map peripherals' virtual address to the exact physical address
    L1_TABLE[UART_TIMER] = 0x3F000000 | AP_ACTIVATE_FULL_ACCESS | L1_TABLE_Entry;
    L1_TABLE[UART_LED]   = 0x3F200000 | AP_ACTIVATE_FULL_ACCESS | L1_TABLE_Entry;
    L1_TABLE[UART_PERI]  = 0x40000000 | AP_ACTIVATE_FULL_ACCESS | L1_TABLE_Entry;
    
//     user sectors accessible by both user and kernel
    L1_TABLE[USER_TEXT]   |= AP_ACTIVATE_FULL_ACCESS;
    L1_TABLE[USER_RODATA] |= AP_ACTIVATE_FULL_ACCESS;
    L1_TABLE[USER_DATA]   |= AP_ACTIVATE_BOTH_READ_ONLY;       // userdata only readable
    L1_TABLE[USER_HEAP]   |= AP_ACTIVATE_FULL_ACCESS;       // userdata only readable
    template = L1_TABLE[USER_DATA];
//     

    for(int i=128; i<4096; i++){
        L1_TABLE[i] |= AP_ACTIVATE_FULL_ACCESS;
    }
    
    init_process_sections();
    init_heap_sections();
}

/*
 *  reads current SCTLR and sets CACHE and Alignment-check bits to 0. it also enables the MMU and writes it back
 */
void set_SCTLR(){
    unsigned int current_SCTLR = read_SCTLR();
    current_SCTLR &= ~(1<<2);
    current_SCTLR &= ~(1<<12);
    current_SCTLR |= 3;
    write_SCTLR(current_SCTLR);    
}

/*
 * prints all L1_TABLE entries with the physical address mapped to as well as access rights
 */
void debug_L1_Table(){
    for(int i=0; i<140; i++){
        kprintf("\033[1;36m Eintrag %i:\033[0m %x\t\033[1;35m AP[2:0]:\033[0m %s \n",i, (L1_TABLE[i] & PHYSICAL_ADDRESS_BITS),translate_AP(i));
    }
}

/*
 * this function initializes MMU and L1_TABLE and does all the necessary configurations for it
 */
void mmu_init(){
    kprintf(".\t.\tinitialize MMU\t.\t.\n");
    L1_TABLE_init();
    write_TTBR0(L1_TABLE);
    write_DACR(1);
    write_TTBCR(0);
    set_SCTLR();
//     debug_L1_Table();                            // activate debug_L1_Table to see how all entries will be initialized
}
