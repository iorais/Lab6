        .syntax     unified
        .cpu        cortex-m4
        .text

// ------------------------------------------------------------------------
// void MatrixMultiply(int32_t a[3][3], int32_t b[3][3], int32_t c[3][3]) ;
// ------------------------------------------------------------------------

        .global     MatrixMultiply
        .thumb_func
        .align

MatrixMultiply: // R0 = &a, R1 = &b, R2 = &c
        PUSH        {r4 - r10, LR}
        MOV         r4, r0                  //preserve a, b, and c
        MOV         r5, r1                  
        MOV         r6, r2

        MOV         r10, 3                  //r10 = 3

        EOR         r7, r7                  //row = 0
NxtRow:                                     
        CMP         r7, 3                   //for row < 3
        BGE         EndRow

        EOR         r8, r8                  //col = 0
NxtCol: 
        CMP         r8, 3                   //for col < 3
        BGE         EndCol

        EOR         r0, r0                  //a[row][col] = 0
        MLA         r3, r10, r7, r8
        STR         r0, [r4, r3, LSL 2]

        EOR         r9, r9                  //k = 0
NxtK:   
        CMP         r9, 3                   //for k < 3
        BGE         EndK

        MLA         r3, r10, r7, r8         //r0 = a[row][col]
        LDR         r0, [r4, r3, LSL 2]

        MLA         r3, r10, r7, r9         //r1 = b[row][k]
        LDR         r1, [r5, r3, LSL 2]

        MLA         r3, r10, r9, r8         //r2 = c[k][col]
        LDR         r2, [r6, r3, LSL 2]

        BL          MultAndAdd              //a[row][col] = MultAndAdd(r0, r1, r2)
        MLA         r3, r10, r7, r8
        STR         r0, [r4, r3, LSL 2]

        ADD         r9, 1                   //k++
        B           NxtK
EndK:   
        ADD         r8, 1                   //col++
        B           NxtCol

EndCol: 
		ADD         r7, 1                   //row++
        B           NxtRow

EndRow:
        POP         {r4 - r10, PC}
        .end


