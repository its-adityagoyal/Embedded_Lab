//Glow five LEDs sequentially through IC 74245 with J10 port with a period of one second.

		ORG 8100H
		CLR P1.2
		CLR P1.3
		CLR P1.4
		CLR P1.5
		
		START:
			SETB P1.2
			ACALL DELAY
			CLR P1.2
			ACALL DELAY
			
			SETB P1.3
			ACALL DELAY
			CLR P1.3
			ACALL DELAY
			
			SETB P1.4
			ACALL DELAY
			CLR P1.4
			ACALL DELAY
			
			SETB P1.5
			ACALL DELAY
			CLR P1.5
			ACALL DELAY
			
			SJMP START
		
		DELAY:
			MOV R3, #8
			LOOP3: MOV R2, #255
			LOOP2: MOV R1, #226
			LOOP1: DJNZ R1, LOOP1
			DJNZ R2, LOOP2
			DJNZ R3, LOOP3			
			RET
		
		HERE: SJMP HERE
		
		END
		