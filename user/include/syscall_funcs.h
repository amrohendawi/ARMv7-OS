#ifndef     _SYSCALL_FUNCS_H_
#define     _SYSCALL_FUNCS_H_

extern void unknown();
extern void exit();
extern void sleep(int time);
extern char read();
extern void write(char c);
extern void create(void (* func) (void *), const void *arg, unsigned int arg_size);


#endif
