/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 3 Phase curent protect
Version : 1.0
Date    : 05/11/2018
Author  : 
Company : 
Comments: 
Doc dien ap tu 3 pha, so sanh voi dien ap cai dat.
Dieu khien ngat dong dau vao khi dong tieu thu lon hon dong cai dat


Chip type               : ATtiny24
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 8
*******************************************************/

#include <tiny24.h>

#include <delay.h>

#define	ADC_current_L1	1
#define	ADC_current_L2	2
#define	ADC_current_L3	3
#define	ADC_current_set	7

#define	num_sample	10

/* He so nhan gia tri ADC doc duoc tu L1, L2, L3 */
#define	current_scale	6

/* Gia tri dong dien cai dat */
#define	CURRENT_SET_MAX	20
#define	CURRENT_SET_MIN	8

/* Gia tri max co the doc duoc tu VR_set */
#define CURRENT_SET_ADC_VALUE_MAX     840


#define	DO_CONTROL_BUZZER	PORTB.0
#define	DO_CONTROL_RELAY	PORTB.1

#define	BUZZER_ON	DO_CONTROL_BUZZER = 1
#define	BUZZER_OFF	DO_CONTROL_BUZZER = 0

#define	RELAY_ON	DO_CONTROL_RELAY = 1
#define	RELAY_OFF	DO_CONTROL_RELAY = 0


#define	Err	0
#define	Ok	1
#define	Processing	2

unsigned int	AI10_Current_L1[num_sample];
unsigned int	AI10_Current_L2[num_sample];
unsigned int	AI10_Current_L3[num_sample];
unsigned int	AI10_SetCurrent_VR1[num_sample];
unsigned char	Uchar_Sample_count;
unsigned char	Uchar_Timer_count;

bit	Bit_AdcSample_full = 0;

bit	Bit_TimerOverflow = 0;

bit Bit_warning = 0;

/*-----------------------------------------------------*/
// Timer1 overflow interrupt service routine
// Timer 10ms
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
	TCNT1H=0xCF2C >> 8;
	TCNT1L=0xCF2C & 0xff;
	Bit_TimerOverflow = 1;
	Uchar_Timer_count++;
	if(Uchar_Timer_count>= 10)
	{
		Uchar_Timer_count = 0;
	}	
	if(Bit_warning == 1)
	{
		RELAY_ON;
		if(Uchar_Timer_count < 5)	BUZZER_ON;
		else	BUZZER_OFF;
	}
	else 
	{
		BUZZER_OFF;
		RELAY_OFF;
	}
}



// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0))

// Read the AD conversion result
// ADC 10 bit
unsigned int read_adc(unsigned char adc_input)
{
	ADMUX=(adc_input & 0x3f) | ADC_VREF_TYPE;
	// Delay needed for the stabilization of the ADC input voltage
	delay_us(10);
	// Start the AD conversion
	ADCSRA|=(1<<ADSC);
	// Wait for the AD conversion to complete
	while ((ADCSRA & (1<<ADIF))==0);
	ADCSRA|=(1<<ADIF);
	return ADCW;
}

/* 
*	Doc gia tri ADC cac dong dien theo chu ki cua timer (10ms/lan)
*	Lay gia tri trung binh cac gai tri doc duoc de giam nhieu.
*	nhan 10 gia tri doc duoc de tang do phan giai so sanh 0.1A
* 	So sanh dong dien tieu thu (1,2,3) voi gia tri cai dat (current_set)
*	Tra ve OK khi dong tieu thu nho hon dong cai dat
*	Tra ve ERR khi dong tieu thu lon hon dong cai dat
*/
unsigned char	Read_value_current(void)
{
	if(Bit_TimerOverflow)
	{
		unsigned char	Uchar_loop_cnt = 0;
		unsigned long	Uint_Current_value = 0;
		unsigned long	Uint_CurrentSet_value = 0; 

		Uint_CurrentSet_value = read_adc(ADC_current_set);
		Uint_CurrentSet_value = ((Uint_CurrentSet_value*10/CURRENT_SET_ADC_VALUE_MAX)*(CURRENT_SET_MAX - CURRENT_SET_MIN)) + CURRENT_SET_MIN*10;

		Uint_Current_value = read_adc(ADC_current_L1);
		Uint_Current_value = Uint_Current_value*5*current_scale*10/1024;
		if(Uint_Current_value > Uint_CurrentSet_value)	
		{
			Bit_warning = 1;
			Uchar_Sample_count = 0;
			//return Err;
		}
		else
		{
			Uint_Current_value = read_adc(ADC_current_L2);
			Uint_Current_value = Uint_Current_value*5*current_scale*10/1024;
			if(Uint_Current_value > Uint_CurrentSet_value)
			{
				Bit_warning = 1;
				Uchar_Sample_count = 0;
				//return Err;
			}
			else
			{
				Uint_Current_value = read_adc(ADC_current_L3);
				Uint_Current_value = Uint_Current_value*5*current_scale*10/1024;
				if(Uint_Current_value > Uint_CurrentSet_value)
				{
					Bit_warning = 1;
					Uchar_Sample_count = 0;
					//return Err;
				}
				else
				{
					Uchar_Sample_count++;
					if(Uchar_Sample_count > 10)		
					{
						Bit_warning = 0;
						Uchar_Sample_count = 6;
					}
					//return Ok;
				}
			}
		}
		Bit_TimerOverflow = 0;

		
		// AI10_Current_L1[Uchar_Sample_count] = read_adc(ADC_current_L1);
		// AI10_Current_L2[Uchar_Sample_count] = read_adc(ADC_current_L2);
		// AI10_Current_L3[Uchar_Sample_count] = read_adc(ADC_current_L3);

		// AI10_SetCurrent_VR1[Uchar_Sample_count] = read_adc(ADC_current_set); 

		// Uchar_Sample_count++;
		// if(Uchar_Sample_count >= num_sample)	
		// {
		// 	Uchar_Sample_count = 0;
		// 	Bit_AdcSample_full = 1;
		// } 

		// /* So mau lay duoc chua dat du num_sample (10) */
		// if(Bit_AdcSample_full == 0)
		// {         
		// 	/* tinh trung binh gia tri dien ap set doc duoc */
		// 	Uint_CurrentSet_value = 0;
        //     for(Uchar_loop_cnt = 0; Uchar_loop_cnt < Uchar_Sample_count; Uchar_loop_cnt++)
		// 	{
		// 		Uint_CurrentSet_value += AI10_SetCurrent_VR1[Uchar_loop_cnt];
		// 	}
		// 	Uint_CurrentSet_value /= Uchar_loop_cnt;  
		// 	if(Uint_CurrentSet_value >= CURRENT_SET_ADC_VALUE_MAX)	Uint_CurrentSet_value = CURRENT_SET_ADC_VALUE_MAX;
		// 	Uint_CurrentSet_value = ((Uint_CurrentSet_value*10/CURRENT_SET_ADC_VALUE_MAX)*(CURRENT_SET_MAX - CURRENT_SET_MIN)) + CURRENT_SET_MIN*10;
                           
           
        //     /* TInh trung binh gia tri dien ap doc duoc tu L1 */ 
		// 	Uint_Current_value = 0;
		// 	for(Uchar_loop_cnt = 0; Uchar_loop_cnt < Uchar_Sample_count; Uchar_loop_cnt++)
		// 	{
		// 		Uint_Current_value += AI10_Current_L1[Uchar_loop_cnt];
		// 	}
		// 	Uint_Current_value /= Uchar_loop_cnt; 
		// 	Uint_Current_value = Uint_Current_value*5*current_scale*10/1024;
		// 	if(Uint_Current_value > Uint_CurrentSet_value)	return Err;
			
		// 	/* TInh trung binh gia tri dien ap doc duoc tu L2 */ 
		// 	Uint_Current_value = 0;
		// 	for(Uchar_loop_cnt = 0; Uchar_loop_cnt < Uchar_Sample_count; Uchar_loop_cnt++)
		// 	{
		// 		Uint_Current_value += AI10_Current_L2[Uchar_loop_cnt];
		// 	}
		// 	Uint_Current_value /= Uchar_loop_cnt; 
		// 	Uint_Current_value = Uint_Current_value*5*current_scale*10/1024;
		// 	if(Uint_Current_value > Uint_CurrentSet_value)	return Err;
			
		// 	/* TInh trung binh gia tri dien ap doc duoc tu L3 */ 
		// 	Uint_Current_value = 0;
		// 	for(Uchar_loop_cnt = 0; Uchar_loop_cnt <= Uchar_Sample_count; Uchar_loop_cnt++)
		// 	{
		// 		Uint_Current_value += AI10_Current_L3[Uchar_loop_cnt];
		// 	}
		// 	Uint_Current_value /= Uchar_loop_cnt; 
		// 	Uint_Current_value = Uint_Current_value*5*current_scale*10/1024;
		// 	if(Uint_Current_value > Uint_CurrentSet_value)	return Err;

		// 	return Ok;
        // }
		// else /* So mau da duoc lay du num_sample*/
		// {
		// 	Uint_CurrentSet_value = 0;
		// 	for(Uchar_loop_cnt = 0; Uchar_loop_cnt < num_sample; Uchar_loop_cnt++)
		// 	{
		// 		Uint_CurrentSet_value += AI10_SetCurrent_VR1[Uchar_loop_cnt];
		// 	}
		// 	Uint_CurrentSet_value /= num_sample;
		// 	if(Uint_CurrentSet_value >= CURRENT_SET_ADC_VALUE_MAX)	Uint_CurrentSet_value = CURRENT_SET_ADC_VALUE_MAX;
		// 	Uint_CurrentSet_value = ((Uint_CurrentSet_value*10/CURRENT_SET_ADC_VALUE_MAX)*(CURRENT_SET_MAX - CURRENT_SET_MIN)) + CURRENT_SET_MIN*10;

		// 	Uint_Current_value = 0;
		// 	for(Uchar_loop_cnt = 0; Uchar_loop_cnt < num_sample; Uchar_loop_cnt++)
		// 	{
		// 		Uint_Current_value += AI10_Current_L1[Uchar_loop_cnt];
		// 	}
		// 	Uint_Current_value /=num_sample; 
		// 	Uint_Current_value = Uint_Current_value*5*current_scale*10/1024;
		// 	if(Uint_Current_value > Uint_CurrentSet_value)	return Err;
			
		// 	Uint_Current_value = 0;
		// 	for(Uchar_loop_cnt = 0; Uchar_loop_cnt < num_sample; Uchar_loop_cnt++)
		// 	{
		// 		Uint_Current_value += AI10_Current_L2[Uchar_loop_cnt];
		// 	}
		// 	Uint_Current_value /=num_sample; 
		// 	Uint_Current_value = Uint_Current_value*5*current_scale*10/1024;
		// 	if(Uint_Current_value > Uint_CurrentSet_value)	return Err;
			
		// 	Uint_Current_value = 0;
		// 	for(Uchar_loop_cnt = 0; Uchar_loop_cnt < num_sample; Uchar_loop_cnt++)
		// 	{
		// 		Uint_Current_value += AI10_Current_L3[Uchar_loop_cnt];
		// 	}
		// 	Uint_Current_value /= num_sample; 
		// 	Uint_Current_value = Uint_Current_value*5*current_scale*10/1024;
		// 	if(Uint_Current_value > Uint_CurrentSet_value)	return Err;	

		// 	return Ok;
		// }		
	}
	return Processing;
}


/*
*	Dieu khien cac tin hieu canh bao dua vao trang thai tra ve cua ham doc gia tri dong dien
*	Err : Bat tin hieu canh bao
*	Ok : Tat tien hieu canh bao
*/
void	Control_ProtectPower(void)
{
	unsigned char	Uchar_respone = Processing;
	Uchar_respone = Read_value_current();
	//Bit_warning = 1;
	// if(Uchar_respone == Err)
	// {
	// 	Bit_warning = 1;
	// }
	// else if(Uchar_respone == Ok)
	// {
	// 	Bit_warning = 0;
	// }
}

void main(void)
{
// Declare your local variables here
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif
// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit3=Out Bit2=In Bit1=Out Bit0=Out 
DDRB=(1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit3=0 Bit2=T Bit1=0 Bit0=0 
PORTB=(0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,1 s
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
TCNT1H=0xCF;
TCNT1L=0x2C;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
// // Timer/Counter 1 initialization
// // Clock source: System Clock
// // Clock value: 31.250 kHz
// // Mode: Normal top=0xFFFF
// // OC1A output: Disconnected
// // OC1B output: Disconnected
// // Noise Canceler: Off
// // Input Capture on Falling Edge
// // Timer Period: 1 s
// // Timer1 Overflow Interrupt: On
// // Input Capture Interrupt: Off
// // Compare A Match Interrupt: Off
// // Compare B Match Interrupt: Off
// TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
// TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
// TCNT1H=0x85;
// TCNT1L=0xEE;
// ICR1H=0x00;
// ICR1L=0x00;
// OCR1AH=0x00;
// OCR1AL=0x00;
// OCR1BH=0x00;
// OCR1BL=0x00;
// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

// // Timer/Counter 1 Interrupt(s) initialization
// TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-11: Off
MCUCR=(0<<ISC01) | (0<<ISC00);
GIMSK=(0<<INT0) | (0<<PCIE1) | (0<<PCIE0);

// USI initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<<USICS0) | (0<<USICLK) | (0<<USITC);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR0=(0<<ADC1D) | (0<<ADC2D);


// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Bipolar Input Mode: Off
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: Off, ADC1: On, ADC2: On, ADC3: On
// ADC4: Off, ADC5: Off, ADC6: Off, ADC7: On
DIDR0=(0<<ADC7D) | (1<<ADC6D) | (1<<ADC5D) | (1<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (1<<ADC0D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
ADCSRB=(0<<BIN) | (0<<ADLAR) | (0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);


// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2k
// Watchdog timeout action: Reset
//#pragma optsize-
//WDTCSR=(0<<WDIF) | (0<<WDIE) | (0<<WDP3) | (1<<WDCE) | (1<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
//WDTCSR=(0<<WDIF) | (0<<WDIE) | (0<<WDP3) | (0<<WDCE) | (1<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
//#ifdef _OPTIMIZE_SIZE_
//#pragma optsize+
//#endif

// Global enable interrupts

#asm("sei")  
BUZZER_ON;
delay_ms(400);
BUZZER_OFF;
delay_ms(400);
BUZZER_ON;
delay_ms(400);
BUZZER_OFF;
delay_ms(400);
// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);  

	while (1)
	{
		Control_ProtectPower();  
	}
}
