#ifndef     _USER_THREAD_H_
#define     _USER_THREAD_H_

// void user_runner(char c);

// void user_write_thread(char c);
// void user_read_thread();
// void user_sleep_thread();

/*
 *  working functions so far
 */
void user_create(void (* func) (void *), const void *arg, unsigned int arg_size);
void user_write(char c);
char user_read();
void anwendung(char c);

#endif
