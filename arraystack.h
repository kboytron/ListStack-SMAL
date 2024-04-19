; arraystack.h
; an implementation of class stack using an array with a stack pointer
; each subclass of stack provides a constructor.

	EXT	NEWARRAYSTACK
			; given   nothing
			; returns R3 -- pointer to a new array stack instance
			; may use R4-R7

; the remainder of the interface definition is found in stack.h
; nothing is revealed here about the internal details of the implementation
