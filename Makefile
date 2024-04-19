# Makefile for the project demonstrating a stack with multiple instances

# Make uses sh, not bash, so we need to install the hawk and hawklink commands;
# these definitions are lifted from the aliases in .bashrc
# (If you try to use this makefile on a different system, you will need
# to change the file names to where hawk and hawklink are installed there.)
smal=~dwjones/bin/smal32 -P 45 -U ~dwjones/lib/hawk
hawklink=~dwjones/bin/hawklink -d
hawk=~dwjones/bin/hawk

##########
# primary make target

stackdemo.o: main.o arraystack.o liststack.o
	$(hawklink) -o stackdemo main.o arraystack.o liststack.o

##########
# secondary make targets

# the main program uses two different stack abstractions
main.o: main.a stack.h arraystack.h liststack.h
	$(smal) main.a

# class stack cannot be instantiated and has no code, so no make rules

# class arraystack, a subclass of stack
arraystack.o: arraystack.a stack.h arraystack.h
	$(smal) arraystack.a

# class liststack, a subclass of stack
liststack.o: liststack.a stack.h liststack.h
	$(smal) liststack.a

##########
# Make utilities

# demonsrate the program
demo: stackdemo.o
	$(hawk)	stackdemo.o

# remove object and listing files
clean:
	rm -f *.o *.l

# create a shell archive of the project
liststack=liststack.h liststack.a
arraystack=arraystack.h arraystack.a
stacks=stack.h $(arraystack) $(liststack)
stackdemo.shar: README Makefile main.a $(stacks)
	shar README Makefile main.a $(stacks) > stackdemo.shar
