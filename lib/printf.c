#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
//#include <string.h>
#define BUFF_SIZE (50)
int kstrlen(const char *str)
{
    const char *s;
    int i=0;
    for (s = str; *s; ++s);
    return (s - str);
}

char* strcpy(char* destination, const char* source)
{
	// return if no memory is allocated to the destination
	if (destination == NULL)
		return NULL;

	// take a pointer pointing to the beginning of destination string
	char *ptr = destination;
	
	// copy the C-string pointed by source into the array
	// pointed by destination
	while (*source != '\0')
	{
		*destination = *source;
		destination++;
		source++;
	}

	// include the terminating null character
	*destination = '\0';

	// destination is returned by standard strcpy()
	return ptr;
}


void kmemset(char* buff, int n){
    for(int i=0;i<n;i++){
        buff[i] = 0;
    }

}
void decToHexStr(int n, char *int_str, int pointer){
    char res[BUFF_SIZE]={0};
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

void intToStr(int n, char *int_str){

    char res[BUFF_SIZE]={0};
    int i=0;
    int j=0;
    kmemset(int_str,BUFF_SIZE);
    if(n<0){
        n *= (-1);
        int_str[j++] = '-';
    }
    if(n >= 48 && n <= 57){
        res[i++]=n;
    }else{
        while(n>0){
            res[i++] = n%10+'0';
            n/=10; 
        }
    }
    i--;
    while(i>=0){
        int_str[j] = res[i];
        j++;i--;
    }
}

int print (char * str, ...)
{
	va_list vl;
	int i = 0, j=0;
    char buff[100]={0}, tmp[BUFF_SIZE]={0};
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
                    buff[j] = (char)va_arg( vl, int );
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
                    intToStr(va_arg(vl,int),tmp);
                    strcpy(&buff[j], tmp);
                    j += kstrlen(tmp);
                break;
                }
                case 'u':
                    intToStr(va_arg(vl,unsigned int),tmp);
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
    fwrite(buff, j, 1, stdout); 
    va_end(vl);
    return j;
 }

int main(){
    print("string: %s integer: %i hex: %x pointer %p %%\n", "and it is !!!",-15,3456789,3456789);
    return 0;
}