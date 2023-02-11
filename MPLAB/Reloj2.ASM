	LIST P=16F84

;----------------------------------------------------------------------------------------------
;Reloj Digital 
;Realizado por Ing. Biagio Cante

;---------------------------------------------------------------------------------------------- 

; Declaracion de Variables 

AUX		EQU	12H	
PCL		EQU	02H
SEG		EQU	11H
PB		EQU	06H
TRISB	EQU	06H
STATUS	EQU	03H
OP		EQU	01H
INTCON	EQU	0BH
VAR		EQU	10H
TMR0	EQU	01H
MIN		EQU	15H
MIN10	EQU	16H
SEG10	EQU	17H
RETA	EQU	18H
PA		EQU	05H
TRISA	EQU	05H
HORA	EQU	20H
HORA10	EQU	19H
VAL		EQU	21H
VAL1	EQU	22H
TX		EQU	23H
R11		EQU	24H
VAR2	EQU	25H

;--------------------------------------------------------------------------------------------------

	ORG	0							;Vector de RESET
	GOTO	START					;Salto a la linea 80 para iniciar el programa ppal
;

		ORG	80						;Inicio en la linea 80
START	BSF		STATUS,5			;Cambio al banco de memoria 1			
		CLRF	TRISB				;Se declara el puerto B como salida
		MOVLW	B'00000011'			;Se mueve el valor de 00000011 a W
		MOVWF	TRISA				;De puerto PA, seran de entrada (PA0,PA1)y los otros salida		
		MOVLW	B'00000111'			;Se mueve el valor de 00000111 a W		
		MOVWF	OP					;Se asigna el divisor a 256 y se dice que el TMR0 trabaja como temporizador de pulsos internos
		BCF		STATUS,5			;Cambio al banco de memoria 0	
		MOVLW	B'10100000'			;Se mueve el valor de 10100000 a W
		MOVWF	INTCON				;Se habilitan todas la interrupciones y en especial la de TMR0
		CLRF	SEG					;Se borra la variable SEG
		CLRF	VAR					;Se borra la variable VAR
		MOVLW	D'100'				;Se asigna el valor de 100 a W
		MOVWF	VAR					;Se le da valor de 100 a VAR
		MOVLW	D'217'				;se asigna el valor de 217 a W
		MOVWF	TMR0				;Se le da valor de 217 a TMR0
		CLRF	SEG10				;Se borra SEG10
		CLRF	MIN					;Se borra MIN
		CLRF	MIN10				;Se Borra MIN10
		CLRF	HORA				;Se borra HORA
		CLRF	HORA10				;Se borra HORA10
		BCF		PA,3			 	;Se apaga el led en PA3
		BCF		VAL,0				;Se borra el bit cero de la variable VAL que usaremos como Flag
;---------------------------------------------------------------------------------------------------------------------------------------

INICIO
		BTFSS	PA,0				;Se valida si PA0 esta precionado (boton que ajustara los minutos) 
		GOTO	MINU				;Se va la etiqueta MINU para ajustar los minutos 
		BCF		VAL,0				;De no estar presionado la Flag (bit 0 de VAL) se pone en 0
		BTFSS	PA,1				;Se valida si PA1 esta prsionado  (boton que ajustara las horas) 
		GOTO	HOR					;Se va la etiqueta HOR para ajustar las horas 
		BCF		VAL1,0				;De no estar presionado la Flag (bit 0 de VAL) se pone en 0
Z1		MOVF	MIN,0				;Se mueve el valor de las unidades de minutos a W
		MOVWF	PB					;Se mueve el valor de W a PB
		BSF		PB,4				;Se activa el primer display
		CALL	RETARDO				;Se llama a la rutina de Retardo
		BCF		PB,4				;Se apaga el primer display
		MOVF	MIN10,0				;Se mueve el valor de las decenas de minutos a W
		MOVWF	PB					;Se mueve el valor de W a PB
		BSF		PB,5				;Se activa el segundo display
		CALL	RETARDO				;Se llama a la rutina de Retardo
		BCF		PB,5				;Se apaga el segundo display	
		MOVF	HORA,0				;Se mueve el valor de las unidades de horas a W
		MOVWF	PB					;Se mueve el valor de W a PB				
		BSF		PB,6				;Se activa el tercer display
		CALL	RETARDO				;Se llama a la rutina de Retardo
		BCF		PB,6				;Se apaga el tercer display
		MOVF	HORA10,0			;Se mueve el valor de las decenas  de horas a W
		MOVWF	PB					;Se mueve el valor de W a PB				
		BSF		PB,7				;Se activa el cuarto display
		CALL	RETARDO				;Se llama a la rutina de Retardo
		BCF		PB,7				;Se apaga el cuarto display
		GOTO	INICIO				;Se vuelve a inicio

MINU	BTFSC	VAL,0				;Se valida la etiqueta VAL0 para saber si sigue presionado el boton 
		GOTO	M1					;Como esta presionado el boton y ya se incremento la variable no se hace mas nada 
		BSF		VAL,0				;Como es apenas presionado cambiamos la Flag a 1 (VAL0) 
		INCF	MIN,1				;Se incrementan las unidades de minutos
		MOVF	MIN,0				;Se mueve el valor de las unidades de minutos a W
		SUBLW	D'10'				;Se le resta el valor de 10 a lo de W
		BTFSS	STATUS,2			;Se valida si la resta dio 0
		GOTO	M1					;Como la resta no dio 0, se va a M1 para continuar
		CLRF	MIN					;Como la resta dio cero quiere decir que es igual a 10 y se borra a 0
		INCF	MIN10,1				;Se incrementan las decenas de Minutos 
		MOVF	MIN10,0				;Se mueve las decenas de minutos a W
		SUBLW	D'6'				;Se les resta el valor de 6 a W
		BTFSS	STATUS,2			;Se valida si la resta dio 0
		GOTO	M1					;Como la resta no dio 0, se va a M1 para continuar
		CLRF	MIN10				;Como la resta dio cero quiere decir que es igual a 6 y se borra a 0 
M1		GOTO	Z1					;Se vuelve a la etuiqueta Z1

HOR		BTFSC	VAL1,0				;Se valida la etiqueta VAL0 para saber si sigue presionado el boton 			
		GOTO	H1					;Como esta presionado el boton y ya se incremento la variable no se hace mas nada				
		BSF		VAL1,0				;Como es apenas presionado cambiamos la Flag a 1 (VAL0)			
		INCF	HORA,1				;Se incrementan las unidades de Horas 			
		MOVF	HORA,0				;Se mueve el valor de las unidades de horas a W		
		SUBLW	D'10'				;Se le resta el valor de 10 a lo de W
		BTFSS	STATUS,2			;Se valida si la resta dio 0		
		GOTO	H2					;Como la resta no dio 0, se va a H2 para continuar		
		CLRF	HORA				;Como la resta dio cero quiere decir que es igual a 10 y se borra a 0					
		INCF	HORA10,1			;Se incrementan las decenas de Horas 		
		GOTO	H1					;Se va a H1 para continuar
H2		MOVF	HORA,0				;Se mueve las unidades de hora a W
		SUBLW	D'4'				;Se le resta 4 a W
		BTFSS	STATUS,2			;Se valida si la resta dio 0
		GOTO	H1					;Como no dio cero 0 se va a H1 para continuar
		MOVF	HORA10,0			;Se mueve las decenas de horas a W
		SUBLW	D'2'				;Se le resta 2 a W
		BTFSS	STATUS,2			;Se valida si la resta dio 0
		GOTO	H1					;Como la resta no dio 0 se va a H1 para continuar
		CLRF	HORA				;Si la resta dio cero se borra las unidades de las horas
		CLRF	HORA10				;Se borran las decenas de las horas
H1		GOTO	Z1					;Se vuelve a la etiqueta Z1


RETARDO	MOVLW	H'FF'				;Se mueve el valor de 255 a W
		MOVWF	RETA				;Se le da el valor de 255 a W
B1		DECFSZ	RETA,1				;Se tiene RETA=RETA-1 y se pregunta si es cero
		GOTO	B1					;Si la resta no dio 0 se va a B1
		RETURN						;La resta dio cero y se vuelve a donde fue llamada la rutina

	
		ORG	4						;Vector de la interrupcion
		MOVWF	AUX					;Se mueve el valor que tenga W para almacenarlo en AUX
		DECFSZ	VAR,1				;Se decrementa VAR y se valida si es 0 el resultado
		GOTO	A1					;Como el resultado de la resta no es 0 se va a A1
		BTFSS	PA,2				;Si el resultado de la resta es 0, se valida se el LED que esta en PA2 esta encendido
		GOTO	UNO					;Como el LED esta apagado se va a la etiqueta UNO
		BCF		PA,2				;Se apaga el LED
		GOTO	CERO				;Se salta a la etiqueta CERO
UNO		BSF		PA,2				;Se enciende el LED
CERO	INCF	SEG,1				;Se incrementa los segundos
		MOVF	SEG,0				;Se mueve las unidades de segundo a W
		SUBLW	D'60'				;Se le resta 60 a W
		BTFSS	STATUS,2			;Se pregunta si la resta dio 0
		GOTO	A2					;Se la resta no dio 0 se va a A2
		CLRF	SEG					;Como la resta dio 0 se borran los segundo	
		INCF	MIN,1				;Se incrementan las unidades de minutos 
		MOVF	MIN,0				;Se mueven las unidades de minutos a W
		SUBLW	D'10'				;Se resta el valor de 10 a W
		BTFSS	STATUS,2			;Se valida si la resta dio 0
		GOTO	A3					;Como la resta no dio 0 se va a A2
		CLRF	MIN					;Se la resta dio 0 se borran las unidades de minutos
		INCF	MIN10,1				;Se incrementan las decenas de minutos
		MOVF	MIN10,0				;Se mueve el valor de las decenas de minutos a W
		SUBLW	D'6'				;Se le resta 6 a W
		BTFSS	STATUS,2			;Se valida si la resta dio 0
		GOTO	A3					;Si la resta no dio 0 se va a A2
		CLRF	MIN10				;La resta dio 0 y se borran las decenas de minutos 
		INCF	HORA,1				;Se incrementan las unidades de las horas 
		MOVF	HORA,0				;Se mueve las unidades de las horas a W
		SUBLW	D'10'				;Se le resta 10 a W
		BTFSS	STATUS,2			;Se valida si la resta dio 0
		GOTO	A5					;Como la resta no dio 0 se va a A5
		CLRF	HORA				;Como la resta dio 0 se borran las unidades de horas
		INCF	HORA10,1			;Se incrementan las decenas de horas 
		GOTO	A3					;Se salta a la etiqueta A2
A5		MOVF	HORA,0				;Se mueve las unidades de horas a W
		SUBLW	D'4'				;Se resta el valor de 4 a W
		BTFSS	STATUS,2			;Se valida si la resta dio 0
		GOTO	A3					;Como la resta no dio 0 se va a A2
		MOVF	HORA10,0			;Si la resta dio 0 se mueve el valor de las decenas de horas a W
		SUBLW	D'2'				;Se le resta 2 a W
		BTFSS	STATUS,2			;Se valida si la resta dio 0
		GOTO	A3					;Si la resta no da 0 se salta a la etiqueta A2
		CLRF	HORA				;Si la resta dio 0 se borran las uniadades de las horas 
		CLRF	HORA10				;Se borran las decenas de las horas 
A3		CALL	TR					;Va a transmitir el dato por el puerto serie
A2		MOVLW	D'100'				;Se le asigna el valor de 100 a W
		MOVWF	VAR					;Se le asigna el valor de 100 a VAR
A1		MOVLW	D'217'				;Se le asigna el valor de 217 a W
		MOVWF	TMR0				;Se le asigna el valor de 217 a TMR0
		BCF		INTCON,2			;Se borra la Flag de la interrupcion de TMR0				
		MOVF	AUX,0				;Se devuelve el valor de la variable AUX a W
		RETFIE						;Se sale de la interrupcion

TR		MOVLW	' '
		CALL	TRANS
		MOVF	HORA10,0			;HORA10 ---> W
		CALL	CONVERT				;Llama a convert para cambiarlo a ASCII
		CALL	TRANS				;Llama a Trans para enviarlo al puerto serial PC
		MOVF	HORA,0				;HORA ---> W
		CALL	CONVERT				;Llama a convert para cambiarlo a ASCII
		CALL	TRANS				;Llama a Trans para enviarlo al puerto serial PC
		MOVLW	':'
		CALL	TRANS
		MOVF	MIN10,0				;MIN10 ---> W
		CALL	CONVERT				;Llama a convert para cambiarlo a ASCII
		CALL	TRANS				;Llama a Trans para enviarlo al puerto serial PC
		MOVF	MIN,0				;MIN ---> W
		CALL	CONVERT				;Llama a convert para cambiarlo a ASCII
		CALL	TRANS				;Llama a Trans para enviarlo al puerto serial PC
		RETURN


TRANS	CLRWDT			;BORRA EL WATHDOG
		MOVWF	TX		;MUEVE EL DATO A TRANSMITIR A LA VARIABLE TX
       	MOVLW   .08		;MUEVE EL VALOR DE 8 A W
		MOVWF	R11		;MUEVE EL VALOR DE 8 AL REGISTRO R11
		BCF		PA,4	;PONE A 0 EL VALOR DE PA,1 (BIT DE INICIO)
		CALL	DELAY1	;LLAMA A LA RUTINA DE RETARDO
XNEXT	BCF		PA,4	;PONE A 0 EL PUERTO PA,1
		BCF		STATUS,0;PONE A CERO LA BANDERA DE ACARREO EN STATUS
        RRF     TX,1	;ROTA EL VALOR DEL TX UN PASO A LA DERECHA
		BTFSC	STATUS,0;CHEQUEA EL VALOR DE ACARREO
		BSF		PA,4	;PONE EN 1 EL BIT PA,1
		CALL	DELAY1	;LLAMA A LA RUTINA DE RETARDO
       	DECFSZ  R11,1	;DECREMENTA LA VARIABLE R11 Y CHEQUEA QUE NO DIO CERO
		GOTO	XNEXT	;LLAMA A LA ETIQUETA XNEXT PARA TRANSMITIR OTRO BIT
		BSF		PA,4	;PONE EN 1 PA,0
		CALL	DELAY1	;LLAMA A LA RUTINA DE DELAY1
		RETURN			;TERMINA LA SUBRUTINA

DELAY1	MOVLW	.166		;CARGA EL NUMERO 166 EN W	
		MOVWF	VAR2		;CARGA EL VALOR EN VAR2
REDO	NOP
		NOP
		DECFSZ	VAR2,1		;DECREMENTA Y VERIFICA QUE NO SEA CERO
		GOTO	REDO	
		RETLW	0 	
	
CONVERT	ADDWF	PCL,1		;SE SUMA LA PCL PARA QUE DEVUELVA EL VALOR CORRESPONDINTE EN ASCII
		RETLW	'0'			;VALOR EN ASCII PARA EL 0
		RETLW	'1'			;VALOR EN ASCII PARA EL 0
		RETLW	'2'			;VALOR EN ASCII PARA EL 0
		RETLW	'3'			;VALOR EN ASCII PARA EL 0
		RETLW	'4'			;VALOR EN ASCII PARA EL 0
		RETLW	'5'			;VALOR EN ASCII PARA EL 0
		RETLW	'6'			;VALOR EN ASCII PARA EL 0
		RETLW	'7'			;VALOR EN ASCII PARA EL 0
		RETLW	'8'			;VALOR EN ASCII PARA EL 0
		RETLW	'9'			;VALOR EN ASCII PARA EL 0

		END
	
	
