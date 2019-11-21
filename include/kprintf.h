#ifndef KPRINTF_H
#define KPRINTF_H

int kstrlen(const char *str);
char* strcpy(char* destination, const char* source);
void kmemset(char* buff, int n);
void decToHexStr(int n, char *int_str, int pointer);
void intToStr(int n, char *int_str, int unsig);
void countOffset(char *str, int i);
void kprintf(char * str, ...);

#endif
