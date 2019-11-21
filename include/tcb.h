#ifndef TCB_H
#define TCB_H

static volatile struct uart * const _uart = (struct uart *)UART_BASE;
typedef void (*thread_function)(void);

thread _create(thread_function thread_func, const void *args, unsigned int args_size);


#endif
