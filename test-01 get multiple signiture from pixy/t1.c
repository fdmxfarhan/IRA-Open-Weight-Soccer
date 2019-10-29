/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 9/28/2019
Author  : 
Company : 
Comments: 


Chip type               : ATmega16A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16a.h>
#include <delay.h>
#include <math.h>
#include <twi.h>
// I2C Bus functions
#include <i2c.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

///////////////////////////////////////////////////////////////////vars
int speed = 255;
int i;
int cmp,c=0;
int x, y,width,height,checksum, signature;
char a;
int x_robot = 147, y_robot = 72, ball_angle, ball, ball_distance;
bool is_ball = false;


//////////////////////////////////////////////////////////////////////////////////PIXY-CMUCAM5
#define I2C_7BIT_DEVICE_ADDRESS 0x54
#define EEPROM_BUS_ADDRESS (I2C_7BIT_DEVICE_ADDRESS << 1)

unsigned int  address=0x54;
unsigned char read()
{
unsigned char data;
i2c_start();
i2c_write(EEPROM_BUS_ADDRESS | 0);
i2c_write(address >> 8);
i2c_write((unsigned char) address);
i2c_start();
i2c_write(EEPROM_BUS_ADDRESS | 1);
data=i2c_read(0);
i2c_stop();
return data;
}
//////////////////////////////////////////////////////////////////////////////////CMP-READ
#define EEPROM_BUS_ADDRES 0xc0
/* read/ a byte from the EEPROM */
unsigned char compass_read(unsigned char addres)
    {
    unsigned char data;
    i2c_start();
    i2c_write(EEPROM_BUS_ADDRES);
    i2c_write(addres);
    i2c_start();
    i2c_write(EEPROM_BUS_ADDRES | 1);
    data=i2c_read(0);
    i2c_stop();
    return data;
    }

void readcmp()
    {
    //if(PIND.6 == 1)  c = compass_read(1);
    cmp = compass_read(1) - c;

    if(cmp>128)       cmp=cmp-255;        
    else if(cmp<-128) cmp=cmp+255;
    
    if(cmp >= 0)
        {
        lcd_gotoxy(11,0);     
        lcd_putchar('+');
        lcd_putchar((cmp/100)%10+'0');          
        lcd_putchar((cmp/10)%10+'0');          
        lcd_putchar((cmp/1)%10+'0');            
        }
    else
        {          
        lcd_gotoxy(11,0);
        lcd_putchar('-');
        lcd_putchar((-cmp/100)%10+'0');
        lcd_putchar((-cmp/10)%10+'0');  
        lcd_putchar((-cmp/1)%10+'0');      
        }
       
    if(cmp<30 && cmp>-30) cmp *= 2;
    else  cmp *= 1;
    cmp *= -1;

    }


void motor(int L1, int L2, int R2,int R1 )
    {   
    L1 += cmp;
    L2 += cmp;
    R1 += cmp;
    R2 += cmp;
        
    
    if (L1>255)  L1=255;
    if (L1<-255) L1=-255;

    if (L2>255)  L2=255;
    if (L2<-255) L2=-255;

    if (R2>255)  R2=255;
    if (R2<-255) R2=-255;

    if (R1>255)  R1=255;
    if (R1<-255) R1=-255;

    ///////////////////L1
    if (L1>0)
        {      
        PORTD.3=0;
        OCR2=L1;
        } 
    else 
        {
        PORTD.3=1;
        OCR2=255+L1;
        }
    ///////////////////L2
    if (L2>0)
        {      
        PORTD.2=0;
        OCR1A=L2;
        } 
    else 
        {
        PORTD.2=1;
        OCR1A=255 + L2;
        }
    ///////////////////R2
    if (R2>0)
        {      
        PORTD.1=0;
        OCR1B=R2;
        } 
    else 
        {
        PORTD.1=1;
        OCR1B=255+R2;
        }
    ///////////////////R1
    if (R1>0)
        {      
        PORTD.0=0;
        OCR0=R1;
        } 
    else 
        {
        PORTD.0=1;
        OCR0=255+R1;
        }
    }

void move(int direction)
    {
    if(direction == 0)      motor(speed   , speed   , -speed  , -speed   );
    if(direction == 1)      motor(speed   , speed/2 , -speed  , -speed/2 );
    if(direction == 2)      motor(speed   , 0       , -speed  , 0        );
    if(direction == 3)      motor(speed   , -speed/2, -speed  , speed/2  );
    if(direction == 4)      motor(speed   , -speed  , -speed  , speed    );
    if(direction == 5)      motor(speed/2 , -speed  , -speed/2, speed    );
    if(direction == 6)      motor(0       , -speed  , 0       , speed    );
    if(direction == 7)      motor(-speed/2, -speed  , speed/2 , speed    );    

    if(direction == 8)      motor(-speed  , -speed  , speed   , speed    );

    if(direction == 9)      motor(-speed   , -speed/2, speed   , speed/2 );
    if(direction == 10)     motor(-speed   , 0       , speed   , 0       );
    if(direction == 11)     motor(-speed   , speed/2 , speed   , -speed/2);
    if(direction == 12)     motor(-speed   , speed   , speed   , -speed  );
    if(direction == 13)     motor(-speed/2 , speed   , speed/2 , -speed  );
    if(direction == 14)     motor(0        , speed   , 0       , -speed  );
    if(direction == 15)     motor(speed/2  , speed   , -speed/2, -speed  );        
    }

void read_pixy()
    {
    a=read();
    if(a==0xaa)
      {
      a=read();
      if(a==0x55)
        {           
        read();
        checksum = read();
        checksum += read() * 255;
        signature = read();
        signature += read() * 255;
        x = read();
        x+=read()*255;
        y = read();
        y += read() * 255;
        width = read();
        width += read() * 255;
        height = read();
        height += read() * 255;
        is_ball = true;
        }
      }                  
    if(a != 0) is_ball = true;
    else is_ball = false;
    ball_angle = atan2(y_robot - y, x_robot - x) * 180 / PI;
    if (ball_angle < 0) ball_angle += 360;
    ball_angle = 360 - ball_angle;
    for(i = 0; i < 16; i++)
        {                     
        if(ball_angle <= 11.25) ball = 0; 
        else if(ball_angle >= 348.5) ball = 0;
        else if((ball_angle - 11.25 >= i * 22.5) && (ball_angle-11.25 < (i+1) * 22.5))
            ball = i + 1;
        }                         
    ball_distance = sqrt(pow(x-(x_robot+35) , 2) + pow(y-y_robot, 2)); 

//    if(ball_angle>=0)
//        {
//        lcd_gotoxy(0,0);     
//        lcd_putchar('+');
//        lcd_putchar((ball_angle/100)%10+'0');          
//        lcd_putchar((ball_angle/10)%10+'0');          
//        lcd_putchar((ball_angle/1)%10+'0');            
//        }
//    else 
//        {          
//        lcd_gotoxy(0,0);
//        lcd_putchar('-');
//        lcd_putchar((-ball_angle/100)%10+'0');          
//        lcd_putchar((-ball_angle/10)%10+'0');          
//        lcd_putchar((-ball_angle/1)%10+'0');
//        }
    lcd_gotoxy(5,1);
    lcd_putchar((ball/10)%10+'0');
    lcd_putchar((ball/1)%10+'0');
    
    lcd_gotoxy(0,1);
    lcd_putchar((ball_distance/100)%10+'0');
    lcd_putchar((ball_distance/10)%10+'0');
    lcd_putchar((ball_distance/1)%10+'0');  
    
    lcd_gotoxy(0,0);
    lcd_putsf("X=");
    lcd_putchar((x/100)%10+'0');
    lcd_putchar((x/10)%10+'0');
    lcd_putchar((x/1)%10+'0');

    lcd_gotoxy(5,0);
    lcd_putsf("Y=");
    lcd_putchar((y/100)%10+'0');
    lcd_putchar((y/10)%10+'0');
    lcd_putchar((y/1)%10+'0');
    } 
            

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Fast PWM top=0xFF
// OC0 output: Non-Inverted PWM
// Timer Period: 2.048 ms
// Output Pulse(s):
// OC0 Period: 2.048 ms Width: 0 us
TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 2.048 ms
// Output Pulse(s):
// OC1A Period: 2.048 ms Width: 0 us// OC1B Period: 2.048 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Non-Inverted PWM
// Timer Period: 2.048 ms
// Output Pulse(s):
// OC2 Period: 2.048 ms Width: 0 us
ASSR=0<<AS2;
TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 62.500 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTB
// I2C SDA bit: 1
// I2C SCL bit: 0
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);

speed = 255;
delay_ms(2000);
c = compass_read(1);
while (1)
    { 
    readcmp();
    read_pixy();     
    if(is_ball)
        {  
        if(ball_distance < 70) 
            {
            if(ball == 0)       move(ball);
            else if(ball == 1)  move(ball);
            else if(ball == 15) move(ball);
            else if(ball == 2)  move(3);
            else if(ball == 14) move(13);

            else if(ball>2 && ball<=6)    move(ball + 2);
            else if(ball>=10 && ball<14)  move(ball - 2);
                
            else if(ball>6 && ball<=8)    move(ball + 2);
            else if(ball>8 && ball<10)    move(ball - 2);
            }
        else
            {
            move(ball);                                            
//            if(ball == 0)       move(ball);
//            else if(ball == 1)  move(ball);
//            else if(ball == 15) move(ball);
//            else if(ball == 2)  move(ball);
//            else if(ball == 14) move(ball);
//            
//                
//            else if(ball>2 && ball<=6)    move(ball + 1);
//            else if(ball>=10 && ball<14)  move(ball - 1);
//                
//            else if(ball>6 && ball<=8)    move(ball + 2);
//            else if(ball>8 && ball<10)    move(ball - 2);
            }       
        }
    else motor(0,0,0,0);
    }
}
