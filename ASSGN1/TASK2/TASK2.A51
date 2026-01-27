//A general polynomial of degree n can be represented in a form
// a[0] + x(a[1] + x(a[2] + ........ x(a[n - 1] + xa[n]))). Assuming n is stored at
// location 9500H, x at 9501H and coefficients at memory locations 9502H onwards (from a[n] to a[0] order).
//Evaluate the polynomial and store the result at location 9550H (higher 8-bit) and at location 9551H (lower 8-bit).


		ORG 8100H
		
		// R0 stores n
		MOV DPTR, #9500H
		MOVX A, @DPTR
		MOV R0, A
		
		//R5 stores x
		INC DPL
		MOVX A, @DPTR
		MOV R5, A
		
		//R1 is loop counter
		MOV R1, #01H
		
		//R6 R7 stores the temporary result as higher and lower 8-bits respectively
		INC DPL
		MOVX A, @DPTR
		MOV R7, A
		MOV R6, #00H
		
		LOOP:
			//LOOP EXIT CONDITION CHECK
			CLR C
			MOV A, R0
			SUBB A, R1
			JC SAVE
			
			//MULTIPLICATION
			MOV A, R7
			MOV B, R5
			MUL AB
			MOV R7, A	// Store multiplication value for lower 8 bits
			MOV R4, B
			
			MOV A, R6
			MOV B, R5
			MUL AB
			ADD A, R4
			MOV R6, A	// Store multiplication value for higher 8 bits
			
			//ADDITION
			INC DPL
			MOVX A, @DPTR
			
			CLR C
			ADD A, R7
			MOV R7, A	// Store addition value for lower 8 bits
			JC CARRY
			
			INC R1
			SJMP LOOP
			
			CARRY:
				MOV A, R6
				ADD A, #01H
				MOV R6, A	// Store addition value for higher 8 bits
				INC R1
				SJMP LOOP
		
		//SAVING THE RESULT IN DESIRED LOCATIONS
		SAVE:
			MOV DPTR, #9551H
			MOV A, R7
			MOVX @DPTR, A
			DEC DPL
			MOV A, R6
			MOVX @DPTR, A
			
			SJMP HERE
		
		//INFINITE LOOP
		HERE: SJMP HERE
			END