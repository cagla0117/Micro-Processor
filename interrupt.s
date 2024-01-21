;Çagla Midikli 150200011
;
				AREA array,data,readonly
				ALIGN

;load array with given value
array_start		DCD 0xffffffff,0xb38cf45a,0xf5010841,0x32477961,0x10bc09c5,0x5543db2b,0xd09b0bf1,0x2eef070e,0xe8e0e237,0xd6ad2467,0xc65a478b,0xbd7bbc07
				DCD 0xa853c4bb,0xfe21ee08,0xa48b2364,0x40c09b9f,0xa67aff4e,0x86342d4a,0xee64e1dc,0x87cdcdcc,0x2b911058,0xb5214bbc,0xff4ecdd7,0x3da3f26
				DCD 0xc79b2267,0x6a72a73a,0xd0d8533d,0x5a4af4a6,0x5c661e05,0xc80c1ae8,0x2d7e4d5a,0x84367925,0x84712f8b,0x2b823605,0x17691e64,0xea49cba
				DCD	0x1d4386fb,0xb085bec8,0x4cc0f704,0x76a4eca9,0x83625326,0x95fa4598,0xe82d995e,0xc5fb78cb,0xaf63720d,0xeb827b5,0xcc11686d,0x18db54ac
				DCD	0x8fe9488c,0xe35cf1,0xd80ec07d,0xbdfcce51,0x9ef8ef5c,0x3a1382b2,0xe1480a2a,0xfe3aae2b,0x2ef7727c,0xda0121e1,0x4b610a78,0xd30f49c5
				DCD	0x1a3c2c63,0x984990bc,0xdb17118a,0x7dae238f,0x77aa1c96,0xb7247800,0xb117475f,0xe6b2e711,0x1fffc297,0x144b449f,0x6f08b591,0x4e614a80
				DCD	0x204dd082,0x163a93e0,0xeb8b565a,0x5326831,0xf0f94119,0xeb6e5842,0xd9c3b040,0x9a14c068,0x38ccce54,0x33e24bae,0xc424c12b,0x5d9b21ad
				DCD 0x355fb674,0xb224f668,0x296b3f6b,0x59805a5f,0x8568723b,0xb9f49f9d,0xf6831262,0x78728bab,0x10f12673,0x984e7bee,0x214f59a2,0xfb088de7
				DCD	0x8b641c20,0x72a0a379,0x225fe86a,0xd98a49f3

				
					
;allocate area for sorted array for read write data
				AREA NEW_ARRAY,data, readwrite
				ALIGN
new_array_start	;allocate space
				SPACE 400
new_array_end
;allocate area for time array for read write data
				AREA TIME_ARRAY,data, readwrite
				ALIGN
time_array_start	
				SPACE 396;allocate space
time_array_end
					
array_size		EQU 100			;array size is 100			
				AREA main, CODE, READONLY
				ENTRY
				THUMB
				EXPORT	__main
				ALIGN
SysTick_CTRL        EQU    	0xE000E010    ;SYST_CSR -> SysTick Control and Status Register
SysTick_RELOAD      EQU    	0xE000E014    ;SYST_RVR -> SysTick Reload Value Register
SysTick_VAL         EQU    	0xE000E018    ;SYST_CVR -> SysTick Current Value Register
RELOAD				EQU		0x00278CFF		;question 1 my results reload value
START				EQU		0x7;#0111
INTERRUPT			EQU		0xE000E00c		;The address where I keep track of the interrupt count
	
	
__main			FUNCTION
				LDR 	R0, =SysTick_CTRL 			;initalize systick register
				LDR		R1, =SysTick_RELOAD
				LDR		R2, =RELOAD
				LDR		R3, =START
				STR		R2, [R1]			; set the reload value
				STR		R3,	[R0]			; set the start value
				movs	r1,#2				;i start 2 for the main loop(i = 2, i <= array_size,i++)
				movs	r7,#0				;When copying from the array to the new array, the variable with which we will sum the starting address of the new array.When copying from the array to the new array, in each iteration, the variable that will be incremented by 4 to copy the next number.
				b		l4					;branch l4

l5				pop		{r3,r5}				;pop r3 and r4
				b		l4					;branch l4
l4				
				ldr		r0,=SysTick_VAL 		;load systick value register adress
				ldr		r2,[r0]					;load  systick current value
				ldr		r0,=array_size			;load array_size
				ldr		r3,=array_start			;load array starting point adress
				ldr		r5,=new_array_start		;load new array starting point adress
				ldr		r6,=time_array_start	;load time array starting point adress
				str		r2,[r6,r7]				;Store the current value to the i-1 element of the time array. At the end of the loop, retrieve the start current value from this address.
				push	{r3,r5}					;push stack r3 and r5 register
				movs	r3,#0					;MOVS 0 TO R3 for reset interrupt counter
				push	{r2}					;push r2 register 
				ldr		r2,=INTERRUPT			;The address where I keep track of the interrupt count
				str		R3,[r2]					;reset interrupt counter
				pop		{r2}					;pop r2 on stack
				movs	r3,#0					;it is variable for copy_array iterate the array for copying and storing of array elements, starting from 0 and incrementing by 4 in each iteration to point to the next array element.
				cmp		r1,r0					;The loop continues as long as 'i' is less than array_size.
				ble		copy_array				;branch copy_array
				b		last2					;finish the loop and branch last2
				
				
copy_array		pop		{r0,r5}					;pop r0 and r5
				push	{r0,r5}					;push r0 and r5
				ldr		r2,[r0,r3]				;Load the element of the array iteration into R2 
				str		r2,[r5,r3]				;new arayin ilgili iterayonuna yükle(iterasyon = r3/4+1)+1 for my code is 1 base.
				adds	r5,r5,r3				;load it into the relevant iteration of the new array. iteration value equal to above line.
				movs	r4,r1
				lsls	r4,#2					;each element 4 byte ;to calculate arrays first element to the location of the last element
				adds	r3,#4					;iterate 1 element
				cmp		r3,r4					;check it copies the first 'i' elements  or not 
				bge		cont
				b 		copy_array
				
								
cont			movs	r0,#2					;j initialize 2
				b		l1
				
l1 				cmp     r1, r0					;The first for loop inside the bubble sort (for j = 2, j <= i, j++)
				blt     last
				movs    r2, #0					;The second(inner) for loop inside the bubble sort (for k = 0, k <= i-j, k++)
				subs  	r3, r1, r0				;r3 = i - j 
				push	{r6,r7}					;push r6,r7
				b       l2
			
l2         		cmp     r2, r3					;compare condition k <= i-j
				bgt     finish2
				lsls    r4, r2, #2				;r4 = r2*4;to calculate k th element adress 
				adds    r2, #1					;k=k+1, iterate array
				ldr     r7, =new_array_start	;new array start adress
				ldr     r5, [r7, r4]			;new arrays k th element 
				adds    r4, #4
				ldr     r6, [r7, r4]			;new arrays k+1 th element 
				cmp     r6, r5					;check k+1 bigger than k or not
				bls     l3						
				b       l2
			
l3	            str     r5, [r7, r4]			;exchange the k and k+1 iterations value
				subs    r4, #4
				str     r6, [r7, r4]
				b       l2
			
finish2		    adds    r0, #1					;j = j + 1 iterate outer (first loop)
				pop		{r6,r7}					;pop r6 r7
				b       l1


last			
				adds	r1,#1					;i=i+1 iterate main loop
				ldr		r2,=SysTick_VAL 		
				ldr		r3,[r2]					;load end systick current value for i bubblesort
				pop		{r4,r5}					
				movs	r4,#0					
				ldr		r5,[r6,r7]				;load end systick current value for i bubblesort
				str		r4,[r6,r7]				;reset the value in time array i-1 iterate adress
				b		time
				

				
time											;this function for calculate total tick number including interrupt
				push	{r4,r6,r7,r1,r2}
				ldr		r2,=INTERRUPT			;interrupt numbers adress
				ldr		r4,[r2]					;count of interrupt
				ldr		r7,=SysTick_RELOAD		
				ldr		r6,[r7]					;load my reload value from reload value register adress
				muls	r4,r6,r4				;product count of interrupt and my reload value
				adds	r4,r5,r4				;add start current value
				subs	r3,r4,r3				;subtract end current value
				pop		{r4,r6,r7,r1,r2}		
				b		cont2				
				;x/8Mh = x / 8*10^6 second = x/8 microsecond because micro = 10^-6 and M = 10^6 , x cycle count, frequency =8MH, frequency = number of cycle in one second so 1/f is periyot(one cycle time range)
cont2			;1/8Mh = 0.125 microsaniye
				lsrs	r3,#3					;tick numbers=cycle count, divide the cycle count by the frequency. frequency=8
				str		r3,[r6,r7]				;store the time array relevalent(i-1) iterate
				adds	r7,#4					;add 4 to r7 for iterate next element of array
				b		l5
	

				


last2			movs	r4,#0
				str		r4,[r6,r7]						;It sets the value to zero after the last element of the time array because I compare 'i' with 'array_size' after saving the start SysTick Current values.
				ldr		r4,=SysTick_CTRL   				;Reset the SysTick value. stop systic timer
				ldr		r0,=new_array_start				;new array start points load r0
				ldr		r1,=time_array_start			;new array start points load r0
				
				
				


stop			B		stop


					
				ENDFUNC
				END

