CC = gcc
LEX = flex
YACC = bison
CFLAGS = -g

all: pascal_parser

pascal_parser: lex.yy.c parser.tab.c
    $(CC) $(CFLAGS) lex.yy.c parser.tab.c -o pascal_parser

lex.yy.c: lexer.l
    $(LEX) lexer.l

parser.tab.c: parser.y
    $(YACC) -d parser.y

clean:
    rm -f lex.yy.c parser.tab.c parser.tab.h pascal_parser

.PHONY: all clean