# Makefile

OBJS	= bison.o lex.o main.o

CC	= g++
CFLAGS	= -g -Wall -ansi -pedantic

cppe:		$(OBJS)
		$(CC)	$(CFLAGS)	$(OBJS)	-o cppe -lfl

lex.o:		lex.c
		$(CC)	$(CFLAGS) -c lex.c -o lex.o

lex.c:		cppe.l 
		flex cppe.l
		cp lex.yy.c lex.c

bison.o:	bison.c
		$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	cppe.y
		bison -d -v cppe.y
		cp cppe.tab.c bison.c
		cmp -s cppe.tab.h tok.h || cp cppe.tab.h tok.h

main.o:		main.cc
		$(CC) $(CFLAGS) -c main.cc -o main.o

lex.o bison.o main.o	: heading.h
lex.o main.o			: tok.h

clean:
	rm -f	*.o *~	lex.c	lex.yy.c	bison.c	tok.h	cppe.tab.c	cppe.tab.h	cppe.output	cppe