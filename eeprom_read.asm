; PIC16F628A Configuration Bit Settings

; ASM source line config statements

#include "p16F628A.inc"

; CONFIG
; __config 0xFF18
 __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
	    
	    ORG	    0x0000	   
total	    EQU	    h'20'
count	    EQU	    h'21'
	    
	    GOTO    setup		
	    ORG	    0x0004
	    RETFIE
	    
readEEByte:   
	    BANKSEL EEADR
	    MOVWF   EEADR
	    BSF	    EECON1, RD
	    MOVF    EEDATA, W
	    BANKSEL PORTA
	    RETURN

readEEData:	    
	    MOVLW   h'22'
	    MOVWF   FSR
	    CLRF    count	    
readLoop:
	    INCF    count
	    MOVF    count, W
	    CALL    readEEByte
	    MOVWF   INDF
	    INCF    FSR	    
	    MOVF    count, W    
	    SUBWF   total, W	    
	    BTFSS   STATUS, Z
	    GOTO    readLoop
	    RETURN
	    
	    
setup:
	    BANKSEL PORTA	    
	    MOVLW   h'20'
	    MOVWF   FSR
	    MOVLW   00
	    CALL    readEEByte
	    MOVWF   INDF
	    CALL    readEEData
	    
loop:
	    GOTO    loop

	    ORG	    0x2100	    
	    DE	    0x0B, "Hello World"
	    
	    END

