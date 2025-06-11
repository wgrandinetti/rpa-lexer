# rpa-lexer
Parser of pascal program for project 1

flex simple.l | gcc lex.yy.c -o lexer -lfl      
./lexer < prueba.txt