

		ORG 8100H
		
		MOV DPTR, #0E803H
		MOV A, #80H
		MOVX @DPTR, A
		
		WHILE:
			MOV DPH, #90H
			MOV A, #00H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
			
			MOV DPH, #90H
			MOV A, #01H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
			
			MOV DPH, #90H
			MOV A, #02H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
			
			MOV DPH, #90H
			MOV A, #03H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
			
			MOV DPH, #90H
			MOV A, #04H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
			
			MOV DPH, #90H
			MOV A, #05H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
			
			MOV DPH, #90H
			MOV A, #06H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
			
			MOV DPH, #90H
			MOV A, #07H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
			
			MOV DPH, #90H
			MOV A, #08H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
			
			MOV DPH, #90H
			MOV A, #09H
			MOV DPL, A
			MOVX A, @DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A
			ACALL DELAY
						
			LJMP WHILE
		
		DELAY:
			MOV R3, #8
			LOP3: MOV R2, #255
			LOP2: MOV R1, #226
			LOP1: DJNZ R1, LOP1
			DJNZ R2, LOP2
			DJNZ R3, LOP3			
			RET
		
		HERE: 
			SJMP HERE
		
		END