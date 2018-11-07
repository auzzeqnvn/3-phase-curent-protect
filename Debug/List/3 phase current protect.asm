
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATtiny24
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 8 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny24
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0008
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Uchar_Sample_count=R3

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x68

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : 3 Phase curent protect
;Version : 1.0
;Date    : 05/11/2018
;Author  :
;Company :
;Comments:
;Doc dien ap tu 3 pha, so sanh voi dien ap cai dat.
;Dieu khien ngat dong dau vao khi dong tieu thu lon hon dong cai dat
;
;
;Chip type               : ATtiny24
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 8
;*******************************************************/
;
;#include <tiny24.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;#define	current_1	1
;#define	current_2	2
;#define	current_3	3
;#define	current_set	7
;
;#define	num_sample	10
;
;#define	current_1_scale	1
;#define	current_2_scale	1
;#define	current_3_scale	1
;#define	current_set_scale	1
;
;//#define	v_num_noise_filter	3
;
;#define	DO_CONTROL_BUZZER	PORTB.2
;
;#define	BUZZER_ON	DO_CONTROL_BUZZER = 1
;#define	BUZZER_OFF	DO_CONTROL_BUZZER = 0
;
;#define	Err	0
;#define	Ok	1
;#define	Processing	2
;
;unsigned int	Uint_Current1_adc[num_sample];
;unsigned int	Uint_Current2_adc[num_sample];
;unsigned int	Uint_Current3_adc[num_sample];
;unsigned int	Uint_CurrentSet_adc[num_sample];
;unsigned char	Uchar_Sample_count;
;
;bit	Bit_AdcSample_full = 0;
;
;bit	Bit_TimerOverflow = 0;
;
;/*-----------------------------------------------------*/
;// Timer1 overflow interrupt service routine
;// Timer 10ms
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0042 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R30
; 0000 0043 // Reinitialize Timer1 value
; 0000 0044 	TCNT1H=0xCF2C >> 8;
	RCALL SUBOPT_0x0
; 0000 0045 	TCNT1L=0xCF2C & 0xff;
; 0000 0046 	Bit_TimerOverflow = 1;
	SBI  0x13,1
; 0000 0047 }
	LD   R30,Y+
	RETI
; .FEND
;
;
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0))
;
;// Read the AD conversion result
;// ADC 10 bit
;unsigned int read_adc(unsigned char adc_input)
; 0000 0051 {
_read_adc:
; .FSTART _read_adc
; 0000 0052 	ADMUX=(adc_input & 0x3f) | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x3F)
	OUT  0x7,R30
; 0000 0053 	// Delay needed for the stabilization of the ADC input voltage
; 0000 0054 	delay_us(10);
	__DELAY_USB 27
; 0000 0055 	// Start the AD conversion
; 0000 0056 	ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0057 	// Wait for the AD conversion to complete
; 0000 0058 	while ((ADCSRA & (1<<ADIF))==0);
_0x5:
	SBIS 0x6,4
	RJMP _0x5
; 0000 0059 	ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 005A 	return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 005B }
; .FEND
;
;/*
;*	Doc gia tri ADC cac dong dien theo chu ki cua timer.
;*	Lay gia tri trung binh cac thong so doc duoc.
;* 	So sanh dong dien tieu thu (1,2,3) voi gia tri cai dat (current_set)
;*	Bat co canh bao khi dong dien tieu thi lon hon cai dat.
;*/
;unsigned char	Current_get_value(void)
; 0000 0064 {
_Current_get_value:
; .FSTART _Current_get_value
; 0000 0065 	if(Bit_TimerOverflow)
	SBIS 0x13,1
	RJMP _0x8
; 0000 0066 	{
; 0000 0067 		unsigned char	Uchar_loop_cnt = 0;
; 0000 0068 		unsigned int	Uint_Current_value = 0;
; 0000 0069 		unsigned int	Uint_CurrentSet_value = 0;
; 0000 006A 		Bit_TimerOverflow = 0;
	SBIW R28,5
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RCALL SUBOPT_0x1
;	Uchar_loop_cnt -> Y+4
;	Uint_Current_value -> Y+2
;	Uint_CurrentSet_value -> Y+0
	CBI  0x13,1
; 0000 006B 
; 0000 006C 		Uint_Current1_adc[Uchar_Sample_count] = read_adc(current_1);
	MOV  R30,R3
	LDI  R26,LOW(_Uint_Current1_adc)
	RCALL SUBOPT_0x2
	PUSH R30
	LDI  R26,LOW(1)
	RCALL _read_adc
	POP  R26
	RCALL SUBOPT_0x3
; 0000 006D 		Uint_Current2_adc[Uchar_Sample_count] = read_adc(current_2);
	LDI  R26,LOW(_Uint_Current2_adc)
	RCALL SUBOPT_0x2
	PUSH R30
	LDI  R26,LOW(2)
	RCALL _read_adc
	POP  R26
	RCALL SUBOPT_0x3
; 0000 006E 		Uint_Current3_adc[Uchar_Sample_count] = read_adc(current_3);
	LDI  R26,LOW(_Uint_Current3_adc)
	RCALL SUBOPT_0x2
	PUSH R30
	LDI  R26,LOW(3)
	RCALL _read_adc
	POP  R26
	RCALL SUBOPT_0x3
; 0000 006F 		Uint_CurrentSet_adc[Uchar_Sample_count] = read_adc(current_set);
	LDI  R26,LOW(_Uint_CurrentSet_adc)
	RCALL SUBOPT_0x2
	PUSH R30
	LDI  R26,LOW(7)
	RCALL _read_adc
	POP  R26
	ST   X+,R30
	ST   X,R31
; 0000 0070 
; 0000 0071 		Uchar_Sample_count++;
	INC  R3
; 0000 0072 		if(Uchar_Sample_count >= num_sample)
	LDI  R30,LOW(10)
	CP   R3,R30
	BRLO _0xB
; 0000 0073 		{
; 0000 0074 			Uchar_Sample_count = 0;
	CLR  R3
; 0000 0075 			Bit_AdcSample_full = 1;
	SBI  0x13,0
; 0000 0076 		}
; 0000 0077 
; 0000 0078 
; 0000 0079 		if(Bit_AdcSample_full == 0)
_0xB:
	SBIC 0x13,0
	RJMP _0xE
; 0000 007A 		{
; 0000 007B 			for(Uchar_loop_cnt = 0; Uchar_loop_cnt < Uchar_Sample_count; Uchar_loop_cnt++)
	RCALL SUBOPT_0x1
_0x10:
	LDD  R26,Y+4
	CP   R26,R3
	BRSH _0x11
; 0000 007C 			{
; 0000 007D 				Uint_CurrentSet_value += Uint_CurrentSet_adc[Uchar_loop_cnt];
	RCALL SUBOPT_0x4
; 0000 007E 			}
	RCALL SUBOPT_0x5
	RJMP _0x10
_0x11:
; 0000 007F 			Uint_CurrentSet_value /= Uchar_loop_cnt;
	RCALL SUBOPT_0x6
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x7
; 0000 0080 
; 0000 0081 			for(Uchar_loop_cnt = 0; Uchar_loop_cnt < Uchar_Sample_count; Uchar_loop_cnt++)
_0x13:
	LDD  R26,Y+4
	CP   R26,R3
	BRSH _0x14
; 0000 0082 			{
; 0000 0083 				Uint_Current_value += Uint_Current1_adc[Uchar_loop_cnt];
	RCALL SUBOPT_0x8
; 0000 0084 			}
	RCALL SUBOPT_0x5
	RJMP _0x13
_0x14:
; 0000 0085 			Uint_Current_value /= Uchar_loop_cnt;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0086 			if(Uint_Current_value*current_1_scale > Uint_CurrentSet_value*current_set_scale)	return Err;
	BRSH _0x15
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 0087 
; 0000 0088 			for(Uchar_loop_cnt = 0; Uchar_loop_cnt < Uchar_Sample_count; Uchar_loop_cnt++)
_0x15:
	RCALL SUBOPT_0x1
_0x17:
	LDD  R26,Y+4
	CP   R26,R3
	BRSH _0x18
; 0000 0089 			{
; 0000 008A 				Uint_Current_value += Uint_Current2_adc[Uchar_loop_cnt];
	RCALL SUBOPT_0xB
; 0000 008B 			}
	RCALL SUBOPT_0x5
	RJMP _0x17
_0x18:
; 0000 008C 			Uint_Current_value /= Uchar_loop_cnt;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 008D 			if(Uint_Current_value*current_2_scale > Uint_CurrentSet_value*current_set_scale)	return Err;
	BRSH _0x19
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 008E 
; 0000 008F 			for(Uchar_loop_cnt = 0; Uchar_loop_cnt <= Uchar_Sample_count; Uchar_loop_cnt++)
_0x19:
	RCALL SUBOPT_0x1
_0x1B:
	LDD  R26,Y+4
	CP   R3,R26
	BRLO _0x1C
; 0000 0090 			{
; 0000 0091 				Uint_Current_value += Uint_Current3_adc[Uchar_loop_cnt];
	RCALL SUBOPT_0xC
; 0000 0092 			}
	RCALL SUBOPT_0x5
	RJMP _0x1B
_0x1C:
; 0000 0093 			Uint_Current_value /= Uchar_loop_cnt;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0094 			if(Uint_Current_value*current_3_scale > Uint_CurrentSet_value*current_set_scale)	return Err;
	BRSH _0x1D
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 0095 		}
_0x1D:
; 0000 0096 		else
	RJMP _0x1E
_0xE:
; 0000 0097 		{
; 0000 0098 			for(Uchar_loop_cnt = 0; Uchar_loop_cnt < num_sample; Uchar_loop_cnt++)
	RCALL SUBOPT_0x1
_0x20:
	RCALL SUBOPT_0xD
	BRSH _0x21
; 0000 0099 			{
; 0000 009A 				Uint_CurrentSet_value += Uint_CurrentSet_adc[Uchar_loop_cnt];
	RCALL SUBOPT_0x4
; 0000 009B 			}
	RCALL SUBOPT_0x5
	RJMP _0x20
_0x21:
; 0000 009C 			Uint_CurrentSet_value /= num_sample;
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x7
; 0000 009D 
; 0000 009E 			for(Uchar_loop_cnt = 0; Uchar_loop_cnt < num_sample; Uchar_loop_cnt++)
_0x23:
	RCALL SUBOPT_0xD
	BRSH _0x24
; 0000 009F 			{
; 0000 00A0 				Uint_Current_value += Uint_Current1_adc[Uchar_loop_cnt];
	RCALL SUBOPT_0x8
; 0000 00A1 			}
	RCALL SUBOPT_0x5
	RJMP _0x23
_0x24:
; 0000 00A2 			Uint_Current_value /=num_sample;
	RCALL SUBOPT_0xF
; 0000 00A3 			if(Uint_Current_value*current_1_scale > Uint_CurrentSet_value*current_set_scale)	return Err;
	BRSH _0x25
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 00A4 
; 0000 00A5 			for(Uchar_loop_cnt = 0; Uchar_loop_cnt < num_sample; Uchar_loop_cnt++)
_0x25:
	RCALL SUBOPT_0x1
_0x27:
	RCALL SUBOPT_0xD
	BRSH _0x28
; 0000 00A6 			{
; 0000 00A7 				Uint_Current_value += Uint_Current2_adc[Uchar_loop_cnt];
	RCALL SUBOPT_0xB
; 0000 00A8 			}
	RCALL SUBOPT_0x5
	RJMP _0x27
_0x28:
; 0000 00A9 			Uint_Current_value /=num_sample;
	RCALL SUBOPT_0xF
; 0000 00AA 			if(Uint_Current_value*current_2_scale > Uint_CurrentSet_value*current_set_scale)	return Err;
	BRSH _0x29
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 00AB 
; 0000 00AC 			for(Uchar_loop_cnt = 0; Uchar_loop_cnt < num_sample; Uchar_loop_cnt++)
_0x29:
	RCALL SUBOPT_0x1
_0x2B:
	RCALL SUBOPT_0xD
	BRSH _0x2C
; 0000 00AD 			{
; 0000 00AE 				Uint_Current_value += Uint_Current3_adc[Uchar_loop_cnt];
	RCALL SUBOPT_0xC
; 0000 00AF 			}
	RCALL SUBOPT_0x5
	RJMP _0x2B
_0x2C:
; 0000 00B0 			Uint_Current_value /= num_sample;
	RCALL SUBOPT_0xF
; 0000 00B1 			if(Uint_Current_value*current_3_scale > Uint_CurrentSet_value*current_set_scale)	return Err;
	BRSH _0x2D
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 00B2 		}
_0x2D:
_0x1E:
; 0000 00B3 		return Ok;
	LDI  R30,LOW(1)
_0x2000001:
	ADIW R28,5
	RET
; 0000 00B4 	}
	ADIW R28,5
; 0000 00B5 	return Processing;
_0x8:
	LDI  R30,LOW(2)
	RET
; 0000 00B6 }
; .FEND
;
;
;/*
;*	Dieu khien cac tin hieu canh bao dua vao trang thai cac co canh bao
;*/
;void	Protect_control(void)
; 0000 00BD {
_Protect_control:
; .FSTART _Protect_control
; 0000 00BE 	unsigned char	Uchar_respone = Processing;
; 0000 00BF 	Uchar_respone = Current_get_value();
	ST   -Y,R17
;	Uchar_respone -> R17
	LDI  R17,2
	RCALL _Current_get_value
	MOV  R17,R30
; 0000 00C0 	if(Uchar_respone == Err)
	CPI  R17,0
	BRNE _0x2E
; 0000 00C1 	{
; 0000 00C2 		BUZZER_ON;
	SBI  0x18,2
; 0000 00C3 	}
; 0000 00C4 	else
	RJMP _0x31
_0x2E:
; 0000 00C5 	{
; 0000 00C6 		BUZZER_OFF;
	CBI  0x18,2
; 0000 00C7 	}
_0x31:
; 0000 00C8 }
	LD   R17,Y+
	RET
; .FEND
;
;void main(void)
; 0000 00CB {
_main:
; .FSTART _main
; 0000 00CC // Declare your local variables here
; 0000 00CD 
; 0000 00CE // Crystal Oscillator division factor: 1
; 0000 00CF #pragma optsize-
; 0000 00D0 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00D1 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00D2 #ifdef _OPTIMIZE_SIZE_
; 0000 00D3 #pragma optsize+
; 0000 00D4 #endif
; 0000 00D5 // Input/Output Ports initialization
; 0000 00D6 // Port A initialization
; 0000 00D7 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D8 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	OUT  0x1A,R30
; 0000 00D9 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00DA PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00DB 
; 0000 00DC // Port B initialization
; 0000 00DD // Function: Bit3=Out Bit2=In Bit1=Out Bit0=Out
; 0000 00DE DDRB=(1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(11)
	OUT  0x17,R30
; 0000 00DF // State: Bit3=0 Bit2=T Bit1=0 Bit0=0
; 0000 00E0 PORTB=(0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00E1 
; 0000 00E2 // Timer/Counter 0 initialization
; 0000 00E3 // Clock source: System Clock
; 0000 00E4 // Clock value: Timer 0 Stopped
; 0000 00E5 // Mode: Normal top=0xFF
; 0000 00E6 // OC0A output: Disconnected
; 0000 00E7 // OC0B output: Disconnected
; 0000 00E8 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x30,R30
; 0000 00E9 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00EA TCNT0=0x00;
	OUT  0x32,R30
; 0000 00EB OCR0A=0x00;
	OUT  0x36,R30
; 0000 00EC OCR0B=0x00;
	OUT  0x3C,R30
; 0000 00ED 
; 0000 00EE // Timer/Counter 1 initialization
; 0000 00EF // Clock source: System Clock
; 0000 00F0 // Clock value: 125,000 kHz
; 0000 00F1 // Mode: Normal top=0xFFFF
; 0000 00F2 // OC1A output: Disconnected
; 0000 00F3 // OC1B output: Disconnected
; 0000 00F4 // Noise Canceler: Off
; 0000 00F5 // Input Capture on Falling Edge
; 0000 00F6 // Timer Period: 0,1 s
; 0000 00F7 // Timer1 Overflow Interrupt: On
; 0000 00F8 // Input Capture Interrupt: Off
; 0000 00F9 // Compare A Match Interrupt: Off
; 0000 00FA // Compare B Match Interrupt: Off
; 0000 00FB TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00FC TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 00FD TCNT1H=0xCF;
	RCALL SUBOPT_0x0
; 0000 00FE TCNT1L=0x2C;
; 0000 00FF ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0100 ICR1L=0x00;
	OUT  0x24,R30
; 0000 0101 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0102 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0103 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0104 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0105 
; 0000 0106 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0107 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0108 
; 0000 0109 // Timer/Counter 1 Interrupt(s) initialization
; 0000 010A TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);
	LDI  R30,LOW(1)
	OUT  0xC,R30
; 0000 010B 
; 0000 010C // External Interrupt(s) initialization
; 0000 010D // INT0: Off
; 0000 010E // Interrupt on any change on pins PCINT0-7: Off
; 0000 010F // Interrupt on any change on pins PCINT8-11: Off
; 0000 0110 MCUCR=(0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0111 GIMSK=(0<<INT0) | (0<<PCIE1) | (0<<PCIE0);
	OUT  0x3B,R30
; 0000 0112 
; 0000 0113 // USI initialization
; 0000 0114 // Mode: Disabled
; 0000 0115 // Clock source: Register & Counter=no clk.
; 0000 0116 // USI Counter Overflow Interrupt: Off
; 0000 0117 USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<<USICS0) | (0<<USICLK) | (0<<USITC);
	OUT  0xD,R30
; 0000 0118 
; 0000 0119 // Analog Comparator initialization
; 0000 011A // Analog Comparator: Off
; 0000 011B // The Analog Comparator's positive input is
; 0000 011C // connected to the AIN0 pin
; 0000 011D // The Analog Comparator's negative input is
; 0000 011E // connected to the AIN1 pin
; 0000 011F ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0120 // Digital input buffer on AIN0: On
; 0000 0121 // Digital input buffer on AIN1: On
; 0000 0122 DIDR0=(0<<ADC1D) | (0<<ADC2D);
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 0123 
; 0000 0124 // ADC initialization
; 0000 0125 // ADC Clock frequency: 1000,000 kHz
; 0000 0126 // ADC Voltage Reference: AVCC pin
; 0000 0127 // ADC Bipolar Input Mode: Off
; 0000 0128 // ADC Auto Trigger Source: Free Running
; 0000 0129 // Digital input buffers on ADC0: Off, ADC1: On, ADC2: On, ADC3: On
; 0000 012A // ADC4: Off, ADC5: Off, ADC6: Off, ADC7: On
; 0000 012B DIDR0=(0<<ADC7D) | (1<<ADC6D) | (1<<ADC5D) | (1<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (1<<ADC0D);
	LDI  R30,LOW(113)
	OUT  0x1,R30
; 0000 012C ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 012D ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(163)
	OUT  0x6,R30
; 0000 012E ADCSRB=(0<<BIN) | (0<<ADLAR) | (0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 012F 
; 0000 0130 
; 0000 0131 // Watchdog Timer initialization
; 0000 0132 // Watchdog Timer Prescaler: OSC/2k
; 0000 0133 // Watchdog timeout action: Reset
; 0000 0134 #pragma optsize-
; 0000 0135 WDTCSR=(0<<WDIF) | (0<<WDIE) | (0<<WDP3) | (1<<WDCE) | (1<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 0136 WDTCSR=(0<<WDIF) | (0<<WDIE) | (0<<WDP3) | (0<<WDCE) | (1<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(8)
	OUT  0x21,R30
; 0000 0137 #ifdef _OPTIMIZE_SIZE_
; 0000 0138 #pragma optsize+
; 0000 0139 #endif
; 0000 013A 
; 0000 013B // Global enable interrupts
; 0000 013C #asm("sei")
	sei
; 0000 013D 
; 0000 013E 	while (1)
_0x34:
; 0000 013F 	{
; 0000 0140 		Protect_control();
	RCALL _Protect_control
; 0000 0141 	}
	RJMP _0x34
; 0000 0142 }
_0x37:
	RJMP _0x37
; .FEND

	.DSEG
_Uint_Current1_adc:
	.BYTE 0x14
_Uint_Current2_adc:
	.BYTE 0x14
_Uint_Current3_adc:
	.BYTE 0x14
_Uint_CurrentSet_adc:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(207)
	OUT  0x2D,R30
	LDI  R30,LOW(44)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STD  Y+4,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LSL  R30
	ADD  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	ST   X+,R30
	ST   X,R31
	MOV  R30,R3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4:
	LDD  R30,Y+4
	LDI  R26,LOW(_Uint_CurrentSet_adc)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	LDD  R30,Y+4
	SUBI R30,-LOW(1)
	STD  Y+4,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDD  R30,Y+4
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	RCALL __DIVW21U
	ST   Y,R30
	STD  Y+1,R31
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
	LDD  R30,Y+4
	LDI  R26,LOW(_Uint_Current1_adc)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xA:
	RCALL __DIVW21U
	STD  Y+2,R30
	STD  Y+2+1,R31
	LD   R30,Y
	LDD  R31,Y+1
	RCALL SUBOPT_0x9
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDD  R30,Y+4
	LDI  R26,LOW(_Uint_Current2_adc)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	RCALL SUBOPT_0x9
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDD  R30,Y+4
	LDI  R26,LOW(_Uint_Current3_adc)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	RCALL SUBOPT_0x9
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDD  R26,Y+4
	CPI  R26,LOW(0xA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xE
	RJMP SUBOPT_0xA


	.CSEG
__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	DEC  R26
	RET

;END OF CODE MARKER
__END_OF_CODE:
