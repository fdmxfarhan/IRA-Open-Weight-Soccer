
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _speed=R4
	.DEF _speed_msb=R5
	.DEF _i=R6
	.DEF _i_msb=R7
	.DEF _cmp=R8
	.DEF _cmp_msb=R9
	.DEF _c=R10
	.DEF _c_msb=R11
	.DEF _x=R12
	.DEF _x_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _twi_int_handler
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x6:
	.DB  0x93
_0x7:
	.DB  0x48
_0x8:
	.DB  0x54
_0x0:
	.DB  0x58,0x3D,0x0,0x59,0x3D,0x0
_0x2020003:
	.DB  0x7
_0x2040003:
	.DB  0x80,0xC0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _x_robot
	.DW  _0x6*2

	.DW  0x01
	.DW  _y_robot
	.DW  _0x7*2

	.DW  0x01
	.DW  _address
	.DW  _0x8*2

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2020003*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 9/28/2019
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <math.h>
;#include <twi.h>
;// I2C Bus functions
;#include <i2c.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0029 {

	.CSEG
; 0000 002A ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 002B // Delay needed for the stabilization of the ADC input voltage
; 0000 002C delay_us(10);
; 0000 002D // Start the AD conversion
; 0000 002E ADCSRA|=(1<<ADSC);
; 0000 002F // Wait for the AD conversion to complete
; 0000 0030 while ((ADCSRA & (1<<ADIF))==0);
; 0000 0031 ADCSRA|=(1<<ADIF);
; 0000 0032 return ADCW;
; 0000 0033 }
;
;///////////////////////////////////////////////////////////////////vars
;int speed = 255;
;int i;
;int cmp,c=0;
;int x, y,width,height,checksum, signature;
;char a;
;int x_robot = 147, y_robot = 72, ball_angle, ball, ball_distance;

	.DSEG
;bool is_ball = false;
;
;
;//////////////////////////////////////////////////////////////////////////////////PIXY-CMUCAM5
;#define I2C_7BIT_DEVICE_ADDRESS 0x54
;#define EEPROM_BUS_ADDRESS (I2C_7BIT_DEVICE_ADDRESS << 1)
;
;unsigned int  address=0x54;
;unsigned char read()
; 0000 0045 {

	.CSEG
_read:
; .FSTART _read
; 0000 0046 unsigned char data;
; 0000 0047 i2c_start();
	ST   -Y,R17
;	data -> R17
	CALL _i2c_start
; 0000 0048 i2c_write(EEPROM_BUS_ADDRESS | 0);
	LDI  R26,LOW(168)
	CALL _i2c_write
; 0000 0049 i2c_write(address >> 8);
	LDS  R30,_address+1
	MOV  R26,R30
	CALL _i2c_write
; 0000 004A i2c_write((unsigned char) address);
	LDS  R26,_address
	CALL _i2c_write
; 0000 004B i2c_start();
	CALL _i2c_start
; 0000 004C i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R26,LOW(169)
	CALL SUBOPT_0x0
; 0000 004D data=i2c_read(0);
; 0000 004E i2c_stop();
; 0000 004F return data;
	LD   R17,Y+
	RET
; 0000 0050 }
; .FEND
;//////////////////////////////////////////////////////////////////////////////////CMP-READ
;#define EEPROM_BUS_ADDRES 0xc0
;/* read/ a byte from the EEPROM */
;unsigned char compass_read(unsigned char addres)
; 0000 0055     {
_compass_read:
; .FSTART _compass_read
; 0000 0056     unsigned char data;
; 0000 0057     i2c_start();
	ST   -Y,R26
	ST   -Y,R17
;	addres -> Y+1
;	data -> R17
	CALL _i2c_start
; 0000 0058     i2c_write(EEPROM_BUS_ADDRES);
	LDI  R26,LOW(192)
	CALL _i2c_write
; 0000 0059     i2c_write(addres);
	LDD  R26,Y+1
	CALL _i2c_write
; 0000 005A     i2c_start();
	CALL _i2c_start
; 0000 005B     i2c_write(EEPROM_BUS_ADDRES | 1);
	LDI  R26,LOW(193)
	CALL SUBOPT_0x0
; 0000 005C     data=i2c_read(0);
; 0000 005D     i2c_stop();
; 0000 005E     return data;
	LDD  R17,Y+0
	RJMP _0x20C0007
; 0000 005F     }
; .FEND
;
;void readcmp()
; 0000 0062     {
_readcmp:
; .FSTART _readcmp
; 0000 0063     //if(PIND.6 == 1)  c = compass_read(1);
; 0000 0064     cmp = compass_read(1) - c;
	LDI  R26,LOW(1)
	RCALL _compass_read
	LDI  R31,0
	SUB  R30,R10
	SBC  R31,R11
	MOVW R8,R30
; 0000 0065 
; 0000 0066     if(cmp>128)       cmp=cmp-255;
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x9
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 8,9,30,31
; 0000 0067     else if(cmp<-128) cmp=cmp+255;
	RJMP _0xA
_0x9:
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0xB
	MOVW R30,R8
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	MOVW R8,R30
; 0000 0068 
; 0000 0069     if(cmp >= 0)
_0xB:
_0xA:
	CLR  R0
	CP   R8,R0
	CPC  R9,R0
	BRLT _0xC
; 0000 006A         {
; 0000 006B         lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x1
; 0000 006C         lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL _lcd_putchar
; 0000 006D         lcd_putchar((cmp/100)%10+'0');
	MOVW R26,R8
	CALL SUBOPT_0x2
; 0000 006E         lcd_putchar((cmp/10)%10+'0');
	MOVW R26,R8
	CALL SUBOPT_0x3
; 0000 006F         lcd_putchar((cmp/1)%10+'0');
	MOVW R26,R8
	RJMP _0x72
; 0000 0070         }
; 0000 0071     else
_0xC:
; 0000 0072         {
; 0000 0073         lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x1
; 0000 0074         lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 0075         lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x2
; 0000 0076         lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x3
; 0000 0077         lcd_putchar((-cmp/1)%10+'0');
	CALL SUBOPT_0x4
_0x72:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x5
; 0000 0078         }
; 0000 0079 
; 0000 007A     if(cmp<30 && cmp>-30) cmp *= 2;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0xF
	LDI  R30,LOW(65506)
	LDI  R31,HIGH(65506)
	CP   R30,R8
	CPC  R31,R9
	BRLT _0x10
_0xF:
	RJMP _0xE
_0x10:
	LSL  R8
	ROL  R9
; 0000 007B     else  cmp *= 1;
	RJMP _0x11
_0xE:
	MOVW R8,R8
; 0000 007C     cmp *= -1;
_0x11:
	MOVW R30,R8
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	MOVW R8,R30
; 0000 007D 
; 0000 007E     }
	RET
; .FEND
;
;
;void motor(int L1, int L2, int R2,int R1 )
; 0000 0082     {
_motor:
; .FSTART _motor
; 0000 0083     L1 += cmp;
	ST   -Y,R27
	ST   -Y,R26
;	L1 -> Y+6
;	L2 -> Y+4
;	R2 -> Y+2
;	R1 -> Y+0
	MOVW R30,R8
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0084     L2 += cmp;
	MOVW R30,R8
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0085     R1 += cmp;
	MOVW R30,R8
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 0086     R2 += cmp;
	MOVW R30,R8
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0087 
; 0000 0088 
; 0000 0089     if (L1>255)  L1=255;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x12
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 008A     if (L1<-255) L1=-255;
_0x12:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x13
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 008B 
; 0000 008C     if (L2>255)  L2=255;
_0x13:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x14
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 008D     if (L2<-255) L2=-255;
_0x14:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x15
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 008E 
; 0000 008F     if (R2>255)  R2=255;
_0x15:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x16
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0090     if (R2<-255) R2=-255;
_0x16:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x17
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0091 
; 0000 0092     if (R1>255)  R1=255;
_0x17:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x18
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0093     if (R1<-255) R1=-255;
_0x18:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x19
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0094 
; 0000 0095     ///////////////////L1
; 0000 0096     if (L1>0)
_0x19:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BRGE _0x1A
; 0000 0097         {
; 0000 0098         PORTD.3=0;
	CBI  0x12,3
; 0000 0099         OCR2=L1;
	LDD  R30,Y+6
	RJMP _0x73
; 0000 009A         }
; 0000 009B     else
_0x1A:
; 0000 009C         {
; 0000 009D         PORTD.3=1;
	SBI  0x12,3
; 0000 009E         OCR2=255+L1;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
_0x73:
	OUT  0x23,R30
; 0000 009F         }
; 0000 00A0     ///////////////////L2
; 0000 00A1     if (L2>0)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __CPW02
	BRGE _0x20
; 0000 00A2         {
; 0000 00A3         PORTD.2=0;
	CBI  0x12,2
; 0000 00A4         OCR1A=L2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x74
; 0000 00A5         }
; 0000 00A6     else
_0x20:
; 0000 00A7         {
; 0000 00A8         PORTD.2=1;
	SBI  0x12,2
; 0000 00A9         OCR1A=255 + L2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x74:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00AA         }
; 0000 00AB     ///////////////////R2
; 0000 00AC     if (R2>0)
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRGE _0x26
; 0000 00AD         {
; 0000 00AE         PORTD.1=0;
	CBI  0x12,1
; 0000 00AF         OCR1B=R2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x75
; 0000 00B0         }
; 0000 00B1     else
_0x26:
; 0000 00B2         {
; 0000 00B3         PORTD.1=1;
	SBI  0x12,1
; 0000 00B4         OCR1B=255+R2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x75:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00B5         }
; 0000 00B6     ///////////////////R1
; 0000 00B7     if (R1>0)
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRGE _0x2C
; 0000 00B8         {
; 0000 00B9         PORTD.0=0;
	CBI  0x12,0
; 0000 00BA         OCR0=R1;
	LD   R30,Y
	RJMP _0x76
; 0000 00BB         }
; 0000 00BC     else
_0x2C:
; 0000 00BD         {
; 0000 00BE         PORTD.0=1;
	SBI  0x12,0
; 0000 00BF         OCR0=255+R1;
	LD   R30,Y
	SUBI R30,-LOW(255)
_0x76:
	OUT  0x3C,R30
; 0000 00C0         }
; 0000 00C1     }
	JMP  _0x20C0004
; .FEND
;
;void move(int direction)
; 0000 00C4     {
_move:
; .FSTART _move
; 0000 00C5     if(direction == 0)      motor(speed   , speed   , -speed  , -speed   );
	ST   -Y,R27
	ST   -Y,R26
;	direction -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x32
	ST   -Y,R5
	ST   -Y,R4
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	MOVW R26,R30
	RCALL _motor
; 0000 00C6     if(direction == 1)      motor(speed   , speed/2 , -speed  , -speed/2 );
_0x32:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x33
	CALL SUBOPT_0x8
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
	MOVW R26,R30
	RCALL _motor
; 0000 00C7     if(direction == 2)      motor(speed   , 0       , -speed  , 0        );
_0x33:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 00C8     if(direction == 3)      motor(speed   , -speed/2, -speed  , speed/2  );
_0x34:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x35
	CALL SUBOPT_0x6
	CALL SUBOPT_0x9
	CALL SUBOPT_0x7
	CALL SUBOPT_0xC
	MOVW R26,R30
	RCALL _motor
; 0000 00C9     if(direction == 4)      motor(speed   , -speed  , -speed  , speed    );
_0x35:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0x36
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	CALL SUBOPT_0xD
; 0000 00CA     if(direction == 5)      motor(speed/2 , -speed  , -speed/2, speed    );
_0x36:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRNE _0x37
	CALL SUBOPT_0xE
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
	CALL SUBOPT_0xD
; 0000 00CB     if(direction == 6)      motor(0       , -speed  , 0       , speed    );
_0x37:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0x38
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x7
	CALL SUBOPT_0xF
	CALL SUBOPT_0xD
; 0000 00CC     if(direction == 7)      motor(-speed/2, -speed  , speed/2 , speed    );
_0x38:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x39
	CALL SUBOPT_0x10
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R23
	ST   -Y,R22
	CALL SUBOPT_0xE
	CALL SUBOPT_0xD
; 0000 00CD 
; 0000 00CE     if(direction == 8)      motor(-speed  , -speed  , speed   , speed    );
_0x39:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x3A
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	MOVW R26,R4
	RCALL _motor
; 0000 00CF 
; 0000 00D0     if(direction == 9)      motor(-speed   , -speed/2, speed   , speed/2 );
_0x3A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRNE _0x3B
	CALL SUBOPT_0x11
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	MOVW R26,R30
	RCALL _motor
; 0000 00D1     if(direction == 10)     motor(-speed   , 0       , speed   , 0       );
_0x3B:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRNE _0x3C
	MOVW R30,R4
	CALL __ANEGW1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x12
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _motor
; 0000 00D2     if(direction == 11)     motor(-speed   , speed/2 , speed   , -speed/2);
_0x3C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,11
	BRNE _0x3D
	CALL SUBOPT_0x10
	CALL SUBOPT_0xC
	CALL SUBOPT_0x12
	MOVW R26,R22
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R26,R30
	RCALL _motor
; 0000 00D3     if(direction == 12)     motor(-speed   , speed   , speed   , -speed  );
_0x3D:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,12
	BRNE _0x3E
	CALL SUBOPT_0x11
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R4
	MOVW R26,R30
	RCALL _motor
; 0000 00D4     if(direction == 13)     motor(-speed/2 , speed   , speed/2 , -speed  );
_0x3E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,13
	BRNE _0x3F
	CALL SUBOPT_0x10
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R22
	RCALL _motor
; 0000 00D5     if(direction == 14)     motor(0        , speed   , 0       , -speed  );
_0x3F:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,14
	BRNE _0x40
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
	MOVW R26,R30
	RCALL _motor
; 0000 00D6     if(direction == 15)     motor(speed/2  , speed   , -speed/2, -speed  );
_0x40:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,15
	BRNE _0x41
	CALL SUBOPT_0xE
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6
	CALL SUBOPT_0x9
	CALL SUBOPT_0x7
	MOVW R26,R30
	RCALL _motor
; 0000 00D7     }
_0x41:
_0x20C0007:
	ADIW R28,2
	RET
; .FEND
;
;void read_pixy()
; 0000 00DA     {
_read_pixy:
; .FSTART _read_pixy
; 0000 00DB     a=read();
	CALL SUBOPT_0x13
; 0000 00DC     if(a==0xaa)
	CPI  R26,LOW(0xAA)
	BREQ PC+2
	RJMP _0x42
; 0000 00DD       {
; 0000 00DE       a=read();
	CALL SUBOPT_0x13
; 0000 00DF       if(a==0x55)
	CPI  R26,LOW(0x55)
	BREQ PC+2
	RJMP _0x43
; 0000 00E0         {
; 0000 00E1         read();
	RCALL _read
; 0000 00E2         checksum = read();
	RCALL _read
	LDI  R31,0
	CALL SUBOPT_0x14
; 0000 00E3         checksum += read() * 255;
	LDI  R26,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	LDS  R26,_checksum
	LDS  R27,_checksum+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x14
; 0000 00E4         signature = read();
	LDI  R31,0
	CALL SUBOPT_0x15
; 0000 00E5         signature += read() * 255;
	LDI  R26,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	LDS  R26,_signature
	LDS  R27,_signature+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x15
; 0000 00E6         x = read();
	MOV  R12,R30
	CLR  R13
; 0000 00E7         x+=read()*255;
	CALL SUBOPT_0x16
	__ADDWRR 12,13,30,31
; 0000 00E8         y = read();
	RCALL _read
	LDI  R31,0
	STS  _y,R30
	STS  _y+1,R31
; 0000 00E9         y += read() * 255;
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	ADD  R30,R26
	ADC  R31,R27
	STS  _y,R30
	STS  _y+1,R31
; 0000 00EA         width = read();
	RCALL _read
	LDI  R31,0
	STS  _width,R30
	STS  _width+1,R31
; 0000 00EB         width += read() * 255;
	CALL SUBOPT_0x16
	LDS  R26,_width
	LDS  R27,_width+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _width,R30
	STS  _width+1,R31
; 0000 00EC         height = read();
	RCALL _read
	LDI  R31,0
	STS  _height,R30
	STS  _height+1,R31
; 0000 00ED         height += read() * 255;
	CALL SUBOPT_0x16
	LDS  R26,_height
	LDS  R27,_height+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _height,R30
	STS  _height+1,R31
; 0000 00EE         is_ball = true;
	LDI  R30,LOW(1)
	STS  _is_ball,R30
; 0000 00EF         }
; 0000 00F0       }
_0x43:
; 0000 00F1     if(a != 0) is_ball = true;
_0x42:
	LDS  R30,_a
	CPI  R30,0
	BREQ _0x44
	LDI  R30,LOW(1)
	RJMP _0x77
; 0000 00F2     else is_ball = false;
_0x44:
	LDI  R30,LOW(0)
_0x77:
	STS  _is_ball,R30
; 0000 00F3     ball_angle = atan2(y_robot - y, x_robot - x) * 180 / PI;
	CALL SUBOPT_0x17
	LDS  R30,_y_robot
	LDS  R31,_y_robot+1
	CALL SUBOPT_0x18
	LDS  R30,_x_robot
	LDS  R31,_x_robot+1
	SUB  R30,R12
	SBC  R31,R13
	CALL SUBOPT_0x19
	CALL _atan2
	__GETD2N 0x43340000
	CALL SUBOPT_0x1A
	__GETD1N 0x40490FDB
	CALL __DIVF21
	LDI  R26,LOW(_ball_angle)
	LDI  R27,HIGH(_ball_angle)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 00F4     if (ball_angle < 0) ball_angle += 360;
	LDS  R26,_ball_angle+1
	TST  R26
	BRPL _0x46
	CALL SUBOPT_0x1B
	SUBI R30,LOW(-360)
	SBCI R31,HIGH(-360)
	STS  _ball_angle,R30
	STS  _ball_angle+1,R31
; 0000 00F5     ball_angle = 360 - ball_angle;
_0x46:
	LDS  R26,_ball_angle
	LDS  R27,_ball_angle+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	SUB  R30,R26
	SBC  R31,R27
	STS  _ball_angle,R30
	STS  _ball_angle+1,R31
; 0000 00F6     for(i = 0; i < 16; i++)
	CLR  R6
	CLR  R7
_0x48:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R6,R30
	CPC  R7,R31
	BRLT PC+2
	RJMP _0x49
; 0000 00F7         {
; 0000 00F8         if(ball_angle <= 11.25) ball = 0;
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x4A
	LDI  R30,LOW(0)
	STS  _ball,R30
	STS  _ball+1,R30
; 0000 00F9         else if(ball_angle >= 348.5) ball = 0;
	RJMP _0x4B
_0x4A:
	CALL SUBOPT_0x1C
	__GETD1N 0x43AE4000
	CALL __CMPF12
	BRLO _0x4C
	STS  _ball,R30
	STS  _ball+1,R30
; 0000 00FA         else if((ball_angle - 11.25 >= i * 22.5) && (ball_angle-11.25 < (i+1) * 22.5))
	RJMP _0x4D
_0x4C:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1E
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R6
	CALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x4F
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1E
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R6
	ADIW R30,1
	CALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x50
_0x4F:
	RJMP _0x4E
_0x50:
; 0000 00FB             ball = i + 1;
	MOVW R30,R6
	ADIW R30,1
	STS  _ball,R30
	STS  _ball+1,R31
; 0000 00FC         }
_0x4E:
_0x4D:
_0x4B:
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x48
_0x49:
; 0000 00FD     ball_distance = sqrt(pow(x-(x_robot+35) , 2) + pow(y-y_robot, 2));
	LDS  R26,_x_robot
	LDS  R27,_x_robot+1
	ADIW R26,35
	MOVW R30,R12
	CALL SUBOPT_0x18
	CALL SUBOPT_0x20
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_y_robot
	LDS  R27,_y_robot+1
	LDS  R30,_y
	LDS  R31,_y+1
	CALL SUBOPT_0x18
	CALL SUBOPT_0x20
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _sqrt
	LDI  R26,LOW(_ball_distance)
	LDI  R27,HIGH(_ball_distance)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 00FE 
; 0000 00FF //    if(ball_angle>=0)
; 0000 0100 //        {
; 0000 0101 //        lcd_gotoxy(0,0);
; 0000 0102 //        lcd_putchar('+');
; 0000 0103 //        lcd_putchar((ball_angle/100)%10+'0');
; 0000 0104 //        lcd_putchar((ball_angle/10)%10+'0');
; 0000 0105 //        lcd_putchar((ball_angle/1)%10+'0');
; 0000 0106 //        }
; 0000 0107 //    else
; 0000 0108 //        {
; 0000 0109 //        lcd_gotoxy(0,0);
; 0000 010A //        lcd_putchar('-');
; 0000 010B //        lcd_putchar((-ball_angle/100)%10+'0');
; 0000 010C //        lcd_putchar((-ball_angle/10)%10+'0');
; 0000 010D //        lcd_putchar((-ball_angle/1)%10+'0');
; 0000 010E //        }
; 0000 010F     lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0110     lcd_putchar((ball/10)%10+'0');
	CALL SUBOPT_0x21
	CALL SUBOPT_0x3
; 0000 0111     lcd_putchar((ball/1)%10+'0');
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 0112 
; 0000 0113     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0114     lcd_putchar((ball_distance/100)%10+'0');
	CALL SUBOPT_0x23
	CALL SUBOPT_0x2
; 0000 0115     lcd_putchar((ball_distance/10)%10+'0');
	CALL SUBOPT_0x23
	CALL SUBOPT_0x3
; 0000 0116     lcd_putchar((ball_distance/1)%10+'0');
	CALL SUBOPT_0x23
	CALL SUBOPT_0x22
; 0000 0117 
; 0000 0118     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
; 0000 0119     lcd_putsf("X=");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 011A     lcd_putchar((x/100)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x2
; 0000 011B     lcd_putchar((x/10)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x3
; 0000 011C     lcd_putchar((x/1)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x22
; 0000 011D 
; 0000 011E     lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x1
; 0000 011F     lcd_putsf("Y=");
	__POINTW2FN _0x0,3
	CALL _lcd_putsf
; 0000 0120     lcd_putchar((y/100)%10+'0');
	CALL SUBOPT_0x17
	CALL SUBOPT_0x2
; 0000 0121     lcd_putchar((y/10)%10+'0');
	CALL SUBOPT_0x17
	CALL SUBOPT_0x3
; 0000 0122     lcd_putchar((y/1)%10+'0');
	CALL SUBOPT_0x17
	CALL SUBOPT_0x22
; 0000 0123     }
	RET
; .FEND
;
;
;void main(void)
; 0000 0127 {
_main:
; .FSTART _main
; 0000 0128 // Declare your local variables here
; 0000 0129 
; 0000 012A // Input/Output Ports initialization
; 0000 012B // Port A initialization
; 0000 012C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 012D DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 012E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 012F PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0130 
; 0000 0131 // Port B initialization
; 0000 0132 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0133 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 0134 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 0135 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0136 
; 0000 0137 // Port C initialization
; 0000 0138 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0139 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 013A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 013B PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 013C 
; 0000 013D // Port D initialization
; 0000 013E // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 013F DDRD=(1<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(191)
	OUT  0x11,R30
; 0000 0140 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0141 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0142 
; 0000 0143 // Timer/Counter 0 initialization
; 0000 0144 // Clock source: System Clock
; 0000 0145 // Clock value: 125.000 kHz
; 0000 0146 // Mode: Fast PWM top=0xFF
; 0000 0147 // OC0 output: Non-Inverted PWM
; 0000 0148 // Timer Period: 2.048 ms
; 0000 0149 // Output Pulse(s):
; 0000 014A // OC0 Period: 2.048 ms Width: 0 us
; 0000 014B TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 014C TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 014D OCR0=0x00;
	OUT  0x3C,R30
; 0000 014E 
; 0000 014F // Timer/Counter 1 initialization
; 0000 0150 // Clock source: System Clock
; 0000 0151 // Clock value: 125.000 kHz
; 0000 0152 // Mode: Fast PWM top=0x00FF
; 0000 0153 // OC1A output: Non-Inverted PWM
; 0000 0154 // OC1B output: Non-Inverted PWM
; 0000 0155 // Noise Canceler: Off
; 0000 0156 // Input Capture on Falling Edge
; 0000 0157 // Timer Period: 2.048 ms
; 0000 0158 // Output Pulse(s):
; 0000 0159 // OC1A Period: 2.048 ms Width: 0 us// OC1B Period: 2.048 ms Width: 0 us
; 0000 015A // Timer1 Overflow Interrupt: Off
; 0000 015B // Input Capture Interrupt: Off
; 0000 015C // Compare A Match Interrupt: Off
; 0000 015D // Compare B Match Interrupt: Off
; 0000 015E TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 015F TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 0160 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0161 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0162 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0163 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0164 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0165 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0166 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0167 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0168 
; 0000 0169 // Timer/Counter 2 initialization
; 0000 016A // Clock source: System Clock
; 0000 016B // Clock value: 125.000 kHz
; 0000 016C // Mode: Fast PWM top=0xFF
; 0000 016D // OC2 output: Non-Inverted PWM
; 0000 016E // Timer Period: 2.048 ms
; 0000 016F // Output Pulse(s):
; 0000 0170 // OC2 Period: 2.048 ms Width: 0 us
; 0000 0171 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0172 TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 0173 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0174 OCR2=0x00;
	OUT  0x23,R30
; 0000 0175 
; 0000 0176 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0177 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0178 
; 0000 0179 // External Interrupt(s) initialization
; 0000 017A // INT0: Off
; 0000 017B // INT1: Off
; 0000 017C // INT2: Off
; 0000 017D MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 017E MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 017F 
; 0000 0180 // USART initialization
; 0000 0181 // USART disabled
; 0000 0182 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0183 
; 0000 0184 // Analog Comparator initialization
; 0000 0185 // Analog Comparator: Off
; 0000 0186 // The Analog Comparator's positive input is
; 0000 0187 // connected to the AIN0 pin
; 0000 0188 // The Analog Comparator's negative input is
; 0000 0189 // connected to the AIN1 pin
; 0000 018A ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 018B 
; 0000 018C // ADC initialization
; 0000 018D // ADC Clock frequency: 62.500 kHz
; 0000 018E // ADC Voltage Reference: AVCC pin
; 0000 018F // ADC Auto Trigger Source: ADC Stopped
; 0000 0190 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0191 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0192 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0193 
; 0000 0194 // SPI initialization
; 0000 0195 // SPI disabled
; 0000 0196 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0197 
; 0000 0198 // TWI initialization
; 0000 0199 // TWI disabled
; 0000 019A TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 019B 
; 0000 019C // Bit-Banged I2C Bus initialization
; 0000 019D // I2C Port: PORTB
; 0000 019E // I2C SDA bit: 1
; 0000 019F // I2C SCL bit: 0
; 0000 01A0 // Bit Rate: 100 kHz
; 0000 01A1 // Note: I2C settings are specified in the
; 0000 01A2 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 01A3 i2c_init();
	CALL _i2c_init
; 0000 01A4 
; 0000 01A5 // Alphanumeric LCD initialization
; 0000 01A6 // Connections are specified in the
; 0000 01A7 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 01A8 // RS - PORTC Bit 0
; 0000 01A9 // RD - PORTC Bit 1
; 0000 01AA // EN - PORTC Bit 2
; 0000 01AB // D4 - PORTC Bit 4
; 0000 01AC // D5 - PORTC Bit 5
; 0000 01AD // D6 - PORTC Bit 6
; 0000 01AE // D7 - PORTC Bit 7
; 0000 01AF // Characters/line: 16
; 0000 01B0 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 01B1 
; 0000 01B2 speed = 255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R4,R30
; 0000 01B3 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 01B4 c = compass_read(1);
	LDI  R26,LOW(1)
	RCALL _compass_read
	MOV  R10,R30
	CLR  R11
; 0000 01B5 while (1)
_0x51:
; 0000 01B6     {
; 0000 01B7     readcmp();
	RCALL _readcmp
; 0000 01B8     read_pixy();
	RCALL _read_pixy
; 0000 01B9     if(is_ball)
	LDS  R30,_is_ball
	CPI  R30,0
	BRNE PC+2
	RJMP _0x54
; 0000 01BA         {
; 0000 01BB         if(ball_distance < 70)
	CALL SUBOPT_0x23
	CPI  R26,LOW(0x46)
	LDI  R30,HIGH(0x46)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0x55
; 0000 01BC             {
; 0000 01BD             if(ball == 0)       move(ball);
	LDS  R30,_ball
	LDS  R31,_ball+1
	SBIW R30,0
	BRNE _0x56
	CALL SUBOPT_0x21
	RJMP _0x78
; 0000 01BE             else if(ball == 1)  move(ball);
_0x56:
	CALL SUBOPT_0x21
	SBIW R26,1
	BRNE _0x58
	CALL SUBOPT_0x21
	RJMP _0x78
; 0000 01BF             else if(ball == 15) move(ball);
_0x58:
	CALL SUBOPT_0x21
	SBIW R26,15
	BRNE _0x5A
	CALL SUBOPT_0x21
	RJMP _0x78
; 0000 01C0             else if(ball == 2)  move(3);
_0x5A:
	CALL SUBOPT_0x21
	SBIW R26,2
	BRNE _0x5C
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _0x78
; 0000 01C1             else if(ball == 14) move(13);
_0x5C:
	CALL SUBOPT_0x21
	SBIW R26,14
	BRNE _0x5E
	LDI  R26,LOW(13)
	LDI  R27,0
	RJMP _0x78
; 0000 01C2 
; 0000 01C3             else if(ball>2 && ball<=6)    move(ball + 2);
_0x5E:
	CALL SUBOPT_0x21
	SBIW R26,3
	BRLT _0x61
	CALL SUBOPT_0x21
	SBIW R26,7
	BRLT _0x62
_0x61:
	RJMP _0x60
_0x62:
	CALL SUBOPT_0x21
	ADIW R26,2
	RJMP _0x78
; 0000 01C4             else if(ball>=10 && ball<14)  move(ball - 2);
_0x60:
	CALL SUBOPT_0x21
	SBIW R26,10
	BRLT _0x65
	CALL SUBOPT_0x21
	SBIW R26,14
	BRLT _0x66
_0x65:
	RJMP _0x64
_0x66:
	RJMP _0x79
; 0000 01C5 
; 0000 01C6             else if(ball>6 && ball<=8)    move(ball + 2);
_0x64:
	CALL SUBOPT_0x21
	SBIW R26,7
	BRLT _0x69
	CALL SUBOPT_0x21
	SBIW R26,9
	BRLT _0x6A
_0x69:
	RJMP _0x68
_0x6A:
	CALL SUBOPT_0x21
	ADIW R26,2
	RJMP _0x78
; 0000 01C7             else if(ball>8 && ball<10)    move(ball - 2);
_0x68:
	CALL SUBOPT_0x21
	SBIW R26,9
	BRLT _0x6D
	CALL SUBOPT_0x21
	SBIW R26,10
	BRLT _0x6E
_0x6D:
	RJMP _0x6C
_0x6E:
_0x79:
	LDS  R26,_ball
	LDS  R27,_ball+1
	SBIW R26,2
_0x78:
	RCALL _move
; 0000 01C8             }
_0x6C:
; 0000 01C9         else
	RJMP _0x6F
_0x55:
; 0000 01CA             {
; 0000 01CB             move(ball);
	CALL SUBOPT_0x21
	RCALL _move
; 0000 01CC //            if(ball == 0)       move(ball);
; 0000 01CD //            else if(ball == 1)  move(ball);
; 0000 01CE //            else if(ball == 15) move(ball);
; 0000 01CF //            else if(ball == 2)  move(ball);
; 0000 01D0 //            else if(ball == 14) move(ball);
; 0000 01D1 //
; 0000 01D2 //
; 0000 01D3 //            else if(ball>2 && ball<=6)    move(ball + 1);
; 0000 01D4 //            else if(ball>=10 && ball<14)  move(ball - 1);
; 0000 01D5 //
; 0000 01D6 //            else if(ball>6 && ball<=8)    move(ball + 2);
; 0000 01D7 //            else if(ball>8 && ball<10)    move(ball - 2);
; 0000 01D8             }
_0x6F:
; 0000 01D9         }
; 0000 01DA     else motor(0,0,0,0);
	RJMP _0x70
_0x54:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	CALL SUBOPT_0xB
; 0000 01DB     }
_0x70:
	RJMP _0x51
; 0000 01DC }
_0x71:
	RJMP _0x71
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL SUBOPT_0x24
	CALL _ftrunc
	CALL SUBOPT_0x25
    brne __floor1
__floor0:
	CALL SUBOPT_0x26
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x27
	CALL __SUBF12
	RJMP _0x20C0003
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x28
	CALL __CPD02
	BRLT _0x200000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0006
_0x200000C:
	CALL SUBOPT_0x29
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x28
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x200000D
	CALL SUBOPT_0x2B
	CALL __ADDF12
	CALL SUBOPT_0x2A
	__SUBWRN 16,17,1
_0x200000D:
	CALL SUBOPT_0x2C
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2C
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	__GETD2N 0x3F654226
	CALL SUBOPT_0x1A
	__GETD1N 0x4054114E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x28
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2F
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x20C0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
; .FEND
_exp:
; .FSTART _exp
	CALL __PUTPARD2
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x30
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x200000F
	CALL SUBOPT_0x31
	RJMP _0x20C0005
_0x200000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2000010
	__GETD1N 0x3F800000
	RJMP _0x20C0005
_0x2000010:
	CALL SUBOPT_0x30
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0005
_0x2000011:
	CALL SUBOPT_0x30
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL SUBOPT_0x30
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x30
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x2E
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x28
	CALL __MULF12
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2F
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x29
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2F
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x20C0005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x32
	CALL __CPD10
	BRNE _0x2000012
	CALL SUBOPT_0x31
	RJMP _0x20C0002
_0x2000012:
	CALL SUBOPT_0x33
	CALL __CPD02
	BRGE _0x2000013
	CALL SUBOPT_0x34
	CALL __CPD10
	BRNE _0x2000014
	__GETD1N 0x3F800000
	RJMP _0x20C0002
_0x2000014:
	CALL SUBOPT_0x33
	CALL SUBOPT_0x35
	RCALL _exp
	RJMP _0x20C0002
_0x2000013:
	CALL SUBOPT_0x34
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x26
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x34
	CALL __CPD12
	BREQ _0x2000015
	CALL SUBOPT_0x31
	RJMP _0x20C0002
_0x2000015:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2000016
	CALL SUBOPT_0x32
	RJMP _0x20C0002
_0x2000016:
	CALL SUBOPT_0x32
	CALL __ANEGF1
	RJMP _0x20C0002
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x34
	CALL SUBOPT_0x37
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x26
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x39
	CALL SUBOPT_0x38
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
_0x20C0004:
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	CALL SUBOPT_0x24
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2000020
	CALL SUBOPT_0x39
	RCALL _xatan
	RJMP _0x20C0003
_0x2000020:
	CALL SUBOPT_0x39
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	CALL SUBOPT_0x27
	CALL SUBOPT_0x3A
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x2E
	RJMP _0x20C0003
_0x2000021:
	CALL SUBOPT_0x27
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x27
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3A
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x20C0003:
	ADIW R28,4
	RET
; .FEND
_atan2:
; .FSTART _atan2
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x34
	CALL __CPD10
	BRNE _0x200002D
	CALL SUBOPT_0x32
	CALL __CPD10
	BRNE _0x200002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0002
_0x200002E:
	CALL SUBOPT_0x33
	CALL __CPD02
	BRGE _0x200002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0002
_0x200002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0002
_0x200002D:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x33
	CALL __DIVF21
	CALL SUBOPT_0x25
	__GETD2S 4
	CALL __CPD02
	BRGE _0x2000030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000031
	CALL SUBOPT_0x39
	RCALL _yatan
	RJMP _0x20C0002
_0x2000031:
	CALL SUBOPT_0x26
	CALL SUBOPT_0x36
	RCALL _yatan
	CALL __ANEGF1
	RJMP _0x20C0002
_0x2000030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000032
	CALL SUBOPT_0x26
	CALL SUBOPT_0x36
	RCALL _yatan
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x2E
	RJMP _0x20C0002
_0x2000032:
	CALL SUBOPT_0x39
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20C0002:
	ADIW R28,12
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
_twi_int_handler:
; .FSTART _twi_int_handler
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	CALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G101
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G101
	LDS  R27,_twi_rx_buffer_G101+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x2020017
	LDI  R18,LOW(0)
	RJMP _0x2020018
_0x2020017:
	CPI  R30,LOW(0x10)
	BRNE _0x2020019
_0x2020018:
	LDS  R30,_slave_address_G101
	RJMP _0x2020067
_0x2020019:
	CPI  R30,LOW(0x18)
	BREQ _0x202001D
	CPI  R30,LOW(0x28)
	BRNE _0x202001E
_0x202001D:
	CP   R16,R19
	BRSH _0x202001F
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G101
	LDS  R27,_twi_tx_buffer_G101+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2020067:
	OUT  0x3,R30
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	OUT  0x36,R30
	RJMP _0x2020020
_0x202001F:
	LDS  R30,_bytes_to_rx_G101
	CP   R17,R30
	BRSH _0x2020021
	LDS  R30,_slave_address_G101
	ORI  R30,1
	STS  _slave_address_G101,R30
	CLT
	BLD  R2,0
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	OUT  0x36,R30
	RJMP _0x2020016
_0x2020021:
	RJMP _0x2020022
_0x2020020:
	RJMP _0x2020016
_0x202001E:
	CPI  R30,LOW(0x50)
	BRNE _0x2020023
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2020024
_0x2020023:
	CPI  R30,LOW(0x40)
	BRNE _0x2020025
_0x2020024:
	LDS  R30,_bytes_to_rx_G101
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x2020026
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2020068
_0x2020026:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2020068:
	OUT  0x36,R30
	RJMP _0x2020016
_0x2020025:
	CPI  R30,LOW(0x58)
	BRNE _0x2020028
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2020029
_0x2020028:
	CPI  R30,LOW(0x20)
	BRNE _0x202002A
_0x2020029:
	RJMP _0x202002B
_0x202002A:
	CPI  R30,LOW(0x30)
	BRNE _0x202002C
_0x202002B:
	RJMP _0x202002D
_0x202002C:
	CPI  R30,LOW(0x48)
	BRNE _0x202002E
_0x202002D:
	CPI  R18,0
	BRNE _0x202002F
	SBRS R2,0
	RJMP _0x2020030
	CP   R16,R19
	BRLO _0x2020032
	RJMP _0x2020033
_0x2020030:
	LDS  R30,_bytes_to_rx_G101
	CP   R17,R30
	BRSH _0x2020034
_0x2020032:
	LDI  R18,LOW(4)
_0x2020034:
_0x2020033:
_0x202002F:
_0x2020022:
	RJMP _0x2020069
_0x202002E:
	CPI  R30,LOW(0x38)
	BRNE _0x2020037
	LDI  R18,LOW(2)
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x202006A
_0x2020037:
	CPI  R30,LOW(0x68)
	BREQ _0x202003A
	CPI  R30,LOW(0x78)
	BRNE _0x202003B
_0x202003A:
	LDI  R18,LOW(2)
	RJMP _0x202003C
_0x202003B:
	CPI  R30,LOW(0x60)
	BREQ _0x202003F
	CPI  R30,LOW(0x70)
	BRNE _0x2020040
_0x202003F:
	LDI  R18,LOW(0)
_0x202003C:
	LDI  R17,LOW(0)
	CLT
	BLD  R2,0
	LDS  R30,_twi_rx_buffer_size_G101
	CPI  R30,0
	BRNE _0x2020041
	LDI  R18,LOW(1)
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x202006B
_0x2020041:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x202006B:
	OUT  0x36,R30
	RJMP _0x2020016
_0x2020040:
	CPI  R30,LOW(0x80)
	BREQ _0x2020044
	CPI  R30,LOW(0x90)
	BRNE _0x2020045
_0x2020044:
	SBRS R2,0
	RJMP _0x2020046
	LDI  R18,LOW(1)
	RJMP _0x2020047
_0x2020046:
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G101
	CP   R17,R30
	BRSH _0x2020048
	LDS  R30,_twi_slave_rx_handler_G101
	LDS  R31,_twi_slave_rx_handler_G101+1
	SBIW R30,0
	BRNE _0x2020049
	LDI  R18,LOW(6)
	RJMP _0x2020047
_0x2020049:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G101,0
	CPI  R30,0
	BREQ _0x202004A
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	RJMP _0x2020016
_0x202004A:
	RJMP _0x202004B
_0x2020048:
	SET
	BLD  R2,0
_0x202004B:
	RJMP _0x202004C
_0x2020045:
	CPI  R30,LOW(0x88)
	BRNE _0x202004D
_0x202004C:
	RJMP _0x202004E
_0x202004D:
	CPI  R30,LOW(0x98)
	BRNE _0x202004F
_0x202004E:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	OUT  0x36,R30
	RJMP _0x2020016
_0x202004F:
	CPI  R30,LOW(0xA0)
	BRNE _0x2020050
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	SET
	BLD  R2,1
	LDS  R30,_twi_slave_rx_handler_G101
	LDS  R31,_twi_slave_rx_handler_G101+1
	SBIW R30,0
	BREQ _0x2020051
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G101,0
	RJMP _0x2020052
_0x2020051:
	LDI  R18,LOW(6)
_0x2020052:
	RJMP _0x2020016
_0x2020050:
	CPI  R30,LOW(0xB0)
	BRNE _0x2020053
	LDI  R18,LOW(2)
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0xA8)
	BRNE _0x2020055
_0x2020054:
	LDS  R30,_twi_slave_tx_handler_G101
	LDS  R31,_twi_slave_tx_handler_G101+1
	SBIW R30,0
	BREQ _0x2020056
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G101,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2020058
	LDI  R18,LOW(0)
	RJMP _0x2020059
_0x2020056:
_0x2020058:
	LDI  R18,LOW(6)
	RJMP _0x2020047
_0x2020059:
	LDI  R16,LOW(0)
	CLT
	BLD  R2,0
	RJMP _0x202005A
_0x2020055:
	CPI  R30,LOW(0xB8)
	BRNE _0x202005B
_0x202005A:
	SBRS R2,0
	RJMP _0x202005C
	LDI  R18,LOW(1)
	RJMP _0x2020047
_0x202005C:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G101
	LDS  R27,_twi_tx_buffer_G101+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x3,R30
	CP   R16,R19
	BRSH _0x202005D
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x202006C
_0x202005D:
	SET
	BLD  R2,0
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x202006C:
	OUT  0x36,R30
	RJMP _0x2020016
_0x202005B:
	CPI  R30,LOW(0xC0)
	BREQ _0x2020060
	CPI  R30,LOW(0xC8)
	BRNE _0x2020061
_0x2020060:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	LDS  R30,_twi_slave_tx_handler_G101
	LDS  R31,_twi_slave_tx_handler_G101+1
	SBIW R30,0
	BREQ _0x2020062
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G101,0
_0x2020062:
	RJMP _0x2020035
_0x2020061:
	CPI  R30,0
	BRNE _0x2020016
	LDI  R18,LOW(3)
_0x2020047:
_0x2020069:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x202006A:
	OUT  0x36,R30
_0x2020035:
	SET
	BLD  R2,1
_0x2020016:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G101,R19
	CALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
; .FSTART __lcd_write_nibble_G102
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x20C0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x3B
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x3B
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040004
_0x2040005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040007
	RJMP _0x20C0001
_0x2040007:
_0x2040004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20C0001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x204000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x204000B
_0x204000D:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3C
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
_y:
	.BYTE 0x2
_width:
	.BYTE 0x2
_height:
	.BYTE 0x2
_checksum:
	.BYTE 0x2
_signature:
	.BYTE 0x2
_a:
	.BYTE 0x1
_x_robot:
	.BYTE 0x2
_y_robot:
	.BYTE 0x2
_ball_angle:
	.BYTE 0x2
_ball:
	.BYTE 0x2
_ball_distance:
	.BYTE 0x2
_is_ball:
	.BYTE 0x1
_address:
	.BYTE 0x2
_slave_address_G101:
	.BYTE 0x1
_twi_tx_buffer_G101:
	.BYTE 0x2
_bytes_to_tx_G101:
	.BYTE 0x1
_twi_rx_buffer_G101:
	.BYTE 0x2
_bytes_to_rx_G101:
	.BYTE 0x1
_twi_rx_buffer_size_G101:
	.BYTE 0x1
_twi_slave_rx_handler_G101:
	.BYTE 0x2
_twi_slave_tx_handler_G101:
	.BYTE 0x2
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	CALL _i2c_write
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R17,R30
	CALL _i2c_stop
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOVW R30,R8
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	ST   -Y,R5
	ST   -Y,R4
	MOVW R30,R4
	CALL __ANEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL __ANEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	ST   -Y,R5
	ST   -Y,R4
	MOVW R26,R4
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9:
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	ST   -Y,R5
	ST   -Y,R4
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R4
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R4
	JMP  _motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	MOVW R26,R4
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOVW R30,R4
	CALL __ANEGW1
	MOVW R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	MOVW R30,R4
	CALL __ANEGW1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R5
	ST   -Y,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	CALL _read
	STS  _a,R30
	LDS  R26,_a
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	STS  _checksum,R30
	STS  _checksum+1,R31
	JMP  _read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	STS  _signature,R30
	STS  _signature+1,R31
	JMP  _read

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	CALL _read
	LDI  R26,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDS  R26,_y
	LDS  R27,_y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDS  R30,_ball_angle
	LDS  R31,_ball_angle+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x1B
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETD1N 0x41340000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x1D
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x41B40000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__GETD2N 0x40000000
	JMP  _pow

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x21:
	LDS  R26,_ball
	LDS  R27,_ball+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDS  R26,_ball_distance
	LDS  R27,_ball_distance+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x26:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x26
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x28:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x29:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	RCALL SUBOPT_0x29
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0x29
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	CALL _log
	__GETD2S 4
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	__GETD2S 4
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3C:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x18 ;PORTB
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

_sqrt:
	rcall __PUTPARD2
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
