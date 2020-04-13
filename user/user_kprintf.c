#include <stdarg.h>
#include <syscall.h>
#define BUFF_SIZE (512)
#define NULL ((void *)-1)

char buff[BUFF_SIZE], tmp[BUFF_SIZE];
int i,j,offset=0,zeros=0;

    
// initializes a certain buffer with zeros
void usr_memset(char* buff, int n){
    for(int i=0;i<n;i++)
        buff[i] = 0;
}

// returns the length of a specific string
int usr_strlen(const char *str)
{
    const char *s;
    for (s = str; *s; ++s);
    return (s - str);
}



void usr_memcpy(void *dest, void *src, int n) 
{ 
   char *csrc = (char *)src; 
   char *cdest = (char *)dest; 
  
   for (int i=0; i<n; i++) 
       cdest[i] = csrc[i]; 
} 


char* usr_strcpy(char* dest, const char* src)
{
	// returns NULL if no memory is allocated for dest
	if (dest == NULL)
		return NULL;
	// pointer of the beginning of string
	char *p = dest;
	// keep copying chars until the end of string (null)
	while (*src != '\0')
	{
		*dest = *src;
		dest++;
		src++;
	}

	// finish the new string with a terminating null
	*dest = '\0';

	return p;
}

// converts a decimal number to hexadecimal and packs it in a buffer as a string
void usr_decToHexStr(unsigned int n, int pointer){
    char res[BUFF_SIZE];
    usr_memset(res,BUFF_SIZE);
    
    char hex[16] = "0123456789abcdef";
    int i=0;
    
    do{
        res[i++] = hex[n%16];
        n /= 16;
    }while(n>0);
    i--;
    
    if(pointer && zeros){
        j=2;
        syscall_putc('0');
        syscall_putc('x');
    }
    
    if(pointer) offset -= 2;
//     while(offset - usr_strlen(res) > 0){
//         if(zeros)
//             syscall_putc('0');
//         else
//             syscall_putc(' ');
//         offset--;
//     }
    if(!zeros && pointer){
        syscall_putc('0');
        syscall_putc('x');
    }
    while(i>=0){
        syscall_putc(res[i]);
        i--;
    }
    offset = 0;
}

// converts int to a string and packs it in a buffer
void usr_intToStr(int n){
    char res[BUFF_SIZE];

    int i=0;
    usr_memset(res,BUFF_SIZE);
    char dec[10] = "0123456789";
    
    if(n<0){
        n *= (-1);
        syscall_putc('-');
    }

    do{
        res[i] = dec[n%10];
        i++;
        n/=10;
    }while(n>0);
    i--;
/*    while(offset - usr_strlen(res) > 0){
        if(zeros)
            syscall_putc('0');
        else
            syscall_putc(' ');
        offset--;
    }   */ 
    while(i>=0){
        syscall_putc(res[i]);
        i--;
    }
}
// converts int to a string and packs it in a buffer
void usr_unusr_intToStr(unsigned int n){
    char res[BUFF_SIZE];
    usr_memset(res,BUFF_SIZE);
//     usr_memset(int_str,BUFF_SIZE);

    int i=0;


    do{
        res[i++] = n%10+'0';
        n/=10; 
    }while(n>0);
    i--;
//     while(offset - usr_strlen(res) > 0){
//         if(zeros)
//             syscall_putc('0');
//         else
//             syscall_putc(' ');
//         offset--;
//     }
    while(i>=0){
        syscall_putc(res[i]);
        i--;
    }
}

// sends chars in a buffer as a stream of bytes to the receiver
// void usr_fwrite(char * buff, int len){
//     for(int i=0;i<len;i++){
//         syscall_putc(buff[i]);
//     }
// }

// a primitive implementation of printf
void usr_kprintf (char * str, ...)
{
	va_list vl;
    usr_memset(tmp,BUFF_SIZE);
    i=0;j=0;
    
    va_start( vl, str); 
    while (str && str[i])
    {
        if(str[i] == '%')
        {
            i++;
            switches:
            switch (str[i]) 
            {
                case 'c': 
                    syscall_putc(va_arg( vl, int));
                    break;
                
//                 case 's': 
//                     usr_strcpy(tmp, va_arg( vl, void *));
//                     while(offset-usr_strlen(va_arg( vl, void *)) > 0){
//                        syscall_putc(' ');
//                         offset--;
//                     }
//                     usr_strcpy(&buff[j], tmp);
//                     while(tmp[t] != '\0')
//                         syscall_putc(temp[t++]);
//                     char_pointer = va_arg( vl, char *);
//                     while(*char_pointer != 0){
//                         syscall_putc(*char_pointer);
//                         char_pointer++;
//                     }
// 
//                     offset = 0;zeros=0;
//                 break;
//                 
                case 'x':
                    usr_decToHexStr(va_arg(vl,unsigned int),0);
//                     usr_strcpy(&buff[j], tmp);
//                     j += usr_strlen(tmp);
                    offset = 0;zeros=0;
                    break;
//                 
                case 'i':
                    usr_intToStr(va_arg(vl,int));
//                     usr_strcpy(&buff[j], tmp);
//                     j += usr_strlen(tmp);
                    offset = 0;zeros=0;
                    break;
//                 
                case 'u':
                    usr_unusr_intToStr(va_arg(vl,unsigned int));
//                     usr_strcpy(&buff[j], tmp);
//                     j += usr_strlen(tmp);
                    
                    offset = 0;zeros=0;
                    break;               
                    
                case 'p':
                    usr_decToHexStr(va_arg(vl,int),1);
//                     usr_strcpy(&buff[j], tmp);
//                     j += usr_strlen(tmp);
                    offset = 0;zeros=0;
                    break;
                    
                case '%':
                    syscall_putc('%');
                    break;
                    
                default:
                    if(str[i] >= '0' && str[i] <= '9'){
                        if(str[i] == '0') zeros=1;
                        while(str[i] >=48 && str[i] <= 57){
                            offset *= 10;
                            offset += str[i] - 48;
                            i++;
                        }
                        goto switches;
                    }else{
                        syscall_putc('%');
                        syscall_putc(str[i]);
                    }
                break;
            }
        } 
        else
            syscall_putc(str[i]);
        i++;
    }
    va_end(vl);
 }
 
 
 void print_line(char * str){
     while(*str != 0){
         syscall_putc(*str);
         str++;
     }
 }
 
