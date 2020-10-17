;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;Microvid Aumento de frecuencia F2
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
PROCESSOR 16F887
    #include <xc.inc>
    ;configuración de los fuses
    CONFIG FOSC=INTRC_NOCLKOUT
    CONFIG WDTE=OFF
    CONFIG PWRTE=ON
    CONFIG MCLRE=OFF
    CONFIG CP=OFF
    CONFIG CPD=OFF
    CONFIG BOREN=OFF                ;Fuses
    CONFIG IESO=OFF
    CONFIG FCMEN=OFF
    CONFIG LVP=OFF
    CONFIG DEBUG=ON
    
    
    CONFIG BOR4V=BOR40V
    CONFIG WRT=OFF
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    PSECT udata
 tick:
    DS 1
 counter:
    DS 1
 counter2:
    DS 1
   
    PSECT code
    delay:                       ;Delay
    movlw 0xFF
    movwf counter
    counter_loop:
    movlw 0xFF
    movwf tick
    tick_loop:
    decfsz tick,f
    goto tick_loop
    decfsz counter,f
    goto counter_loop
    return
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$    
PSECT resetVec,class=CODE,delta=2
	PAGESEL main
	goto main
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$	
PSECT isr,class=CODE,delta=2
isr8:
BANKSEL PORTB
btfss PORTB,6
goto isr7
bcf INTCON,0
BANKSEL OSCCON
movlw 0b01100101             ;4Mhz  RB6
movwf OSCCON
retfie
    
isr7:
BANKSEL PORTB
btfss PORTB,5
goto isr6
bcf INTCON,0
BANKSEL OSCCON
movlw 0b01010101             ;2Mhz  RB5
movwf OSCCON
retfie
    
isr6:
BANKSEL PORTB
btfss PORTB,4
goto isr5
bcf INTCON,0
BANKSEL OSCCON
movlw 0b01000101             ;1Mhz   RB4
movwf OSCCON
retfie
    
isr5:
BANKSEL PORTB
btfss PORTB,3
goto isr4
bcf INTCON,0
BANKSEL OSCCON
movlw 0b00110101             ;500khz  RB3
movwf OSCCON
retfie
	
isr4:
BANKSEL PORTB
btfss PORTB,2
goto isr3
bcf INTCON,0
BANKSEL OSCCON
movlw 0b00100101             ;250kHz   RB2
movwf OSCCON
retfie
    
isr3:
BANKSEL PORTB
btfss PORTB,1
goto isr2
bcf INTCON,0
BANKSEL OSCCON
movlw 0b00010101              ;125kHz  RB1
movwf OSCCON
retfie
isr2:
   BANKSEL PORTB
   btfss PORTB,0
   goto isr
     bcf INTCON,0
     BANKSEL OSCCON
     movlw 0b00000011          ;31kHz   RB0
     movwf OSCCON
   retfie

isr:
    btfss INTCON,0
    retfie
    bcf INTCON,0
    BANKSEL PORTB
    btfss PORTB,7
    retfie
    BANKSEL OSCCON
    movlw 0b01110101     ; se pone a 8Mhz, RB7       trabaja con el interno y es el alto es decir trabaja con el reloj interno y en alta frecuencia y este mismo se utiliza como reloj interno
    movwf OSCCON
    BANKSEL PORTC
    movlw 0b10000000
    movwf PORTC
    BANKSEL PORTA
    retfie
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$	
PSECT main,class=CODE,delta=2
main:
    ;//////////////////////////////////////////
    clrf INTCON
    movlw 0b10001000    ;Activamos INTCON
    movwf INTCON
    ;//////////////////////////////////////////
    BANKSEL OSCCON
    movlw 0b01100101     ; se pone a 8Mhz, trabaja con el interno y es el alto es decir trabaja con el reloj interno y en alta frecuencia y este mismo se utiliza como reloj interno
    movwf OSCCON
    ;////////////////////////////////////////////
    BANKSEL PORTB
    clrf    PORTB
    BANKSEL TRISB      ;limpia PORTB y configura todos los pines como entrada
    movlw   0xFF         ;
    movwf   TRISB
    ;//////////////////////////////////////////
    BANKSEL ANSELH
    CLRF ANSELH
    ;//////////////////////////////////////////7
   BANKSEL WPUB
   movlw 0x00
   movwf WPUB
    ;///////////////////////////////////////////7

    ;/////////////////////////////////////////
    BANKSEL IOCB
    movlw 0xFF
    movwf IOCB
    ;//////////////////////////7777
    BANKSEL PORTC
	clrf PORTC    ;limpia PORTc y configura todos los pines como SALIDA
    BANKSEL TRISC
	clrf TRISC
    ;////////////////////////////////////////////
    BANKSEL ANSEL
    movlw   0x00         ;desactiva la entrada analogica y permite la entrada de una funcion especial
    movwf   ANSEL
    ;///////////////////////////////////////////
    BANKSEL PORTA  ;limpia el porta 
    clrf    PORTA
    BANKSEL TRISA   ; coloca el TRISA como salida
    clrf    TRISA
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    loop:
    BANKSEL PORTA   ;seleccionamos porta
    call delay      ;llamamos la instruccion delay
    movlw 0x01                                                 ;Ciclo
    xorwf PORTA     ;hace la operacion or compara w con porta en el bit 0 y luego lo guarda en f para una comparacion futura
    goto loop
    END