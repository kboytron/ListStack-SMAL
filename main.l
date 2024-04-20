SMAL32 (rev  8/19)              MP4 by Douglas Jones, recu   10:20:52  Page  1
                                                             Fri Apr 19 2024

                                 1          TITLE   "MP4 by Douglas Jones, recursion-free version"
                                 2          ; plots the trees using explicit stacks of what needs printing
                                 3          ; to plot a tree, pushes the coordinates of the center of the tree
                                 4          ; comptes the tree size by trying bigger and bigger till it won't fit
                                 5  
                                 6          ; NOTE:  There is no recursion here, it's all done with loops and stacks
                                 7          ; Code has been added so that, for a large screen, the heap overflows
                                 8          ; in order to force the stack implementation to throw an exception
                                 9  
                                10          ; NOTE:  Code has been added to check that both stack overflow and
                                11          ; stack underflow throw exceptions; the code deliberately nests
                                12          ; try-catch blocks to make sure they nest correctly.
                                13  
                                14          USE     "hawk.h"
                                15          USE     "stdio.h"
                                16          USE     "stdlib.h"
                                17          USE     "exceptions.h"
                                18          USE     "stack.h"
                                19          USE     "arraystack.h"
                                20          USE     "liststack.h"
                                21  
                                22          INT     MAIN
                                23          S       MAIN
                                24  
                                25  ; activation record for MAIN
                                26  ;RETAD  =       0
                                27  EX1     =       4               ; support outer try-catch block
                                28  EX2     =       4 + EXSIZE      ; inner try-catch block
                                29  SVR13   =       EX2 + EXSIZE    ; save locations for registers during try
                                30  SVR14   =       SVR13 + 4
                                31  SVR15   =       SVR14 + 4
                                32  ARSIZE  =       SVR15 + 4
                                33  
                                34  MAIN:
+00000000: F1  A2               35          STORES  R1,R2
+00000002: F2  62  0028         36          ADDI    R2,R2,ARSIZE
+00000006: F1  70  01E2  F1     37          EXINSTALL STACKEXCEPT,EX1-ARSIZE,MAINHAND
+0000000B: 22  FFDC  F2  22 
+00000010: FFE0  E1 +000000 
+00000016: F3  D1  F3  22 
+0000001A: FFE4  F3  72 
+0000001E: FFDC  F3  A1 
SMAL32 (rev  8/19)              MP4 by Douglas Jones, recu   10:20:52  Page  2
                                                             Fri Apr 19 2024

                                38                                  ; try {
                                39  
                                40                                  ;   -- A, make some different kinds of stacks
+00000022: E1 +000000           41          LIL     R1,NEWARRAYSTACK
+00000026: F1  B1               42          JSRS    R1,R1           ;   -- stack for sizes of trees
+00000028: FD  F3               43          MOVE    R13,R3          ;   sizestack = newarraystack()
+0000002A: E1 +000000           44          LIL     R1,NEWLISTSTACK
+0000002E: F1  B1               45          JSRS    R1,R1           ;   -- stack for x coordinates
+00000030: FE  F3               46          MOVE    R14,R3          ;   xstack = newliststack()
+00000032: E1 +000000           47          LIL     R1,NEWLISTSTACK
+00000036: F1  B1               48          JSRS    R1,R1           ;   -- stack for y coordinates
+00000038: FF  F3               49          MOVE    R15,R3          ;   ystack = newliststack()
                                50          ; here  R13 = sizestack
                                51          ;       R14 = xstack
                                52          ;       R15 = ystack    ;   -- these stacks describe pending trees
                                53  
                                54                                  ;   -- B, make sure popping empty throws ex
+0000003A: FD  22  001C         55          STORE   R13,R2,SVR13
+0000003E: FE  22  0020         56          STORE   R14,R2,SVR14
+00000042: FF  22  0024         57          STORE   R15,R2,SVR15    ;   -- save registers lost if exception thrown
+00000046: F1  70  002E  F1     58          EXINSTALL STACKEXCEPT,EX2-ARSIZE,INNERHND
+0000004B: 22  FFE8  F2  22 
+00000050: FFEC  E1 +000000 
+00000056: F3  D1  F3  22 
+0000005A: FFF0  F3  72 
+0000005E: FFE8  F3  A1 
                                59                                  ;   try {
+00000062: F3  FE               60          MOVE    R3,R14          ;     -- parameter xstack (a list stack)
+00000064: F1  53  0008         61          LOAD    R1,R3,POP
+00000068: F1  B1               62          JSRS    R1,R1
+0000006A: F9  F3               63          MOVE    R9,R3           ;     (void)xstack->pop( xstack )
+0000006C: F3  52  FFF0  E1     64          EXREMOVE STACKEXCEPT,EX2-ARSIZE
+00000071:+000000  F3  A1 
+00000076: 00  05               65          BR      INNERDONE
                                66  INNERHND:                       ;   } catch stackexecpt {
+00000078: F3  70  0180         67          LEA     R3,EMPTYOK
+0000007C: E1 +000000           68          LIL     R1,PUTS
+00000080: F1  B1               69          JSRS    R1,R1           ;     puts( "pop empty throws exception" )
                                70  INNERDONE:                      ;   }
+00000082: FD  52  001C         71          LOAD    R13,R2,SVR13
+00000086: FE  52  0020         72          LOAD    R14,R2,SVR14
SMAL32 (rev  8/19)              MP4 by Douglas Jones, recu   10:20:52  Page  3
                                                             Fri Apr 19 2024

+0000008A: FF  52  0024         73          LOAD    R15,R2,SVR15    ;   -- restore registers saved above
                                74  
                                75                                  ;   -- C, use up most of the heap
+0000008E: E3  00FA80           76          LIL     R3,#FA80        ;   -- param p = amount of heap to use
+00000092: E1 +000000           77          LIL     R1,MALLOC
+00000096: F1  B1               78          JSRS    R1,R1
+00000098: F0  E3               79          TESTR   R3
+0000009A: 0A  05               80          BZR     CRAMP           ;   if (malloc( p ) == NULL) {
+0000009C: F3  70  0177         81          LEA     R3,HEAPFIL
+000000A0: E1 +000000           82          LIL     R1,PUTS
+000000A4: F1  B1               83          JSRS    R1,R1           ;     puts( "failed to cramp stack" )
                                84  CRAMP:                          ;   }
                                85          
                                86                                  ;   -- D, get tree size from screen size
+000000A6: E3 +000000           87          LIL     R3,TERMINFO
+000000AA: F4  53  0004         88          LOAD    R4,R3,TERMCOLS  ;   -- get termcols
+000000AE: F5  53  0000         89          LOAD    R5,R3,TERMROWS  ;   -- get termrows
                                90  
                                91                                  ;   -- problem 1, what size fits?
+000000B2: D3  01               92          LIS     R3,1            ;   size = 1
                                93          ; here  R3 = size       ;   -- size is always a power of 2
                                94          ;       R4 = termcols
                                95          ;       R5 = termrows
                                96          ;       R6 = height then width
                                97          ;       R13,14,15 = stacks for size,x,y
                                98  SIZELP:                         ;   for (;;) {
+000000B4: B6  31               99          MOVESL  R6,R3,1
+000000B6: 16  CF              100          ADDSI   R6,-1           ;     height = 2*size - 1
+000000B8: 20  56              101          CMP     R5,R6
+000000BA: 05  05              102          BLT     SIZEQT          ;     if (termrows < height) break
+000000BC: A6  01              103          SL      R6,1            ;     width = 2*height
+000000BE: 20  46              104          CMP     R4,R6
+000000C0: 05  02              105          BLT     SIZEQT          ;     if (termcols < width) break
+000000C2: A3  01              106          SL      R3,1            ;     size = size * 2
+000000C4: 00  F7              107          BR      SIZELP
                               108  SIZEQT:                         ;   }
                               109          
                               110                                  ;   -- we computed one size too large
+000000C6: 83  01              111          SRU     R3,1            ;   -- parameter size = size/2
+000000C8: 94  01              112          SR      R4,1            ;   -- parameter x = termcols/2
+000000CA: 95  01              113          SR      R5,1            ;   -- parameter y = termrows/2 - size + 1
SMAL32 (rev  8/19)              MP4 by Douglas Jones, recu   10:20:52  Page  4
                                                             Fri Apr 19 2024

                               114  
                               115                                  ;   -- E, schedule first tree to print
                               116          ; here  R3 = size       ;   -- size of the tree
                               117          ;       R4 = termcols   ;   -- x location of tree center
                               118          ;       R5 = termrows   ;   -- y location of gree center
                               119          ;       R13,14,15 = stacks for size,x,y
                               120  
+000000CC: F8  F4              121          MOVE    R8,R4
+000000CE: F9  F5              122          MOVE    R9,R5           ;   -- move x and y temporarily
+000000D0: F4  F3              123          MOVE    R4,R3           ;   -- parameter size
+000000D2: F3  FD              124          MOVE    R3,R13          ;   -- parameter sizestack
+000000D4: F1  53  0004        125          LOAD    R1,R3,PUSH
+000000D8: F1  B1              126          JSRS    R1,R1           ;   sizestack->push( sizestack, size )
+000000DA: F4  F8              127          MOVE    R4,R8           ;   -- parameter x
+000000DC: F3  FE              128          MOVE    R3,R14          ;   -- parameter xstack
+000000DE: F1  53  0004        129          LOAD    R1,R3,PUSH
+000000E2: F1  B1              130          JSRS    R1,R1           ;   xstack->push( xstack, x )
+000000E4: F4  F9              131          MOVE    R4,R9           ;   -- parameter y
+000000E6: F3  FF              132          MOVE    R3,R15          ;   -- parameter ystack
+000000E8: F1  53  0004        133          LOAD    R1,R3,PUSH
+000000EC: F1  B1              134          JSRS    R1,R1           ;   ystack->push( ystack, x )
                               135  
                               136                                  ;   -- F, plot trees till stack is empty
                               137  PLOTLOOP:                       ;   for (;;) {
                               138          ; here  R13 = sizestack
                               139          ;       R14 = xstack
                               140          ;       R15 = ystack
+000000EE: F3  FD              141          MOVE    R3,R13          ;     -- parameter sizestack
+000000F0: F1  53  0000        142          LOAD    R1,R3,EMPTY
+000000F4: F1  B1              143          JSRS    R1,R1
+000000F6: F0  E3              144          TESTR   R3
+000000F8: 0A  5C              145          BZR     PLOTQUIT        ;     if (sizestack->empty(sizestack)) break
                               146  
+000000FA: F3  FE              147          MOVE    R3,R14          ;     -- parameter xstack
+000000FC: F1  53  0000        148          LOAD    R1,R3,EMPTY
+00000100: F1  B1              149          JSRS    R1,R1
+00000102: F0  E3              150          TESTR   R3
+00000104: 0A  56              151          BZR     PLOTQUIT        ;     if (xstack->empty( xstack )) break
                               152  
+00000106: F3  FF              153          MOVE    R3,R15          ;     -- parameter ystack
+00000108: F1  53  0000        154          LOAD    R1,R3,EMPTY
SMAL32 (rev  8/19)              MP4 by Douglas Jones, recu   10:20:52  Page  5
                                                             Fri Apr 19 2024

+0000010C: F1  B1              155          JSRS    R1,R1
+0000010E: F0  E3              156          TESTR   R3
+00000110: 0A  50              157          BZR     PLOTQUIT        ;     if (ystack->empty( ystack )) break
                               158  
                               159                                  ;     -- if any stack was empty we quit
+00000112: F3  FD              160          MOVE    R3,R13          ;     -- parameter sizestack
+00000114: F1  53  0008        161          LOAD    R1,R3,POP
+00000118: F1  B1              162          JSRS    R1,R1           ; 
+0000011A: F8  F3              163          MOVE    R8,R3           ;     size = sizestack->pop( sizestack )
+0000011C: F3  FE              164          MOVE    R3,R14          ;     -- parameter xstack
+0000011E: F1  53  0008        165          LOAD    R1,R3,POP
+00000122: F1  B1              166          JSRS    R1,R1
+00000124: F9  F3              167          MOVE    R9,R3           ;     x = xstack->pop( xstack )
+00000126: F3  FF              168          MOVE    R3,R15          ;     -- parameter ystack
+00000128: F1  53  0008        169          LOAD    R1,R3,POP
+0000012C: F1  B1              170          JSRS    R1,R1
+0000012E: FA  F3              171          MOVE    R10,R3          ;     y = ystack->pop( ystack )
                               172          ; here  R8 = size
                               173          ;       R9 = x
                               174          ;       R10 = y         ;     -- characteristics of one tree
                               175          ;       R13,14,15 = stacks for size,x,y
                               176  
+00000130: F0  E8              177          TESTR   R8
+00000132: 02  DD              178          BZS     NOTREE          ;     if (size >= 1) {
                               179  
                               180                                  ;       -- push left subtree attributes
+00000134: F3  FD              181          MOVE    R3,R13          ;       -- parameter sizestack
+00000136: F4  F8              182          MOVE    R4,R8           ;
+00000138: 94  01              183          SR      R4,1            ;       -- parameter size/2
+0000013A: F1  53  0004        184          LOAD    R1,R3,PUSH
+0000013E: F1  B1              185          JSRS    R1,R1           ;       sizestack->push( sizestack, size/2 )
                               186  
+00000140: F3  FE              187          MOVE    R3,R14          ;       -- parameter xstack
+00000142: F4  F9              188          MOVE    R4,R9
+00000144: 24  48              189          SUB     R4,R4,R8        ;       -- parameter x - size
+00000146: F1  53  0004        190          LOAD    R1,R3,PUSH
+0000014A: F1  B1              191          JSRS    R1,R1           ;       xstack->push( xstack, x - size )
                               192  
+0000014C: F3  FF              193          MOVE    R3,R15          ;       -- parameter ystack
+0000014E: F4  F8              194          MOVE    R4,R8
+00000150: 94  01              195          SR      R4,1
SMAL32 (rev  8/19)              MP4 by Douglas Jones, recu   10:20:52  Page  6
                                                             Fri Apr 19 2024

+00000152: 34  A4              196          ADD     R4,R10,R4       ;       -- parameter y + size/2
+00000154: F1  53  0004        197          LOAD    R1,R3,PUSH
+00000158: F1  B1              198          JSRS    R1,R1           ;       ystack->push( ystack, y + size/2 )
                               199  
                               200                                  ;       -- push right subtree attributes
+0000015A: F3  FD              201          MOVE    R3,R13          ;       -- parameter sizestack
+0000015C: F4  F8              202          MOVE    R4,R8
+0000015E: 94  01              203          SR      R4,1            ;       -- parameter size/2
+00000160: F1  53  0004        204          LOAD    R1,R3,PUSH
+00000164: F1  B1              205          JSRS    R1,R1           ;       sizestack->push(sizestack,size/2)
                               206  
+00000166: F3  FE              207          MOVE    R3,R14          ;       -- parameter xstack
+00000168: F4  F9              208          MOVE    R4,R9
+0000016A: 34  48              209          ADD     R4,R4,R8        ;       -- parameter x + size
+0000016C: F1  53  0004        210          LOAD    R1,R3,PUSH
+00000170: F1  B1              211          JSRS    R1,R1           ;       xstack->push( xstack, x + size )
                               212  
+00000172: F3  FF              213          MOVE    R3,R15          ;       -- parameter ystack
+00000174: F4  F8              214          MOVE    R4,R8
+00000176: 94  01              215          SR      R4,1
+00000178: 34  A4              216          ADD     R4,R10,R4       ;       -- parameter y + size/2
+0000017A: F1  53  0004        217          LOAD    R1,R3,PUSH
+0000017E: F1  B1              218          JSRS    R1,R1           ;       ystack->push( ystack, y + size/2 )
                               219  
                               220  PLOTBRANCH:                     ;       do { -- output size rows of /\
                               221          ; here  R8 = size
                               222          ;       R9 = x
                               223          ;       R10 = y         ;         -- characteristics of one tree
                               224          ;       R13,14,15 = stacks for size,x,y
+00000180: F3  F9              225          MOVE    R3,R9
+00000182: 23  38              226          SUB     R3,R3,R8        ;         -- parameter x - size
+00000184: F4  FA              227          MOVE    R4,R10          ;         -- parameter y
+00000186: E1 +000000          228          LIL     R1,PUTAT
+0000018A: F1  B1              229          JSRS    R1,R1           ;         putat( x - size, y )
+0000018C: D3  2F              230          LIS     R3,'/'          ;         -- parameter
+0000018E: E1 +000000          231          LIL     R1,PUTCHAR
+00000192: F1  B1              232          JSRS    R1,R1           ;         putchar( '/' )
                               233  
+00000194: F3  F9              234          MOVE    R3,R9
+00000196: 33  38              235          ADD     R3,R3,R8
+00000198: 13  CF              236          ADDSI   R3,-1           ;         -- parameter x + size - 1
SMAL32 (rev  8/19)              MP4 by Douglas Jones, recu   10:20:52  Page  7
                                                             Fri Apr 19 2024

+0000019A: F4  FA              237          MOVE    R4,R10          ;         -- parameter y
+0000019C: E1 +000000          238          LIL     R1,PUTAT
+000001A0: F1  B1              239          JSRS    R1,R1           ;         putat( x + size - 1, y - 1 )
+000001A2: D3  5C              240          LIS     R3,'\'          ;         -- parameter
+000001A4: E1 +000000          241          LIL     R1,PUTCHAR
+000001A8: F1  B1              242          JSRS    R1,R1           ;         putchar( '\' )
                               243  
+000001AA: 1A  CF              244          ADDSI   R10,-1          ;         y = y - 1   -- move up
+000001AC: 18  CF              245          ADDSI   R8,-1           ;         size = size - 1
+000001AE: 0E  E8              246          BGT     PLOTBRANCH      ;       } while (size > 0)
                               247  NOTREE  =       PLOTLOOP        ;     }
+000001B0: 00  9E              248          BR      PLOTLOOP        ;   }
                               249  PLOTQUIT:                       ;   -- assert, some stack was empty
                               250                                  ;   -- test that they are all empty
+000001B2: F3  FD              251          MOVE    R3,R13          ;   -- parameter sizestack
+000001B4: F1  53  0000        252          LOAD    R1,R3,EMPTY
+000001B8: F1  B1              253          JSRS    R1,R1
+000001BA: F0  E3              254          TESTR   R3
+000001BC: 02  0C              255          BZS     PLOTBUG         ;   if (!sizestack->empty(sizestack)
                               256  
+000001BE: F3  FE              257          MOVE    R3,R14          ;   -- parameter xstack
+000001C0: F1  53  0000        258          LOAD    R1,R3,EMPTY
+000001C4: F1  B1              259          JSRS    R1,R1
+000001C6: F0  E3              260          TESTR   R3
+000001C8: 02  06              261          BZS     PLOTBUG         ;   ||  !xstack->empty(xstack)
                               262  
+000001CA: F3  FF              263          MOVE    R3,R15          ;   -- parameter ystack
+000001CC: F1  53  0000        264          LOAD    R1,R3,EMPTY
+000001D0: F1  B1              265          JSRS    R1,R1
+000001D2: F0  E3              266          TESTR   R3
+000001D4: 0A  05              267          BZR     PLOTOK          ;   ||  !ystack->empty(xstack)) {
                               268  PLOTBUG:
+000001D6: F3  70  0052        269          LEA     R3,STACKBUG
+000001DA: E1 +000000          270          LIL     R1,PUTS
+000001DE: F1  B1              271          JSRS    R1,R1           ;     puts( "stacks not all empty" )
                               272  PLOTOK:                         ;   }
+000001E0: F3  52  FFE4  E1    273          EXREMOVE STACKEXCEPT,EX1-ARSIZE
+000001E5:+000000  F3  A1 
+000001EA: 00  05              274          BR      ENDCATCH        
                               275  MAINHAND:                       ; } catch stackexcept {
+000001EC: F3  70  0051        276          LEA     R3,STACKEX1
SMAL32 (rev  8/19)              MP4 by Douglas Jones, recu   10:20:52  Page  8
                                                             Fri Apr 19 2024

+000001F0: E1 +000000          277          LIL     R1,PUTS
+000001F4: F1  B1              278          JSRS    R1,R1           ;   puts( "stack exception" )
                               279  
                               280  ENDCATCH:                       ; }
+000001F6: F2  62  FFD8        281          ADDI    R2,R2,-ARSIZE
+000001FA: F0  D2              282          LOADS   PC,R2           ; return
                               283  
                               284  EMPTYOK:
+000001FC: 70  6F  70  20      285          ASCII   "pop empty throws exception",0
+00000200: 65  6D  70  74 
+00000204: 79  20  74  68 
+00000208: 72  6F  77  73 
+0000020C: 20  65  78  63 
+00000210: 65  70  74  69 
+00000214: 6F  6E  00 
                               286  HEAPFIL:
+00000217: 66  61  69  6C      287          ASCII   "failed to cramp heap",0
+0000021B: 65  64  20  74 
+0000021F: 6F  20  63  72 
+00000223: 61  6D  70  20 
+00000227: 68  65  61  70 
+0000022B: 00 
                               288  STACKBUG:
+0000022C: 73  74  61  63      289          ASCII   "stacks not all empty",0
+00000230: 6B  73  20  6E 
+00000234: 6F  74  20  61 
+00000238: 6C  6C  20  65 
+0000023C: 6D  70  74  79 
+00000240: 00 
                               290  STACKEX1:
+00000241: 73  74  61  63      291          ASCII   "stack exception",0
+00000245: 6B  20  65  78 
+00000249: 63  65  70  74 
+0000024D: 69  6F  6E  00 
                               292          
                               293          END
                    no errors
