;------------------------------------------------------------------------------------
;CONTADOR BINARIO 
;------------------------------------------------------------------------------------
LIST p=16F877
INCLUDE <P16F877.INC>

ORG 0x00 ;Inicio de programa
DATO EQU 0x20 ;usamos la dirección de memoria 23  
DECENAS EQU 0x21 ;Usamos la direccion de memoria 24

CLRF PORTC ;limpiar registro PORTC
CLRF PORTB ;limpiar registro PORTB
CLRF PORTD ;limpiar registro PORTD

BSF STATUS,RP0  ;Acceder al banco 1 puesto que en el banco 1 se encuentran los registros TRISB,TRISD
				;BANC0 0 | RP0= 0 , RP1= 0
				;BANCO 1 | RP0= 1 , RP1= 0

MOVLW b'11111111' ;establecer todos los pines de puerto B como ENTRADA (recibirán valores desde el exterior)
MOVWF TRISB
MOVLW b'00000000' ;establecer todos los pines de puerto D como SALIDA (Serán manipulados desde dentro)
MOVWF TRISD
MOVLW b'00000000' ;establecer todos los pines del puerto C como SALIDA (Serán manipulados desde dentro)
MOVWF TRISC

BCF STATUS,RP0 ;limpiar RP0 para regresar al BANCO 0.



;INICIALIZACION EN CEROS DE MIS VARIABLES
MOVLW b'00000000' ;inicializar variable DATO en ceros
MOVWF DATO
MOVLW b'00000000' ;inicializar variable DECENAS en ceros
MOVWF DECENAS
;--------------------------------------------------------


;Instruccion para que al correr el programa comience mostrando el CERO INICIAL.
MOVLW b'00111111' ;Dibujar Cero en el display
MOVWF PORTD ;Mostrar dicho CERO en display del puerto D
MOVWF PORTC ;Mostrar dicho CERO en display del puerto C


UNIDADES
BTFSS PORTB,0 ;checar que el BIT 0 este prendido (boton presionado)
goto $-1
BTFSC PORTB,0 ;checar que el bit 0 este apagado (boton liberado)
GOTO $-1

INCF DATO,1 ;Incrementar en 1 y almacenarlo en la misma variable DATO
MOVF DATO,W ;copiar registro DATO a registro W
CALL TABLA_UNIDADES
MOVWF PORTD
GOTO UNIDADES




	
;PCL (Program Counter Low)
TABLA_UNIDADES
ADDWF PCL,F ;Suma el contenido del Registro W a PCL y el resultado se almacena en el mismo registro (PCL).
RETLW b'001111111';CERO ;Cuando cumple la ultima instruccion que es "NUEVE", se regresa aqui que seria el 10 (1 en  el display de Decenas)
RETLW b'00000110' 	  ;UNO
RETLW b'01011011' 	  ;DOS
RETLW b'01001111' 	  ;TRES
RETLW b'01100110'	  ;CUATRO
RETLW b'01101101' 	  ;CINCO
RETLW b'01111101' 	  ;SEIS
RETLW b'00000111'	  ;SIETE
RETLW b'01111111' 	  ;OCHO
RETLW b'01100111'	  ;NUEVE
RETURN





;---------------------------------------------------------------------------------------------
END ;DELIMITADOR FIN DEL PROGRAMA

