# raspberryPi Operating system

This is a fully functional operating system built on RaspberryPi Bootloader. We used RaspberryPi version 2B for the sake of working with ARMv7 instruction set.
The following parts were implemented from scratch:
1- Drivers (UART, LED, Timer)
2- Library (kprintf, kscanf, some string related functions such as strcpy etc.)
3- Memory (MMU management)
4- Exceptions (exception handlers, trampoline, routine for testing exceptions)
5- Multithreading (RR-scheduler and threads, context switching mechanism etc.)
6- Processes (memory segmentation, 8 processes and 8 process stacks, routine for testing processes)
7- User interface (seperation mechanism between kernel and system, syscall interface for inter-process-communication)
8- Heap (dynamic memory allocation using malloc and free, routine for testing heap robustness)
