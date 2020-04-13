.global read_SCTLR
.global write_SCTLR

read_SCTLR:
    MRC p15, 0, r0, c1, c0, 0
    mov pc,lr

write_SCTLR:
    MCR p15, 0, r0, c1, c0, 0
    mov pc,lr

    

.global read_TTBR0
.global write_TTBR0

/* read TTBRO and return it
*/
read_TTBR0:
    MRC p15, 0, r0, c2, c0, 0
    mov pc,lr

/* write given unsigned int from r0 in TTBRO
*/
write_TTBR0:
    MCR p15, 0, r0, c2, c0, 0
    mov pc,lr

.global read_TTBCR
.global write_TTBCR

/* read TTBCR and return it
*/
read_TTBCR:
    MRC p15, 0, r0, c2, c0, 2
    mov pc,lr
    
/* write given unsigned int from r0 in TTBCR
*/
write_TTBCR:
    MCR p15, 0, r0, c2, c0, 2
    mov pc,lr
    
    
.global read_DACR
.global write_DACR

/* read DACR and return it
*/
read_DACR:
    MRC p15, 0, r0, c3, c0, 0
    mov pc,lr

/* write given unsigned int from r0 in DACR
*/
write_DACR:
    MCR p15, 0, r0, c3, c0, 0
    mov pc,lr
