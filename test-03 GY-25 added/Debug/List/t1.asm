
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
	.DB  0x6D
_0xF:
	.DB  0x4C
_0x10:
	.DB  0x54
_0x0:
	.DB  0x58,0x3D,0x0,0x59,0x3D,0x0
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
	.DW  _last_out
	.DW  _0xF*2

	.DW  0x01
	.DW  _address
	.DW  _0x10*2

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
	RJMP _0x20C0006
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
;int cmp;
;int x, y,width,height,checksum, signature;
;char a,b;
;int x_robot = 150, y_robot = 109, ball_angle, ball, ball_distance;

	.DSEG
;int x_goal, y_goal, goal_angle, goal_distance, goal,is_goal = 0,cnt=0,cmp_balance = 0;
;int front_distance,back_distance;
;int kick_sen;
;int is_ball = 0;
;int turn_back = 0;
;int LDR_R,LDR_L,set_r,set_l,last_out = 'L',once_done = 0;
;int out_cnt = 0;
;//////////////////////////////////////////////////////////////////////////////////PIXY-CMUCAM5
;#define I2C_7BIT_DEVICE_ADDRESS 0x54
;#define EEPROM_BUS_ADDRESS (I2C_7BIT_DEVICE_ADDRESS << 1)
;
;unsigned int  address=0x54;
;unsigned char read()
; 0000 0092 {

	.CSEG
_read:
; .FSTART _read
; 0000 0093 unsigned char data;
; 0000 0094 i2c_start();
	ST   -Y,R17
;	data -> R17
	CALL _i2c_start
; 0000 0095 i2c_write(EEPROM_BUS_ADDRESS | 0);
	LDI  R26,LOW(168)
	CALL _i2c_write
; 0000 0096 i2c_write(address >> 8);
	LDS  R30,_address+1
	MOV  R26,R30
	CALL _i2c_write
; 0000 0097 i2c_write((unsigned char) address);
	LDS  R26,_address
	CALL _i2c_write
; 0000 0098 i2c_start();
	CALL _i2c_start
; 0000 0099 i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R26,LOW(169)
	CALL _i2c_write
; 0000 009A data=i2c_read(0);
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R17,R30
; 0000 009B i2c_stop();
	CALL _i2c_stop
; 0000 009C return data;
_0x20C0006:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 009D }
; .FEND
;
;void print()
; 0000 00A0     {
_print:
; .FSTART _print
; 0000 00A1 //    lcd_gotoxy(0,0);
; 0000 00A2 //    lcd_putchar('B');
; 0000 00A3 //    lcd_putchar((ball/10)%10+'0');
; 0000 00A4 //    lcd_putchar((ball/1)%10+'0');
; 0000 00A5 //
; 0000 00A6 //
; 0000 00A7 //    lcd_gotoxy(5,0);
; 0000 00A8 //    lcd_putchar((ball_distance/100)%10+'0');
; 0000 00A9 //    lcd_putchar((ball_distance/10)%10+'0');
; 0000 00AA //    lcd_putchar((ball_distance/1)%10+'0');
; 0000 00AB //
; 0000 00AC 
; 0000 00AD     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 00AE     lcd_putsf("X=");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 00AF     lcd_putchar((x/100)%10+'0');
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
; 0000 00B0     lcd_putchar((x/10)%10+'0');
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
; 0000 00B1     lcd_putchar((x/1)%10+'0');
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
; 0000 00B2 
; 0000 00B3     lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 00B4     lcd_putsf("Y=");
	__POINTW2FN _0x0,3
	CALL _lcd_putsf
; 0000 00B5     lcd_putchar((y/100)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1
; 0000 00B6     lcd_putchar((y/10)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x2
; 0000 00B7     lcd_putchar((y/1)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x3
; 0000 00B8 
; 0000 00B9 //    lcd_gotoxy(0,1);
; 0000 00BA //    lcd_putchar((LDR_L/100)%10+'0');
; 0000 00BB //    lcd_putchar((LDR_L/10)%10+'0');
; 0000 00BC //    lcd_putchar((LDR_L/1)%10+'0');
; 0000 00BD //
; 0000 00BE //    lcd_gotoxy(4,1);
; 0000 00BF //    lcd_putchar((LDR_R/100)%10+'0');
; 0000 00C0 //    lcd_putchar((LDR_R/10)%10+'0');
; 0000 00C1 //    lcd_putchar((LDR_R/1)%10+'0');
; 0000 00C2 
; 0000 00C3     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 00C4     lcd_putchar((front_distance/100)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x1
; 0000 00C5     lcd_putchar((front_distance/10)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x2
; 0000 00C6     lcd_putchar((front_distance/1)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x3
; 0000 00C7 
; 0000 00C8     lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x5
; 0000 00C9     lcd_putchar((back_distance/100)%10+'0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1
; 0000 00CA     lcd_putchar((back_distance/10)%10+'0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2
; 0000 00CB     lcd_putchar((back_distance/1)%10+'0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x3
; 0000 00CC 
; 0000 00CD 
; 0000 00CE 
; 0000 00CF 
; 0000 00D0     }
	RET
; .FEND
;
;void motor(int mr1,int mr2,int ml2,int ml1)
; 0000 00D3     {
_motor:
; .FSTART _motor
; 0000 00D4     mr1 += cmp;
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
; 0000 00D5     mr2 += cmp;
	MOVW R30,R12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00D6     ml1 += cmp;
	MOVW R30,R12
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 00D7     ml2 += cmp;
	MOVW R30,R12
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00D8 
; 0000 00D9     if(ml1>255) ml1=255;
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x11
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00DA     if(ml2>255) ml2=255;
_0x11:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x12
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00DB     if(mr2>255) mr2=255;
_0x12:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x13
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00DC     if(mr1>255) mr1=255;
_0x13:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x14
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00DD 
; 0000 00DE     if(ml1<-255) ml1=-255;
_0x14:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x15
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00DF     if(ml2<-255) ml2=-255;
_0x15:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x16
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00E0     if(mr2<-255) mr2=-255;
_0x16:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x17
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00E1     if(mr1<-255) mr1=-255;
_0x17:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x18
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00E2 
; 0000 00E3     //////////////mr1
; 0000 00E4     {
_0x18:
; 0000 00E5     if(mr1>=0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x19
; 0000 00E6         {
; 0000 00E7         PORTB.2=0;
	CBI  0x18,2
; 0000 00E8         OCR0=mr1;
	LDD  R30,Y+6
	RJMP _0x132
; 0000 00E9         }
; 0000 00EA     else
_0x19:
; 0000 00EB         {
; 0000 00EC         PORTB.2=1;
	SBI  0x18,2
; 0000 00ED         OCR0=mr1+255;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
_0x132:
	OUT  0x3C,R30
; 0000 00EE         }
; 0000 00EF         }
; 0000 00F0     //////////////mr2
; 0000 00F1     {
; 0000 00F2     if(mr2>=0)
	LDD  R26,Y+5
	TST  R26
	BRMI _0x1F
; 0000 00F3         {
; 0000 00F4         PORTD.2=0;
	CBI  0x12,2
; 0000 00F5         OCR1B=mr2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x133
; 0000 00F6         }
; 0000 00F7     else
_0x1F:
; 0000 00F8         {
; 0000 00F9         PORTD.2=1;
	SBI  0x12,2
; 0000 00FA         OCR1B=mr2+255;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x133:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00FB         }
; 0000 00FC         }
; 0000 00FD     //////////////mL2
; 0000 00FE     {
; 0000 00FF     if(ml2>=0)
	LDD  R26,Y+3
	TST  R26
	BRMI _0x25
; 0000 0100         {
; 0000 0101         PORTD.3=0;
	CBI  0x12,3
; 0000 0102         OCR1A=ml2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x134
; 0000 0103         }
; 0000 0104     else
_0x25:
; 0000 0105         {
; 0000 0106         PORTD.3=1;
	SBI  0x12,3
; 0000 0107         OCR1A=ml2+255;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x134:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0108         }
; 0000 0109         }
; 0000 010A     //////////////ml1
; 0000 010B     {
; 0000 010C     if(ml1>=0)
	LDD  R26,Y+1
	TST  R26
	BRMI _0x2B
; 0000 010D         {
; 0000 010E         PORTD.6=0;
	CBI  0x12,6
; 0000 010F         OCR2=ml1;
	LD   R30,Y
	RJMP _0x135
; 0000 0110         }
; 0000 0111     else
_0x2B:
; 0000 0112         {
; 0000 0113         PORTD.6=1;
	SBI  0x12,6
; 0000 0114         OCR2=ml1+255;
	LD   R30,Y
	SUBI R30,-LOW(255)
_0x135:
	OUT  0x23,R30
; 0000 0115         }
; 0000 0116     }
; 0000 0117 
; 0000 0118     }
	ADIW R28,8
	RET
; .FEND
;
;void read_pixy()
; 0000 011B     {
_read_pixy:
; .FSTART _read_pixy
; 0000 011C     a=read();
	RCALL _read
	MOV  R6,R30
; 0000 011D     if(a==0xaa)
	LDI  R30,LOW(170)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x31
; 0000 011E       {
; 0000 011F       a=read();
	RCALL _read
	MOV  R6,R30
; 0000 0120       if(a==0x55)
	LDI  R30,LOW(85)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x32
; 0000 0121         {
; 0000 0122         read();
	RCALL _read
; 0000 0123         checksum = read();
	RCALL _read
	LDI  R31,0
	CALL SUBOPT_0x8
; 0000 0124         checksum += read() * 255;
	LDI  R26,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	LDS  R26,_checksum
	LDS  R27,_checksum+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x8
; 0000 0125         signature = read();
	LDI  R31,0
	STS  _signature,R30
	STS  _signature+1,R31
; 0000 0126         signature += read() * 255;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	STS  _signature,R30
	STS  _signature+1,R31
; 0000 0127         if(signature == 1)
	CALL SUBOPT_0xA
	SBIW R26,1
	BRNE _0x33
; 0000 0128             {
; 0000 0129             x = read();
	RCALL _read
	LDI  R31,0
	STS  _x,R30
	STS  _x+1,R31
; 0000 012A             x+=read()*255;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x0
	ADD  R30,R26
	ADC  R31,R27
	STS  _x,R30
	STS  _x+1,R31
; 0000 012B             y = read();
	RCALL _read
	LDI  R31,0
	STS  _y,R30
	STS  _y+1,R31
; 0000 012C             y += read() * 255;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x4
	ADD  R30,R26
	ADC  R31,R27
	STS  _y,R30
	STS  _y+1,R31
; 0000 012D             }
; 0000 012E         else
	RJMP _0x34
_0x33:
; 0000 012F             {
; 0000 0130             x_goal = read();
	RCALL _read
	LDI  R31,0
	STS  _x_goal,R30
	STS  _x_goal+1,R31
; 0000 0131             x_goal+=read()*255;
	CALL SUBOPT_0x9
	LDS  R26,_x_goal
	LDS  R27,_x_goal+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _x_goal,R30
	STS  _x_goal+1,R31
; 0000 0132             y_goal = read();
	RCALL _read
	LDI  R31,0
	STS  _y_goal,R30
	STS  _y_goal+1,R31
; 0000 0133             y_goal += read() * 255;
	CALL SUBOPT_0x9
	LDS  R26,_y_goal
	LDS  R27,_y_goal+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _y_goal,R30
	STS  _y_goal+1,R31
; 0000 0134             }
_0x34:
; 0000 0135         width = read();
	RCALL _read
	LDI  R31,0
	STS  _width,R30
	STS  _width+1,R31
; 0000 0136         width += read() * 255;
	CALL SUBOPT_0x9
	LDS  R26,_width
	LDS  R27,_width+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _width,R30
	STS  _width+1,R31
; 0000 0137         height = read();
	RCALL _read
	LDI  R31,0
	STS  _height,R30
	STS  _height+1,R31
; 0000 0138         height += read() * 255;
	CALL SUBOPT_0x9
	LDS  R26,_height
	LDS  R27,_height+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _height,R30
	STS  _height+1,R31
; 0000 0139         }
; 0000 013A       }
_0x32:
; 0000 013B     if(a != 0 && signature == 1) is_ball = 1;
_0x31:
	TST  R6
	BREQ _0x36
	CALL SUBOPT_0xA
	SBIW R26,1
	BREQ _0x37
_0x36:
	RJMP _0x35
_0x37:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _is_ball,R30
	STS  _is_ball+1,R31
; 0000 013C     else if(a != 0 && signature == 2) {is_goal = 1; is_ball = 0;}
	RJMP _0x38
_0x35:
	TST  R6
	BREQ _0x3A
	CALL SUBOPT_0xA
	SBIW R26,2
	BREQ _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _is_goal,R30
	STS  _is_goal+1,R31
	LDI  R30,LOW(0)
	STS  _is_ball,R30
	STS  _is_ball+1,R30
; 0000 013D     else
	RJMP _0x3C
_0x39:
; 0000 013E         {
; 0000 013F         is_ball = 0;
	LDI  R30,LOW(0)
	STS  _is_ball,R30
	STS  _is_ball+1,R30
; 0000 0140         is_goal = 0;
	STS  _is_goal,R30
	STS  _is_goal+1,R30
; 0000 0141         }
_0x3C:
_0x38:
; 0000 0142     ball_angle = atan2(y - y_robot, x - x_robot) * 180 / PI;
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	LDI  R26,LOW(_ball_angle)
	LDI  R27,HIGH(_ball_angle)
	CALL SUBOPT_0xE
; 0000 0143     if (ball_angle < 0) ball_angle += 360;
	LDS  R26,_ball_angle+1
	TST  R26
	BRPL _0x3D
	CALL SUBOPT_0xF
	SUBI R30,LOW(-360)
	SBCI R31,HIGH(-360)
	STS  _ball_angle,R30
	STS  _ball_angle+1,R31
; 0000 0144     ball_angle = 360 - ball_angle;
_0x3D:
	LDS  R26,_ball_angle
	LDS  R27,_ball_angle+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	SUB  R30,R26
	SBC  R31,R27
	STS  _ball_angle,R30
	STS  _ball_angle+1,R31
; 0000 0145     for(i = 0; i < 16; i++)
	CLR  R10
	CLR  R11
_0x3F:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R10,R30
	CPC  R11,R31
	BRLT PC+2
	RJMP _0x40
; 0000 0146         {
; 0000 0147         if(ball_angle <= 11.25) ball = 0;
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x41
	LDI  R30,LOW(0)
	STS  _ball,R30
	STS  _ball+1,R30
; 0000 0148         else if(ball_angle >= 348.5) ball = 0;
	RJMP _0x42
_0x41:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x12
	BRLO _0x43
	LDI  R30,LOW(0)
	STS  _ball,R30
	STS  _ball+1,R30
; 0000 0149         else if((ball_angle - 11.25 >= i * 22.5) && (ball_angle-11.25 < (i+1) * 22.5))
	RJMP _0x44
_0x43:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x13
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x14
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x46
	CALL SUBOPT_0x10
	CALL SUBOPT_0x13
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x15
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x47
_0x46:
	RJMP _0x45
_0x47:
; 0000 014A             ball = i + 1;
	MOVW R30,R10
	ADIW R30,1
	STS  _ball,R30
	STS  _ball+1,R31
; 0000 014B         }
_0x45:
_0x44:
_0x42:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x3F
_0x40:
; 0000 014C     ball_distance = sqrt(pow(x-(x_robot) , 2) + pow(y-y_robot, 2));
	CALL SUBOPT_0xC
	CALL SUBOPT_0x16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB
	__GETD2N 0x40000000
	CALL _pow
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x17
	LDI  R26,LOW(_ball_distance)
	LDI  R27,HIGH(_ball_distance)
	CALL SUBOPT_0xE
; 0000 014D 
; 0000 014E 
; 0000 014F     goal_angle = atan2(y_goal - y_robot, x_goal - x_robot) * 180 / PI;
	CALL SUBOPT_0x18
	CALL __PUTPARD1
	CALL SUBOPT_0x19
	CALL SUBOPT_0xD
	LDI  R26,LOW(_goal_angle)
	LDI  R27,HIGH(_goal_angle)
	CALL SUBOPT_0xE
; 0000 0150     if (goal_angle < 0) goal_angle += 360;
	LDS  R26,_goal_angle+1
	TST  R26
	BRPL _0x48
	CALL SUBOPT_0x1A
	SUBI R30,LOW(-360)
	SBCI R31,HIGH(-360)
	STS  _goal_angle,R30
	STS  _goal_angle+1,R31
; 0000 0151     goal_angle = 360 - goal_angle;
_0x48:
	LDS  R26,_goal_angle
	LDS  R27,_goal_angle+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	SUB  R30,R26
	SBC  R31,R27
	STS  _goal_angle,R30
	STS  _goal_angle+1,R31
; 0000 0152     for(i = 0; i < 16; i++)
	CLR  R10
	CLR  R11
_0x4A:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R10,R30
	CPC  R11,R31
	BRLT PC+2
	RJMP _0x4B
; 0000 0153         {
; 0000 0154         if(goal_angle <= 11.25) goal = 0;
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x11
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x4C
	LDI  R30,LOW(0)
	STS  _goal,R30
	STS  _goal+1,R30
; 0000 0155         else if(goal_angle >= 348.5) goal = 0;
	RJMP _0x4D
_0x4C:
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x12
	BRLO _0x4E
	LDI  R30,LOW(0)
	STS  _goal,R30
	STS  _goal+1,R30
; 0000 0156         else if((goal_angle - 11.25 >= i * 22.5) && (goal_angle-11.25 < (i+1) * 22.5))
	RJMP _0x4F
_0x4E:
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x13
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x14
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x51
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x13
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x15
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO _0x52
_0x51:
	RJMP _0x50
_0x52:
; 0000 0157             goal = i + 1;
	MOVW R30,R10
	ADIW R30,1
	STS  _goal,R30
	STS  _goal+1,R31
; 0000 0158         }
_0x50:
_0x4F:
_0x4D:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x4A
_0x4B:
; 0000 0159     goal_distance = sqrt(pow(x_goal-(x_robot) , 2) + pow(y_goal-y_robot, 2));
	CALL SUBOPT_0x19
	CALL SUBOPT_0x16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x16
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x17
	LDI  R26,LOW(_goal_distance)
	LDI  R27,HIGH(_goal_distance)
	CALL SUBOPT_0xE
; 0000 015A     }
	RET
; .FEND
;
;void move(int direction)
; 0000 015D     {
_move:
; .FSTART _move
; 0000 015E     if(direction == 0)      motor(speed   , speed   , -speed  , -speed   );
	ST   -Y,R27
	ST   -Y,R26
;	direction -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x53
	ST   -Y,R9
	ST   -Y,R8
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	MOVW R26,R30
	RCALL _motor
; 0000 015F     if(direction == 1)      motor(speed   , speed/2 , -speed  , -speed/2 );
_0x53:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x54
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	MOVW R26,R30
	RCALL _motor
; 0000 0160     if(direction == 2)      motor(speed   , 0       , -speed  , 0        );
_0x54:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x55
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
; 0000 0161     if(direction == 3)      motor(speed   , -speed/2, -speed  , speed/2  );
_0x55:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x56
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x22
	MOVW R26,R30
	RCALL _motor
; 0000 0162     if(direction == 4)      motor(speed   , -speed  , -speed  , speed    );
_0x56:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0x57
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x23
; 0000 0163     if(direction == 5)      motor(speed/2 , -speed  , -speed/2, speed    );
_0x57:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRNE _0x58
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x23
; 0000 0164     if(direction == 6)      motor(0       , -speed  , 0       , speed    );
_0x58:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0x59
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x25
	CALL SUBOPT_0x23
; 0000 0165     if(direction == 7)      motor(-speed/2, -speed  , speed/2 , speed    );
_0x59:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x5A
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1F
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R23
	ST   -Y,R22
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
; 0000 0166 
; 0000 0167     if(direction == 8)      motor(-speed  , -speed  , speed   , speed    );
_0x5A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x5B
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	MOVW R26,R8
	RCALL _motor
; 0000 0168 
; 0000 0169     if(direction == 9)      motor(-speed   , -speed/2, speed   , speed/2 );
_0x5B:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRNE _0x5C
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1F
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
	MOVW R26,R30
	RCALL _motor
; 0000 016A     if(direction == 10)     motor(-speed   , 0       , speed   , 0       );
_0x5C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRNE _0x5D
	MOVW R30,R8
	CALL __ANEGW1
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _motor
; 0000 016B     if(direction == 11)     motor(-speed   , speed/2 , speed   , -speed/2);
_0x5D:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,11
	BRNE _0x5E
	CALL SUBOPT_0x26
	CALL SUBOPT_0x22
	CALL SUBOPT_0x28
	MOVW R26,R22
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R26,R30
	RCALL _motor
; 0000 016C     if(direction == 12)     motor(-speed   , speed   , speed   , -speed  );
_0x5E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,12
	BRNE _0x5F
	CALL SUBOPT_0x27
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R9
	ST   -Y,R8
	MOVW R26,R30
	RCALL _motor
; 0000 016D     if(direction == 13)     motor(-speed/2 , speed   , speed/2 , -speed  );
_0x5F:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,13
	BRNE _0x60
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1F
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R22
	RCALL _motor
; 0000 016E     if(direction == 14)     motor(0        , speed   , 0       , -speed  );
_0x60:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,14
	BRNE _0x61
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x20
	MOVW R26,R30
	RCALL _motor
; 0000 016F     if(direction == 15)     motor(speed/2  , speed   , -speed/2, -speed  );
_0x61:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,15
	BRNE _0x62
	CALL SUBOPT_0x24
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1D
	MOVW R26,R30
	RCALL _motor
; 0000 0170     }
_0x62:
	ADIW R28,2
	RET
; .FEND
;
;void read_sensor()
; 0000 0173     {
_read_sensor:
; .FSTART _read_sensor
; 0000 0174     //--------------GY-25 Compass read
; 0000 0175     putchar(0xa5);
	LDI  R26,LOW(165)
	CALL _putchar
; 0000 0176     putchar(0x52);
	LDI  R26,LOW(82)
	CALL _putchar
; 0000 0177     b = getchar();
	RCALL _getchar
	STS  _b,R30
; 0000 0178     if(b == 0xaa)  cmp = getchar() + cmp_balance;
	LDS  R26,_b
	CPI  R26,LOW(0xAA)
	BRNE _0x63
	RCALL _getchar
	LDI  R31,0
	LDS  R26,_cmp_balance
	LDS  R27,_cmp_balance+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R12,R30
; 0000 0179     if(cnt>=200) {cmp_balance++; cnt = 0;}
_0x63:
	LDS  R26,_cnt
	LDS  R27,_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x64
	LDI  R26,LOW(_cmp_balance)
	LDI  R27,HIGH(_cmp_balance)
	CALL SUBOPT_0x29
	LDI  R30,LOW(0)
	STS  _cnt,R30
	STS  _cnt+1,R30
; 0000 017A     cnt++;
_0x64:
	LDI  R26,LOW(_cnt)
	LDI  R27,HIGH(_cnt)
	CALL SUBOPT_0x29
; 0000 017B     if(cmp > 128) cmp = cmp - 255;
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x65
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 12,13,30,31
; 0000 017C     lcd_gotoxy(0,1);
_0x65:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 017D     if(cmp<30 && cmp>-30) cmp*=2;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x67
	LDI  R30,LOW(65506)
	LDI  R31,HIGH(65506)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x68
_0x67:
	RJMP _0x66
_0x68:
	LSL  R12
	ROL  R13
; 0000 017E     if(turn_back)
_0x66:
	CALL SUBOPT_0x2A
	BREQ _0x69
; 0000 017F         {
; 0000 0180         if(cmp >=0) cmp = -(128 - cmp);
	CLR  R0
	CP   R12,R0
	CPC  R13,R0
	BRLT _0x6A
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	SUB  R30,R12
	SBC  R31,R13
	CALL __ANEGW1
	RJMP _0x136
; 0000 0181         else        cmp = cmp + 128;
_0x6A:
	MOVW R30,R12
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
_0x136:
	MOVW R12,R30
; 0000 0182         }
; 0000 0183     //--------------Front Distance
; 0000 0184     DDRA.6=1;
_0x69:
	SBI  0x1A,6
; 0000 0185     PORTA.6=1;
	SBI  0x1B,6
; 0000 0186     delay_us(10);
	__DELAY_USB 27
; 0000 0187     PORTA.6=0;
	CBI  0x1B,6
; 0000 0188     back_distance=0;
	LDI  R30,LOW(0)
	STS  _back_distance,R30
	STS  _back_distance+1,R30
; 0000 0189     DDRA.6=0;
	CBI  0x1A,6
; 0000 018A     while(PINA.6==0);
_0x74:
	SBIS 0x19,6
	RJMP _0x74
; 0000 018B     while(PINA.6==1)
_0x77:
	SBIS 0x19,6
	RJMP _0x79
; 0000 018C         {
; 0000 018D         back_distance++;
	LDI  R26,LOW(_back_distance)
	LDI  R27,HIGH(_back_distance)
	CALL SUBOPT_0x29
; 0000 018E         delay_us(1);
	__DELAY_USB 3
; 0000 018F         }
	RJMP _0x77
_0x79:
; 0000 0190     back_distance/=22;
	CALL SUBOPT_0x7
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL __DIVW21
	STS  _back_distance,R30
	STS  _back_distance+1,R31
; 0000 0191     //--------------Back Distance
; 0000 0192     DDRA.7=1;
	SBI  0x1A,7
; 0000 0193     PORTA.7=1;
	SBI  0x1B,7
; 0000 0194     delay_us(10);
	__DELAY_USB 27
; 0000 0195     PORTA.7=0;
	CBI  0x1B,7
; 0000 0196     front_distance=0;
	LDI  R30,LOW(0)
	STS  _front_distance,R30
	STS  _front_distance+1,R30
; 0000 0197     DDRA.7=0;
	CBI  0x1A,7
; 0000 0198     while(PINA.7==0);
_0x82:
	SBIS 0x19,7
	RJMP _0x82
; 0000 0199     while(PINA.7==1)
_0x85:
	SBIS 0x19,7
	RJMP _0x87
; 0000 019A         {
; 0000 019B         front_distance++;
	LDI  R26,LOW(_front_distance)
	LDI  R27,HIGH(_front_distance)
	CALL SUBOPT_0x29
; 0000 019C         delay_us(1);
	__DELAY_USB 3
; 0000 019D         }
	RJMP _0x85
_0x87:
; 0000 019E     front_distance/=22;
	CALL SUBOPT_0x6
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL __DIVW21
	STS  _front_distance,R30
	STS  _front_distance+1,R31
; 0000 019F     //--------------Kicker Sensor
; 0000 01A0     kick_sen = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	STS  _kick_sen,R30
	STS  _kick_sen+1,R31
; 0000 01A1     //--------------LDR read
; 0000 01A2     LDR_L = read_adc(3) - set_l;
	LDI  R26,LOW(3)
	RCALL _read_adc
	LDS  R26,_set_l
	LDS  R27,_set_l+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _LDR_L,R30
	STS  _LDR_L+1,R31
; 0000 01A3     LDR_R = read_adc(2) - set_r;
	LDI  R26,LOW(2)
	RCALL _read_adc
	LDS  R26,_set_r
	LDS  R27,_set_r+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _LDR_R,R30
	STS  _LDR_R+1,R31
; 0000 01A4     }
	RET
; .FEND
;
;void shoot()
; 0000 01A7     {
_shoot:
; .FSTART _shoot
; 0000 01A8     PORTC.3 = 1;
	SBI  0x15,3
; 0000 01A9     delay_ms(100);
	CALL SUBOPT_0x2B
; 0000 01AA     PORTC.3 = 0;
	CBI  0x15,3
; 0000 01AB     }
	RET
; .FEND
;
;void out()
; 0000 01AE     {
_out:
; .FSTART _out
; 0000 01AF //    speed = 150;
; 0000 01B0     if(LDR_L>60)
	CALL SUBOPT_0x2C
	BRGE PC+2
	RJMP _0x8C
; 0000 01B1         {
; 0000 01B2         last_out = 'L';
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x2D
; 0000 01B3         cmp = 0;
; 0000 01B4         move(4);
	CALL SUBOPT_0x2E
; 0000 01B5         delay_ms(200);
	CALL SUBOPT_0x2F
; 0000 01B6         out_cnt = 0;
; 0000 01B7         while((ball>8 || ball == 0) && is_ball && out_cnt<20)
_0x8D:
	CALL SUBOPT_0x30
	SBIW R26,9
	BRGE _0x90
	CALL SUBOPT_0x30
	SBIW R26,0
	BRNE _0x92
_0x90:
	CALL SUBOPT_0x31
	BREQ _0x92
	LDS  R26,_out_cnt
	LDS  R27,_out_cnt+1
	SBIW R26,20
	BRLT _0x93
_0x92:
	RJMP _0x8F
_0x93:
; 0000 01B8             {
; 0000 01B9             read_sensor();
	CALL SUBOPT_0x32
; 0000 01BA             read_pixy();
; 0000 01BB             if(LDR_R>60 && LDR_L>60) move(4);
	CALL SUBOPT_0x33
	BRLT _0x95
	CALL SUBOPT_0x2C
	BRGE _0x96
_0x95:
	RJMP _0x94
_0x96:
	CALL SUBOPT_0x2E
; 0000 01BC             else motor(0,0,0,0);
	RJMP _0x97
_0x94:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x25
	CALL SUBOPT_0x21
; 0000 01BD             out_cnt++;
_0x97:
	LDI  R26,LOW(_out_cnt)
	LDI  R27,HIGH(_out_cnt)
	CALL SUBOPT_0x29
; 0000 01BE             }
	RJMP _0x8D
_0x8F:
; 0000 01BF         while(is_ball)
_0x98:
	CALL SUBOPT_0x31
	BRNE PC+2
	RJMP _0x9A
; 0000 01C0             {
; 0000 01C1             PORTB.4 = 1;
	SBI  0x18,4
; 0000 01C2             read_sensor();
	CALL SUBOPT_0x32
; 0000 01C3             read_pixy();
; 0000 01C4             cmp = 0;
	CALL SUBOPT_0x35
; 0000 01C5             speed = 100;
; 0000 01C6             if(kick_sen < 400)
	BRGE _0x9D
; 0000 01C7                 {
; 0000 01C8                 speed = 150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	MOVW R8,R30
; 0000 01C9                 delay_ms(100);
	CALL SUBOPT_0x2B
; 0000 01CA                 for(i = 0; i<70; i++)
	CLR  R10
	CLR  R11
_0x9F:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0xA0
; 0000 01CB                     {
; 0000 01CC                     read_sensor();
	RCALL _read_sensor
; 0000 01CD                     move(6);
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _move
; 0000 01CE                     }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x9F
_0xA0:
; 0000 01CF                 return;
	RET
; 0000 01D0                 }
; 0000 01D1             else if(ball != 0)
_0x9D:
	CALL SUBOPT_0x36
	BREQ _0xA2
; 0000 01D2                 {
; 0000 01D3                 if(ball>=8)      motor(-50,-50,-50,-50);
	CALL SUBOPT_0x30
	SBIW R26,8
	BRLT _0xA3
	CALL SUBOPT_0x37
	CALL SUBOPT_0x37
	CALL SUBOPT_0x37
	LDI  R26,LOW(65486)
	LDI  R27,HIGH(65486)
	RJMP _0x137
; 0000 01D4                 else if(ball<8) motor(50,50,50,50);
_0xA3:
	CALL SUBOPT_0x30
	SBIW R26,8
	BRGE _0xA5
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	LDI  R26,LOW(50)
	LDI  R27,0
_0x137:
	RCALL _motor
; 0000 01D5                 }
_0xA5:
; 0000 01D6             else if(front_distance>13) move(0);
	RJMP _0xA6
_0xA2:
	CALL SUBOPT_0x6
	SBIW R26,14
	BRLT _0xA7
	CALL SUBOPT_0x39
; 0000 01D7             else motor(0,0,0,0);
	RJMP _0xA8
_0xA7:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x25
	CALL SUBOPT_0x21
; 0000 01D8             }
_0xA8:
_0xA6:
	RJMP _0x98
_0x9A:
; 0000 01D9         }
; 0000 01DA     else if(LDR_R>60)
	RJMP _0xA9
_0x8C:
	CALL SUBOPT_0x33
	BRGE PC+2
	RJMP _0xAA
; 0000 01DB         {
; 0000 01DC         last_out = 'R';
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x2D
; 0000 01DD         cmp = 0;
; 0000 01DE         move(12);
	LDI  R26,LOW(12)
	LDI  R27,0
	RCALL _move
; 0000 01DF         delay_ms(200);
	CALL SUBOPT_0x2F
; 0000 01E0         out_cnt = 0;
; 0000 01E1         while(ball<8 && is_ball && out_cnt<20)
_0xAB:
	CALL SUBOPT_0x30
	SBIW R26,8
	BRGE _0xAE
	CALL SUBOPT_0x31
	BREQ _0xAE
	LDS  R26,_out_cnt
	LDS  R27,_out_cnt+1
	SBIW R26,20
	BRLT _0xAF
_0xAE:
	RJMP _0xAD
_0xAF:
; 0000 01E2             {
; 0000 01E3             read_sensor();
	CALL SUBOPT_0x32
; 0000 01E4             read_pixy();
; 0000 01E5             if(LDR_L>60 || LDR_R>60) move(12);
	CALL SUBOPT_0x2C
	BRGE _0xB1
	CALL SUBOPT_0x33
	BRLT _0xB0
_0xB1:
	LDI  R26,LOW(12)
	LDI  R27,0
	RCALL _move
; 0000 01E6             else motor(0,0,0,0);
	RJMP _0xB3
_0xB0:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x25
	CALL SUBOPT_0x21
; 0000 01E7             out_cnt++;
_0xB3:
	LDI  R26,LOW(_out_cnt)
	LDI  R27,HIGH(_out_cnt)
	CALL SUBOPT_0x29
; 0000 01E8             }
	RJMP _0xAB
_0xAD:
; 0000 01E9         while(is_ball)
_0xB4:
	CALL SUBOPT_0x31
	BRNE PC+2
	RJMP _0xB6
; 0000 01EA             {
; 0000 01EB             PORTB.4 = 1;
	SBI  0x18,4
; 0000 01EC             read_sensor();
	CALL SUBOPT_0x32
; 0000 01ED             read_pixy();
; 0000 01EE             cmp = 0;
	CALL SUBOPT_0x35
; 0000 01EF             speed = 100;
; 0000 01F0             if(kick_sen < 400)
	BRGE _0xB9
; 0000 01F1                 {
; 0000 01F2                 speed = 150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	MOVW R8,R30
; 0000 01F3                 delay_ms(100);
	CALL SUBOPT_0x2B
; 0000 01F4                 for(i = 0; i<70; i++)
	CLR  R10
	CLR  R11
_0xBB:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0xBC
; 0000 01F5                     {
; 0000 01F6                     read_sensor();
	RCALL _read_sensor
; 0000 01F7                     move(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _move
; 0000 01F8                     }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0xBB
_0xBC:
; 0000 01F9                 return;
	RET
; 0000 01FA                 }
; 0000 01FB             else if(ball != 0)
_0xB9:
	CALL SUBOPT_0x36
	BREQ _0xBE
; 0000 01FC                 {
; 0000 01FD                 if(ball>=8)      motor(-50,-50,-50,-50);
	CALL SUBOPT_0x30
	SBIW R26,8
	BRLT _0xBF
	CALL SUBOPT_0x37
	CALL SUBOPT_0x37
	CALL SUBOPT_0x37
	LDI  R26,LOW(65486)
	LDI  R27,HIGH(65486)
	RJMP _0x138
; 0000 01FE                 else if(ball<8) motor(50,50,50,50);
_0xBF:
	CALL SUBOPT_0x30
	SBIW R26,8
	BRGE _0xC1
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	LDI  R26,LOW(50)
	LDI  R27,0
_0x138:
	RCALL _motor
; 0000 01FF                 }
_0xC1:
; 0000 0200             else if(front_distance>13) move(0);
	RJMP _0xC2
_0xBE:
	CALL SUBOPT_0x6
	SBIW R26,14
	BRLT _0xC3
	CALL SUBOPT_0x39
; 0000 0201             else motor(0,0,0,0);
	RJMP _0xC4
_0xC3:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x25
	CALL SUBOPT_0x21
; 0000 0202             }
_0xC4:
_0xC2:
	RJMP _0xB4
_0xB6:
; 0000 0203         }
; 0000 0204 //    speed = 255;
; 0000 0205     }
_0xAA:
_0xA9:
	RET
; .FEND
;
;void main(void)
; 0000 0208 {
_main:
; .FSTART _main
; 0000 0209 // Declare your local variables here
; 0000 020A 
; 0000 020B // Input/Output Ports initialization
; 0000 020C // Port A initialization
; 0000 020D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 020E DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 020F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0210 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0211 
; 0000 0212 // Port B initialization
; 0000 0213 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0214 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(24)
	OUT  0x17,R30
; 0000 0215 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 0216 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0217 
; 0000 0218 // Port C initialization
; 0000 0219 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 021A DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(8)
	OUT  0x14,R30
; 0000 021B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 021C PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 021D 
; 0000 021E // Port D initialization
; 0000 021F // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0220 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0221 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0222 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0223 
; 0000 0224 // Timer/Counter 0 initialization
; 0000 0225 // Clock source: System Clock
; 0000 0226 // Clock value: 125.000 kHz
; 0000 0227 // Mode: Fast PWM top=0xFF
; 0000 0228 // OC0 output: Non-Inverted PWM
; 0000 0229 // Timer Period: 2.048 ms
; 0000 022A // Output Pulse(s):
; 0000 022B // OC0 Period: 2.048 ms Width: 0 us
; 0000 022C TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 022D TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 022E OCR0=0x00;
	OUT  0x3C,R30
; 0000 022F 
; 0000 0230 // Timer/Counter 1 initialization
; 0000 0231 // Clock source: System Clock
; 0000 0232 // Clock value: 125.000 kHz
; 0000 0233 // Mode: Fast PWM top=0x00FF
; 0000 0234 // OC1A output: Non-Inverted PWM
; 0000 0235 // OC1B output: Non-Inverted PWM
; 0000 0236 // Noise Canceler: Off
; 0000 0237 // Input Capture on Falling Edge
; 0000 0238 // Timer Period: 2.048 ms
; 0000 0239 // Output Pulse(s):
; 0000 023A // OC1A Period: 2.048 ms Width: 0 us// OC1B Period: 2.048 ms Width: 0 us
; 0000 023B // Timer1 Overflow Interrupt: Off
; 0000 023C // Input Capture Interrupt: Off
; 0000 023D // Compare A Match Interrupt: Off
; 0000 023E // Compare B Match Interrupt: Off
; 0000 023F TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0240 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 0241 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0242 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0243 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0244 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0245 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0246 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0247 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0248 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0249 
; 0000 024A // Timer/Counter 2 initialization
; 0000 024B // Clock source: System Clock
; 0000 024C // Clock value: 125.000 kHz
; 0000 024D // Mode: Fast PWM top=0xFF
; 0000 024E // OC2 output: Non-Inverted PWM
; 0000 024F // Timer Period: 2.048 ms
; 0000 0250 // Output Pulse(s):
; 0000 0251 // OC2 Period: 2.048 ms Width: 0 us
; 0000 0252 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0253 TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 0254 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0255 OCR2=0x00;
	OUT  0x23,R30
; 0000 0256 
; 0000 0257 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0258 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0259 
; 0000 025A // External Interrupt(s) initialization
; 0000 025B // INT0: Off
; 0000 025C // INT1: Off
; 0000 025D // INT2: Off
; 0000 025E MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 025F MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0260 
; 0000 0261 // USART initialization
; 0000 0262 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0263 // USART Receiver: On
; 0000 0264 // USART Transmitter: On
; 0000 0265 // USART Mode: Asynchronous
; 0000 0266 // USART Baud Rate: 9600
; 0000 0267 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 0268 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0269 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 026A UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 026B UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 026C 
; 0000 026D // Analog Comparator initialization
; 0000 026E // Analog Comparator: Off
; 0000 026F // The Analog Comparator's positive input is
; 0000 0270 // connected to the AIN0 pin
; 0000 0271 // The Analog Comparator's negative input is
; 0000 0272 // connected to the AIN1 pin
; 0000 0273 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0274 
; 0000 0275 // ADC initialization
; 0000 0276 // ADC Clock frequency: 125.000 kHz
; 0000 0277 // ADC Voltage Reference: AVCC pin
; 0000 0278 // ADC Auto Trigger Source: ADC Stopped
; 0000 0279 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 027A ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 027B SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 027C 
; 0000 027D // SPI initialization
; 0000 027E // SPI disabled
; 0000 027F SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0280 
; 0000 0281 // TWI initialization
; 0000 0282 // TWI disabled
; 0000 0283 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0284 
; 0000 0285 // Bit-Banged I2C Bus initialization
; 0000 0286 // I2C Port: PORTB
; 0000 0287 // I2C SDA bit: 1
; 0000 0288 // I2C SCL bit: 0
; 0000 0289 // Bit Rate: 100 kHz
; 0000 028A // Note: I2C settings are specified in the
; 0000 028B // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 028C i2c_init();
	CALL _i2c_init
; 0000 028D 
; 0000 028E // Alphanumeric LCD initialization
; 0000 028F // Connections are specified in the
; 0000 0290 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0291 // RS - PORTC Bit 0
; 0000 0292 // RD - PORTC Bit 1
; 0000 0293 // EN - PORTC Bit 2
; 0000 0294 // D4 - PORTC Bit 4
; 0000 0295 // D5 - PORTC Bit 5
; 0000 0296 // D6 - PORTC Bit 6
; 0000 0297 // D7 - PORTC Bit 7
; 0000 0298 // Characters/line: 16
; 0000 0299 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 029A 
; 0000 029B // Global enable interrupts
; 0000 029C #asm("sei")
	sei
; 0000 029D speed = 255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R8,R30
; 0000 029E set_l = read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	STS  _set_l,R30
	STS  _set_l+1,R31
; 0000 029F set_r = read_adc(2);
	LDI  R26,LOW(2)
	RCALL _read_adc
	STS  _set_r,R30
	STS  _set_r+1,R31
; 0000 02A0 
; 0000 02A1 read_pixy();
	RCALL _read_pixy
; 0000 02A2 while(x == 0 && y == 0) read_pixy();
_0xC5:
	CALL SUBOPT_0x0
	SBIW R26,0
	BRNE _0xC8
	CALL SUBOPT_0x4
	SBIW R26,0
	BREQ _0xC9
_0xC8:
	RJMP _0xC7
_0xC9:
	RCALL _read_pixy
	RJMP _0xC5
_0xC7:
; 0000 02A3 while (1)
_0xCA:
; 0000 02A4     {
; 0000 02A5     read_pixy();
	RCALL _read_pixy
; 0000 02A6     read_sensor();
	RCALL _read_sensor
; 0000 02A7     print();
	RCALL _print
; 0000 02A8     if(kick_sen<400)
	CALL SUBOPT_0x3A
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0xCD
; 0000 02A9         {
; 0000 02AA         PORTB.4 = 1;
	SBI  0x18,4
; 0000 02AB         speed = 255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R8,R30
; 0000 02AC         if(!is_goal && turn_back == 0)  move(0);
	LDS  R30,_is_goal
	LDS  R31,_is_goal+1
	SBIW R30,0
	BRNE _0xD1
	LDS  R26,_turn_back
	LDS  R27,_turn_back+1
	SBIW R26,0
	BREQ _0xD2
_0xD1:
	RJMP _0xD0
_0xD2:
	CALL SUBOPT_0x39
; 0000 02AD         else if(!is_goal && turn_back == 1)  move(8);
	RJMP _0xD3
_0xD0:
	LDS  R30,_is_goal
	LDS  R31,_is_goal+1
	SBIW R30,0
	BRNE _0xD5
	LDS  R26,_turn_back
	LDS  R27,_turn_back+1
	SBIW R26,1
	BREQ _0xD6
_0xD5:
	RJMP _0xD4
_0xD6:
	CALL SUBOPT_0x3B
; 0000 02AE         else if(front_distance < 10 && !turn_back)
	RJMP _0xD7
_0xD4:
	CALL SUBOPT_0x6
	SBIW R26,10
	BRGE _0xD9
	CALL SUBOPT_0x2A
	BREQ _0xDA
_0xD9:
	RJMP _0xD8
_0xDA:
; 0000 02AF             {
; 0000 02B0             turn_back = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _turn_back,R30
	STS  _turn_back+1,R31
; 0000 02B1             move(8);
	CALL SUBOPT_0x3B
; 0000 02B2             if(last_out == 'L')
	LDS  R26,_last_out
	LDS  R27,_last_out+1
	CPI  R26,LOW(0x4C)
	LDI  R30,HIGH(0x4C)
	CPC  R27,R30
	BRNE _0xDB
; 0000 02B3                 {
; 0000 02B4                 for(i = 0; i < 100; i++)
	CLR  R10
	CLR  R11
_0xDD:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0xDE
; 0000 02B5                     {
; 0000 02B6                     read_sensor();
	CALL SUBOPT_0x3C
; 0000 02B7                     if(kick_sen>400) {break;turn_back = 0;}
	BRGE _0xDE
; 0000 02B8                     motor(-200,-200,-50,0);
	LDI  R30,LOW(65336)
	LDI  R31,HIGH(65336)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	CALL SUBOPT_0x21
; 0000 02B9                     }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0xDD
_0xDE:
; 0000 02BA                 }
; 0000 02BB             else
	RJMP _0xE0
_0xDB:
; 0000 02BC                 {
; 0000 02BD                 for(i = 0; i < 100; i++)
	CLR  R10
	CLR  R11
_0xE2:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0xE3
; 0000 02BE                     {
; 0000 02BF                     read_sensor();
	CALL SUBOPT_0x3C
; 0000 02C0                     if(kick_sen>400) {break;turn_back = 0;}
	BRGE _0xE3
; 0000 02C1                     motor(0,50,200,200);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x38
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _motor
; 0000 02C2                     }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0xE2
_0xE3:
; 0000 02C3                 }
_0xE0:
; 0000 02C4 
; 0000 02C5             }
; 0000 02C6         else if(back_distance < 20 && turn_back && goal_distance>70)  move(4);
	RJMP _0xE5
_0xD8:
	CALL SUBOPT_0x7
	SBIW R26,20
	BRGE _0xE7
	CALL SUBOPT_0x2A
	BREQ _0xE7
	LDS  R26,_goal_distance
	LDS  R27,_goal_distance+1
	CPI  R26,LOW(0x47)
	LDI  R30,HIGH(0x47)
	CPC  R27,R30
	BRGE _0xE8
_0xE7:
	RJMP _0xE6
_0xE8:
	CALL SUBOPT_0x2E
; 0000 02C7         else if(goal_distance<90)
	RJMP _0xE9
_0xE6:
	LDS  R26,_goal_distance
	LDS  R27,_goal_distance+1
	CPI  R26,LOW(0x5A)
	LDI  R30,HIGH(0x5A)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0xEA
; 0000 02C8             {
; 0000 02C9             cmp = 0;
	CLR  R12
	CLR  R13
; 0000 02CA             if(goal == 0) {motor(-cmp,-cmp,-cmp,-cmp);shoot();}
	LDS  R30,_goal
	LDS  R31,_goal+1
	SBIW R30,0
	BRNE _0xEB
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
; 0000 02CB             else if(goal>3 && goal < 8)   motor(120,120,120,120);
	RJMP _0xEC
_0xEB:
	CALL SUBOPT_0x3D
	SBIW R26,4
	BRLT _0xEE
	CALL SUBOPT_0x3D
	SBIW R26,8
	BRLT _0xEF
_0xEE:
	RJMP _0xED
_0xEF:
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3E
	LDI  R26,LOW(120)
	LDI  R27,0
	RJMP _0x139
; 0000 02CC             else if(goal>=8 && goal < 13) motor(-120,-120,-120,-120);
_0xED:
	CALL SUBOPT_0x3D
	SBIW R26,8
	BRLT _0xF2
	CALL SUBOPT_0x3D
	SBIW R26,13
	BRLT _0xF3
_0xF2:
	RJMP _0xF1
_0xF3:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3F
	LDI  R26,LOW(65416)
	LDI  R27,HIGH(65416)
	RJMP _0x139
; 0000 02CD             else if(goal<=3)              motor(80,80,80,80);
_0xF1:
	CALL SUBOPT_0x3D
	SBIW R26,4
	BRGE _0xF5
	CALL SUBOPT_0x40
	CALL SUBOPT_0x40
	CALL SUBOPT_0x40
	LDI  R26,LOW(80)
	LDI  R27,0
	RJMP _0x139
; 0000 02CE             else if(goal>=13)             motor(-80,-80,-80,-80);
_0xF5:
	CALL SUBOPT_0x3D
	SBIW R26,13
	BRLT _0xF7
	CALL SUBOPT_0x41
	CALL SUBOPT_0x41
	CALL SUBOPT_0x41
	LDI  R26,LOW(65456)
	LDI  R27,HIGH(65456)
_0x139:
	RCALL _motor
; 0000 02CF             }
_0xF7:
_0xEC:
; 0000 02D0         else
	RJMP _0xF8
_0xEA:
; 0000 02D1             {
; 0000 02D2             speed = 200;
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	MOVW R8,R30
; 0000 02D3             move(goal);
	CALL SUBOPT_0x3D
	RCALL _move
; 0000 02D4             speed = 255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R8,R30
; 0000 02D5             }
_0xF8:
_0xE9:
_0xE5:
_0xD7:
_0xD3:
; 0000 02D6         }
; 0000 02D7     else if(is_ball)
	RJMP _0xF9
_0xCD:
	CALL SUBOPT_0x31
	BRNE PC+2
	RJMP _0xFA
; 0000 02D8         {
; 0000 02D9         out();
	RCALL _out
; 0000 02DA         speed = 255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R8,R30
; 0000 02DB         if(ball_distance <40)
	LDS  R26,_ball_distance
	LDS  R27,_ball_distance+1
	SBIW R26,40
	BRGE _0xFB
; 0000 02DC             {
; 0000 02DD             PORTB.4 = 1;
	SBI  0x18,4
; 0000 02DE             if(ball == 0)       move(ball);
	CALL SUBOPT_0x36
	BRNE _0xFE
	CALL SUBOPT_0x30
	RJMP _0x13A
; 0000 02DF             else if(ball < 2)   move(ball+1);
_0xFE:
	CALL SUBOPT_0x30
	SBIW R26,2
	BRGE _0x100
	CALL SUBOPT_0x30
	ADIW R26,1
	RJMP _0x13A
; 0000 02E0             else if(ball > 14)  move(ball-1);
_0x100:
	CALL SUBOPT_0x30
	SBIW R26,15
	BRLT _0x102
	CALL SUBOPT_0x30
	SBIW R26,1
	RJMP _0x13A
; 0000 02E1             else if(ball <= 8)  move(ball+3);
_0x102:
	CALL SUBOPT_0x30
	SBIW R26,9
	BRGE _0x104
	CALL SUBOPT_0x30
	ADIW R26,3
	RJMP _0x13A
; 0000 02E2             else if(ball > 8)   move(ball-3);
_0x104:
	CALL SUBOPT_0x30
	SBIW R26,9
	BRLT _0x106
	CALL SUBOPT_0x30
	SBIW R26,3
_0x13A:
	RCALL _move
; 0000 02E3             }
_0x106:
; 0000 02E4         else if(ball_distance < 90)
	RJMP _0x107
_0xFB:
	LDS  R26,_ball_distance
	LDS  R27,_ball_distance+1
	CPI  R26,LOW(0x5A)
	LDI  R30,HIGH(0x5A)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0x108
; 0000 02E5             {
; 0000 02E6             PORTB.4 = 1;
	SBI  0x18,4
; 0000 02E7             if(ball == 0)       move(ball);
	CALL SUBOPT_0x36
	BRNE _0x10B
	CALL SUBOPT_0x30
	RJMP _0x13B
; 0000 02E8             else if(ball == 1)  move(1);
_0x10B:
	CALL SUBOPT_0x30
	SBIW R26,1
	BRNE _0x10D
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP _0x13B
; 0000 02E9             else if(ball == 15) move(15);
_0x10D:
	CALL SUBOPT_0x30
	SBIW R26,15
	BRNE _0x10F
	LDI  R26,LOW(15)
	LDI  R27,0
	RJMP _0x13B
; 0000 02EA             else if(ball == 2)  move(3);
_0x10F:
	CALL SUBOPT_0x30
	SBIW R26,2
	BRNE _0x111
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _0x13B
; 0000 02EB             else if(ball == 14) move(13);
_0x111:
	CALL SUBOPT_0x30
	SBIW R26,14
	BRNE _0x113
	LDI  R26,LOW(13)
	LDI  R27,0
	RJMP _0x13B
; 0000 02EC 
; 0000 02ED             else if(ball>2 && ball<=6)    move(ball + 2);
_0x113:
	CALL SUBOPT_0x30
	SBIW R26,3
	BRLT _0x116
	CALL SUBOPT_0x30
	SBIW R26,7
	BRLT _0x117
_0x116:
	RJMP _0x115
_0x117:
	CALL SUBOPT_0x30
	ADIW R26,2
	RJMP _0x13B
; 0000 02EE             else if(ball>=10 && ball<14)  move(ball - 2);
_0x115:
	CALL SUBOPT_0x30
	SBIW R26,10
	BRLT _0x11A
	CALL SUBOPT_0x30
	SBIW R26,14
	BRLT _0x11B
_0x11A:
	RJMP _0x119
_0x11B:
	RJMP _0x13C
; 0000 02EF 
; 0000 02F0             else if(ball>6 && ball<=8)    move(ball + 2);
_0x119:
	CALL SUBOPT_0x30
	SBIW R26,7
	BRLT _0x11E
	CALL SUBOPT_0x30
	SBIW R26,9
	BRLT _0x11F
_0x11E:
	RJMP _0x11D
_0x11F:
	CALL SUBOPT_0x30
	ADIW R26,2
	RJMP _0x13B
; 0000 02F1             else if(ball>8 && ball<10)    move(ball - 2);
_0x11D:
	CALL SUBOPT_0x30
	SBIW R26,9
	BRLT _0x122
	CALL SUBOPT_0x30
	SBIW R26,10
	BRLT _0x123
_0x122:
	RJMP _0x121
_0x123:
_0x13C:
	LDS  R26,_ball
	LDS  R27,_ball+1
	SBIW R26,2
_0x13B:
	RCALL _move
; 0000 02F2             }
_0x121:
; 0000 02F3         else
	RJMP _0x124
_0x108:
; 0000 02F4             {
; 0000 02F5             PORTB.4 = 0;
	CBI  0x18,4
; 0000 02F6             if(ball == 0 )      move(ball);
	CALL SUBOPT_0x36
	BRNE _0x127
	CALL SUBOPT_0x30
	RJMP _0x13D
; 0000 02F7             else if(ball<=8)    move(ball+2);
_0x127:
	CALL SUBOPT_0x30
	SBIW R26,9
	BRGE _0x129
	CALL SUBOPT_0x30
	ADIW R26,2
	RJMP _0x13D
; 0000 02F8             else if(ball>8)     move(ball-2);
_0x129:
	CALL SUBOPT_0x30
	SBIW R26,9
	BRLT _0x12B
	CALL SUBOPT_0x30
	SBIW R26,2
_0x13D:
	RCALL _move
; 0000 02F9             }
_0x12B:
_0x124:
_0x107:
; 0000 02FA         }
; 0000 02FB     else
	RJMP _0x12C
_0xFA:
; 0000 02FC         {
; 0000 02FD         turn_back = 0;
	LDI  R30,LOW(0)
	STS  _turn_back,R30
	STS  _turn_back+1,R30
; 0000 02FE         PORTB.4 = 0;
	CBI  0x18,4
; 0000 02FF         if(back_distance > 30) move(8);
	CALL SUBOPT_0x7
	SBIW R26,31
	BRLT _0x12F
	CALL SUBOPT_0x3B
; 0000 0300         else motor(0,0,0,0);
	RJMP _0x130
_0x12F:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x25
	CALL SUBOPT_0x21
; 0000 0301         }
_0x130:
_0x12C:
_0xF9:
; 0000 0302     }
	RJMP _0xCA
; 0000 0303 }
_0x131:
	RJMP _0x131
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
	CALL SUBOPT_0x42
	CALL _ftrunc
	CALL SUBOPT_0x43
    brne __floor1
__floor0:
	CALL SUBOPT_0x44
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x45
	CALL __SUBF12
	RJMP _0x20C0003
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x46
	CALL __CPD02
	BRLT _0x200000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0005
_0x200000C:
	CALL SUBOPT_0x47
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x48
	CALL SUBOPT_0x46
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x200000D
	CALL SUBOPT_0x49
	CALL __ADDF12
	CALL SUBOPT_0x48
	__SUBWRN 16,17,1
_0x200000D:
	CALL SUBOPT_0x4A
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4A
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x48
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
	__GETD2N 0x3F654226
	CALL SUBOPT_0x4C
	__GETD1N 0x4054114E
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x46
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4E
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
_0x20C0005:
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
	CALL SUBOPT_0x4F
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x200000F
	CALL SUBOPT_0x50
	RJMP _0x20C0004
_0x200000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2000010
	__GETD1N 0x3F800000
	RJMP _0x20C0004
_0x2000010:
	CALL SUBOPT_0x4F
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0004
_0x2000011:
	CALL SUBOPT_0x4F
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL SUBOPT_0x4F
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x4F
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x4D
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x48
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x46
	CALL __MULF12
	CALL SUBOPT_0x48
	CALL SUBOPT_0x4E
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x47
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x46
	CALL SUBOPT_0x4E
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x20C0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x51
	CALL __CPD10
	BRNE _0x2000012
	CALL SUBOPT_0x50
	RJMP _0x20C0002
_0x2000012:
	CALL SUBOPT_0x52
	CALL __CPD02
	BRGE _0x2000013
	CALL SUBOPT_0x53
	CALL __CPD10
	BRNE _0x2000014
	__GETD1N 0x3F800000
	RJMP _0x20C0002
_0x2000014:
	CALL SUBOPT_0x52
	CALL SUBOPT_0x54
	RCALL _exp
	RJMP _0x20C0002
_0x2000013:
	CALL SUBOPT_0x53
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x44
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x53
	CALL __CPD12
	BREQ _0x2000015
	CALL SUBOPT_0x50
	RJMP _0x20C0002
_0x2000015:
	CALL SUBOPT_0x51
	CALL SUBOPT_0x55
	CALL SUBOPT_0x54
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2000016
	CALL SUBOPT_0x51
	RJMP _0x20C0002
_0x2000016:
	CALL SUBOPT_0x51
	CALL __ANEGF1
	RJMP _0x20C0002
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x53
	CALL SUBOPT_0x56
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x57
	CALL SUBOPT_0x56
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x44
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x58
	CALL SUBOPT_0x57
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
	CALL SUBOPT_0x42
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2000020
	CALL SUBOPT_0x58
	RCALL _xatan
	RJMP _0x20C0003
_0x2000020:
	CALL SUBOPT_0x58
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	CALL SUBOPT_0x45
	CALL SUBOPT_0x59
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x4D
	RJMP _0x20C0003
_0x2000021:
	CALL SUBOPT_0x45
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x45
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x59
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
	CALL SUBOPT_0x53
	CALL __CPD10
	BRNE _0x200002D
	CALL SUBOPT_0x51
	CALL __CPD10
	BRNE _0x200002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0002
_0x200002E:
	CALL SUBOPT_0x52
	CALL __CPD02
	BRGE _0x200002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0002
_0x200002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0002
_0x200002D:
	CALL SUBOPT_0x53
	CALL SUBOPT_0x52
	CALL __DIVF21
	CALL SUBOPT_0x43
	__GETD2S 4
	CALL __CPD02
	BRGE _0x2000030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000031
	CALL SUBOPT_0x58
	RCALL _yatan
	RJMP _0x20C0002
_0x2000031:
	CALL SUBOPT_0x44
	CALL SUBOPT_0x55
	RCALL _yatan
	CALL __ANEGF1
	RJMP _0x20C0002
_0x2000030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000032
	CALL SUBOPT_0x44
	CALL SUBOPT_0x55
	RCALL _yatan
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x4D
	RJMP _0x20C0002
_0x2000032:
	CALL SUBOPT_0x58
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
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x5A
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x5A
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
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x202000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x202000B
_0x202000D:
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
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5B
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
_front_distance:
	.BYTE 0x2
_back_distance:
	.BYTE 0x2
_kick_sen:
	.BYTE 0x2
_is_ball:
	.BYTE 0x2
_turn_back:
	.BYTE 0x2
_LDR_R:
	.BYTE 0x2
_LDR_L:
	.BYTE 0x2
_set_r:
	.BYTE 0x2
_set_l:
	.BYTE 0x2
_last_out:
	.BYTE 0x2
_out_cnt:
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDS  R26,_x
	LDS  R27,_x+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
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
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
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
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDS  R26,_y
	LDS  R27,_y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDS  R26,_front_distance
	LDS  R27,_front_distance+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDS  R26,_back_distance
	LDS  R27,_back_distance+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	STS  _checksum,R30
	STS  _checksum+1,R31
	JMP  _read

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9:
	CALL _read
	LDI  R26,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDS  R26,_signature
	LDS  R27,_signature+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB:
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
SUBOPT_0xC:
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
SUBOPT_0xD:
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
SUBOPT_0xE:
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDS  R30,_ball_angle
	LDS  R31,_ball_angle+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xF
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	__GETD1N 0x41340000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__GETD1N 0x43AE4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x11
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14:
	MOVW R30,R10
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x41B40000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	MOVW R30,R10
	ADIW R30,1
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x41B40000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	CALL __PUTPARD1
	__GETD2N 0x40000000
	JMP  _pow

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
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
SUBOPT_0x19:
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
SUBOPT_0x1A:
	LDS  R30,_goal_angle
	LDS  R31,_goal_angle+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x1A
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x29:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	LDS  R30,_turn_back
	LDS  R31,_turn_back+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDS  R26,_LDR_L
	LDS  R27,_LDR_L+1
	SBIW R26,61
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	STS  _last_out,R30
	STS  _last_out+1,R31
	CLR  R12
	CLR  R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(4)
	LDI  R27,0
	JMP  _move

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  _out_cnt,R30
	STS  _out_cnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x30:
	LDS  R26,_ball
	LDS  R27,_ball+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x31:
	LDS  R30,_is_ball
	LDS  R31,_is_ball+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	CALL _read_sensor
	JMP  _read_pixy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	LDS  R26,_LDR_R
	LDS  R27,_LDR_R+1
	SBIW R26,61
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x35:
	CLR  R12
	CLR  R13
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	MOVW R8,R30
	LDS  R26,_kick_sen
	LDS  R27,_kick_sen+1
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	LDS  R30,_ball
	LDS  R31,_ball+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _move

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDS  R26,_kick_sen
	LDS  R27,_kick_sen+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(8)
	LDI  R27,0
	JMP  _move

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3C:
	CALL _read_sensor
	RCALL SUBOPT_0x3A
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	LDS  R26,_goal
	LDS  R27,_goal+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	LDI  R30,LOW(65416)
	LDI  R31,HIGH(65416)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(65456)
	LDI  R31,HIGH(65456)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x44:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x45:
	RCALL SUBOPT_0x44
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x46:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x47:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	RCALL SUBOPT_0x47
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0x47
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4D:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4F:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x53:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	CALL _log
	__GETD2S 4
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	__GETD2S 4
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5B:
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
