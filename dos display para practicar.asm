;------------------------------------------------------------------------------------
;CONTADOR BINARIO 
;------------------------------------------------------------------------------------
LIST p=16F877
INCLUDE <P16F877.INC>

ORG 0x00 ;Inicio de programa
DATO EQU 0x20 ;usamos la dirección de memoria 23   

CLRF PORTB ;limpiar registro PORTB
CLRF PORTD ;limpiar registro PORTD

BSF STATUS,RP0  ;Acceder al banco 1 puesto que en el banco 1 se encuentran los registros TRISB,TRISD
				;BANC0 0 | RP0= 0 , RP1= 0
				;BANCO 1 | RP0= 1 , RP1= 0

MOVLW b'11111111' ;establecer todos los pines de puerto B como ENTRADA (recibirán valores desde el exterior)
MOVWF TRISB

MOVLW b'00000000' ;establecer todos los pines de puerto D como SALIDA (Serán manipulados desde dentro)
MOVWF TRISD

BCF STATUS,RP0 ;limpiar RP0 para regresar al BANCO 0.


MOVLW b'00000000' ;inicializar variable DATO en ceros
MOVWF DATO



MOVF DATO,W ;mover 00000000 a W
CALL TABLA;llamar a subrutina
MOVWF PORTD

INICIO
BTFSS PORTB,0 ;checar que el BIT 0 este prendido (boton presionado)
goto $-1
BTFSC PORTB,0 ;checar que el bit 0 este apagado (boton liberado)
GOTO $-1

INCF DATO,1 ;Incrementar en 1 y almacenarlo en la misma variable DATO
MOVF DATO,W ;copiar registro DATO a registro W
CALL TABLA
MOVWF PORTD

GOTO INICIO


APAGADO
MOVLW b'00000000'
MOVWF PORTD
BTFSS PORTB,0
GOTO $-1
BTFSC PORTB,0
GOTO $-1
GOTO INICIO
	
	
;PCL (Program Counter Low)
TABLA
ADDWF PCL,F ;Suma el contenido del Registro W a PCL y el resultado se almacena en el mismo registro (PCL).
RETLW b'00111111'     ;CERO
RETLW b'00000110' 	  ;UNO
RETLW b'01011011' 	  ;DOS
RETLW b'01001111' 	  ;TRES
RETLW b'01100110'	  ;CUATRO
RETLW b'01101101' 	  ;CINCO
RETLW b'01111101' 	  ;SEIS
RETLW b'00000111'	  ;SIETE
RETLW b'01111111' 	  ;OCHO
RETLW b'01100111'	  ;NUEVE
GOTO APAGADO

TABLA_DOS
RETLW b'00111111'     ;CERO
RETLW b'00000110' 	  ;UNO
RETLW b'01011011' 	  ;DOS
RETLW b'01001111' 	  ;TRES
RETLW b'01100110'	  ;CUATRO
RETLW b'01101101' 	  ;CINCO
RETLW b'01111101' 	  ;SEIS
RETLW b'00000111'	  ;SIETE
RETLW b'01111111' 	  ;OCHO
RETLW b'01100111'	  ;NUEVE


END

;00001001 NUEVE
;00001010 DIEZ