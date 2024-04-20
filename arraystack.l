SMAL32 (rev  8/19)              arraystack.a -- stacks imp   10:20:52  Page  1
                                                             Fri Apr 19 2024

                                 1          TITLE   "arraystack.a -- stacks implemented with an array"
                                 2  
                                 3          USE     "hawk.h"
                                 4          USE     "stdlib.h"
                                 5          USE     "exceptions.h"
                                 6  
                                 7          USE     "stack.h"       ; the code here implements the stack interface
                                 8  
                                 9  ; configuration constants
                                10  STACKSIZE=      10      ; stack size for this implementation, in words
                                11  
                                12  ; each stack object is a structure with 2 fields:
                                13  ; All instances of stack have the following fields:
                                14  ;EMPTY  =       0       ; pointer to the empty method, see stack.h
                                15  ;PUSH   =       4       ; pointer to the push method, see stack.h
                                16  ;POP    =       8       ; pointer to the pop method, see stack.h
                                17  
                                18  ; additional fields defined for arraystack objects
                                19  SP      =       12      ; the stack pointer, address of first free word
                                20  STACK   =       16      ; first word of an array of stacksize words
                                21  OBJSIZE =       STACK + (STACKSIZE << 2)
                                22  
                                23  ;==========
                                24          INT     NEWARRAYSTACK; construct a new stack object, see arraystack.h
                                25                          ; given   nothing
                                26                          ; returns R3 -- pointer to an initialized stack object
                                27                          ; wipes out R3-R7
                                28  ; AR for NEWARRAYSTACK
                                29  ;RETAD  =       0
                                30  ARSIZE  =       4
                                31  NEWARRAYSTACK:
+00000000: F1  A2               32          STORES  R1,R2
+00000002: 12  C4               33          ADDSI   R2,ARSIZE
                                34                                  ; -- first, allocate a new stack object
+00000004: D3  38               35          LIS     R3,OBJSIZE      ; -- parameter
+00000006: E1 +000000           36          LIL     R1,MALLOC
+0000000A: F1  B1               37          JSRS    R1,R1           ; retval = malloc( stacksize * 4 )
                                38  
                                39                                  ; -- second, initialize the new object
                                40                                  ; -- start with the method pointers
+0000000C: F4  70  0020         41          LEA     R4,ASEMPTY
SMAL32 (rev  8/19)              arraystack.a -- stacks imp   10:20:52  Page  2
                                                             Fri Apr 19 2024

+00000010: F4  23  0000         42          STORE   R4,R3,EMPTY     ; retval->empty = asempty -- the empty method
+00000014: F4  70  002A         43          LEA     R4,ASPUSH
+00000018: F4  23  0004         44          STORE   R4,R3,PUSH      ; retval->push = aspush -- the push method
+0000001C: F4  70  0038         45          LEA     R4,ASPOP
+00000020: F4  23  0008         46          STORE   R4,R3,POP       ; retval->pop = aspop -- the pop method
                                47  
                                48                                  ; -- finish by making this new stack empty
+00000024: F4  73  0010         49          LEA     R4,R3,STACK
+00000028: F4  23  000C         50          STORE   R4,R3,SP        ; retval->sp = &(retval->stack)
                                51  
+0000002C: 12  CC               52          ADDSI   R2,-ARSIZE
+0000002E: F0  D2               53          LOADS   PC,R2           ; return retval
                                54  
                                55  ;==========
                                56  ;               ASEMPTY ; test to see if a stack is empty
                                57  ASEMPTY:                ; given   R3 -- s, a stack to test
                                58                          ; returns R3 -- zero if not empty, nonzero if empty
                                59                          ; may use R4-R7
+00000030: F4  73  0010         60          LEA     R4,R3,STACK     ; -- &(s->stack)
+00000034: F5  53  000C         61          LOAD    R5,R3,SP        ; -- s->sp
+00000038: 23  45               62          SUB     R3,R4,R5        ; temp = &(s->stack) - s->sp
                                63                                  ; -- here, temp = 0 if empty, we want opposite
+0000003A: 02  01               64          BZS     ASEZERO
+0000003C: D3  FF               65          LIS     R3,-1           ; -- tricky code: if it was nonzero, make it -1
                                66  ASEZERO:
+0000003E: 13  90               67          NOT     R3              ; retval = (temp == 0)
                                68  
+00000040: F0  B1               69          JUMPS   R1              ; return retval
                                70          
                                71  ;==========
                                72  ;               ASPUSH  ; push a word on the stack
                                73                          ; given   R3 -- s, stack to push on
                                74                          ;         R4 -- word to push
                                75                          ; returns nothing
                                76                          ; wipes out R3-R7
                                77                          ; throws STACKEXCEPT if STACKSIZE exceeded
                                78  ASPUSH:
+00000042: F5  73  000C         79          LEA     R5,R3,SP        ; -- address of stack->mysp
+00000046: F6  D5               80          LOADS   R6,R5           ; -- value of stack->mysp
+00000048: F7  73  0038         81          LEA     R7,R3,OBJSIZE
+0000004C: 20  67               82          CMP     R6,R7
SMAL32 (rev  8/19)              arraystack.a -- stacks imp   10:20:52  Page  3
                                                             Fri Apr 19 2024

+0000004E: 04  0F               83          BGEU    THROW           ; if (s->mysp >= s->objsize) throw stackexcept
+00000050: F4  A6               84          STORES  R4,R6           ; *(s->mysp) = word to push
+00000052: 16  C4               85          ADDSI   R6,4            ; s->mysp ++
+00000054: F6  A5               86          STORES  R6,R5           ; -- put s->mysp back
                                87  
+00000056: F0  B1               88          JUMPS   R1              ; return
                                89  
                                90  ;==========
                                91  ;               ASPOP   ; pop a word from the stack
                                92                          ; given   R3 -- s, stack to push on
                                93                          ; returns R3 -- a word popped from the stack
                                94                          ; wipes out R4-R6
                                95                          ; throws STACKEXCEPT on pop from empty stack
                                96  ASPOP:
+00000058: F5  73  000C         97          LEA     R5,R3,SP        ; -- address of stack->mysp
+0000005C: F6  D5               98          LOADS   R6,R5           ; -- value of stack->mysp
+0000005E: F7  73  0010         99          LEA     R7,R3,STACK
+00000062: 20  67              100          CMP     R6,R7
+00000064: 07  04              101          BLEU    THROW           ; if (s->mysp <= s->stack) throw stackexcept
+00000066: 16  CC              102          ADDSI   R6,-4           ; s->mysp --
+00000068: F3  D6              103          LOADS   R3,R6           ; retval = *(s->mysp)
+0000006A: F6  A5              104          STORES  R6,R5           ; -- put s->mysp back
                               105  
+0000006C: F0  B1              106          JUMPS   R1              ; return retval
                               107  
                               108  ;==========
                               109  ;  shared code to throw a stack exception
                               110  THROW:
+0000006E: E3 +000000          111          LIL     R3,STACKEXCEPT
+00000072: F1  D3              112          LOADS   R1,R3           ; e = stackexept
+00000074: F2  51  0008        113          LOAD    R2,R1,EXOLD
+00000078: F2  A3              114          STORES  R2,R3           ; stackexept = e->exold
+0000007A: F2  51  0004        115          LOAD    R2,R1,EXAR      ; stack-frame = e->exar
+0000007E: F0  D1              116          LOADS   PC,R1;EXHAND    ; pc = e->exhand
                               117  
                               118          END
                    no errors
