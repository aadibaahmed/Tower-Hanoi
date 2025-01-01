hanoi:

					
		PUSH {lr}				// save return address and frame pointer
		PUSH {fp}
		MOV fp, sp				// make the base pointer
		SUB sp, sp, #4			// help rod variables

		LDR r0, [fp, #8]		// load n disks
		CMP r0, #1				// check if n == 0
		BNE else				// else

		LDR r1, [fp, #12]		// r1 = fromPeg
		LDR r2, [fp, #16]		// r2 = toPeg
		B if_end

else:
	// call function for (n-1, from_rod, help_rod)
	
	// Find help rod position
		LDR r0, [fp, #12]		// load from_rod
		RSB	r0, r0, #6			// r0 = 6 - from_rod	
		
		LDR r1, [fp, #16]		// to_rod
		SUB r0, r0, r1			// r0 = 6 - from_rod - to_rod
		STR r0, [fp, #-4]   	// help_rod = 6 - from_rod - to_rod


		LDR r0, [fp, #-4]		// load in help_rod
		PUSH {r0}				// push on the stack

		LDR r0, [fp, #12]		// load in from_rod
		PUSH {r0}				// push on the stack

		LDR r0, [fp, #8]		// load in n-disk
		SUB r0, r0, #1			// perform n - 1
		PUSH {r0}

		BL hanoi
		ADD	sp, sp, #12     	// Pop parameters

	
							
		LDR r1, [fp, #12]		// print move disk n to to_rod
		LDR r2, [fp, #16]
	
	// do the same thing for (n-1, help_rod, to_rod)
		
		LDR r0, [fp, #16]  		// load to_rod
		push {r0}
		
		LDR r0, [fp, #-4]		// load help_rod
		push {r0}
		
		LDR r0, [fp, #8]		// load in n-disk
		SUB r0, r0, #1			// perform n - 1
		PUSH {r0}

		BL hanoi
		ADD sp, sp, #12     	// Pop parameters

if_end:

		// return

		MOV sp, fp
		POP {fp}
		POP {pc}

.global _start
_start:
	
	
	//main that passes parameters into funtion

		MOV r0, #3				// to_rod 3
		PUSH {r0}				// push into stack
		MOV r0, #1				// from_rod 1
		PUSH {r0}				// push into stack
		MOV r0, #2				// number of disks = n
		PUSH {r0}				// push into stack
	
	// Creates the stack with (From top to bottom): n-disks, from_rod, to_rod
	
		BL hanoi				// call function

		add	sp, sp, #12     	// Pop parameters


.data
	.EQU stack_loc, 0x20001000  // Initial Main Stack Ponter Value
	
.end
	
	