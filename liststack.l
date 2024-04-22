SMAL32 (rev  8/19)              liststack.a by Karan Singh   18:09:58  Page  1
                                                             Sat Apr 20 2024

                                 1          TITLE   "liststack.a by Karan Singh -- linked list stacks"
                                 2  
                                 3          USE     "hawk.h"
                                 4          USE     "stdlib.h"
                                 5          USE     "stack.h"
                                 6          USE     "exceptions.h"
                                 7  
                                 8  ;EMPTY  =       0
                                 9  ;PUSH   =       4
                                10  ;POP    =       8
                                11  HPTR    =       12
                                12  
                                13          INT     NEWLISTSTACK
                                14  
                                15  RETAD   =       0
                                16  ARSIZE  =       8
                                17  NEWLISTSTACK:
+00000000: F1  A2               18          STORES  R1,R2
+00000002: 12  C0               19          ADDSI   R2,ARSIZE
                                20  
+00000004: E3  000010           21          LIL     R3,16           ;malloc 16 bytes for the
+00000008: E1 +000000           22          LIL     R1,MALLOC       ;stack methods
+0000000C: F1  B1               23          JSRS    R1,R1
                                24  
+0000000E: F4  70  001E         25          LEA     R4,LSEMPTY
+00000012: F4  23  0000         26          STORE   R4,R3,EMPTY
                                27  
+00000016: F4  70  0022         28          LEA     R4,LSPUSH       ;construct the methods
+0000001A: F4  23  0004         29          STORE   R4,R3,PUSH
+0000001E: F4  70  0056         30          LEA     R4,LSPOP
+00000022: F4  23  0008         31          STORE   R4,R3,POP
                                32  
+00000026: D4  00               33          LIS     R4,0
+00000028: F4  23  000C         34          STORE   R4,R3,HPTR      ;init hptr to 0
                                35  
                                36  
+0000002C: 12  C8               37          ADDSI   R2,-ARSIZE
+0000002E: F0  D2               38          LOADS   PC,R2
                                39  
                                40  LSEMPTY:
+00000030: F3  43  000C         41          LOADCC  R3,R3,HPTR      ;if hptr == null, it is empty
SMAL32 (rev  8/19)              liststack.a by Karan Singh   18:09:58  Page  2
                                                             Sat Apr 20 2024

+00000034: 02  01               42          BZS     ISEMPTY
                                43  
+00000036: D3  FF               44          LIS     R3,-1           ;if hptr != null, return -1
                                45  ISEMPTY:
+00000038: 13  90               46          NOT     R3
+0000003A: F0  B1               47          JUMPS   R1
                                48  
                                49  
                                50  NODEVAL =       0
                                51  NODEPTR =       4
                                52  
                                53  RETAD   =       0
                                54  R8S     =       4
                                55  R9S     =       8
                                56  ARSIZE  =       12
                                57  LSPUSH:
+0000003C: F1  A2               58          STORES  R1,R2
+0000003E: F8  22  0004         59          STORE   R8,R2,R8S
+00000042: F9  22  0008         60          STORE   R9,R2,R9S
+00000046: F2  62  000C         61          ADDI    R2,R2,ARSIZE
                                62  
+0000004A: F8  F3               63          MOVE    R8,R3           ;R3-STACK TO PUSH ON
+0000004C: F9  F4               64          MOVE    R9,R4           ;R4-WORD
                                65  
+0000004E: D3  08               66          LIS     R3,8
+00000050: E1 +000000           67          LIL     R1,MALLOC       ;allocate 8b
+00000054: F1  B1               68          JSRS    R1,R1
                                69  
+00000056: F0  E3               70          TESTR   R3
+00000058: 02  28               71          BZS     THROW
                                72  
+0000005A: F9  23  0000         73          STORE   R9,R3,NODEVAL   ;store the word in NODEVAL
+0000005E: F5  58  000C         74          LOAD    R5,R8,HPTR      ;put hptr -
+00000062: F5  23  0004         75          STORE   R5,R3,NODEPTR   ;-into nodeptr
+00000066: F3  28  000C         76          STORE   R3,R8,HPTR      ;point hptr to newnode
                                77  
+0000006A: F2  62  FFF4         78          ADDI    R2,R2,-ARSIZE
+0000006E: F8  52  0004         79          LOAD    R8,R2,R8S       ;restore r8,r9
+00000072: F9  52  0008         80          LOAD    R9,R2,R9S
+00000076: F0  D2               81          LOADS   PC,R2
                                82  
SMAL32 (rev  8/19)              liststack.a by Karan Singh   18:09:58  Page  3
                                                             Sat Apr 20 2024

                                83  RETAD   =       0
                                84  R8S     =       4
                                85  ARSIZE  =       8
                                86  LSPOP:
+00000078: F1  A2               87          STORES  R1,R2
+0000007A: F8  22  0004         88          STORE   R8,R2,R8S
+0000007E: 12  C0               89          ADDSI   R2,ARSIZE
                                90  
+00000080: F5  53  000C         91          LOAD    R5,R3,HPTR      ;put addr of head node in r5
                                92  
+00000084: F0  65  0000         93          CMPI    R5,0
+00000088: 02  10               94          BEQ     THROW
                                95  
+0000008A: F6  55  0004         96          LOAD    R6,R5,NODEPTR   ;put addr of head.next in r6
+0000008E: F8  55  0000         97          LOAD    R8,R5,NODEVAL   ;put popped word in r8 for output
+00000092: F7  F3               98          MOVE    R7,R3
+00000094: F3  F5               99          MOVE    R3,R5           ;move addr of head node in r3
+00000096: E1 +000000          100          LIL     R1,FREE         ;free memory from addr in r3
+0000009A: F1  B1              101          JSRS    R1,R1
                               102  
+0000009C: F6  27  000C        103          STORE   R6,R7,HPTR      ;hptr = head.next
+000000A0: F3  F8              104          MOVE    R3,R8           ;move word to r3 for return
                               105  
+000000A2: 12  C8              106          ADDSI   R2,-ARSIZE
+000000A4: F8  52  0004        107          LOAD    R8,R2,R8S
+000000A8: F0  D2              108          LOADS   PC,R2
                               109  
                               110  THROW:
+000000AA: E3 +000000          111          LIL     R3,STACKEXCEPT
+000000AE: F1  D3              112          LOADS   R1,R3           ; e = stackexept
+000000B0: F2  51  0008        113          LOAD    R2,R1,EXOLD
+000000B4: F2  A3              114          STORES  R2,R3           ; stackexept = e->exold
+000000B6: F2  51  0004        115          LOAD    R2,R1,EXAR      ; stack-frame = e->exar
+000000BA: F0  D1              116          LOADS   PC,R1;EXHAND    ; pc = e->exhand
                               117  
                               118          END
                    no errors
