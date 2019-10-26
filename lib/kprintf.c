#include <uart.h>
#include <stdarg.h>
#define BUFF_SIZE (50)
#define NULL ((void *)-1)


// initializes a certain buffer with zeros
void kmemset(char* buff, int n){
    for(int i=0;i<n;i++){
        buff[i] = 0;
    }
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
void decToHexStr(int n, char *int_str, int pointer){
    char res[BUFF_SIZE];
    for(int i=0;i<BUFF_SIZE;i++){
        res[i]=0;
    }
    int i=0;
    
    while(n!=0){
        int temp = n%16;
        if(temp < 10) {
            res[i++] = temp + 48;
        }
        else{
            res[i++] = temp + 55;
        }
        n /= 16;
    }
    i--;
    kmemset(int_str,BUFF_SIZE);
    int j=0;
    if(pointer){
        j=2;
        int_str[0] = '0';
        int_str[1] = 'x';
    }
    while(i>=0){
        int_str[j] = res[i];
        j++;i--;
    }
}

// converts int to a string and packs it in a buffer
// for unsigned numbers an extra conversion is made
void intToStr(int n, char *int_str, int unsig){
    long int n_l = n;
    char res[BUFF_SIZE];
    for(int i=0;i<BUFF_SIZE;i++){
        res[i]=0;
    }
    int i=0;
    int j=0;
    kmemset(int_str,BUFF_SIZE);
    if(unsig){
        unsigned int n_unsigned = n;
        n_l = n_unsigned;
    }
    if(n_l<0 && !unsig){
        n_l *= (-1);
        int_str[j++] = '-';
    }
    if(n_l >= 48 && n_l <= 57){
        res[i++]=n_l;
    }else{
        while(n_l>0){
            res[i++] = n_l%10+'0';
            n_l/=10; 
        }
    }
    i--;
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
	int i = 0, j=0;
    char buff[100], tmp[BUFF_SIZE];
    for(int i=0;i<BUFF_SIZE;i++){
        tmp[i]=0;
    }
    for(int i=0;i<100;i++){
        buff[i]=0;
    }
    va_start( vl, str ); 
    while (str && str[i])
    {
        if(str[i] == '%')
        {
            i++;
            switch (str[i]) 
            {
                case 'c': 
                {
                    buff[j] = (char)va_arg( vl, int);
                    j++;
                    break;
                }
                case 's': 
                {
                    strcpy(tmp, va_arg( vl, void *));
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                break;
                }
                case 'x': 
                {
                    decToHexStr(va_arg(vl,int),tmp,0);
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                break;
                }
                case 'i': 
                {
                    intToStr(va_arg(vl,int),tmp,0);
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                break;
                }
                case 'u':
                    intToStr(va_arg(vl,unsigned int),tmp,1);
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                    break;
                case 'p':
                    decToHexStr(va_arg(vl,int),tmp,1);
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                    break;
                case '%':
                    buff[j++] = '%';
                    break;
                default:
                    // str = "krpintf error : wrong option !! please specify one of the following character: c,s,x,i,u,p,%\n";
                    // strcpy(&buff[j],str);
                    return -1;
            }
        } 
        else 
        {
            buff[j] =str[i];
            j++;
        }
        i++;
    }
    fwrite(buff, j);
    va_end(vl);
    return j;
 }
 
