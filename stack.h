; stack.h
; an abstract class -- that is, it cannot be instantiated.
; subclasses of stack each will provide a constructor.
			; see the subclass .h file for documentation

	COMMON	STACKEXCEPT,4

; stackexcept is an exception pointer, see exceptions.h

; All instances of stack have the following fields:
EMPTY	=	0	; pointer to the empty method of this stack
			; given   nothing
			; returns R3 -- zero if not empty, nonzero if empty
			; may use R4-R7

PUSH	=	4	; pointer to the pop method of this stack
			; given   R3 -- stack to push on
			;         R4 -- word to push
			; returns nothing
			; may use R3-R7
			; throws STACKEXCEPT if push is impossible
			;         eg, if memory exhausted

POP	=	8	; pointer to the pop method of this stack
			; given   R3 -- stack to push on
			; returns R3 -- a word popped from the stack
			; may use R4-R7
			; throws STACKEXCEPT on pop from empty stack

; each subclass may define other fields
; the total size of a stack object depends on which subclass it comes from
