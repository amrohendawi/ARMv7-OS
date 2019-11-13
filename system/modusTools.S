.global cause_data_abort
.global get_lr_usr
.global get_lr_svc
.global get_lr_abt
.global get_lr_fiq
.global get_lr_irq
.global get_lr_und
.global get_sp_usr
.global get_sp_svc
.global get_sp_abt
.global get_sp_fiq
.global get_sp_irq
.global get_sp_und
.global get_spsr_svc
.global get_spsr_abt
.global get_spsr_fiq
.global get_spsr_irq
.global get_spsr_und


cause_data_abort:
    mrc p15,0,r1,c1,c0,0
    orr r1, #2
    mcr p15,0,r1,c1,c0,0
    mov r1,#0x1
    ldr r1,[r1]
    mov pc,lr

    
get_lr_usr:
    mrs r0, lr_usr
    mov pc,lr
    
get_lr_svc:
    mrs r0, lr_svc
    mov pc,lr
    
get_lr_abt:
    mrs r0, lr_abt
    mov pc,lr
    
get_lr_fiq:
    mrs r0, lr_fiq
    mov pc,lr
    
get_lr_irq:
    mrs r0, lr_irq
    mov pc,lr
    
get_lr_und:
    mrs r0, lr_und
    mov pc,lr
   
   
   
get_sp_usr:
    mrs r0, sp_usr
    mov pc,lr
    
get_sp_svc:
    mrs r0, sp_svc
    mov pc,lr
    
get_sp_abt:
    mrs r0, sp_abt
    mov pc,lr
    
get_sp_fiq:
    mrs r0, sp_fiq
    mov pc,lr
    
get_sp_irq:
    mrs r0, sp_irq
    mov pc,lr
    
get_sp_und:
    mrs r0, sp_und
    mov pc,lr
    
    
get_spsr_svc:
    mrs r0, spsr_svc
    mov pc,lr
    
get_spsr_abt:
    mrs r0, spsr_abt
    mov pc,lr
    
get_spsr_fiq:
    mrs r0, spsr_fiq
    mov pc,lr
    
get_spsr_irq:
    mrs r0, spsr_irq
    mov pc,lr
    
get_spsr_und:
    mrs r0, spsr_und
    mov pc,lr
    
