; PIC16F628A Configuration Bit Settings
; ASM source line config statements
#include "p16F628A.inc"

; CONFIG
; __config 0xFF18
 __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

    ORG 0x0000

ia  EQU b'00000011'
x   EQU 0x20    
var EQU 0x21
var2    EQU 0x22
n   EQU d'28'
m   EQU d'245'

    BANKSEL TRISA
    MOVLW   0x07 ;Turn comparators off and
    MOVWF   CMCON

    MOVLW   ia
    MOVWF   TRISA

    BANKSEL PORTA

    CLRF    PORTA
    CLRF    var

resetX: MOVLW   0x00
    MOVWF   x
    GOTO    delay

inc:    INCF    x
    GOTO    delay

loop:   BTFSS   PORTA, RA0
    GOTO    resetX  
    BTFSS   PORTA, RA1
    GOTO    inc
    GOTO    loop

delay:  MOVLW   n
    MOVWF   var 
count:  DECFSZ  var
    GOTO    delay2
    GOTO    loop

delay2: MOVLW   m
    MOVWF   var2    
count2: DECFSZ  var2
    GOTO    count2
    GOTO    count


    END
