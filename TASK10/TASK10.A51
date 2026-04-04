//Design a digital clock using common-cathode 7-segment display modules and a mode switch. The clock normally displays the time in hh-mm-ss format.
//It updates time automatically using the timer interrupt of the microcontroller. On pressing the mode switch, the display changes to stopwatch mode
//in hh-mm-ss format. In stopwatch mode there are two more buttons - start and stop. The start button starts the stopwatch resetting it to zero, stop
//button stops the stopwatch.
		
		ORG 0FFF0H
		LJMP ISR
		
		ORG 8100H
		
		//CONTROL WORD (MODE 0 CONFIGURATION)
		MOV DPTR, #0E803H
		MOV A, #89H
		MOVX @DPTR, A
		
		MOV R7, #00H
		MOV TMOD, #01H
		MOV TH0, #4CH
		MOV TL0, #00H
		MOV IE, #82H
		SETB TR0
		
		
		//INITIALIZATION
		MOV R0,#00H
		MOV R1,#00H
		MOV R2,#00H
		MOV R3,#00H
		MOV R4,#00H
		MOV R5,#00H

		MAIN: 
			//RESET STOPWATCH
			MOV A,#00H
			MOV DPH, #91H
			MOV DPL, #00H
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
		
			//NORMAL LOGIC
			MOV DPTR, #0E801H
			MOV A, #248
			MOVX @DPTR, A
			MOV DPH, #90H
			MOV A, R0
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			MOV DPTR, #0E801H
			MOV A, #244
			MOVX @DPTR, A
			MOV DPH, #90H
			MOV A, R1
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			MOV DPTR, #0E801H
			MOV A, #236
			MOVX @DPTR, A
			MOV DPH, #90H
			MOV A, R2
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			MOV DPTR, #0E801H
			MOV A, #220
			MOVX @DPTR, A
			MOV DPH, #90H
			MOV A, R3
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			MOV DPTR, #0E801H
			MOV A, #188
			MOVX @DPTR, A
			MOV DPH, #90H
			MOV A, R4
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			MOV DPTR, #0E801H
			MOV A, #124
			MOVX @DPTR, A
			MOV DPH, #90H
			MOV A, R5
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			MOV DPTR, #0E802H
			MOVX A, @DPTR
			ANL A, #01H
			CJNE A, #00H, LOOP1
			
			
			LOOP2:
				LJMP MAIN
		
		HELLO1:
			MOV A,#00H
			MOV DPH, #91H
			MOV DPL, #00H
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
			INC DPL
			MOVX @DPTR, A
			SJMP HELLO2
			
		LOOP1:
			//START LOGIC
			MOV DPTR, #0E802H
			MOVX A, @DPTR
			ANL A, #02H
			CJNE A, #02H, HELLO1
			
			HELLO2:
			
			MOV DPTR, #0E802H
			MOVX A, @DPTR
			ANL A, #01H
			CJNE A, #01H, LOOP2
			
			//control
			MOV DPTR, #0E801H
			MOV A, #248
			MOVX @DPTR, A
			//Value
			MOV DPTR, #9105H
			MOVX A, @DPTR
			//Decode
			MOV DPH, #90H
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			//control
			MOV DPTR, #0E801H
			MOV A, #244
			MOVX @DPTR, A
			//Value
			MOV DPTR, #9104H
			MOVX A, @DPTR
			//Decode
			MOV DPH, #90H
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			//control
			MOV DPTR, #0E801H
			MOV A, #236
			MOVX @DPTR, A
			//Value
			MOV DPTR, #9103H
			MOVX A, @DPTR
			//Decode
			MOV DPH, #90H
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			//control
			MOV DPTR, #0E801H
			MOV A, #220
			MOVX @DPTR, A
			//Value
			MOV DPTR, #9102H
			MOVX A, @DPTR
			//Decode
			MOV DPH, #90H
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			//control
			MOV DPTR, #0E801H
			MOV A, #188
			MOVX @DPTR, A
			//Value
			MOV DPTR, #9101H
			MOVX A, @DPTR
			//Decode
			MOV DPH, #90H
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			//control
			MOV DPTR, #0E801H
			MOV A, #124
			MOVX @DPTR, A
			//Value
			MOV DPTR, #9100H
			MOVX A, @DPTR
			//Decode
			MOV DPH, #90H
			MOV DPL, A
			MOVX A, @DPTR
			MOV B, #02H
			MUL AB
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			ACALL DELAY
			
			LJMP LOOP1
		ISR:
			MOV TH0, #4CH
			MOV TL0, #00H
			
			INC R7
			MOV A, R7
			CJNE A, #20, EXIT1
			
			MOV R7, #00H
			
			//CLOCK INCREMENT LOGIC
			INC R0
			MOV A,R0
			CJNE A, #0AH, EXIT
			MOV R0, #00H
			
			INC R1
			MOV A,R1
			CJNE A, #06H, EXIT
			MOV R1, #00H
			
			INC R2
			MOV A,R2
			CJNE A, #0AH, EXIT
			MOV R2, #00H
			
			INC R3
			MOV A,R3
			CJNE A, #06H, EXIT
			MOV R3, #00H
			
			INC R4
			MOV A,R4
			CJNE A, #0AH, EXIT
			MOV R4, #00H
			
			INC R5
			MOV A,R5
			CJNE A, #0AH, EXIT
			MOV R5, #00H
			
			EXIT:
			
			//START LOGIC
			MOV DPTR, #0E802H
			MOVX A, @DPTR
			ANL A, #02H
			CJNE A, #02H, EXIT1
			
			//STOPWATCH INCREMENT LOGIC
			MOV DPTR, #9105H
			MOVX A, @DPTR
			INC A
			MOVX @DPTR, A
			CJNE A, #0AH, EXIT1
			MOV A, #00H
			MOVX @DPTR, A
			
			MOV DPTR, #9104H
			MOVX A, @DPTR
			INC A
			MOVX @DPTR, A
			CJNE A, #06H, EXIT1
			MOV A, #00H
			MOVX @DPTR, A
			
			MOV DPTR, #9103H
			MOVX A, @DPTR
			INC A
			MOVX @DPTR, A
			CJNE A, #0AH, EXIT1
			MOV A, #00H
			MOVX @DPTR, A
			
			MOV DPTR, #9102H
			MOVX A, @DPTR
			INC A
			MOVX @DPTR, A
			CJNE A, #06H, EXIT1
			MOV A, #00H
			MOVX @DPTR, A
			
			MOV DPTR, #9101H
			MOVX A, @DPTR
			INC A
			MOVX @DPTR, A
			CJNE A, #0AH, EXIT1
			MOV A, #00H
			MOVX @DPTR, A
			
			MOV DPTR, #9100H
			MOVX A, @DPTR
			INC A
			MOVX @DPTR, A
			CJNE A, #0AH, EXIT1
			MOV A, #00H
			MOVX @DPTR, A
		
		EXIT1:
			RETI
		
		DELAY:
			MOV B, #0FFH  
			INNER: DJNZ B, INNER
			RET
			
		HERE: SJMP HERE
			END
			