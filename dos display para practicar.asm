;------------------------------------------------------------------------------------
;CONTADOR BINARIO 
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
LIST p=16F877
INCLUDE <P16F877.INC>

ORG 0x00 ;Inicio de programa
UNIDADES EQU 0x20 ;usamos la dirección de memoria 23  
DECENAS  EQU 0x21 ;Usamos la direccion de memoria 24
CONTADOR0 EQU 0x22
CONTADOR1 EQU 0x23
CONTADOR2 EQU 0x24 
CENTENAS EQU 0x25

CLRF PORTC ;limpiar registro PORTC
CLRF PORTB ;limpiar registro PORTB
CLRF PORTD ;limpiar registro PORTD

BSF STATUS,RP0  ;Acceder al banco 1 puesto que en el banco 1 se encuentran los registros TRISB,TRISD
				;BANC0 0 | RP0= 0 , RP1= 0
				;BANCO 1 | RP0= 1 , RP1= 0

MOVLW b'10000000' ;establecer el pin 7 como Entrada, todos los demas como SALIDA
MOVWF TRISB
MOVLW b'00000000' ;establecer todos los pines de puerto D como SALIDA (Serán manipulados desde dentro)
MOVWF TRISD
MOVLW b'00000000' ;establecer todos los pines del puerto C como SALIDA (Serán manipulados desde dentro)
MOVWF TRISC

BCF STATUS,RP0 ;limpiar RP0 para regresar al BANCO 0.
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BTFSS PORTB,7
GOTO $-1
BTFSC PORTB,7
GOTO $-1

INICIO
;INICIALIZACION EN CEROS DE MIS VARIABLES
MOVLW b'00000000' ;inicializar variable UNIDADES en ceros
MOVWF UNIDADES
MOVLW b'00000000' ;inicializar variable DECENAS en ceros
MOVWF DECENAS
MOVLW b'00000000'
MOVWF CENTENAS
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;MOSTRAR EL "CERO" INICIAL EN AMBOS DISPLAY AL INICIAR EL PROGRAMA
MOVLW b'00111111' ;Dibujar Cero en el display
MOVWF PORTD ;Mostrar dicho CERO en display del puerto D
MOVWF PORTC ;Mostrar dicho CERO en display del puerto C
MOVWF PORTB ;Mostrar CERO en display del puerto B
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CALL SUBRUT

CICLO
;BTFSS PORTB,0 ;checar que el BIT 0 este prendido (boton presionado)
;goto $-1
;BTFSC PORTB,0 ;checar que el bit 0 este apagado (boton liberado)
;GOTO $-1
INCF UNIDADES,1 ;Incrementar en 1 y almacenarlo en la misma variable UNIDADES
MOVF UNIDADES,W ;copiar registro DATO a registro W
CALL TABLA
MOVWF PORTD
CALL SUBRUT
GOTO CICLO


REINICIAR_UNIDADES
CLRF UNIDADES ;Dejar en 00000000 variable UNIDADES
MOVLW b'00111111' ;dibujar Cero en display nuevamente
MOVWF PORTD
INCF DECENAS,1 ;incrementar en 1 variable DECENAS
MOVF DECENAS,W ;mover 00000001,00000010,00000011... etc a W
CALL TABLA_DECENAS ;llamar a Tabla Decenas... para desplegar la decena correspondiente
MOVWF PORTC ;moverlo al PUERTO C encargado de las DECENAS
CALL SUBRUT
GOTO CICLO


	BLOQUECENTENAS
MOVLW b'00111111' ;dibujar 0 en DISPLAY de DECENAS (Minuto completado)
MOVWF PORTC
MOVLW b'00111111' ;dibujar 0 en display de UNIDADES
MOVWF PORTD


INCF CENTENAS,1
MOVF CENTENAS,W
CALL TABLA_CENTENAS
MOVWF PORTB
CALL SUBRUT
CLRF DECENAS
	GOTO CICLO


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
GOTO REINICIAR_UNIDADES ;DIEZ

TABLA_DECENAS
ADDWF PCL,F ;Suma el contenido del Registro W a PCL y el resultado se almacena en el mismo registro (PCL).
RETLW b'00111111'     ;CERO 
RETLW b'00000110' 	  ;UNO
RETLW b'01011011' 	  ;DOS
RETLW b'01001111' 	  ;TRES
RETLW b'01100110'	  ;CUATRO
RETLW b'01101101' 	  ;CINCO
GOTO BLOQUECENTENAS

TABLA_CENTENAS
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
GOTO INICIO ;DIEZ

;--------------BLOQUE DE DELAY PARA LOS SEGUNDOS----------------------------------------------------------
SUBRUT ;Esto es una SUBRUTINA, estas se llaman con CALL
	MOVLW 0x7; EN decimal vale 9
	MOVWF CONTADOR2
DECRE3
	MOVLW 0x64 ;En decimal vale 100
	MOVWF CONTADOR1
DECRE2
	MOVLW 0x64 ;En decimal vale 100
	MOVWF CONTADOR0

;AQUI SE REALIZARA EL CONTEO REGRESIVO DE LOS VALOREES QUE ESTAMOS TRABAJANDO
				;palabra reservada "DECFSZ" decrementa BIT por BIT
DECRE1				
	DECFSZ CONTADOR0,1  ;Como CONTADOR0 vale 100, va de 100,99,88 etc...
	GOTO   DECRE1  

	DECFSZ CONTADOR1,1 ;Como CONTADOR1 vale 100, va de 100,99,88 etc...
	GOTO   DECRE2

	DECFSZ CONTADOR2,1 ;como CONTADOR2 vale 33, va de 33,32,31...
	GOTO   DECRE3

	RETURN ;Con RETURN regresamos al codigo original donde se habia quedado, osea
		   ;justo después de llamar SUBRUTINA con CALL SUBRUTINA





END ;DELIMITADOR FIN DEL PROGRAMA
