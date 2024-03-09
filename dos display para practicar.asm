;------------------------------------------------------------------------------------
;CONTADOR BINARIO 
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
LIST p=16F877
INCLUDE <P16F877.INC>

ORG 0x00 ;Inicio de programa
UNIDADES EQU 0x20 ;usamos la dirección de memoria 23  
DECENAS  EQU 0x21 ;Usamos la direccion de memoria 24

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
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;INICIALIZACION EN CEROS DE MIS VARIABLES
MOVLW b'00000000' ;inicializar variable UNIDADES en ceros
MOVWF UNIDADES
MOVLW b'00000000' ;inicializar variable DECENAS en ceros
MOVWF DECENAS
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;MOSTRAR EL "CERO" INICIAL EN AMBOS DISPLAY AL INICIAR EL PROGRAMA
MOVLW b'00111111' ;Dibujar Cero en el display
MOVWF PORTD ;Mostrar dicho CERO en display del puerto D
MOVWF PORTC ;Mostrar dicho CERO en display del puerto C
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UNIDADES_CICLO
BTFSS PORTB,0 ;checar que el BIT 0 este prendido (boton presionado)
goto $-1
BTFSC PORTB,0 ;checar que el bit 0 este apagado (boton liberado)
GOTO $-1

INCF UNIDADES,1 ;Incrementar en 1 y almacenarlo en la misma variable UNIDADES
MOVF UNIDADES,W ;copiar registro DATO a registro W
CALL TABLA_UNIDADES
MOVWF PORTD
GOTO UNIDADES_CICLO


REINICIAR_UNIDADES
MOVLW b'00000000' ;reiniciar en ceros variable UNIDADES
MOVWF UNIDADES
MOVLW b'00111111' ;dibujar Cero en display nuevamente
MOVWF PORTD

INCF DECENAS,1 ;incrementar en 1 variable DECENAS
MOVF DECENAS,W ;mover 00000001,00000010,00000011... etc a W
CALL TABLA_DECENAS ;llamar a Tabla Decenas... para desplegar la decena correspondiente
MOVWF PORTC ;moverlo al PUERTO C encargado de las DECENAS
GOTO UNIDADES_CICLO


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;PCL (Program Counter Low)
TABLA_UNIDADES
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
GOTO REINICIAR_UNIDADES ;DIEZ


TABLA_DECENAS
ADDWF PCL,F ;Suma el contenido del Registro W a PCL y el resultado se almacena en el mismo registro (PCL)
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





END ;DELIMITADOR FIN DEL PROGRAMA

