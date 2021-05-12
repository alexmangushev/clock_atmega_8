
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 4,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF _hour=R5
	.DEF _min=R4
	.DEF _sec=R7
	.DEF _ukd=R6
	.DEF _hour1=R9
	.DEF _min1=R8
	.DEF _ukd1=R11
	.DEF _charge=R10
	.DEF _menu=R13
	.DEF _timelight=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _customization
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _time
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_chis:
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39
_char0:
	.DB  0xE,0x11,0x11,0x11,0x11,0x1F,0x1F,0x1F
_char1:
	.DB  0xE,0x11,0x11,0x1F,0x1F,0x1F,0x1F,0x1F
_char2:
	.DB  0xE,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0014

_0x3:
	.DB  0xA
_0x4:
	.DB  LOW(_0x0*2),HIGH(_0x0*2),LOW(_0x0*2+7),HIGH(_0x0*2+7),LOW(_0x0*2+15),HIGH(_0x0*2+15),LOW(_0x0*2+25),HIGH(_0x0*2+25)
	.DB  LOW(_0x0*2+34),HIGH(_0x0*2+34),LOW(_0x0*2+41),HIGH(_0x0*2+41),LOW(_0x0*2+50),HIGH(_0x0*2+50)
_0x72:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x4D,0x6F,0x6E,0x64,0x61,0x79,0x0,0x54
	.DB  0x75,0x65,0x73,0x64,0x61,0x79,0x0,0x57
	.DB  0x65,0x64,0x6E,0x65,0x73,0x64,0x61,0x79
	.DB  0x0,0x54,0x68,0x75,0x72,0x73,0x64,0x61
	.DB  0x79,0x0,0x46,0x72,0x69,0x64,0x61,0x79
	.DB  0x0,0x53,0x61,0x74,0x75,0x72,0x64,0x61
	.DB  0x79,0x0,0x53,0x75,0x6E,0x64,0x61,0x79
	.DB  0x0,0x3A,0x0,0x4F,0x4E,0x0,0x4F,0x46
	.DB  0x46,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0E
	.DW  _dday
	.DW  _0x4*2

	.DW  0x02
	.DW  _0x1C
	.DW  _0x0*2+57

	.DW  0x02
	.DW  _0x1C+2
	.DW  _0x0*2+57

	.DW  0x02
	.DW  _0x1E
	.DW  _0x0*2+57

	.DW  0x0A
	.DW  0x04
	.DW  _0x72*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Project : clock
;Version : 1
;Date    : 22.07.2019
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 4,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;
;const unsigned char time_backlight=10;

	.DSEG
;
;
;typedef unsigned char byte;
;
;register unsigned char hour=0 ,min=0, sec=0, ukd=0, hour1=0, min1=0,
;ukd1=0, charge=0, menu=0,timelight;
;
;register bit clockon=0,on=0,light=1,menustart=0,show=1;
;
;flash unsigned char chis[10]={48,49,50,51,52,53,54,55,56,57};
;
;flash unsigned char *dday[7]={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"};
;
;flash byte char0[8] = {
;	0b01110,
;	0b10001,
;	0b10001,
;	0b10001,
;	0b10001,
;	0b11111,
;	0b11111,
;	0b11111
;};
;//заряд мало
;
;flash byte char1[8] = {
;	0b01110,
;	0b10001,
;	0b10001,
;	0b11111,
;	0b11111,
;	0b11111,
;	0b11111,
;	0b11111
;};
;//заряд средне
;
;flash byte char2[8] = {
;	0b01110,
;	0b11111,
;	0b11111,
;	0b11111,
;	0b11111,
;	0b11111,
;	0b11111,
;	0b11111
;};
;//заряд много
;
;
;void define_char(byte flash *pc,byte char_code)
; 0000 0045 {

	.CSEG
_define_char:
; 0000 0046   byte i,a;
; 0000 0047   a=(char_code<<3)|0x40;
	RCALL __SAVELOCR2
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 0048   for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
	LDI  R17,LOW(0)
_0x6:
	CPI  R17,8
	BRSH _0x7
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	RCALL SUBOPT_0x0
	RCALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0x6
_0x7:
; 0000 0049 }
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
;
;unsigned char EncoderScan(unsigned char a)
; 0000 004C {
_EncoderScan:
; 0000 004D     if (PINB.1==0)
;	a -> Y+0
	SBIC 0x16,1
	RJMP _0x8
; 0000 004E     {
; 0000 004F         while (PINB.1==0) {}
_0x9:
	SBIS 0x16,1
	RJMP _0x9
; 0000 0050         while (PINB.2==0) {}
_0xC:
	SBIS 0x16,2
	RJMP _0xC
; 0000 0051         if ((PINB.2==1) && (PINB.1==1)) a++;
	SBIS 0x16,2
	RJMP _0x10
	SBIC 0x16,1
	RJMP _0x11
_0x10:
	RJMP _0xF
_0x11:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0052     }
_0xF:
; 0000 0053 
; 0000 0054      if (PINB.2==0)
_0x8:
	SBIC 0x16,2
	RJMP _0x12
; 0000 0055     {
; 0000 0056         while (PINB.2==0) {}
_0x13:
	SBIS 0x16,2
	RJMP _0x13
; 0000 0057         while (PINB.1==0) {}
_0x16:
	SBIS 0x16,1
	RJMP _0x16
; 0000 0058         if ((PINB.2==1) && (PINB.1==1)) a--;
	SBIS 0x16,2
	RJMP _0x1A
	SBIC 0x16,1
	RJMP _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
; 0000 0059     }
_0x19:
; 0000 005A     return a;
_0x12:
	LD   R30,Y
	RJMP _0x2020001
; 0000 005B }
;//обработка энкодера
;
;void write(void)
; 0000 005F {
_write:
; 0000 0060    lcd_clear();
	RCALL _lcd_clear
; 0000 0061    lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x1
; 0000 0062    lcd_putchar(chis[hour/10]);
	RCALL SUBOPT_0x2
	RCALL _lcd_putchar
; 0000 0063    lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x1
; 0000 0064    lcd_putchar(chis[hour%10]);
	RCALL SUBOPT_0x3
	RCALL _lcd_putchar
; 0000 0065    lcd_gotoxy(6,0);
	RCALL SUBOPT_0x4
; 0000 0066    lcd_puts(":");
	__POINTW1MN _0x1C,0
	RCALL SUBOPT_0x5
; 0000 0067    lcd_gotoxy(7,0);
	RCALL SUBOPT_0x6
; 0000 0068    lcd_putchar(chis[min/10]);
	MOV  R26,R4
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x7
; 0000 0069    lcd_gotoxy(8,0);
; 0000 006A    lcd_putchar(chis[min%10]);
	MOV  R26,R4
	RCALL SUBOPT_0x3
	RCALL _lcd_putchar
; 0000 006B    lcd_gotoxy(9,0);
	RCALL SUBOPT_0x8
; 0000 006C    lcd_puts(":");
	__POINTW1MN _0x1C,2
	RCALL SUBOPT_0x5
; 0000 006D    lcd_gotoxy(10,0);
	RCALL SUBOPT_0x9
; 0000 006E    lcd_putchar(chis[sec/10]);
	MOV  R26,R7
	RCALL SUBOPT_0x2
	RCALL _lcd_putchar
; 0000 006F    lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	RCALL SUBOPT_0xA
; 0000 0070    lcd_putchar(chis[sec%10]);
	MOV  R26,R7
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xB
; 0000 0071    lcd_gotoxy(0,1);
; 0000 0072    lcd_putsf(dday[ukd]);
	MOV  R30,R6
	RCALL SUBOPT_0xC
; 0000 0073    if (menustart) {
	SBRS R2,3
	RJMP _0x1D
; 0000 0074      lcd_gotoxy(15,0);
	LDI  R30,LOW(15)
	RCALL SUBOPT_0xA
; 0000 0075      lcd_putchar(chis[menu%10]); }
	MOV  R26,R13
	RCALL SUBOPT_0x3
	RCALL _lcd_putchar
; 0000 0076    lcd_gotoxy(15,1);
_0x1D:
	RJMP _0x2020004
; 0000 0077    lcd_putchar(charge);
; 0000 0078    //wait();
; 0000 0079 }

	.DSEG
_0x1C:
	.BYTE 0x4
;// основной вывод на дисплей
;
;void write2(void)
; 0000 007D {

	.CSEG
_write2:
; 0000 007E    lcd_clear();
	RCALL _lcd_clear
; 0000 007F    lcd_gotoxy(6,0);
	RCALL SUBOPT_0x4
; 0000 0080    lcd_putchar(chis[hour1/10]);
	MOV  R26,R9
	RCALL SUBOPT_0x2
	RCALL _lcd_putchar
; 0000 0081    lcd_gotoxy(7,0);
	RCALL SUBOPT_0x6
; 0000 0082    lcd_putchar(chis[hour1%10]);
	MOV  R26,R9
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x7
; 0000 0083    lcd_gotoxy(8,0);
; 0000 0084    lcd_puts(":");
	__POINTW1MN _0x1E,0
	RCALL SUBOPT_0x5
; 0000 0085    lcd_gotoxy(9,0);
	RCALL SUBOPT_0x8
; 0000 0086    lcd_putchar(chis[min1/10]);
	MOV  R26,R8
	RCALL SUBOPT_0x2
	RCALL _lcd_putchar
; 0000 0087    lcd_gotoxy(10,0);
	RCALL SUBOPT_0x9
; 0000 0088    lcd_putchar(chis[min1%10]);
	MOV  R26,R8
	RCALL SUBOPT_0x3
	RCALL _lcd_putchar
; 0000 0089    lcd_gotoxy(15,0);
	LDI  R30,LOW(15)
	RCALL SUBOPT_0xA
; 0000 008A    lcd_putchar(chis[menu%10]);
	MOV  R26,R13
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xB
; 0000 008B    lcd_gotoxy(0,1);
; 0000 008C    lcd_putsf(dday[ukd1]);
	MOV  R30,R11
	RCALL SUBOPT_0xC
; 0000 008D    lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0xD
; 0000 008E    if (clockon) lcd_putsf("ON");
	SBRS R2,0
	RJMP _0x1F
	__POINTW1FN _0x0,59
	RJMP _0x6D
; 0000 008F    else  lcd_putsf("OFF");
_0x1F:
	__POINTW1FN _0x0,62
_0x6D:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_putsf
; 0000 0090    lcd_gotoxy(15,1);
_0x2020004:
	LDI  R30,LOW(15)
	RCALL SUBOPT_0xD
; 0000 0091    lcd_putchar(charge);
	ST   -Y,R10
	RCALL _lcd_putchar
; 0000 0092 }
	RET

	.DSEG
_0x1E:
	.BYTE 0x2
;// вывод в режиме настройки будильника
;interrupt [2] void customization(void)
; 0000 0095 {

	.CSEG
_customization:
	RCALL SUBOPT_0xE
; 0000 0096     if (light)
	SBRS R2,2
	RJMP _0x21
; 0000 0097     { light=0; timelight=sec+time_backlight;
	CLT
	BLD  R2,2
	MOV  R30,R7
	SUBI R30,-LOW(10)
	MOV  R12,R30
; 0000 0098       if (timelight>=60) timelight-=60;
	LDI  R30,LOW(60)
	CP   R12,R30
	BRLO _0x22
	MOV  R30,R12
	RCALL SUBOPT_0xF
	SBIW R30,60
	MOV  R12,R30
; 0000 0099       goto m1; }
_0x22:
	RJMP _0x23
; 0000 009A     else
_0x21:
; 0000 009B     {
; 0000 009C       if (on) { clockon=0; goto m1; }
	SBRS R2,1
	RJMP _0x25
	CLT
	BLD  R2,0
	RJMP _0x23
; 0000 009D       #asm("cli")
_0x25:
	cli
; 0000 009E       menu=0; menustart=1;
	CLR  R13
	SET
	BLD  R2,3
; 0000 009F       MCUCR=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00A0       GICR=0b00000000;
	OUT  0x3B,R30
; 0000 00A1       write();
	RCALL _write
; 0000 00A2       while(menu!=9)
_0x26:
	LDI  R30,LOW(9)
	CP   R30,R13
	BRNE PC+2
	RJMP _0x28
; 0000 00A3       {
; 0000 00A4         while (PINB.1==PINB.2)
_0x29:
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	LDI  R30,0
	SBIC 0x16,2
	LDI  R30,1
	CP   R30,R26
	BRNE _0x2B
; 0000 00A5         {
; 0000 00A6           if (PIND.2==0)
	SBIC 0x10,2
	RJMP _0x2C
; 0000 00A7            {
; 0000 00A8             while (PIND.2==0) {}
_0x2D:
	SBIS 0x10,2
	RJMP _0x2D
; 0000 00A9             menu++;
	INC  R13
; 0000 00AA             if (menu==2) #asm("sei")
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x30
	sei
; 0000 00AB             if (menu==5) show=0;
_0x30:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0x31
	CLT
	BLD  R2,4
; 0000 00AC             if (menu<=4) write();
_0x31:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRLO _0x32
	RCALL _write
; 0000 00AD             else write2();
	RJMP _0x33
_0x32:
	RCALL _write2
; 0000 00AE             if (menu>=9) goto m1;
_0x33:
	LDI  R30,LOW(9)
	CP   R13,R30
	BRLO _0x34
	RJMP _0x23
; 0000 00AF            }
_0x34:
; 0000 00B0         }
_0x2C:
	RJMP _0x29
_0x2B:
; 0000 00B1             switch (menu)
	MOV  R30,R13
	RCALL SUBOPT_0xF
; 0000 00B2             {
; 0000 00B3               case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x38
; 0000 00B4                {
; 0000 00B5                  sec=EncoderScan(sec);
	ST   -Y,R7
	RCALL _EncoderScan
	MOV  R7,R30
; 0000 00B6                  if (sec>=60) sec=0; write();
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0x39
	CLR  R7
_0x39:
	RCALL _write
; 0000 00B7                  break;
	RJMP _0x37
; 0000 00B8                }
; 0000 00B9               case 2:
_0x38:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3A
; 0000 00BA                {
; 0000 00BB                  min=EncoderScan(min);
	ST   -Y,R4
	RCALL _EncoderScan
	MOV  R4,R30
; 0000 00BC                  if (min>=60) min=0; write();
	LDI  R30,LOW(60)
	CP   R4,R30
	BRLO _0x3B
	CLR  R4
_0x3B:
	RCALL _write
; 0000 00BD                  break;
	RJMP _0x37
; 0000 00BE                }
; 0000 00BF               case 3:
_0x3A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3C
; 0000 00C0                {
; 0000 00C1                  hour=EncoderScan(hour);
	ST   -Y,R5
	RCALL _EncoderScan
	MOV  R5,R30
; 0000 00C2                  if (hour>=24) hour=0; write();
	LDI  R30,LOW(24)
	CP   R5,R30
	BRLO _0x3D
	CLR  R5
_0x3D:
	RCALL _write
; 0000 00C3                  break;
	RJMP _0x37
; 0000 00C4                }
; 0000 00C5               case 4:
_0x3C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3E
; 0000 00C6                {
; 0000 00C7                  ukd=EncoderScan(ukd);
	ST   -Y,R6
	RCALL _EncoderScan
	MOV  R6,R30
; 0000 00C8                  if (ukd>=7) ukd=0; write();
	LDI  R30,LOW(7)
	CP   R6,R30
	BRLO _0x3F
	CLR  R6
_0x3F:
	RCALL _write
; 0000 00C9                  break;
	RJMP _0x37
; 0000 00CA                }
; 0000 00CB               case 5:
_0x3E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x40
; 0000 00CC                {
; 0000 00CD                  min1=EncoderScan(min1);
	ST   -Y,R8
	RCALL _EncoderScan
	MOV  R8,R30
; 0000 00CE                  if (min1>=60) min1=0; write2();
	LDI  R30,LOW(60)
	CP   R8,R30
	BRLO _0x41
	CLR  R8
_0x41:
	RJMP _0x6E
; 0000 00CF                  break;
; 0000 00D0                }
; 0000 00D1               case 6:
_0x40:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x42
; 0000 00D2                {
; 0000 00D3                  hour1=EncoderScan(hour1);
	ST   -Y,R9
	RCALL _EncoderScan
	MOV  R9,R30
; 0000 00D4                  if (hour1>=24) hour1=0; write2();
	LDI  R30,LOW(24)
	CP   R9,R30
	BRLO _0x43
	CLR  R9
_0x43:
	RJMP _0x6E
; 0000 00D5                  break;
; 0000 00D6                }
; 0000 00D7               case 7:
_0x42:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x44
; 0000 00D8                {
; 0000 00D9                  ukd1=EncoderScan(ukd1);
	ST   -Y,R11
	RCALL _EncoderScan
	MOV  R11,R30
; 0000 00DA                  if (ukd1>=7) ukd1=0; write2();
	LDI  R30,LOW(7)
	CP   R11,R30
	BRLO _0x45
	CLR  R11
_0x45:
	RJMP _0x6E
; 0000 00DB                  break;
; 0000 00DC                }
; 0000 00DD               case 8:
_0x44:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x37
; 0000 00DE                {
; 0000 00DF                  clockon=EncoderScan(clockon);
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _EncoderScan
	RCALL __BSTB1
	BLD  R2,0
; 0000 00E0                  write2();
_0x6E:
	RCALL _write2
; 0000 00E1                  break;
; 0000 00E2                }
; 0000 00E3             }
_0x37:
; 0000 00E4 
; 0000 00E5       }
	RJMP _0x26
_0x28:
; 0000 00E6       }
; 0000 00E7 m1:
_0x23:
; 0000 00E8     #asm("sei")
	sei
; 0000 00E9     MCUCR=0b00000010;
	RCALL SUBOPT_0x10
; 0000 00EA     GICR=0b01000000;
; 0000 00EB     menustart=0; show=1;
	CLT
	BLD  R2,3
	SET
	BLD  R2,4
; 0000 00EC }
	RJMP _0x71
;// обработка настройки времени и будильника
;
;interrupt [7] void time(void)
; 0000 00F0 {
_time:
	RCALL SUBOPT_0xE
; 0000 00F1       sec++;
	INC  R7
; 0000 00F2       if(sec==60) {min++; sec=0;}
	LDI  R30,LOW(60)
	CP   R30,R7
	BRNE _0x47
	INC  R4
	CLR  R7
; 0000 00F3       if (min==60) {hour++; min=0;}
_0x47:
	LDI  R30,LOW(60)
	CP   R30,R4
	BRNE _0x48
	INC  R5
	CLR  R4
; 0000 00F4       if (hour==24) {ukd++; hour=0;}
_0x48:
	LDI  R30,LOW(24)
	CP   R30,R5
	BRNE _0x49
	INC  R6
	CLR  R5
; 0000 00F5       if (ukd==7) ukd=0;
_0x49:
	LDI  R30,LOW(7)
	CP   R30,R6
	BRNE _0x4A
	CLR  R6
; 0000 00F6       if (on)
_0x4A:
	SBRS R2,1
	RJMP _0x4B
; 0000 00F7       {
; 0000 00F8         if (TCCR2==0b00000000) TCCR2=0b00011111;
	IN   R30,0x25
	CPI  R30,0
	BRNE _0x4C
	LDI  R30,LOW(31)
	RJMP _0x6F
; 0000 00F9         else TCCR2=0b00000000;
_0x4C:
	LDI  R30,LOW(0)
_0x6F:
	OUT  0x25,R30
; 0000 00FA       }
; 0000 00FB       else TCCR2=0b00000000;
	RJMP _0x4E
_0x4B:
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 00FC       if (show) write();
_0x4E:
	SBRC R2,4
	RCALL _write
; 0000 00FD }
_0x71:
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
;// прерывание часов
;void main(void)
; 0000 0100 {
_main:
; 0000 0101 
; 0000 0102 PORTB=0b00000001;
	LDI  R30,LOW(1)
	OUT  0x18,R30
; 0000 0103 DDRB=0b00001001;
	LDI  R30,LOW(9)
	OUT  0x17,R30
; 0000 0104 
; 0000 0105 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0106 DDRC=0x00;
	OUT  0x14,R30
; 0000 0107 
; 0000 0108 PORTD=0x00;
	OUT  0x12,R30
; 0000 0109 DDRD=0x00;
	OUT  0x11,R30
; 0000 010A 
; 0000 010B //TCCR0=0b00000101;     //3906 Hz
; 0000 010C 
; 0000 010D TCCR1A=0b00000000;
	OUT  0x2F,R30
; 0000 010E TCCR1B=0b00001100;  //15625 Hz
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 010F TIMSK=0b00010000;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 0110 OCR1A=15623;
	LDI  R30,LOW(15623)
	LDI  R31,HIGH(15623)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0111 
; 0000 0112 TCCR2=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0113 OCR2=8;
	LDI  R30,LOW(8)
	OUT  0x23,R30
; 0000 0114 
; 0000 0115 MCUCR=0b00000010;      //power-save mod 1011
	RCALL SUBOPT_0x10
; 0000 0116 GICR=0b01000000;
; 0000 0117 
; 0000 0118 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0119 
; 0000 011A ADCSRA=0b00000101;  // /32, режим однократных измерений
	LDI  R30,LOW(5)
	OUT  0x6,R30
; 0000 011B ADMUX=0b01100101; //ADC5, старшие биты в ADCH, опорное - AVCC, C на AREF и GND
	LDI  R30,LOW(101)
	OUT  0x7,R30
; 0000 011C 
; 0000 011D lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 011E define_char(char0,0);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	RCALL SUBOPT_0x11
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _define_char
; 0000 011F define_char(char1,1);
	LDI  R30,LOW(_char1*2)
	LDI  R31,HIGH(_char1*2)
	RCALL SUBOPT_0x11
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _define_char
; 0000 0120 define_char(char2,2);
	LDI  R30,LOW(_char2*2)
	LDI  R31,HIGH(_char2*2)
	RCALL SUBOPT_0x11
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _define_char
; 0000 0121 #asm ("sei")
	sei
; 0000 0122 
; 0000 0123 while (1)
_0x50:
; 0000 0124       {
; 0000 0125         //write();      //PORTB.0 - подсветка
; 0000 0126         if ((!light) && (sec!=timelight))  PORTB.0=0;
	SBRC R2,2
	RJMP _0x54
	CP   R12,R7
	BRNE _0x55
_0x54:
	RJMP _0x53
_0x55:
	CBI  0x18,0
; 0000 0127         else { PORTB.0=1; light=1;}
	RJMP _0x58
_0x53:
	SBI  0x18,0
	SET
	BLD  R2,2
_0x58:
; 0000 0128         if ((clockon==1) && (ukd1==ukd) && (hour1==hour) && (min1==min)) on=1;
	SBRS R2,0
	RJMP _0x5C
	CP   R6,R11
	BRNE _0x5C
	CP   R5,R9
	BRNE _0x5C
	CP   R4,R8
	BREQ _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
	SET
	RJMP _0x70
; 0000 0129         else on=0;
_0x5B:
	CLT
_0x70:
	BLD  R2,1
; 0000 012A         if (sec%20==1) { ADCSRA.7=1; ADCSRA.6=1; }
	MOV  R26,R7
	CLR  R27
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL __MODW21
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5F
	SBI  0x6,7
	SBI  0x6,6
; 0000 012B         if (ADCSRA.4==1)
_0x5F:
	SBIS 0x6,4
	RJMP _0x64
; 0000 012C          {
; 0000 012D             if (ADCH<=183) { charge=0; on=1;} // U<3,49  (173)
	IN   R30,0x5
	CPI  R30,LOW(0xB8)
	BRSH _0x65
	CLR  R10
	SET
	BLD  R2,1
; 0000 012E             if ((ADCH>183) && (ADCH<210)) { charge=1; on=0; }  // 3,49<U<4,05
_0x65:
	IN   R30,0x5
	CPI  R30,LOW(0xB8)
	BRLO _0x67
	IN   R30,0x5
	CPI  R30,LOW(0xD2)
	BRLO _0x68
_0x67:
	RJMP _0x66
_0x68:
	LDI  R30,LOW(1)
	MOV  R10,R30
	CLT
	BLD  R2,1
; 0000 012F             if (ADCH>=210) {charge=2; on=0;}  // U>4,05         (200)
_0x66:
	IN   R30,0x5
	CPI  R30,LOW(0xD2)
	BRLO _0x69
	LDI  R30,LOW(2)
	MOV  R10,R30
	CLT
	BLD  R2,1
; 0000 0130             ADCSRA.7=0;
_0x69:
	CBI  0x6,7
; 0000 0131          }
; 0000 0132       }
_0x64:
	RJMP _0x50
; 0000 0133 }
_0x6C:
	RJMP _0x6C
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x15,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x15,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x15,2
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,2
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x15,1
	RJMP _0x2000009
_0x2000008:
	CBI  0x15,1
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x15,0
	RJMP _0x200000B
_0x200000A:
	CBI  0x15,0
_0x200000B:
	__DELAY_USB 3
	SBI  0x15,4
	__DELAY_USB 7
	CBI  0x15,4
	__DELAY_USB 7
	RJMP _0x2020001
__lcd_write_data:
	LD   R30,Y
	RCALL SUBOPT_0x12
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x12
	__DELAY_USB 67
	RJMP _0x2020001
_lcd_write_byte:
	LDD  R30,Y+1
	RCALL SUBOPT_0x13
	SBI  0x12,0
	LD   R30,Y
	RCALL SUBOPT_0x13
	CBI  0x12,0
	RJMP _0x2020003
_lcd_gotoxy:
	LD   R30,Y
	RCALL SUBOPT_0xF
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x13
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2020003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x13
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2020001
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x12,0
	LD   R30,Y
	RCALL SUBOPT_0x13
	CBI  0x12,0
	RJMP _0x2020001
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	RJMP _0x2020002
_lcd_putsf:
	ST   -Y,R17
_0x2000017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000017
_0x2000019:
_0x2020002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x14,3
	SBI  0x14,2
	SBI  0x14,1
	SBI  0x14,0
	SBI  0x14,4
	SBI  0x11,0
	SBI  0x11,1
	CBI  0x15,4
	CBI  0x12,0
	CBI  0x12,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x11
	RCALL _delay_ms
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x15
	__DELAY_USB 133
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x12
	__DELAY_USB 133
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x13
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x13
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x13
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x13
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET

	.DSEG
_dday:
	.BYTE 0xE
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	LPM  R30,Z
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _lcd_gotoxy
	MOV  R26,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x2:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	SUBI R30,LOW(-_chis*2)
	SBCI R31,HIGH(-_chis*2)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x3:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,LOW(-_chis*2)
	SBCI R31,HIGH(-_chis*2)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	RCALL _lcd_putchar
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	RCALL _lcd_putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_dday)
	LDI  R27,HIGH(_dday)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xE:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(2)
	OUT  0x35,R30
	LDI  R30,LOW(64)
	OUT  0x3B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x11
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	__DELAY_USB 133
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x12


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x3E8
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
