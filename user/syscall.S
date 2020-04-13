#define EXIT  0
#define EXEC  1
#define PUTC  2
#define GETC  3
#define SLEEP 4

.section .text
.global syscall_exit
syscall_exit:
	mov r7, #EXIT
	svc #0

.global syscall_exec
syscall_exec:
	push {r7,lr}
	mov r7, #EXEC
	svc #0
	pop {r7,lr}
	bx lr

.global syscall_putc
syscall_putc:
	push {r7,lr}
	mov r7, #PUTC
	svc #0
	pop {r7,lr}
	bx lr

.global syscall_getc
syscall_getc:
	push {r7,lr}
	mov r7, #GETC
	svc #0
	pop {r7,lr}
	bx lr

.global syscall_sleep
syscall_sleep:
	push {r7,lr}
	mov r7, #SLEEP
	svc #0
	pop {r7,lr}
	bx lr
