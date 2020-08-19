# Snasm

## The classic snake game!
### But text based
#### and written in x86 assembly
##### because I enjoy pain

<hr>

This is still a WIP, ``/snake.asm`` isn't a snake game yet, just a hello world script. There are a bunch of sub-projects in ``/Buildup`` that I'm using as stepping stones to learn what I need to in order to finish the final game:

- Hello world
- NullTerm  : Null terminated strings
- binStr    : register -> ascii binary
- debug     : print all registers in binary
- UI        : Displaying a simple UI frame, using pointers for potential access
- Input waiting test: Get input without blocking
- Input loop : more input testing, ran into ANSI term issues here

I was using an online dev environment (over at https://www.jdoodle.com/compile-assembler-nasm-online/) since it's easier than setting up everthing on my windows pc & I wanted to use linux syscalls. However, this tool dosen't accept ANSI terminal codes or scrolling. I need these for clearing the screen for updates, and potentially for colouring to make things a little prettier.

Hitting this problem, I am considering setting up an old laptop with x86 linux, or just re-learning things as needed to use ARM, since I have a raspberry pi that I already use as a server.