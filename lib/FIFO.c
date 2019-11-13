#define MAX_SIZE    128
#define NULL ((void *)-1)
#include <kprintf.h>
#include <routine.h>
#include <uart.h>

char buf[MAX_SIZE];
int len = 0;

int getLength(){
    return len;
}
char enqueue(char input){
    if(len < MAX_SIZE){
        buf[len++] = input;
//         kprintf("enqueue %c\n",input);
        return buf[len-1];
    }else{
        kprintf("Buffer voll !! kann keine weiteren Zeichen speichern\n");
        return '\0';
    }
}


char dequeue(){
    if(len == 0)
        return '\0';
    char output = buf[0];
    len--;
    for(int i=0;i<len;i++){
        buf[i] = buf[i+1];
    }
    buf[len] = '\0';
    
    return output;
}

void read_and_write(){
    enqueue(recvChar());
    while(getLength() > 0){
        call_routine(dequeue());
    }
}
