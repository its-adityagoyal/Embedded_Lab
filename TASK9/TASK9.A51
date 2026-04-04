//Count 00 to 06, 15 to 23, 29, 47 to 54 continually with two 7-segment displayswith 0.5 second digit display time.
//The hex value to light 7-segment display for digit i is stored at location 9000+i
		
		
		ORG 8100H
		
		//CONTROL WORD (MODE 0 CONFIGURATION)
		MOV DPTR, #0E803H
		MOV A, #80H
		MOVX @DPTR, A
		
		// MAIN LOGIC
		WHILE:
			MOV R1, #00H
			MOV R0, #00H
			ACALL PRINT
			
			MOV R1, #00H
			MOV R0, #01H
			ACALL PRINT
			
			MOV R1, #00H
			MOV R0, #02H
			ACALL PRINT
			
			MOV R1, #00H
			MOV R0, #03H
			ACALL PRINT
			
			MOV R1, #00H
			MOV R0, #04H
			ACALL PRINT
			
			MOV R1, #00H
			MOV R0, #05H
			ACALL PRINT
			
			MOV R1, #00H
			MOV R0, #06H
			ACALL PRINT
			
			MOV R1, #01H
			MOV R0, #05H
			ACALL PRINT
			
			MOV R1, #01H
			MOV R0, #06H
			ACALL PRINT
			
			MOV R1, #01H
			MOV R0, #07H
			ACALL PRINT
			
			MOV R1, #01H
			MOV R0, #08H
			ACALL PRINT
			
			MOV R1, #01H
			MOV R0, #09H
			ACALL PRINT
			
			MOV R1, #02H
			MOV R0, #00H
			ACALL PRINT
			
			MOV R1, #02H
			MOV R0, #01H
			ACALL PRINT
			
			MOV R1, #02H
			MOV R0, #02H
			ACALL PRINT
			
			MOV R1, #02H
			MOV R0, #03H
			ACALL PRINT
			
			MOV R1, #02H
			MOV R0, #09H
			ACALL PRINT
			
			MOV R1, #04H
			MOV R0, #07H
			ACALL PRINT
			
			MOV R1, #04H
			MOV R0, #08H
			ACALL PRINT
			
			MOV R1, #04H
			MOV R0, #09H
			ACALL PRINT
			
			MOV R1, #05H
			MOV R0, #00H
			ACALL PRINT
			
			MOV R1, #05H
			MOV R0, #01H
			ACALL PRINT
			
			MOV R1, #05H
			MOV R0, #02H
			ACALL PRINT
			
			MOV R1, #05H
			MOV R0, #03H
			ACALL PRINT
			
			MOV R1, #05H
			MOV R0, #04H
			ACALL PRINT
						
			LJMP WHILE
		
		PRINT:
			MOV R3, #4
			LOP3: MOV R4, #255
				LOP1: 
					ACALL DISPLAY
					DJNZ R4, LOP1
				DJNZ R3, LOP3			
			RET
		
		DISPLAY:
			
			MOV DPTR, #0E801H
			MOV A, #02H
			MOVX @DPTR, A
			MOV DPH, #90H
			MOV A, R0
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			MOV R6, #0FFH
			SWITCH1: DJNZ R6, SWITCH1
			
			MOV DPTR, #0E801H
			MOV A, #01H
			MOVX @DPTR, A
			MOV DPH, #90H
			MOV A, R1
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			
			MOV R6, #0FFH
			SWITCH2: DJNZ R6, SWITCH2
			
			RET
		
		HERE: 
			SJMP HERE
		
		END