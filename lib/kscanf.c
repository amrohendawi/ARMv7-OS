#include <uart.h>
#include <stdarg.h>
#include <kprintf.h>
#define NULL ((void *)-1)

int fread(char *c, char recv){
    *c = recv;
    return *c;
}


int kscanf (char * str, ...)
{
    va_list vl;
    int i = 0, j=0, counter = 0;
    char buff[100],c;
    kmemset(buff,100);
    
//     char *out_loc;
    while(c != '\n')
    {
        if (fread(&c,recvChar())) 
        {
 	       buff[i] = c;
           sendChar(c);
 	       i++;
 	    }
 	}

 	va_start( vl, str );
 	i = 0;
 	while (str && str[i])
 	{
 	    if (str[i] == '%') 
 	    {
 	       i++;
 	       switch (str[i]) 
 	       {
 	           case 'c': 
	 	           *(char *)va_arg( vl, char* ) = buff[j];
	 	           j++;
	 	           counter ++;
	 	           break;

//  	           case 's':
//                     kmemset(tmp,100);
//                     y=0;
//                    while(buff[j] != ' ' || buff[j] != '\n'){
//                    tmp[y++] = buff[j];
//                     j++;
//                     counter ++;
//                    }
//                    va_arg( vl, char* ) = tmp;
// 	 	           break;

//  	            case 'x': 
// 	 	           *(int *)va_arg( vl, int* ) =strtol(&buff[j], &out_loc, 16);
// 	 	           j+=out_loc -&buff[j];
// 	 	           counter++;
// 	 	           break;

//  	           case 'i': 
// 	 	           *(int *)va_arg( vl, int* ) = strtol(&buff[j], &out_loc, 10);
// 	 	           j+=out_loc - &buff[j];
// 	 	           counter++;
// 	 	           break;

//  	           case 'p': 
// 	 	           *(int *)va_arg( vl, int* ) =strtol(&buff[j], &out_loc, 10);
// 	 	           j+=out_loc -&buff[j];
// 	 	           counter++;
// 	 	           break;

 	           case '%': 
	 	           *(char *)va_arg( vl, char* ) = '%';
	 	           j++;
	 	           counter ++;
	 	           break;
 	        }
 	    } 
 	    else 
 	    {
 	        buff[j] =str[i];
            j++;
        }
        i++;
    }
    va_end(vl);
    return counter;
}
