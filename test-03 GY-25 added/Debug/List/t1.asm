
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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _speed=R8
	.DEF _speed_msb=R9
	.DEF _i=R10
	.DEF _i_msb=R11
	.DEF _cmp=R12
	.DEF _cmp_msb=R13
	.DEF _a=R6

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
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0xFF,0x0

_0xD:
	.DB  0x96
_0xE:
	.DB  0x64
_0xF:
	.DB  0x54
_0x2020003:
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

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _x_robot
	.DW  _0xD*2

	.DW  0x01
	.DW  _y_robot
	.DW  _0xE*2

	.DW  0x01
	.DW  _address
	.DW  _0xF*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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
;Date    : 11/13/2019
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
;
;#include <delay.h>
;#include <math.h>
;
;// I2C Bus functions
;#include <i2c.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0040 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041 char status,data;
; 0000 0042 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0043 data=UDR;
	IN   R16,12
; 0000 0044 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0045    {
; 0000 0046    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0047 #if RX_BUFFER_SIZE == 256
; 0000 0048    // special case for receiver buffer size=256
; 0000 0049    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 004A #else
; 0000 004B    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 004C    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 004D       {
; 0000 004E       rx_counter=0;
	CLR  R7
; 0000 004F       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0050       }
; 0000 0051 #endif
; 0000 0052    }
_0x5:
; 0000 0053 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 005A {
_getchar:
; .FSTART _getchar
; 0000 005B char data;
; 0000 005C while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 005D data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 005E #if RX_BUFFER_SIZE != 256
; 0000 005F if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 0060 #endif
; 0000 0061 #asm("cli")
_0x9:
	cli
; 0000 0062 --rx_counter;
	DEC  R7
; 0000 0063 #asm("sei")
	sei
; 0000 0064 return data;
	RJMP _0x20C0007
; 0000 0065 }
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0071 {
_read_adc:
; .FSTART _read_adc
; 0000 0072 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0073 // Delay needed for the stabilization of the ADC input voltage
; 0000 0074 delay_us(10);
	__DELAY_USB 27
; 0000 0075 // Start the AD conversion
; 0000 0076 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0077 // Wait for the AD conversion to complete
; 0000 0078 while ((ADCSRA & (1<<ADIF))==0);
_0xA:
	SBIS 0x6,4
	RJMP _0xA
; 0000 0079 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 007A return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 007B }
; .FEND
;
;
;///////////////////////////////////////////////////////////////////vars
;int speed = 255;
;int i;
;int cmp,c=0;
;int x, y,width,height,checksum, signature;
;char a,b;
;int x_robot = 150, y_robot = 100, ball_angle, ball, ball_distance;

	.DSEG
;int x_goal, y_goal, goal_angle, goal_distance, goal,is_goal = 0,cnt=0,cmp_balance = 0;
;
;int kick_sen;
;int is_ball = 0;
;
;//////////////////////////////////////////////////////////////////////////////////PIXY-CMUCAM5
;#define I2C_7BIT_DEVICE_ADDRESS 0x54
;#define EEPROM_BUS_ADDRESS (I2C_7BIT_DEVICE_ADDRESS << 1)
;
;unsigned int  address=0x54;
;unsigned char read()
; 0000 0090 {

	.CSEG
_read:
; .FSTART _read
; 0000 0091 unsigned char data;
; 0000 0092 i2c_start();
	ST   -Y,R17
;	data -> R17
	CALL _i2c_start
; 0000 0093 i2c_write(EEPROM_BUS_ADDRESS | 0);
	LDI  R26,LOW(168)
	CALL _i2c_write
; 0000 0094 i2c_write(address >> 8);
	LDS  R30,_address+1
	MOV  R26,R30
	CALL _i2c_write
; 0000 0095 i2c_write((unsigned char) address);
	LDS  R26,_address
	CALL _i2c_write
; 0000 0096 i2c_start();
	CALL _i2c_start
; 0000 0097 i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R26,LOW(169)
	CALL _i2c_write
; 0000 0098 data=i2c_read(0);
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R17,R30
; 0000 0099 i2c_stop();
	CALL _i2c_stop
; 0000 009A return data;
_0x20C0007:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 009B }
; .FEND
;//////////////////////////////////////////////////////////////////////////////////CMP-READ
;#define EEPROM_BUS_ADDRES 0xc0
;/* read/ a byte from the EEPROM */
;unsigned char compass_read(unsigned char addres)
; 0000 00A0     {
; 0000 00A1     unsigned char data;
; 0000 00A2     i2c_start();
;	addres -> Y+1
;	data -> R17
; 0000 00A3     i2c_write(EEPROM_BUS_ADDRES);
; 0000 00A4     i2c_write(addres);
; 0000 00A5     i2c_start();
; 0000 00A6     i2c_write(EEPROM_BUS_ADDRES | 1);
; 0000 00A7     data=i2c_read(0);
; 0000 00A8     i2c_stop();
; 0000 00A9     return data;
; 0000 00AA     }
;
;void print(int var)
; 0000 00AD     {
_print:
; .FSTART _print
; 0000 00AE     if(var>=0)
	ST   -Y,R27
	ST   -Y,R26
;	var -> Y+0
	LDD  R26,Y+1
	TST  R26
	BRMI _0x10
; 0000 00AF         {
; 0000 00B0         lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL SUBOPT_0x0
; 0000 00B1         lcd_putchar((var/100)%10+'0');
	CALL SUBOPT_0x1
	CALL SUBOPT_0x0
; 0000 00B2         lcd_putchar((var/10)%10+'0');
	CALL SUBOPT_0x2
	CALL SUBOPT_0x0
; 0000 00B3         lcd_putchar((var/1)%10+'0');
	RJMP _0xAF
; 0000 00B4         }
; 0000 00B5     else
_0x10:
; 0000 00B6         {
; 0000 00B7         lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL SUBOPT_0x3
; 0000 00B8         lcd_putchar((-var/100)%10+'0');
	CALL SUBOPT_0x1
	CALL SUBOPT_0x3
; 0000 00B9         lcd_putchar((-var/10)%10+'0');
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 00BA         lcd_putchar((-var/1)%10+'0');
_0xAF:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x4
; 0000 00BB         }
; 0000 00BC     }
	ADIW R28,2
	RET
; .FEND
;
;void motor(int mr1,int mr2,int ml2,int ml1)
; 0000 00BF     {
_motor:
; .FSTART _motor
; 0000 00C0     mr1 += cmp;
	ST   -Y,R27
	ST   -Y,R26
;	mr1 -> Y+6
;	mr2 -> Y+4
;	ml2 -> Y+2
;	ml1 -> Y+0
	MOVW R30,R12
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00C1     mr2 += cmp;
	MOVW R30,R12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00C2     ml1 += cmp;
	MOVW R30,R12
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 00C3     ml2 += cmp;
	MOVW R30,R12
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00C4 
; 0000 00C5     if(ml1>255) ml1=255;
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x12
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00C6     if(ml2>255) ml2=255;
_0x12:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x13
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00C7     if(mr2>255) mr2=255;
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
; 0000 00C8     if(mr1>255) mr1=255;
_0x14:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x15
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00C9 
; 0000 00CA     if(ml1<-255) ml1=-255;
_0x15:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x16
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00CB     if(ml2<-255) ml2=-255;
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
; 0000 00CC     if(mr2<-255) mr2=-255;
_0x17:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x18
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00CD     if(mr1<-255) mr1=-255;
_0x18:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x19
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00CE 
; 0000 00CF     //////////////mr1
; 0000 00D0     {
_0x19:
; 0000 00D1     if(mr1>=0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x1A
; 0000 00D2         {
; 0000 00D3         PORTB.2=0;
	CBI  0x18,2
; 0000 00D4         OCR0=mr1;
	LDD  R30,Y+6
	RJMP _0xB0
; 0000 00D5         }
; 0000 00D6     else
_0x1A:
; 0000 00D7         {
; 0000 00D8         PORTB.2=1;
	SBI  0x18,2
; 0000 00D9         OCR0=mr1+255;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
_0xB0:
	OUT  0x3C,R30
; 0000 00DA         }
; 0000 00DB         }
; 0000 00DC     //////////////mr2
; 0000 00DD     {
; 0000 00DE     if(mr2>=0)
	LDD  R26,Y+5
	TST  R26
	BRMI _0x20
; 0000 00DF         {
; 0000 00E0         PORTD.2=0;
	CBI  0x12,2
; 0000 00E1         OCR1B=mr2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0xB1
; 0000 00E2         }
; 0000 00E3     else
_0x20:
; 0000 00E4         {
; 0000 00E5         PORTD.2=1;
	SBI  0x12,2
; 0000 00E6         OCR1B=mr2+255;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0xB1:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00E7         }
; 0000 00E8         }
; 0000 00E9     //////////////mL2
; 0000 00EA     {
; 0000 00EB     if(ml2>=0)
	LDD  R26,Y+3
	TST  R26
	BRMI _0x26
; 0000 00EC         {
; 0000 00ED         PORTD.3=0;
	CBI  0x12,3
; 0000 00EE         OCR1A=ml2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0xB2
; 0000 00EF         }
; 0000 00F0     else
_0x26:
; 0000 00F1         {
; 0000 00F2         PORTD.3=1;
	SBI  0x12,3
; 0000 00F3         OCR1A=ml2+255;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0xB2:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00F4         }
; 0000 00F5         }
; 0000 00F6     //////////////ml1
; 0000 00F7     {
; 0000 00F8     if(ml1>=0)
	LDD  R26,Y+1
	TST  R26
	BRMI _0x2C
; 0000 00F9         {
; 0000 00FA         PORTD.6=0;
	CBI  0x12,6
; 0000 00FB         OCR2=ml1;
	LD   R30,Y
	RJMP _0xB3
; 0000 00FC         }
; 0000 00FD     else
_0x2C:
; 0000 00FE         {
; 0000 00FF         PORTD.6=1;
	SBI  0x12,6
; 0000 0100         OCR2=ml1+255;
	LD   R30,Y
	SUBI R30,-LOW(255)
_0xB3:
	OUT  0x23,R30
; 0000 0101         }
; 0000 0102     }
; 0000 0103 
; 0000 0104     }
	ADIW R28,8
	RET
; .FEND
;
;void read_pixy()
; 0000 0107     {
_read_pixy:
; .FSTART _read_pixy
; 0000 0108     a=read();
	RCALL _read
	MOV  R6,R30
; 0000 0109     if(a==0xaa)
	LDI  R30,LOW(170)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x32
; 0000 010A       {
; 0000 010B       a=read();
	RCALL _read
	MOV  R6,R30
; 0000 010C       if(a==0x55)
	LDI  R30,LOW(85)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x33
; 0000 010D         {
; 0000 010E         read();
	RCALL _read
; 0000 010F         checksum = read();
	RCALL _read
	LDI  R31,0
	CALL SUBOPT_0x5
; 0000 0110         checksum += read() * 255;
	LDI  R26,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	LDS  R26,_checksum
	LDS  R27,_checksum+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x5
; 0000 0111         signature = read();
	LDI  R31,0
	STS  _signature,R30
	STS  _signature+1,R31
; 0000 0112         signature += read() * 255;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	ADD  R30,R26
	ADC  R31,R27
	STS  _signature,R30
	STS  _signature+1,R31
; 0000 0113         if(signature == 1)
	CALL SUBOPT_0x7
	SBIW R26,1
	BRNE _0x34
; 0000 0114             {
; 0000 0115             x = read();
	RCALL _read
	LDI  R31,0
	STS  _x,R30
	STS  _x+1,R31
; 0000 0116             x+=read()*255;
	CALL SUBOPT_0x6
	LDS  R26,_x
	LDS  R27,_x+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _x,R30
	STS  _x+1,R31
; 0000 0117             y = read();
	RCALL _read
	LDI  R31,0
	STS  _y,R30
	STS  _y+1,R31
; 0000 0118             y += read() * 255;
	CALL SUBOPT_0x6
	LDS  R26,_y
	LDS  R27,_y+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _y,R30
	STS  _y+1,R31
; 0000 0119             }
; 0000 011A         else
	RJMP _0x35
_0x34:
; 0000 011B             {
; 0000 011C             x_goal = read();
	RCALL _read
	LDI  R31,0
	STS  _x_goal,R30
	STS  _x_goal+1,R31
; 0000 011D             x_goal+=read()*255;
	CALL SUBOPT_0x6
	LDS  R26,_x_goal
	LDS  R27,_x_goal+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _x_goal,R30
	STS  _x_goal+1,R31
; 0000 011E             y_goal = read();
	RCALL _read
	LDI  R31,0
	STS  _y_goal,R30
	STS  _y_goal+1,R31
; 0000 011F             y_goal += read() * 255;
	CALL SUBOPT_0x6
	LDS  R26,_y_goal
	LDS  R27,_y_goal+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _y_goal,R30
	STS  _y_goal+1,R31
; 0000 0120             }
_0x35:
; 0000 0121         width = read();
	RCALL _read
	LDI  R31,0
	STS  _width,R30
	STS  _width+1,R31
; 0000 0122         width += read() * 255;
	CALL SUBOPT_0x6
	LDS  R26,_width
	LDS  R27,_width+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _width,R30
	STS  _width+1,R31
; 0000 0123         height = read();
	RCALL _read
	LDI  R31,0
	STS  _height,R30
	STS  _height+1,R31
; 0000 0124         height += read() * 255;
	CALL SUBOPT_0x6
	LDS  R26,_height
	LDS  R27,_height+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _height,R30
	STS  _height+1,R31
; 0000 0125         }
; 0000 0126       }
_0x33:
; 0000 0127     if(a != 0 && signature == 1) is_ball = 1;
_0x32:
	TST  R6
	BREQ _0x37
	CALL SUBOPT_0x7
	SBIW R26,1
	BREQ _0x38
_0x37:
	RJMP _0x36
_0x38:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _is_ball,R30
	STS  _is_ball+1,R31
; 0000 0128     else if(a != 0 && signature == 2) {is_goal = 1; is_ball = 0;}
	RJMP _0x39
_0x36:
	TST  R6
	BREQ _0x3B
	CALL SUBOPT_0x7
	SBIW R26,2
	BREQ _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _is_goal,R30
	STS  _is_goal+1,R31
	LDI  R30,LOW(0)
	STS  _is_ball,R30
	STS  _is_ball+1,R30
; 0000 0129     else
	RJMP _0x3D
_0x3A:
; 0000 012A         {
; 0000 012B         is_ball = 0;
	LDI  R30,LOW(0)
	STS  _is_ball,R30
	STS  _is_ball+1,R30
; 0000 012C         is_goal = 0;
	STS  _is_goal,R30
	STS  _is_goal+1,R30
; 0000 012D         }
_0x3D:
_0x39:
; 0000 012E     ball_angle = atan2(y - y_robot, x - x_robot) * 180 / PI;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	LDI  R26,LOW(_ball_angle)
	LDI  R27,HIGH(_ball_angle)
	CALL SUBOPT_0xB
; 0000 012F     if (ball_angle < 0) ball_angle += 360;
	LDS  R26,_ball_angle+1
	TST  R26
	BRPL _0x3E
	CALL SUBOPT_0xC
	SUBI R30,LOW(-360)
	SBCI R31,HIGH(-360)
	STS  _ball_angle,R30
	STS  _ball_angle+1,R31
; 0000 0130     ball_angle = 360 - ball_angle;
_0x3E:
	LDS  R26,_ball_angle
	LDS  R27,_ball_angle+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	SUB  R30,R26
	SBC  R31,R27
	STS  _ball_angle,R30
	STS  _ball_angle+1,R31
; 0000 0131     for(i = 0; i < 16; i++)
	CLR  R10
	CLR  R11
_0x40:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R10,R30
	CPC  R11,R31
	BRLT PC+2
	RJMP _0x41
; 0000 0132         {
; 0000 0133         if(ball_angle <= 11.25) ball = 0;
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x42
	LDI  R30,LOW(0)
	STS  _ball,R30
	STS  _ball+1,R30
; 0000 0134         else if(ball_angle >= 348.5) ball = 0;
	RJMP _0x43
_0x42:
	CALL SUBOPT_0xD
	CALL SUBOPT_0xF
	BRLO _0x44
	LDI  R30,LOW(0)
	STS  _ball,R30
	STS  _ball+1,R30
; 0000 0135         else if((ball_angle - 11.25 >= i * 22.5) && (ball_angle-11.25 < (i+1) * 22.5))
	RJMP _0x45
_0x44:
	CALL SUBOPT_0xD
	CALL SUBOPT_0x10
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x11
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x47
	CALL SUBOPT_0xD
	CALL SUBOPT_0x10
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x48
_0x47:
	RJMP _0x46
_0x48:
; 0000 0136             ball = i + 1;
	MOVW R30,R10
	ADIW R30,1
	STS  _ball,R30
	STS  _ball+1,R31
; 0000 0137         }
_0x46:
_0x45:
_0x43:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x40
_0x41:
; 0000 0138     ball_distance = sqrt(pow(x-(x_robot) , 2) + pow(y-y_robot, 2));
	CALL SUBOPT_0x9
	CALL SUBOPT_0x13
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8
	__GETD2N 0x40000000
	CALL _pow
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x14
	LDI  R26,LOW(_ball_distance)
	LDI  R27,HIGH(_ball_distance)
	CALL SUBOPT_0xB
; 0000 0139 
; 0000 013A 
; 0000 013B     goal_angle = atan2(y_goal - y_robot, x_goal - x_robot) * 180 / PI;
	CALL SUBOPT_0x15
	CALL __PUTPARD1
	CALL SUBOPT_0x16
	CALL SUBOPT_0xA
	LDI  R26,LOW(_goal_angle)
	LDI  R27,HIGH(_goal_angle)
	CALL SUBOPT_0xB
; 0000 013C     if (goal_angle < 0) goal_angle += 360;
	LDS  R26,_goal_angle+1
	TST  R26
	BRPL _0x49
	CALL SUBOPT_0x17
	SUBI R30,LOW(-360)
	SBCI R31,HIGH(-360)
	STS  _goal_angle,R30
	STS  _goal_angle+1,R31
; 0000 013D     goal_angle = 360 - goal_angle;
_0x49:
	LDS  R26,_goal_angle
	LDS  R27,_goal_angle+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	SUB  R30,R26
	SBC  R31,R27
	STS  _goal_angle,R30
	STS  _goal_angle+1,R31
; 0000 013E     for(i = 0; i < 16; i++)
	CLR  R10
	CLR  R11
_0x4B:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R10,R30
	CPC  R11,R31
	BRLT PC+2
	RJMP _0x4C
; 0000 013F         {
; 0000 0140         if(goal_angle <= 11.25) goal = 0;
	CALL SUBOPT_0x18
	CALL SUBOPT_0xE
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x4D
	LDI  R30,LOW(0)
	STS  _goal,R30
	STS  _goal+1,R30
; 0000 0141         else if(goal_angle >= 348.5) goal = 0;
	RJMP _0x4E
_0x4D:
	CALL SUBOPT_0x18
	CALL SUBOPT_0xF
	BRLO _0x4F
	LDI  R30,LOW(0)
	STS  _goal,R30
	STS  _goal+1,R30
; 0000 0142         else if((goal_angle - 11.25 >= i * 22.5) && (goal_angle-11.25 < (i+1) * 22.5))
	RJMP _0x50
_0x4F:
	CALL SUBOPT_0x18
	CALL SUBOPT_0x10
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x11
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x52
	CALL SUBOPT_0x18
	CALL SUBOPT_0x10
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x53
_0x52:
	RJMP _0x51
_0x53:
; 0000 0143             goal = i + 1;
	MOVW R30,R10
	ADIW R30,1
	STS  _goal,R30
	STS  _goal+1,R31
; 0000 0144         }
_0x51:
_0x50:
_0x4E:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x4B
_0x4C:
; 0000 0145     goal_distance = sqrt(pow(x_goal-(x_robot) , 2) + pow(y_goal-y_robot, 2));
	CALL SUBOPT_0x16
	CALL SUBOPT_0x13
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x13
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x14
	LDI  R26,LOW(_goal_distance)
	LDI  R27,HIGH(_goal_distance)
	CALL SUBOPT_0xB
; 0000 0146 
; 0000 0147     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0148     lcd_putchar('B');
	LDI  R26,LOW(66)
	CALL SUBOPT_0x19
; 0000 0149     lcd_putchar((ball/10)%10+'0');
	CALL SUBOPT_0x2
	CALL SUBOPT_0x19
; 0000 014A     lcd_putchar((ball/1)%10+'0');
	CALL SUBOPT_0x1A
; 0000 014B 
; 0000 014C     lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 014D     lcd_putchar('G');
	LDI  R26,LOW(71)
	CALL SUBOPT_0x1B
; 0000 014E     lcd_putchar((goal/10)%10+'0');
	CALL SUBOPT_0x2
	CALL SUBOPT_0x1B
; 0000 014F     lcd_putchar((goal/1)%10+'0');
	CALL SUBOPT_0x1A
; 0000 0150 
; 0000 0151 
; 0000 0152 //    lcd_gotoxy(0,0);
; 0000 0153 //    lcd_putsf("X=");
; 0000 0154 //    lcd_putchar((x/100)%10+'0');
; 0000 0155 //    lcd_putchar((x/10)%10+'0');
; 0000 0156 //    lcd_putchar((x/1)%10+'0');
; 0000 0157 //
; 0000 0158 //    lcd_gotoxy(5,0);
; 0000 0159 //    lcd_putsf("Y=");
; 0000 015A //    lcd_putchar((y/100)%10+'0');
; 0000 015B //    lcd_putchar((y/10)%10+'0');
; 0000 015C //    lcd_putchar((y/1)%10+'0');
; 0000 015D     }
	RET
; .FEND
;
;void move(int direction)
; 0000 0160     {
_move:
; .FSTART _move
; 0000 0161     if(direction == 0)      motor(speed   , speed   , -speed  , -speed   );
	ST   -Y,R27
	ST   -Y,R26
;	direction -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x54
	ST   -Y,R9
	ST   -Y,R8
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	MOVW R26,R30
	RCALL _motor
; 0000 0162     if(direction == 1)      motor(speed   , speed/2 , -speed  , -speed/2 );
_0x54:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x55
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	MOVW R26,R30
	RCALL _motor
; 0000 0163     if(direction == 2)      motor(speed   , 0       , -speed  , 0        );
_0x55:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x56
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
; 0000 0164     if(direction == 3)      motor(speed   , -speed/2, -speed  , speed/2  );
_0x56:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x57
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x22
	MOVW R26,R30
	RCALL _motor
; 0000 0165     if(direction == 4)      motor(speed   , -speed  , -speed  , speed    );
_0x57:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0x58
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x23
; 0000 0166     if(direction == 5)      motor(speed/2 , -speed  , -speed/2, speed    );
_0x58:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRNE _0x59
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x23
; 0000 0167     if(direction == 6)      motor(0       , -speed  , 0       , speed    );
_0x59:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0x5A
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x25
	CALL SUBOPT_0x23
; 0000 0168     if(direction == 7)      motor(-speed/2, -speed  , speed/2 , speed    );
_0x5A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x5B
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1F
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R23
	ST   -Y,R22
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
; 0000 0169 
; 0000 016A     if(direction == 8)      motor(-speed  , -speed  , speed   , speed    );
_0x5B:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x5C
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	MOVW R26,R8
	RCALL _motor
; 0000 016B 
; 0000 016C     if(direction == 9)      motor(-speed   , -speed/2, speed   , speed/2 );
_0x5C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRNE _0x5D
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1F
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
	MOVW R26,R30
	RCALL _motor
; 0000 016D     if(direction == 10)     motor(-speed   , 0       , speed   , 0       );
_0x5D:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRNE _0x5E
	MOVW R30,R8
	CALL __ANEGW1
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _motor
; 0000 016E     if(direction == 11)     motor(-speed   , speed/2 , speed   , -speed/2);
_0x5E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,11
	BRNE _0x5F
	CALL SUBOPT_0x26
	CALL SUBOPT_0x22
	CALL SUBOPT_0x28
	MOVW R26,R22
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R26,R30
	RCALL _motor
; 0000 016F     if(direction == 12)     motor(-speed   , speed   , speed   , -speed  );
_0x5F:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,12
	BRNE _0x60
	CALL SUBOPT_0x27
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R9
	ST   -Y,R8
	MOVW R26,R30
	RCALL _motor
; 0000 0170     if(direction == 13)     motor(-speed/2 , speed   , speed/2 , -speed  );
_0x60:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,13
	BRNE _0x61
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1F
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R22
	RCALL _motor
; 0000 0171     if(direction == 14)     motor(0        , speed   , 0       , -speed  );
_0x61:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,14
	BRNE _0x62
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x20
	MOVW R26,R30
	RCALL _motor
; 0000 0172     if(direction == 15)     motor(speed/2  , speed   , -speed/2, -speed  );
_0x62:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,15
	BRNE _0x63
	CALL SUBOPT_0x24
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1D
	MOVW R26,R30
	RCALL _motor
; 0000 0173     }
_0x63:
	JMP  _0x20C0002
; .FEND
;
;void read_cmp()
; 0000 0176     {
_read_cmp:
; .FSTART _read_cmp
; 0000 0177     putchar(0xa5);
	LDI  R26,LOW(165)
	CALL _putchar
; 0000 0178     putchar(0x52);
	LDI  R26,LOW(82)
	CALL _putchar
; 0000 0179     b = getchar();
	RCALL _getchar
	STS  _b,R30
; 0000 017A     if(b == 0xaa)  cmp = getchar() + cmp_balance;
	LDS  R26,_b
	CPI  R26,LOW(0xAA)
	BRNE _0x64
	RCALL _getchar
	LDI  R31,0
	LDS  R26,_cmp_balance
	LDS  R27,_cmp_balance+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R12,R30
; 0000 017B     if(cnt>=200) {cmp_balance++; cnt = 0;}
_0x64:
	LDS  R26,_cnt
	LDS  R27,_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x65
	LDI  R26,LOW(_cmp_balance)
	LDI  R27,HIGH(_cmp_balance)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDI  R30,LOW(0)
	STS  _cnt,R30
	STS  _cnt+1,R30
; 0000 017C     cnt++;
_0x65:
	LDI  R26,LOW(_cnt)
	LDI  R27,HIGH(_cnt)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 017D     if(cmp > 128) cmp = cmp - 255;
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x66
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 12,13,30,31
; 0000 017E     lcd_gotoxy(0,1);
_0x66:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 017F     print(cmp);
	MOVW R26,R12
	RCALL _print
; 0000 0180     if(cmp<30 && cmp>-30) cmp*=2;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x68
	LDI  R30,LOW(65506)
	LDI  R31,HIGH(65506)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x69
_0x68:
	RJMP _0x67
_0x69:
	LSL  R12
	ROL  R13
; 0000 0181     }
_0x67:
	RET
; .FEND
;
;void shoot()
; 0000 0184     {
_shoot:
; .FSTART _shoot
; 0000 0185     PORTC.3 = 1;
	SBI  0x15,3
; 0000 0186     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0187     PORTC.3 = 0;
	CBI  0x15,3
; 0000 0188 
; 0000 0189     }
	RET
; .FEND
;
;void main(void)
; 0000 018C {
_main:
; .FSTART _main
; 0000 018D // Declare your local variables here
; 0000 018E 
; 0000 018F // Input/Output Ports initialization
; 0000 0190 // Port A initialization
; 0000 0191 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0192 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0193 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0194 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0195 
; 0000 0196 // Port B initialization
; 0000 0197 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0198 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(24)
	OUT  0x17,R30
; 0000 0199 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 019A PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 019B 
; 0000 019C // Port C initialization
; 0000 019D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 019E DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(8)
	OUT  0x14,R30
; 0000 019F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 01A0 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01A1 
; 0000 01A2 // Port D initialization
; 0000 01A3 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 01A4 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 01A5 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 01A6 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01A7 
; 0000 01A8 // Timer/Counter 0 initialization
; 0000 01A9 // Clock source: System Clock
; 0000 01AA // Clock value: 125.000 kHz
; 0000 01AB // Mode: Fast PWM top=0xFF
; 0000 01AC // OC0 output: Non-Inverted PWM
; 0000 01AD // Timer Period: 2.048 ms
; 0000 01AE // Output Pulse(s):
; 0000 01AF // OC0 Period: 2.048 ms Width: 0 us
; 0000 01B0 TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 01B1 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 01B2 OCR0=0x00;
	OUT  0x3C,R30
; 0000 01B3 
; 0000 01B4 // Timer/Counter 1 initialization
; 0000 01B5 // Clock source: System Clock
; 0000 01B6 // Clock value: 125.000 kHz
; 0000 01B7 // Mode: Fast PWM top=0x00FF
; 0000 01B8 // OC1A output: Non-Inverted PWM
; 0000 01B9 // OC1B output: Non-Inverted PWM
; 0000 01BA // Noise Canceler: Off
; 0000 01BB // Input Capture on Falling Edge
; 0000 01BC // Timer Period: 2.048 ms
; 0000 01BD // Output Pulse(s):
; 0000 01BE // OC1A Period: 2.048 ms Width: 0 us// OC1B Period: 2.048 ms Width: 0 us
; 0000 01BF // Timer1 Overflow Interrupt: Off
; 0000 01C0 // Input Capture Interrupt: Off
; 0000 01C1 // Compare A Match Interrupt: Off
; 0000 01C2 // Compare B Match Interrupt: Off
; 0000 01C3 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 01C4 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 01C5 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01C6 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01C7 ICR1H=0x00;
	OUT  0x27,R30
; 0000 01C8 ICR1L=0x00;
	OUT  0x26,R30
; 0000 01C9 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01CA OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01CB OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01CC OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01CD 
; 0000 01CE // Timer/Counter 2 initialization
; 0000 01CF // Clock source: System Clock
; 0000 01D0 // Clock value: 125.000 kHz
; 0000 01D1 // Mode: Fast PWM top=0xFF
; 0000 01D2 // OC2 output: Non-Inverted PWM
; 0000 01D3 // Timer Period: 2.048 ms
; 0000 01D4 // Output Pulse(s):
; 0000 01D5 // OC2 Period: 2.048 ms Width: 0 us
; 0000 01D6 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 01D7 TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 01D8 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01D9 OCR2=0x00;
	OUT  0x23,R30
; 0000 01DA 
; 0000 01DB // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01DC TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 01DD 
; 0000 01DE // External Interrupt(s) initialization
; 0000 01DF // INT0: Off
; 0000 01E0 // INT1: Off
; 0000 01E1 // INT2: Off
; 0000 01E2 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 01E3 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 01E4 
; 0000 01E5 // USART initialization
; 0000 01E6 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01E7 // USART Receiver: On
; 0000 01E8 // USART Transmitter: On
; 0000 01E9 // USART Mode: Asynchronous
; 0000 01EA // USART Baud Rate: 9600
; 0000 01EB UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 01EC UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 01ED UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01EE UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01EF UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01F0 
; 0000 01F1 // Analog Comparator initialization
; 0000 01F2 // Analog Comparator: Off
; 0000 01F3 // The Analog Comparator's positive input is
; 0000 01F4 // connected to the AIN0 pin
; 0000 01F5 // The Analog Comparator's negative input is
; 0000 01F6 // connected to the AIN1 pin
; 0000 01F7 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01F8 
; 0000 01F9 // ADC initialization
; 0000 01FA // ADC Clock frequency: 125.000 kHz
; 0000 01FB // ADC Voltage Reference: AVCC pin
; 0000 01FC // ADC Auto Trigger Source: ADC Stopped
; 0000 01FD ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 01FE ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 01FF SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0200 
; 0000 0201 // SPI initialization
; 0000 0202 // SPI disabled
; 0000 0203 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0204 
; 0000 0205 // TWI initialization
; 0000 0206 // TWI disabled
; 0000 0207 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0208 
; 0000 0209 // Bit-Banged I2C Bus initialization
; 0000 020A // I2C Port: PORTB
; 0000 020B // I2C SDA bit: 1
; 0000 020C // I2C SCL bit: 0
; 0000 020D // Bit Rate: 100 kHz
; 0000 020E // Note: I2C settings are specified in the
; 0000 020F // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0210 i2c_init();
	CALL _i2c_init
; 0000 0211 
; 0000 0212 // Alphanumeric LCD initialization
; 0000 0213 // Connections are specified in the
; 0000 0214 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0215 // RS - PORTC Bit 0
; 0000 0216 // RD - PORTC Bit 1
; 0000 0217 // EN - PORTC Bit 2
; 0000 0218 // D4 - PORTC Bit 4
; 0000 0219 // D5 - PORTC Bit 5
; 0000 021A // D6 - PORTC Bit 6
; 0000 021B // D7 - PORTC Bit 7
; 0000 021C // Characters/line: 16
; 0000 021D lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 021E 
; 0000 021F // Global enable interrupts
; 0000 0220 #asm("sei")
	sei
; 0000 0221 speed = 255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R8,R30
; 0000 0222 read_pixy();
	RCALL _read_pixy
; 0000 0223 while(x == 0 && y == 0) read_pixy();
_0x6E:
	LDS  R26,_x
	LDS  R27,_x+1
	SBIW R26,0
	BRNE _0x71
	LDS  R26,_y
	LDS  R27,_y+1
	SBIW R26,0
	BREQ _0x72
_0x71:
	RJMP _0x70
_0x72:
	RCALL _read_pixy
	RJMP _0x6E
_0x70:
; 0000 0224 while (1)
_0x73:
; 0000 0225     {
; 0000 0226     read_pixy();
	RCALL _read_pixy
; 0000 0227     read_cmp();
	RCALL _read_cmp
; 0000 0228     kick_sen = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	STS  _kick_sen,R30
	STS  _kick_sen+1,R31
; 0000 0229     lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 022A     lcd_putchar((kick_sen/1000)%10+'10');
	CALL SUBOPT_0x29
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	MOVW R26,R30
	CALL SUBOPT_0x1A
; 0000 022B     lcd_putchar((kick_sen/100)%10+'10');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1
	CALL _lcd_putchar
; 0000 022C     lcd_putchar((kick_sen/10)%10+'10');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2
	CALL _lcd_putchar
; 0000 022D     lcd_putchar((kick_sen/1)%10+'10');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1A
; 0000 022E     if(kick_sen<400)
	CALL SUBOPT_0x29
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0x76
; 0000 022F         {
; 0000 0230         PORTB.4 = 1;
	SBI  0x18,4
; 0000 0231         if(!is_goal)  motor(-150,-150,150,150);
	LDS  R30,_is_goal
	LDS  R31,_is_goal+1
	SBIW R30,0
	BRNE _0x79
	LDI  R30,LOW(65386)
	LDI  R31,HIGH(65386)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(150)
	LDI  R27,0
	RCALL _motor
; 0000 0232         else if(goal_distance<70)
	RJMP _0x7A
_0x79:
	LDS  R26,_goal_distance
	LDS  R27,_goal_distance+1
	CPI  R26,LOW(0x46)
	LDI  R30,HIGH(0x46)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0x7B
; 0000 0233             {
; 0000 0234             cmp = 0;
	CLR  R12
	CLR  R13
; 0000 0235             if(goal == 0) {motor(-cmp,-cmp,-cmp,-cmp);shoot();}
	LDS  R30,_goal
	LDS  R31,_goal+1
	SBIW R30,0
	BRNE _0x7C
	MOVW R30,R12
	CALL __ANEGW1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R30
	RCALL _motor
	RCALL _shoot
; 0000 0236             else if(goal>3 && goal < 8)   motor(120,120,120,120);
	RJMP _0x7D
_0x7C:
	CALL SUBOPT_0x2A
	SBIW R26,4
	BRLT _0x7F
	CALL SUBOPT_0x2A
	SBIW R26,8
	BRLT _0x80
_0x7F:
	RJMP _0x7E
_0x80:
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2B
	LDI  R26,LOW(120)
	LDI  R27,0
	RJMP _0xB4
; 0000 0237             else if(goal>=8 && goal < 13) motor(-120,-120,-120,-120);
_0x7E:
	CALL SUBOPT_0x2A
	SBIW R26,8
	BRLT _0x83
	CALL SUBOPT_0x2A
	SBIW R26,13
	BRLT _0x84
_0x83:
	RJMP _0x82
_0x84:
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2C
	LDI  R26,LOW(65416)
	LDI  R27,HIGH(65416)
	RJMP _0xB4
; 0000 0238             else if(goal<=3)              motor(80,80,80,80);
_0x82:
	CALL SUBOPT_0x2A
	SBIW R26,4
	BRGE _0x86
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2D
	LDI  R26,LOW(80)
	LDI  R27,0
	RJMP _0xB4
; 0000 0239             else if(goal>=13)             motor(-80,-80,-80,-80);
_0x86:
	CALL SUBOPT_0x2A
	SBIW R26,13
	BRLT _0x88
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	LDI  R26,LOW(65456)
	LDI  R27,HIGH(65456)
_0xB4:
	RCALL _motor
; 0000 023A             }
_0x88:
_0x7D:
; 0000 023B         else
	RJMP _0x89
_0x7B:
; 0000 023C             {
; 0000 023D             speed = 150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	MOVW R8,R30
; 0000 023E             move(goal);
	CALL SUBOPT_0x2A
	RCALL _move
; 0000 023F             speed = 255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R8,R30
; 0000 0240             }
_0x89:
_0x7A:
; 0000 0241         }
; 0000 0242     else if(is_ball)
	RJMP _0x8A
_0x76:
	LDS  R30,_is_ball
	LDS  R31,_is_ball+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x8B
; 0000 0243         {
; 0000 0244         if(ball_distance < 90)
	LDS  R26,_ball_distance
	LDS  R27,_ball_distance+1
	CPI  R26,LOW(0x5A)
	LDI  R30,HIGH(0x5A)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0x8C
; 0000 0245             {
; 0000 0246             PORTB.4 = 1;
	SBI  0x18,4
; 0000 0247             if(ball == 0)       move(ball);
	LDS  R30,_ball
	LDS  R31,_ball+1
	SBIW R30,0
	BRNE _0x8F
	CALL SUBOPT_0x2F
	RJMP _0xB5
; 0000 0248             else if(ball == 1)  move(2);
_0x8F:
	CALL SUBOPT_0x2F
	SBIW R26,1
	BRNE _0x91
	LDI  R26,LOW(2)
	LDI  R27,0
	RJMP _0xB5
; 0000 0249             else if(ball == 15) move(14);
_0x91:
	CALL SUBOPT_0x2F
	SBIW R26,15
	BRNE _0x93
	LDI  R26,LOW(14)
	LDI  R27,0
	RJMP _0xB5
; 0000 024A             else if(ball == 2)  move(4);
_0x93:
	CALL SUBOPT_0x2F
	SBIW R26,2
	BRNE _0x95
	LDI  R26,LOW(4)
	LDI  R27,0
	RJMP _0xB5
; 0000 024B             else if(ball == 14) move(12);
_0x95:
	CALL SUBOPT_0x2F
	SBIW R26,14
	BRNE _0x97
	LDI  R26,LOW(12)
	LDI  R27,0
	RJMP _0xB5
; 0000 024C 
; 0000 024D             else if(ball>2 && ball<=6)    move(ball + 2);
_0x97:
	CALL SUBOPT_0x2F
	SBIW R26,3
	BRLT _0x9A
	CALL SUBOPT_0x2F
	SBIW R26,7
	BRLT _0x9B
_0x9A:
	RJMP _0x99
_0x9B:
	CALL SUBOPT_0x2F
	ADIW R26,2
	RJMP _0xB5
; 0000 024E             else if(ball>=10 && ball<14)  move(ball - 2);
_0x99:
	CALL SUBOPT_0x2F
	SBIW R26,10
	BRLT _0x9E
	CALL SUBOPT_0x2F
	SBIW R26,14
	BRLT _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
	RJMP _0xB6
; 0000 024F 
; 0000 0250             else if(ball>6 && ball<=8)    move(ball + 2);
_0x9D:
	CALL SUBOPT_0x2F
	SBIW R26,7
	BRLT _0xA2
	CALL SUBOPT_0x2F
	SBIW R26,9
	BRLT _0xA3
_0xA2:
	RJMP _0xA1
_0xA3:
	CALL SUBOPT_0x2F
	ADIW R26,2
	RJMP _0xB5
; 0000 0251             else if(ball>8 && ball<10)    move(ball - 2);
_0xA1:
	CALL SUBOPT_0x2F
	SBIW R26,9
	BRLT _0xA6
	CALL SUBOPT_0x2F
	SBIW R26,10
	BRLT _0xA7
_0xA6:
	RJMP _0xA5
_0xA7:
_0xB6:
	LDS  R26,_ball
	LDS  R27,_ball+1
	SBIW R26,2
_0xB5:
	RCALL _move
; 0000 0252             }
_0xA5:
; 0000 0253         else
	RJMP _0xA8
_0x8C:
; 0000 0254             {
; 0000 0255             PORTB.4 = 0;
	CBI  0x18,4
; 0000 0256             move(ball);
	CALL SUBOPT_0x2F
	RCALL _move
; 0000 0257             }
_0xA8:
; 0000 0258         }
; 0000 0259     else
	RJMP _0xAB
_0x8B:
; 0000 025A         {
; 0000 025B         PORTB.4 = 0;
	CBI  0x18,4
; 0000 025C         motor(0,0,0,0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x25
	CALL SUBOPT_0x25
	CALL SUBOPT_0x21
; 0000 025D         }
_0xAB:
_0x8A:
; 0000 025E     }
	RJMP _0x73
; 0000 025F }
_0xAE:
	RJMP _0xAE
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
	CALL SUBOPT_0x30
	CALL _ftrunc
	CALL SUBOPT_0x31
    brne __floor1
__floor0:
	CALL SUBOPT_0x32
	RJMP _0x20C0004
__floor1:
    brtc __floor0
	CALL SUBOPT_0x33
	CALL __SUBF12
	RJMP _0x20C0004
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x34
	CALL __CPD02
	BRLT _0x200000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0006
_0x200000C:
	CALL SUBOPT_0x35
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x36
	CALL SUBOPT_0x34
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x200000D
	CALL SUBOPT_0x37
	CALL __ADDF12
	CALL SUBOPT_0x36
	__SUBWRN 16,17,1
_0x200000D:
	CALL SUBOPT_0x38
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x38
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	CALL SUBOPT_0x39
	__GETD2N 0x3F654226
	CALL SUBOPT_0x3A
	__GETD1N 0x4054114E
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x34
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3C
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
	CALL SUBOPT_0x3D
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x200000F
	CALL SUBOPT_0x3E
	RJMP _0x20C0005
_0x200000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2000010
	__GETD1N 0x3F800000
	RJMP _0x20C0005
_0x2000010:
	CALL SUBOPT_0x3D
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0005
_0x2000011:
	CALL SUBOPT_0x3D
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL SUBOPT_0x3D
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x3D
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x3B
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	CALL SUBOPT_0x39
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x34
	CALL __MULF12
	CALL SUBOPT_0x36
	CALL SUBOPT_0x3C
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x35
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3C
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
	CALL SUBOPT_0x3F
	CALL __CPD10
	BRNE _0x2000012
	CALL SUBOPT_0x3E
	RJMP _0x20C0003
_0x2000012:
	CALL SUBOPT_0x40
	CALL __CPD02
	BRGE _0x2000013
	CALL SUBOPT_0x41
	CALL __CPD10
	BRNE _0x2000014
	__GETD1N 0x3F800000
	RJMP _0x20C0003
_0x2000014:
	CALL SUBOPT_0x40
	CALL SUBOPT_0x42
	RCALL _exp
	RJMP _0x20C0003
_0x2000013:
	CALL SUBOPT_0x41
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x32
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x41
	CALL __CPD12
	BREQ _0x2000015
	CALL SUBOPT_0x3E
	RJMP _0x20C0003
_0x2000015:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x43
	CALL SUBOPT_0x42
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2000016
	CALL SUBOPT_0x3F
	RJMP _0x20C0003
_0x2000016:
	CALL SUBOPT_0x3F
	CALL __ANEGF1
	RJMP _0x20C0003
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x45
	CALL SUBOPT_0x44
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x32
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x46
	CALL SUBOPT_0x45
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	CALL SUBOPT_0x30
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2000020
	CALL SUBOPT_0x46
	RCALL _xatan
	RJMP _0x20C0004
_0x2000020:
	CALL SUBOPT_0x46
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	CALL SUBOPT_0x33
	CALL SUBOPT_0x47
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x3B
	RJMP _0x20C0004
_0x2000021:
	CALL SUBOPT_0x33
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x33
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x47
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x20C0004:
	ADIW R28,4
	RET
; .FEND
_atan2:
; .FSTART _atan2
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x41
	CALL __CPD10
	BRNE _0x200002D
	CALL SUBOPT_0x3F
	CALL __CPD10
	BRNE _0x200002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0003
_0x200002E:
	CALL SUBOPT_0x40
	CALL __CPD02
	BRGE _0x200002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0003
_0x200002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0003
_0x200002D:
	CALL SUBOPT_0x41
	CALL SUBOPT_0x40
	CALL __DIVF21
	CALL SUBOPT_0x31
	__GETD2S 4
	CALL __CPD02
	BRGE _0x2000030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000031
	CALL SUBOPT_0x46
	RCALL _yatan
	RJMP _0x20C0003
_0x2000031:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x43
	RCALL _yatan
	CALL __ANEGF1
	RJMP _0x20C0003
_0x2000030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000032
	CALL SUBOPT_0x32
	CALL SUBOPT_0x43
	RCALL _yatan
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x3B
	RJMP _0x20C0003
_0x2000032:
	CALL SUBOPT_0x46
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20C0003:
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
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
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
	JMP  _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x20C0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x48
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x48
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
	BREQ _0x2020005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x20C0001
_0x2020007:
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20C0001
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
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
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
	RJMP _0x20C0001
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

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
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
_rx_buffer:
	.BYTE 0x8
_x:
	.BYTE 0x2
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
_b:
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
_x_goal:
	.BYTE 0x2
_y_goal:
	.BYTE 0x2
_goal_angle:
	.BYTE 0x2
_goal_distance:
	.BYTE 0x2
_goal:
	.BYTE 0x2
_is_goal:
	.BYTE 0x2
_cnt:
	.BYTE 0x2
_cmp_balance:
	.BYTE 0x2
_kick_sen:
	.BYTE 0x2
_is_ball:
	.BYTE 0x2
_address:
	.BYTE 0x2
__base_y_G101:
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CALL _lcd_putchar
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	CALL _lcd_putchar
	LD   R30,Y
	LDD  R31,Y+1
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	STS  _checksum,R30
	STS  _checksum+1,R31
	JMP  _read

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
	CALL _read
	LDI  R26,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R26,_signature
	LDS  R27,_signature+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8:
	LDS  R26,_y_robot
	LDS  R27,_y_robot+1
	LDS  R30,_y
	LDS  R31,_y+1
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDS  R26,_x_robot
	LDS  R27,_x_robot+1
	LDS  R30,_x
	LDS  R31,_x+1
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan2
	__GETD2N 0x43340000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40490FDB
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDS  R30,_ball_angle
	LDS  R31,_ball_angle+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0xC
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	__GETD1N 0x41340000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__GETD1N 0x43AE4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xE
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	MOVW R30,R10
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x41B40000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	MOVW R30,R10
	ADIW R30,1
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x41B40000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	CALL __PUTPARD1
	__GETD2N 0x40000000
	JMP  _pow

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDS  R26,_y_robot
	LDS  R27,_y_robot+1
	LDS  R30,_y_goal
	LDS  R31,_y_goal+1
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	LDS  R26,_x_robot
	LDS  R27,_x_robot+1
	LDS  R30,_x_goal
	LDS  R31,_x_goal+1
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDS  R30,_goal_angle
	LDS  R31,_goal_angle+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x18:
	RCALL SUBOPT_0x17
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CALL _lcd_putchar
	LDS  R26,_ball
	LDS  R27,_ball+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL _lcd_putchar
	LDS  R26,_goal
	LDS  R27,_goal+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	ST   -Y,R9
	ST   -Y,R8
	MOVW R30,R8
	CALL __ANEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1D:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL __ANEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	ST   -Y,R9
	ST   -Y,R8
	MOVW R26,R8
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1F:
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	ST   -Y,R9
	ST   -Y,R8
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R8
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R8
	JMP  _motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	MOVW R26,R8
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	MOVW R30,R8
	CALL __ANEGW1
	MOVW R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	MOVW R30,R8
	CALL __ANEGW1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R9
	ST   -Y,R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LDS  R26,_kick_sen
	LDS  R27,_kick_sen+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	LDS  R26,_goal
	LDS  R27,_goal+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(65416)
	LDI  R31,HIGH(65416)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(65456)
	LDI  R31,HIGH(65456)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2F:
	LDS  R26,_ball
	LDS  R27,_ball+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x32:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	RCALL SUBOPT_0x32
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x34:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x35
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	RCALL SUBOPT_0x35
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3B:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3D:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x41:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	CALL _log
	__GETD2S 4
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	__GETD2S 4
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x49:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
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

;END OF CODE MARKER
__END_OF_CODE:
