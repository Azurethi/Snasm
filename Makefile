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

build/0_test: build/0_test.o
	gcc -o $@ $<

build/0_test.o : buildup/test.S
	as -o $@ $<

clean:
	rm -vf build/*