#include <uart.h>
#include <stdarg.h>

void decToHexStr(int n){
    char res[50];
    int i = 0;
    
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
    while(i >= 0){
        sendChar(res[i--]);
    }
}

void intToStr(char n){
    if(n >= 48 && n <= 57){
        sendChar(n);
    }else{
        char res[20];
        int i=0;
        while(n>0){
            res[i] = n%10+'0';
            n/=10; 
            i++;
        }
        i--;
        while(i >= 0){
            sendChar(res[i--]);
        }
    }
}


int kprintf(char * Str, ...){
    sendChar('\n');
    int i=0, j=0;
    va_list v1;
    va_start(v1,str);
    // char ch = (char)va_arg(v1,int);
    char buff[100]={0},tmp[20];
    while(str && str[i]){
        if(str[i] == '%'){
            i++;
            switch(str)
            {
                case 'c':
                    sendChar(str[i]);
                    i++;
                    break;
                case 's':
                    buff[j] = (unsigned char) var_arg(v1,int);
                    // TODO : implement sprintf or itoa
                    sprintf(va_arg(v1,int), tmp, 16);
                    // TODO : implement strcpy
                    strcpy(&buff[j], tmp);
                    // TODO : implement strlen
                    j+= strlen(tmp);
                    while (buff[0] != 0){
                        sendChar(buff[0]);
                        buff++;
                    }
                    break;        
                case 'x':
                    sendChar(ch);
                    char * str = " is in hexadecimal: 0x";
                    while (str[0] != 0){
                        sendChar(str[0]);
                        str++;
                    }
                    decToHexStr(ch);
                    break; 
                case 'i':
                    sendChar(ch);
                    str = " is as integer: ";
                    while (str[0] != 0){
                        sendChar(str[0]);
                        str++;
                    }
                    intToStr(ch);
                    break;
                case 'u':
                    sendChar(ch);
                    str = " is as unsigned integer: ";
                    while (str[0] != 0){
                        sendChar(str[0]);
                        str++;
                    }
                    unsigned int u_ch = ch;
                    intToStr(u_ch);
                    break;
                case 'p':
                    sendChar(ch);
                    str = " is at address : 0x";
                    while (str[0] != 0){
                        sendChar(str[0]);
                        str++;
                    }
                    decToHexStr(ch);
                    break;
                case '%':
                    sendChar('%');
                    break;
                default:
                    str = "krpintf error : wrong option !! please specify one of the following character: c,s,x,i,u,p,%\n";
                    while (str[0] != 0){
                        sendChar(str[0]);
                        str++;
                        return -1;
                    }
            }
            return 0;
        }
        else{
            sendChar(str[i]);
            i++;
        }
    }
    
}
