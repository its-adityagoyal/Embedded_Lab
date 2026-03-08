
		ORG 8100H
		
		CLR P1.0
		CLR P1.1
		CLR P1.2
		CLR P1.3
		CLR P1.4
		
		MOV R0, #00H
		MOV DPTR, #9000H

		SETB P1.5
		JB P1.5, START2
		
		START1:
			MOV A, R0
			MOV DPL, A
			 
			MOV P1, A
			CLR P1.4
			MOVX A, @DPTR

			CLR C
			SUBB A, #01H
			JC UNSET
			
			SETB P1.4
			ACALL DELAY
			INC R0
			MOV A, R0
			SETB P1.5
			JB P1.5, START2
			CJNE A, #10H, START1
			MOV R0, #00H
			SJMP START1
			
			UNSET:
				CLR P1.4
				ACALL DELAY
				INC R0
				MOV A, R0
				SETB P1.5
				JB P1.5, START2
				CJNE A, #10H, START1
				MOV R0, #00H                                                        
				SJMP START1
		START2:
			CLR P1.0
			CLR P1.1
			CLR P1.2
			CLR P1.3
			CLR P1.4
			ACALL DELAY
			
			SETB P1.0
			SETB P1.1
			SETB P1.2
			SETB P1.3
			SETB P1.4
			ACALL DELAY
			
			SETB P1.5
			JB P1.5, START2
			MOV R0, #00H
			SJMP START1
		
		DELAY:
			MOV R3, #8
			LOOP3: MOV R2, #255
			LOOP2: MOV R1, #226
			LOOP1: DJNZ R1, LOOP1
			DJNZ R2, LOOP2
			DJNZ R3, LOOP3			
			RET
		
		HERE: 
			SJMP HERE
		
		END