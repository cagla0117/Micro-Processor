;Cagla Midikli 150200011
		AREA power, CODE, READONLY	;declare new area
		ENTRY 						;declare as entry point
		ALIGN						;ensures that main addresses the following instruction	
main  	FUNCTION						
		EXPORT main					;make main as global to access from startup file			
		MOVS r0, #3					;exponent value
		MOVS r1, #5					;number value
		MOVS r2,r0					;for decrement exponent value
		BL power1					;branch with link to 'power1' for recursive call
					
power1	
		CMP r2,#0					;for compare zero with r2,if r2 equals to 0 return true value
		BEQ base_case				;branch to 'base_case' if r2 equals 0 ,if last value is true,jump to base_case functions
		PUSH {r2,lr} 				;push r2 and lr to stack
		SUBS r2,r2,#1				;for subtract 1 from r2 and update r2
		BL power1					;branch with link to 'power1' for recursive call
		MULS r4,r1,r4				;for multiply r1 by r4 and store the result in r4
		POP {r2,r3} 				;return the registers and lr from the top of stack.
		CMP r2, r0					;for compare r0 with r2,if r2 equals to r0 return true value.if r2 equals to first exponent value this mean my stack is emoty so recursive is completed
		BEQ stop					;branch to 'stop' if r2 equals r0 ,if last value is true,jump to stop functions
		BX LR						;return from subroutine
		
		
base_case			
		MOVS r4, #1					;move 1 to R4 because of store multiplication results 
		BX LR						;return from subroutine
	
stop	B stop						;branch stop funtion		
	
		ENDFUNC						;finish function
		END							;finish assembly file