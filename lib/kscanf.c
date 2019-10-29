#include <stdio.h>
#include <stdlib.h>
#include<stdarg.h>

int scan (char * str, ...)
{
    va_list vl;
    int i = 0, j=0, counter = 0;
    char buff[100] = {0}, tmp[20], c;
    char *out_loc;
    while(c != '\n')
    {
        if (fread(&c, 1, 1, stdin)) 
        {
 	       buff[i] = c;
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

 	           case 's': 
	 	           *(char *)va_arg( vl, char* ) = buff[j];
	 	           j++;
	 	           counter ++;
	 	           break;

 	            case 'x': 
	 	           *(int *)va_arg( vl, int* ) =strtol(&buff[j], &out_loc, 16);
	 	           j+=out_loc -&buff[j];
	 	           counter++;
	 	           break;

 	           case 'i': 
	 	           *(int *)va_arg( vl, int* ) =strtol(&buff[j], &out_loc, 10);
	 	           j+=out_loc -&buff[j];
	 	           counter++;
	 	           break;

 	           case 'p': 
	 	           *(int *)va_arg( vl, int* ) =strtol(&buff[j], &out_loc, 10);
	 	           j+=out_loc -&buff[j];
	 	           counter++;
	 	           break;

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
    printf("j is %d and counter %d\n\n", j,counter);
    return counter;
}
int main(int argc, char *argv[])
{
	char c,d;
	int i;
	int h;
	int counter = 0;
    printf("enter char integer hexa %\n");
	counter = scan("%c %i %x %%", &c, &i, &h, &d);
	printf("C = %c, I = %d, H = %d, counter %d %% returns %c\n", c, i, h, counter,d);
	return 0;
}
