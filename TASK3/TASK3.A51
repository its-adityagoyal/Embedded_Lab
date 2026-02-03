//Sort in ascending an array of N bytes stored in external memory from location 9000H onwards. Now perform binary search for a number
//Stored at location 9500H into this sorted array. If the number is present, index (not address) is stored at location 9550H. Otherwise,
//the location 9550H should contain -1.

		ORG 8100H
		
		MOV R0, #00H
		
		LOOP1:
			MOV A, #0AH
			CLR C
			SUBB A, R0
			JC BINARY
			
			INC R0
			MOV DPTR, #9000H
			MOV R3, #00H
			
			LOOP2:
				MOV A, #08H
				CLR C
				SUBB A, R3
				JC LOOP1
			
				MOVX A, @DPTR
				MOV R1, A
				INC DPTR
				MOVX A, @DPTR
				MOV R2, A
				
				CLR C
				SUBB A, R1
				JC LESS
				
				INC R3
				SJMP LOOP2
		
				LESS:
					MOV A, R1
					MOVX @DPTR, A
					DEC DPL
					MOV A, R2
					MOVX @DPTR, A
					INC DPL
					
					INC R3
					SJMP LOOP2
			
		BINARY:
			MOV DPTR, #9500H
			MOVX A, @DPTR
			MOV R7, A
			
			MOV DPTR, #9550H
			MOV A, #0FFH
			MOVX @DPTR, A
			
			
			MOV R1, #00H
			MOV R2, #09H
			
			MOV DPTR, #9000H
			
			WHILE:
				MOV A,R2
				CLR C
				SUBB A,R1
				
				JC HERE
				
				MOV A, R2
				ADD A,R1
				MOV B, #02H
				DIV AB
				MOV R0, A
				
				MOV DPL, A
				MOVX A, @DPTR
				
				CJNE A, 07H, NOTEQUAL
				
				MOV DPTR, #9550H
				MOV A, R0
				MOVX @DPTR, A
				SJMP HERE
				
				NOTEQUAL:
					CLR C
					SUBB A, R7
					JC RIGHT
					
					MOV A, R0
					DEC A
					MOV R2, A
					SJMP WHILE
					
					RIGHT:
						MOV A, R0
						INC A
						MOV R1, A
						SJMP WHILE
		
		HERE: SJMP HERE
			END
			