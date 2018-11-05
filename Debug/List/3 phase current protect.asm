
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATtiny24
;Program type           : Application
;Clock frequency        : 8.000000 MHz
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
	.DEF _v_current_value=R2
	.DEF _v_current_value_msb=R3
	.DEF _v_current_set_value=R4
	.DEF _v_current_set_value_msb=R5
	.DEF _v_num_sample_cnt=R7

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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x02
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

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
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
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
;//#define	v_num_noise_filter	3
;
;unsigned int	v_current_value = 0;
;unsigned int	v_current_set_value = 0;
;
;unsigned int	v_adc_current_1[num_sample];
;unsigned int	v_adc_current_2[num_sample];
;unsigned int	v_adc_current_3[num_sample];
;unsigned int	v_adc_current_set[num_sample];
;unsigned char	v_num_sample_cnt;
;
;bit	f_current_1_hight = 0;
;bit	f_current_2_hight = 0;
;bit	f_current_3_hight = 0;
;
;bit	f_adc_get_sample = 0;
;
;bit	f_timer_overflow = 0;
;
;#define	BUZZER_ON	PORTB |= 0x02
;#define	BUZZER_OFF	PORTB &= 0xFD
;
;// Declare your global variables here
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0042 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R30
; 0000 0043 // Reinitialize Timer1 value
; 0000 0044 TCNT1H=0xCF2C >> 8;
	RCALL SUBOPT_0x0
; 0000 0045 TCNT1L=0xCF2C & 0xff;
; 0000 0046 f_timer_overflow = 1;
	SBI  0x13,4
; 0000 0047 
; 0000 0048 // Place your code here
; 0000 0049 
; 0000 004A }
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
;unsigned int read_adc(unsigned char adc_input)
; 0000 0053 {
_read_adc:
; .FSTART _read_adc
; 0000 0054 ADMUX=(adc_input & 0x3f) | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x3F)
	OUT  0x7,R30
; 0000 0055 // Delay needed for the stabilization of the ADC input voltage
; 0000 0056 delay_us(10);
	__DELAY_USB 27
; 0000 0057 // Start the AD conversion
; 0000 0058 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0059 // Wait for the AD conversion to complete
; 0000 005A while ((ADCSRA & (1<<ADIF))==0);
_0x5:
	SBIS 0x6,4
	RJMP _0x5
; 0000 005B ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 005C return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 005D }
; .FEND
;
;void	Current_get_value(void)
; 0000 0060 {
_Current_get_value:
; .FSTART _Current_get_value
; 0000 0061 	unsigned char	cnt_loop = 0;
; 0000 0062 
; 0000 0063 	v_adc_current_1[v_num_sample_cnt] = read_adc(current_1);
	ST   -Y,R17
;	cnt_loop -> R17
	LDI  R17,0
	MOV  R30,R7
	LDI  R26,LOW(_v_adc_current_1)
	RCALL SUBOPT_0x1
	PUSH R30
	LDI  R26,LOW(1)
	RCALL _read_adc
	POP  R26
	RCALL SUBOPT_0x2
; 0000 0064 	v_adc_current_2[v_num_sample_cnt] = read_adc(current_2);
	LDI  R26,LOW(_v_adc_current_2)
	RCALL SUBOPT_0x1
	PUSH R30
	LDI  R26,LOW(2)
	RCALL _read_adc
	POP  R26
	RCALL SUBOPT_0x2
; 0000 0065 	v_adc_current_3[v_num_sample_cnt] = read_adc(current_3);
	LDI  R26,LOW(_v_adc_current_3)
	RCALL SUBOPT_0x1
	PUSH R30
	LDI  R26,LOW(3)
	RCALL _read_adc
	POP  R26
	RCALL SUBOPT_0x2
; 0000 0066 	v_adc_current_set[v_num_sample_cnt] = read_adc(current_set);
	LDI  R26,LOW(_v_adc_current_set)
	RCALL SUBOPT_0x1
	PUSH R30
	LDI  R26,LOW(7)
	RCALL _read_adc
	POP  R26
	ST   X+,R30
	ST   X,R31
; 0000 0067 
; 0000 0068 	if((v_num_sample_cnt < (num_sample-1)) && (f_adc_get_sample == 0))
	LDI  R30,LOW(9)
	CP   R7,R30
	BRSH _0x9
	SBIS 0x13,3
	RJMP _0xA
_0x9:
	RJMP _0x8
_0xA:
; 0000 0069     {
; 0000 006A         for(cnt_loop = 0; cnt_loop <= v_num_sample_cnt; cnt_loop++)
	LDI  R17,LOW(0)
_0xC:
	CP   R7,R17
	BRLO _0xD
; 0000 006B 		{
; 0000 006C 			v_current_set_value += v_adc_current_set[cnt_loop];
	RCALL SUBOPT_0x3
; 0000 006D 		}
	SUBI R17,-1
	RJMP _0xC
_0xD:
; 0000 006E 		v_current_set_value /= cnt_loop;
	RCALL SUBOPT_0x4
	MOVW R26,R4
	RCALL __DIVW21U
	MOVW R4,R30
; 0000 006F 
; 0000 0070 		for(cnt_loop = 0; cnt_loop <= v_num_sample_cnt; cnt_loop++)
	LDI  R17,LOW(0)
_0xF:
	CP   R7,R17
	BRLO _0x10
; 0000 0071 		{
; 0000 0072 			v_current_value += v_adc_current_1[cnt_loop];
	RCALL SUBOPT_0x5
; 0000 0073 		}
	SUBI R17,-1
	RJMP _0xF
_0x10:
; 0000 0074 		v_current_value /= cnt_loop;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x6
; 0000 0075         if(v_current_value*current_1_scale > v_current_set_value*current_set_scale)	f_current_1_hight = 1;
	BRSH _0x11
	SBI  0x13,0
; 0000 0076 		else	f_current_1_hight = 0;
	RJMP _0x14
_0x11:
	CBI  0x13,0
; 0000 0077 
; 0000 0078 		for(cnt_loop = 0; cnt_loop <= v_num_sample_cnt; cnt_loop++)
_0x14:
	LDI  R17,LOW(0)
_0x18:
	CP   R7,R17
	BRLO _0x19
; 0000 0079 		{
; 0000 007A 			v_current_value += v_adc_current_2[cnt_loop];
	RCALL SUBOPT_0x7
; 0000 007B 		}
	SUBI R17,-1
	RJMP _0x18
_0x19:
; 0000 007C 		v_current_value /= cnt_loop;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x6
; 0000 007D         if(v_current_value*current_2_scale > v_current_set_value*current_set_scale)	f_current_2_hight = 1;
	BRSH _0x1A
	SBI  0x13,1
; 0000 007E 		else	f_current_2_hight = 0;
	RJMP _0x1D
_0x1A:
	CBI  0x13,1
; 0000 007F 
; 0000 0080 		for(cnt_loop = 0; cnt_loop <= v_num_sample_cnt; cnt_loop++)
_0x1D:
	LDI  R17,LOW(0)
_0x21:
	CP   R7,R17
	BRLO _0x22
; 0000 0081 		{
; 0000 0082 			v_current_value += v_adc_current_3[cnt_loop];
	RCALL SUBOPT_0x8
; 0000 0083 		}
	SUBI R17,-1
	RJMP _0x21
_0x22:
; 0000 0084 		v_current_value /= cnt_loop;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x6
; 0000 0085         if(v_current_value*current_3_scale > v_current_set_value*current_set_scale)	f_current_3_hight = 1;
	BRSH _0x23
	SBI  0x13,2
; 0000 0086 		else	f_current_3_hight = 0;
	RJMP _0x26
_0x23:
	CBI  0x13,2
; 0000 0087     }
_0x26:
; 0000 0088     else
	RJMP _0x29
_0x8:
; 0000 0089     {
; 0000 008A 		f_adc_get_sample = 1;
	SBI  0x13,3
; 0000 008B 		for(cnt_loop = 0; cnt_loop < num_sample; cnt_loop++)
	LDI  R17,LOW(0)
_0x2D:
	CPI  R17,10
	BRSH _0x2E
; 0000 008C 		{
; 0000 008D 			v_current_set_value += v_adc_current_set[cnt_loop];
	RCALL SUBOPT_0x3
; 0000 008E 		}
	SUBI R17,-1
	RJMP _0x2D
_0x2E:
; 0000 008F 		v_current_set_value /= num_sample;
	MOVW R26,R4
	RCALL SUBOPT_0x9
	MOVW R4,R30
; 0000 0090 
; 0000 0091 		for(cnt_loop = 0; cnt_loop < num_sample; cnt_loop++)
	LDI  R17,LOW(0)
_0x30:
	CPI  R17,10
	BRSH _0x31
; 0000 0092 		{
; 0000 0093 			v_current_value += v_adc_current_1[cnt_loop];
	RCALL SUBOPT_0x5
; 0000 0094 		}
	SUBI R17,-1
	RJMP _0x30
_0x31:
; 0000 0095 		v_current_value /=num_sample;
	MOVW R26,R2
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0096         if(v_current_value*current_1_scale > v_current_set_value*current_set_scale)	f_current_1_hight = 1;
	BRSH _0x32
	SBI  0x13,0
; 0000 0097 		else	f_current_1_hight = 0;
	RJMP _0x35
_0x32:
	CBI  0x13,0
; 0000 0098 
; 0000 0099 		for(cnt_loop = 0; cnt_loop < num_sample; cnt_loop++)
_0x35:
	LDI  R17,LOW(0)
_0x39:
	CPI  R17,10
	BRSH _0x3A
; 0000 009A 		{
; 0000 009B 			v_current_value += v_adc_current_2[cnt_loop];
	RCALL SUBOPT_0x7
; 0000 009C 		}
	SUBI R17,-1
	RJMP _0x39
_0x3A:
; 0000 009D 		v_current_value /=num_sample;
	MOVW R26,R2
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 009E         if(v_current_value*current_2_scale > v_current_set_value*current_set_scale)	f_current_2_hight = 1;
	BRSH _0x3B
	SBI  0x13,1
; 0000 009F 		else	f_current_2_hight = 0;
	RJMP _0x3E
_0x3B:
	CBI  0x13,1
; 0000 00A0 
; 0000 00A1 		for(cnt_loop = 0; cnt_loop < num_sample; cnt_loop++)
_0x3E:
	LDI  R17,LOW(0)
_0x42:
	CPI  R17,10
	BRSH _0x43
; 0000 00A2 		{
; 0000 00A3 			v_current_value += v_adc_current_3[cnt_loop];
	RCALL SUBOPT_0x8
; 0000 00A4 		}
	SUBI R17,-1
	RJMP _0x42
_0x43:
; 0000 00A5 		v_current_value /= num_sample;
	MOVW R26,R2
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 00A6         if(v_current_value*current_3_scale > v_current_set_value*current_set_scale)	f_current_3_hight = 1;
	BRSH _0x44
	SBI  0x13,2
; 0000 00A7 		else	f_current_3_hight = 0;
	RJMP _0x47
_0x44:
	CBI  0x13,2
; 0000 00A8 
; 0000 00A9     }
_0x47:
_0x29:
; 0000 00AA 
; 0000 00AB     v_num_sample_cnt++;
	INC  R7
; 0000 00AC 	if(v_num_sample_cnt >= num_sample)	v_num_sample_cnt = 0;
	LDI  R30,LOW(10)
	CP   R7,R30
	BRLO _0x4A
	CLR  R7
; 0000 00AD }
_0x4A:
	LD   R17,Y+
	RET
; .FEND
;
;void	Control(void)
; 0000 00B0 {
_Control:
; .FSTART _Control
; 0000 00B1 	if(f_current_1_hight || f_current_2_hight || f_current_3_hight)
	SBIC 0x13,0
	RJMP _0x4C
	SBIC 0x13,1
	RJMP _0x4C
	SBIS 0x13,2
	RJMP _0x4B
_0x4C:
; 0000 00B2 	{
; 0000 00B3 		BUZZER_ON;
	SBI  0x18,1
; 0000 00B4 	}
; 0000 00B5 	else
	RJMP _0x4E
_0x4B:
; 0000 00B6 	{
; 0000 00B7 		BUZZER_OFF;
	CBI  0x18,1
; 0000 00B8 	}
_0x4E:
; 0000 00B9 }
	RET
; .FEND
;
;void main(void)
; 0000 00BC {
_main:
; .FSTART _main
; 0000 00BD // Declare your local variables here
; 0000 00BE 
; 0000 00BF // Crystal Oscillator division factor: 1
; 0000 00C0 #pragma optsize-
; 0000 00C1 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00C2 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00C3 #ifdef _OPTIMIZE_SIZE_
; 0000 00C4 #pragma optsize+
; 0000 00C5 #endif
; 0000 00C6 
; 0000 00C7 //// Reset Source checking
; 0000 00C8 //if (MCUSR & (1<<PORF))
; 0000 00C9 //   {
; 0000 00CA //   // Power-on Reset
; 0000 00CB //   MCUSR=0;
; 0000 00CC //   // Place your code here
; 0000 00CD //
; 0000 00CE //   }
; 0000 00CF //else if (MCUSR & (1<<EXTRF))
; 0000 00D0 //   {
; 0000 00D1 //   // External Reset
; 0000 00D2 //   MCUSR=0;
; 0000 00D3 //   // Place your code here
; 0000 00D4 //
; 0000 00D5 //   }
; 0000 00D6 //else if (MCUSR & (1<<BORF))
; 0000 00D7 //   {
; 0000 00D8 //   // Brown-Out Reset
; 0000 00D9 //   MCUSR=0;
; 0000 00DA //   // Place your code here
; 0000 00DB //
; 0000 00DC //   }
; 0000 00DD //else
; 0000 00DE //   {
; 0000 00DF //   // Watchdog Reset
; 0000 00E0 //   MCUSR=0;
; 0000 00E1 //   // Place your code here
; 0000 00E2 //
; 0000 00E3 //   }
; 0000 00E4 
; 0000 00E5 // Input/Output Ports initialization
; 0000 00E6 // Port A initialization
; 0000 00E7 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00E8 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	OUT  0x1A,R30
; 0000 00E9 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00EA PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00EB 
; 0000 00EC // Port B initialization
; 0000 00ED // Function: Bit3=Out Bit2=In Bit1=Out Bit0=Out
; 0000 00EE DDRB=(1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(11)
	OUT  0x17,R30
; 0000 00EF // State: Bit3=0 Bit2=T Bit1=0 Bit0=0
; 0000 00F0 PORTB=(0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00F1 
; 0000 00F2 // Timer/Counter 0 initialization
; 0000 00F3 // Clock source: System Clock
; 0000 00F4 // Clock value: Timer 0 Stopped
; 0000 00F5 // Mode: Normal top=0xFF
; 0000 00F6 // OC0A output: Disconnected
; 0000 00F7 // OC0B output: Disconnected
; 0000 00F8 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x30,R30
; 0000 00F9 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00FA TCNT0=0x00;
	OUT  0x32,R30
; 0000 00FB OCR0A=0x00;
	OUT  0x36,R30
; 0000 00FC OCR0B=0x00;
	OUT  0x3C,R30
; 0000 00FD 
; 0000 00FE // Timer/Counter 1 initialization
; 0000 00FF // Clock source: System Clock
; 0000 0100 // Clock value: 125,000 kHz
; 0000 0101 // Mode: Normal top=0xFFFF
; 0000 0102 // OC1A output: Disconnected
; 0000 0103 // OC1B output: Disconnected
; 0000 0104 // Noise Canceler: Off
; 0000 0105 // Input Capture on Falling Edge
; 0000 0106 // Timer Period: 0,1 s
; 0000 0107 // Timer1 Overflow Interrupt: On
; 0000 0108 // Input Capture Interrupt: Off
; 0000 0109 // Compare A Match Interrupt: Off
; 0000 010A // Compare B Match Interrupt: Off
; 0000 010B TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 010C TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 010D TCNT1H=0xCF;
	RCALL SUBOPT_0x0
; 0000 010E TCNT1L=0x2C;
; 0000 010F ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0110 ICR1L=0x00;
	OUT  0x24,R30
; 0000 0111 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0112 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0113 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0114 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0115 
; 0000 0116 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0117 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0118 
; 0000 0119 // Timer/Counter 1 Interrupt(s) initialization
; 0000 011A TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);
	LDI  R30,LOW(1)
	OUT  0xC,R30
; 0000 011B 
; 0000 011C // External Interrupt(s) initialization
; 0000 011D // INT0: Off
; 0000 011E // Interrupt on any change on pins PCINT0-7: Off
; 0000 011F // Interrupt on any change on pins PCINT8-11: Off
; 0000 0120 MCUCR=(0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0121 GIMSK=(0<<INT0) | (0<<PCIE1) | (0<<PCIE0);
	OUT  0x3B,R30
; 0000 0122 
; 0000 0123 // USI initialization
; 0000 0124 // Mode: Disabled
; 0000 0125 // Clock source: Register & Counter=no clk.
; 0000 0126 // USI Counter Overflow Interrupt: Off
; 0000 0127 USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<<USICS0) | (0<<USICLK) | (0<<USITC);
	OUT  0xD,R30
; 0000 0128 
; 0000 0129 // Analog Comparator initialization
; 0000 012A // Analog Comparator: Off
; 0000 012B // The Analog Comparator's positive input is
; 0000 012C // connected to the AIN0 pin
; 0000 012D // The Analog Comparator's negative input is
; 0000 012E // connected to the AIN1 pin
; 0000 012F ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0130 // Digital input buffer on AIN0: On
; 0000 0131 // Digital input buffer on AIN1: On
; 0000 0132 DIDR0=(0<<ADC1D) | (0<<ADC2D);
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 0133 
; 0000 0134 // ADC initialization
; 0000 0135 // ADC Clock frequency: 1000,000 kHz
; 0000 0136 // ADC Voltage Reference: AVCC pin
; 0000 0137 // ADC Bipolar Input Mode: Off
; 0000 0138 // ADC Auto Trigger Source: Free Running
; 0000 0139 // Digital input buffers on ADC0: Off, ADC1: On, ADC2: On, ADC3: On
; 0000 013A // ADC4: Off, ADC5: Off, ADC6: Off, ADC7: On
; 0000 013B DIDR0=(0<<ADC7D) | (1<<ADC6D) | (1<<ADC5D) | (1<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (1<<ADC0D);
	LDI  R30,LOW(113)
	OUT  0x1,R30
; 0000 013C ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 013D ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(163)
	OUT  0x6,R30
; 0000 013E ADCSRB=(0<<BIN) | (0<<ADLAR) | (0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 013F 
; 0000 0140 
; 0000 0141 // Watchdog Timer initialization
; 0000 0142 // Watchdog Timer Prescaler: OSC/2k
; 0000 0143 // Watchdog timeout action: Reset
; 0000 0144 #pragma optsize-
; 0000 0145 WDTCSR=(0<<WDIF) | (0<<WDIE) | (0<<WDP3) | (1<<WDCE) | (1<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 0146 WDTCSR=(0<<WDIF) | (0<<WDIE) | (0<<WDP3) | (0<<WDCE) | (1<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(8)
	OUT  0x21,R30
; 0000 0147 #ifdef _OPTIMIZE_SIZE_
; 0000 0148 #pragma optsize+
; 0000 0149 #endif
; 0000 014A 
; 0000 014B // Global enable interrupts
; 0000 014C #asm("sei")
	sei
; 0000 014D 
; 0000 014E 	while (1)
_0x4F:
; 0000 014F 	{
; 0000 0150 		// Place your code here
; 0000 0151 		if(f_timer_overflow)
	SBIS 0x13,4
	RJMP _0x52
; 0000 0152 		{
; 0000 0153 			Current_get_value();
	RCALL _Current_get_value
; 0000 0154 			f_timer_overflow = 0;
	CBI  0x13,4
; 0000 0155 		}
; 0000 0156 		Control();
_0x52:
	RCALL _Control
; 0000 0157 	}
	RJMP _0x4F
; 0000 0158 }
_0x55:
	RJMP _0x55
; .FEND

	.DSEG
_v_adc_current_1:
	.BYTE 0x14
_v_adc_current_2:
	.BYTE 0x14
_v_adc_current_3:
	.BYTE 0x14
_v_adc_current_set:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(207)
	OUT  0x2D,R30
	LDI  R30,LOW(44)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LSL  R30
	ADD  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	ST   X+,R30
	ST   X,R31
	MOV  R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	MOV  R30,R17
	LDI  R26,LOW(_v_adc_current_set)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	__ADDWRR 4,5,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	LDI  R26,LOW(_v_adc_current_1)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	__ADDWRR 2,3,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	MOVW R26,R2
	RCALL __DIVW21U
	MOVW R2,R30
	__CPWRR 4,5,2,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	MOV  R30,R17
	LDI  R26,LOW(_v_adc_current_2)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	__ADDWRR 2,3,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	LDI  R26,LOW(_v_adc_current_3)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	__ADDWRR 2,3,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	MOVW R2,R30
	__CPWRR 4,5,2,3
	RET


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
