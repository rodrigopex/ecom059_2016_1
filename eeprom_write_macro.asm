; PIC16F628A Configuration Bit Settings

; ASM source line config statements

#include "p16F628A.inc"

; CONFIG
; __config 0xFF18
 __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

SETBANK		macro bank
		if bank == 0
		    BANKSEL	PORTA
		else
		    BANKSEL	EECON1
		endif
		endm

		cblock 0x20
		size, count
		endc

		ORG	0x0000
		GOTO	setup

		ORG	0x0004
		SETBANK	0
		BTFSS	PIR1, EEIF
		GOTO	isr_exit
		INCF	count, F
		BCF	PIR1, EEIF
isr_exit:
		RETFIE

writeEEByte:
		MOVF	count, W
		BANK1
		MOVWF	EEADR
		MOVLW	h'AF'
		MOVWF	EEDATA

		BSF	EECON1, WREN
		BCF	INTCON, GIE
		BTFSC	INTCON,GIE
		GOTO	$ - 2
		MOVLW	h'55'
		MOVWF	EECON2
		MOVLW	h'AA'
		MOVWF	EECON2
		BSF	EECON1,WR
		BSF	INTCON, GIE
		BCF	EECON1, WREN
		RETURN

setup:
		CLRF	count
		MOVLW	h'7A'
		MOVWF	count
		MOVLW	b'11000000'
		MOVWF	INTCON
		BANK1
		BSF	PIE1, EEIE

		BANK0
		CALL	writeEEByte
		NOP
		GOTO	$ - 2

		END
