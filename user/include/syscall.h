#ifndef _SYSCALL_H_
#define _SYSCALL_H_

/* Verfügbare Syscalls */

__attribute__((noreturn))
void syscall_exit(void);

/* gibt 0 zurück be Erfolg */
int syscall_exec(void (*func)(void *), void * args, unsigned int arg_size, unsigned int flags);

void syscall_putc(char);

char syscall_getc(void);

void syscall_sleep(unsigned int count);

#endif
