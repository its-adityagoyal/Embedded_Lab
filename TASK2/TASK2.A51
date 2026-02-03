//Compare two values. If the first is smaller, indicate it by writing 01 to memory location
//9550H, if it is larger or equal, write 00 on the same location

		ORG 8100H
		
		MOV R0, #00H
		MOV R1, #01H
		MOV A, #05H
		MOV DPTR, #9550H

		SUBB A, #09H
		JC LESS
		
		MOV A, R0
		MOVX @DPTR, A
		PHERE: SJMP PHERE
		
		LESS:
		MOV A, R1
		MOVX @DPTR, A
			END
		
		
		