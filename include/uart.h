#ifndef UART_H
#define UART_H
#define UART_BASE (0x7E201000 - 0x3F000000)

/* flag register bits */
#define RTXDIS	(1 << 13)
#define TERI	(1 << 12)
#define DDCD	(1 << 11)
#define DDSR	(1 << 10)
#define DCTS	(1 << 9)
#define RI	     (1 << 8)
#define TXFE	(1 << 7)
#define RXFF	(1 << 6)
#define TXFF	(1 << 5)
#define RXFE	(1 << 4)
#define BUSY	(1 << 3)
#define DCD	(1 << 2)
#define DSR	(1 << 1)
#define CTS	(1 << 0)


/* transmit/receive line register bits */
#define SPS		(1 << 7)
#define WLEN_8	(3 << 5)
#define WLEN_7	(2 << 5)
#define WLEN_6	(1 << 5)
#define WLEN_5	(0 << 5)
#define FEN		(1 << 4)
#define STP2		(1 << 3)
#define EPS		(1 << 2)
#define PEN		(1 << 1)
#define BRK		(1 << 0)

/* control register bits */
#define CTSEN		(1 << 15)
#define RTSEN		(1 << 14)
#define OUT2		(1 << 13)
#define OUT1		(1 << 12)
#define RTS		(1 << 11)

#define DTR		(1 << 10)
#define RXE		(1 << 9)
#define TXE		(1 << 8)
#define LPE		(1 << 7)
#define OVSFACT		(1 << 3)
#define UARTEN		(1 << 0)

#define RTIM		(1 << 6)
#define RXIM		(1 << 4)


struct uart {
    unsigned int DR;
    unsigned int RSRECR;
    unsigned int unused[4];
    unsigned int FR;
    unsigned int unused2[2];
    unsigned int IBRD;
    unsigned int FBRD;
    unsigned int LCRH;
    unsigned int CR;
    unsigned int IFLS;
    unsigned int IMSC;
    unsigned int RIS;
    unsigned int MIS;
    unsigned int ICR;
    unsigned int DMACR;
    unsigned int unused4[9];
    unsigned int ITCR;
    unsigned int ITIP;
    unsigned int ITOP;
    unsigned int TDR;
    
};

static volatile struct uart * const _uart = (struct uart *)UART_BASE;


void sendChar(char c);
char recvChar(void);
#endif
