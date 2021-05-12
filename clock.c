/*****************************************************
Project : clock
Version : 1
Date    : 22.07.2019

Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 4,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <alcd.h>

const unsigned char time_backlight=10;


typedef unsigned char byte;

register unsigned char hour=0 ,min=0, sec=0, ukd=0, hour1=0, min1=0, 
ukd1=0, charge=0, menu=0,timelight;

register bit clockon=0,on=0,light=1,menustart=0,show=1;

flash unsigned char chis[10]={48,49,50,51,52,53,54,55,56,57};

flash unsigned char *dday[7]={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"};

flash byte char0[8] = {
	0b01110,
	0b10001,
	0b10001,
	0b10001,
	0b10001,
	0b11111,
	0b11111,
	0b11111
};  
//заряд мало

flash byte char1[8] = {
	0b01110,
	0b10001,
	0b10001,
	0b11111,
	0b11111,
	0b11111,
	0b11111,
	0b11111
};   
//заряд средне

flash byte char2[8] = {
	0b01110,
	0b11111,
	0b11111,
	0b11111,
	0b11111,
	0b11111,
	0b11111,
	0b11111
};    
//заряд много


void define_char(byte flash *pc,byte char_code)
{
  byte i,a;
  a=(char_code<<3)|0x40;
  for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}

unsigned char EncoderScan(unsigned char a)
{
    if (PINB.1==0)
    {
        while (PINB.1==0) {}
        while (PINB.2==0) {} 
        if ((PINB.2==1) && (PINB.1==1)) a++;
    }
    
     if (PINB.2==0)
    {
        while (PINB.2==0) {}
        while (PINB.1==0) {}
        if ((PINB.2==1) && (PINB.1==1)) a--;
    }
    return a; 
}
//обработка энкодера
            
void write(void)
{
   lcd_clear();
   lcd_gotoxy(4,0);
   lcd_putchar(chis[hour/10]);
   lcd_gotoxy(5,0);
   lcd_putchar(chis[hour%10]);
   lcd_gotoxy(6,0);
   lcd_puts(":");
   lcd_gotoxy(7,0);
   lcd_putchar(chis[min/10]);
   lcd_gotoxy(8,0);
   lcd_putchar(chis[min%10]);
   lcd_gotoxy(9,0);
   lcd_puts(":");
   lcd_gotoxy(10,0);
   lcd_putchar(chis[sec/10]);
   lcd_gotoxy(11,0);
   lcd_putchar(chis[sec%10]);
   lcd_gotoxy(0,1);
   lcd_putsf(dday[ukd]);
   if (menustart) {
     lcd_gotoxy(15,0);
     lcd_putchar(chis[menu%10]); }
   lcd_gotoxy(15,1);
   lcd_putchar(charge);
   //wait();
}
// основной вывод на дисплей 

void write2(void)
{
   lcd_clear();
   lcd_gotoxy(6,0);
   lcd_putchar(chis[hour1/10]);
   lcd_gotoxy(7,0);
   lcd_putchar(chis[hour1%10]);
   lcd_gotoxy(8,0);
   lcd_puts(":");
   lcd_gotoxy(9,0);
   lcd_putchar(chis[min1/10]);
   lcd_gotoxy(10,0);
   lcd_putchar(chis[min1%10]);
   lcd_gotoxy(15,0);
   lcd_putchar(chis[menu%10]);
   lcd_gotoxy(0,1);
   lcd_putsf(dday[ukd1]);
   lcd_gotoxy(10,1);
   if (clockon) lcd_putsf("ON");
   else  lcd_putsf("OFF");
   lcd_gotoxy(15,1);
   lcd_putchar(charge);
}
// вывод в режиме настройки будильника
interrupt [2] void customization(void)
{
    if (light) 
    { light=0; timelight=sec+time_backlight; 
      if (timelight>=60) timelight-=60; 
      goto m1; }
    else 
    { 
      if (on) { clockon=0; goto m1; }
      #asm("cli")
      menu=0; menustart=1;
      MCUCR=0b00000000;
      GICR=0b00000000;
      write();
      while(menu!=9)
      {  
        while (PINB.1==PINB.2)
        {
          if (PIND.2==0)
           {
            while (PIND.2==0) {}
            menu++;
            if (menu==2) #asm("sei")
            if (menu==5) show=0; 
            if (menu<=4) write();
            else write2();
            if (menu>=9) goto m1;
           }
        } 
            switch (menu)
            {
              case 1:
               {
                 sec=EncoderScan(sec); 
                 if (sec>=60) sec=0; write();
                 break;
               }
              case 2:
               {  
                 min=EncoderScan(min); 
                 if (min>=60) min=0; write();
                 break;
               }
              case 3:
               {
                 hour=EncoderScan(hour); 
                 if (hour>=24) hour=0; write();
                 break;
               }
              case 4:      
               { 
                 ukd=EncoderScan(ukd);
                 if (ukd>=7) ukd=0; write();
                 break;
               }
              case 5:
               { 
                 min1=EncoderScan(min1); 
                 if (min1>=60) min1=0; write2();
                 break;
               }
              case 6:
               {
                 hour1=EncoderScan(hour1); 
                 if (hour1>=24) hour1=0; write2();
                 break;
               }
              case 7:
               { 
                 ukd1=EncoderScan(ukd1);
                 if (ukd1>=7) ukd1=0; write2();
                 break;
               }
              case 8:
               { 
                 clockon=EncoderScan(clockon);
                 write2();
                 break;
               }        
            }    
               
      }
      }
m1:    
    #asm("sei")
    MCUCR=0b00000010;
    GICR=0b01000000;
    menustart=0; show=1; 
}
// обработка настройки времени и будильника

interrupt [7] void time(void)
{
      sec++; 
      if(sec==60) {min++; sec=0;}
      if (min==60) {hour++; min=0;}
      if (hour==24) {ukd++; hour=0;}
      if (ukd==7) ukd=0;
      if (on) 
      {
        if (TCCR2==0b00000000) TCCR2=0b00011111;
        else TCCR2=0b00000000;
      }
      else TCCR2=0b00000000;
      if (show) write();   
}
// прерывание часов
void main(void)
{

PORTB=0b00000001;
DDRB=0b00001001;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x00;

//TCCR0=0b00000101;     //3906 Hz

TCCR1A=0b00000000;
TCCR1B=0b00001100;  //15625 Hz
TIMSK=0b00010000;
OCR1A=15623;

TCCR2=0b00000000;
OCR2=8;

MCUCR=0b00000010;      //power-save mod 1011
GICR=0b01000000;

ACSR=0x80;

ADCSRA=0b00000101;  // /32, режим однократных измерений
ADMUX=0b01100101; //ADC5, старшие биты в ADCH, опорное - AVCC, C на AREF и GND

lcd_init(16);
define_char(char0,0);
define_char(char1,1);
define_char(char2,2);
#asm ("sei")

while (1)
      {
        //write();      //PORTB.0 - подсветка
        if ((!light) && (sec!=timelight))  PORTB.0=0; 
        else { PORTB.0=1; light=1;} 
        if ((clockon==1) && (ukd1==ukd) && (hour1==hour) && (min1==min)) on=1;
        else on=0;
        if (sec%20==1) { ADCSRA.7=1; ADCSRA.6=1; }
        if (ADCSRA.4==1) 
         {
            if (ADCH<=183) { charge=0; on=1;} // U<3,49  (173)
            if ((ADCH>183) && (ADCH<210)) { charge=1; on=0; }  // 3,49<U<4,05
            if (ADCH>=210) {charge=2; on=0;}  // U>4,05         (200)
            ADCSRA.7=0;
         }  
      }
}