#include <uart.h>
#include <stdarg.h>
#define BUFF_SIZE (512)
#define NULL ((void *)-1)

char buff[BUFF_SIZE], tmp[BUFF_SIZE];
int i,j,offset=0;

    
// initializes a certain buffer with zeros
void kmemset(char* buff, int n){
    for(int i=0;i<n;i++)
        buff[i] = 0;
}

// returns the length of a specific string
int kstrlen(const char *str)
{
    const char *s;
    for (s = str; *s; ++s);
    return (s - str);
}

char* strcpy(char* dest, const char* src)
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
void decToHexStr(unsigned int n, char *int_str, int pointer){
    char res[BUFF_SIZE];
    kmemset(res,BUFF_SIZE);
    kmemset(int_str,BUFF_SIZE);
    int j=0;
    
    char hex[16] = "0123456789ABCDEF";
    int i=0;
    
    while(n>0){
        res[i++] = hex[n%16];
        n /= 16;
    }
    i--;
    
    if(pointer){
        j=2;
        int_str[0] = '0';
        int_str[1] = 'x';
    }
    
    while(offset - kstrlen(res) > 0){
        int_str[j] = '0';
        j++;offset--;
    }
    while(i>=0){
        int_str[j] = res[i];
        j++;i--;
    }
    offset = 0;
}

// converts int to a string and packs it in a buffer
void intToStr(int n, char *int_str){
    char res[BUFF_SIZE];

    int i=0;
    int j=0;
    kmemset(res,BUFF_SIZE);
    kmemset(int_str,BUFF_SIZE);
    char dec[10] = "0123456789";
    
    if(n<0){
        n *= (-1);
        int_str[j++] = '-';
    }

    while(n>0){
        res[i++] = dec[n%10];
        n/=10; 
    }
    i--;
    while(offset - kstrlen(res) > 0){
        int_str[j] = '0';
        j++;offset--;
    }    
    while(i>=0){
        int_str[j] = res[i];
        j++;i--;
    }
}

// converts int to a string and packs it in a buffer
void unintToStr(unsigned int n, char *int_str){
    char res[BUFF_SIZE];
    kmemset(res,BUFF_SIZE);
    kmemset(int_str,BUFF_SIZE);

    int i=0;
    int j=0;

    if(n >= 48 && n <= 57){
        res[i++]=n;
    }else{
        while(n>0){
            res[i++] = n%10+'0';
            n/=10; 
        }
    }
    i--;
    while(offset - kstrlen(res) > 0){
        int_str[j] = '0';
        j++;offset--;
    }    
    while(i>=0){
        int_str[j] = res[i];
        j++;i--;
    }
}

// sends chars in a buffer as a stream of bytes to the receiver
void fwrite(char * buff, int len){
    for(int i=0;i<len;i++){
        sendChar(buff[i]);
    }
}

// a primitive implementation of printf
int kprintf (char * str, ...)
{
	va_list vl;
    
    kmemset(tmp,BUFF_SIZE);
    i=0;j=0;
    
    va_start( vl, str ); 
    while (str && str[i])
    {
        if(str[i] == '%')
        {
            i++;
            switches:
            switch (str[i]) 
            {
                case 'c': 
                    buff[j++] = va_arg( vl, int);
                    break;
                
                case 's': 
                    strcpy(tmp, va_arg( vl, void *));
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                    while(offset-kstrlen(tmp) > 0){
                        buff[j] = ' ';
                        j++;offset--;
                    }
                    offset = 0;
                break;
                
                case 'x': 
                    decToHexStr(va_arg(vl,unsigned int),tmp,0);
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                    offset = 0;
                break;
                
                case 'i': 
                    intToStr(va_arg(vl,int),tmp);
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                    offset = 0;
                break;
                
                case 'u':
                    unintToStr(va_arg(vl,unsigned int),tmp);
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                    offset = 0;
                    break;                

                    
                case 'p':
                    decToHexStr(va_arg(vl,int),tmp,1);
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                    offset = 0;
                    break;
                    
                case '%':
                    buff[j++] = '%';
                    break;
                    
                default:
                    if(str[i] >= 48 && str[i] <= 57){
                        while(str[i] >=48 && str[i] <= 57){
                            offset *= 10;
                            offset += str[i] - 48;
                            i++;
                        }
                        goto switches;
                    }else{
                        buff[j++] = '%';
                        buff[j++] = str[i];
                    }
                break;
            }
        } 
        else 
            buff[j++] =str[i];
        i++;
    }
    fwrite(buff, j);
    va_end(vl);
    return j;
 }
 
