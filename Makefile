# Makefile

# rem:
# $@ is a macro that refers to the target
# $< is a macro that refers to the first dependency
# $^ is a macro that refers to all dependencies
# $+ is like $^ but exactly won't ignore dublicates


#all: first
#
#first: first.o
#	gcc -o $@ $+
#
#first.o : first.s
#	as -o $@ $<
#
#clean:
#	rm -vf first *.o

0_test:
	as -o 0_test.o 0_test.s
	gcc -o 0_test 0_test.0
