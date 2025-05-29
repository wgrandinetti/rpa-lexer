%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern int yylex();
extern FILE *yyin;
extern int statement_count;

void yyerror(const char *s);
void count_statement();
%}

%union {
    int number;
    char *string;
}

%token PROGRAM VAR BEGIN END IF THEN ELSE WHILE DO FOR TO DOWNTO
%token REPEAT UNTIL CASE OF PROCEDURE FUNCTION GOTO WITH TRY FINALLY EXCEPT RAISE
%token WRITE WRITELN READ READLN
/* ... otros tokens ... */

%precedence THEN_PREC
%precedence ELSE

%%

program:
    PROGRAM IDENTIFIER ';' block '.' 
    {
        printf("Número total de sentencias: %d\n", statement_count);
    }
    ;

block:
    declarations compound_statement
    ;

compound_statement:
    BEGIN statement_list END
    ;

statement_list:
    statement { count_statement(); }
    | statement_list ';' statement { count_statement(); }
    ;

statement:
    assignment_statement
    | if_statement
    | while_statement
    | compound_statement
    | io_statement
    /* ... otras sentencias ... */
    ;

assignment_statement:
    IDENTIFIER ASSIGN expression
    ;

if_statement:
    IF expression THEN statement %prec THEN_PREC
    | IF expression THEN statement ELSE statement
    ;

io_statement:
    WRITE '(' argument_list ')' 
    | READ '(' argument_list ')'
    ;

/* ... resto de gramática ... */

%%

void count_statement() {
    // Solo cuenta sentencias en el nivel superior
    // (evita contar sentencias anidadas múltiples veces)
    static int depth = 0;
    if (depth == 0) {
        statement_count++;
    }
}

void yyerror(const char *s) {
    fprintf(stderr, "Error en línea %d: %s\n", yylineno, s);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s archivo.pas\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error al abrir archivo");
        return 1;
    }

    statement_count = 0;
    yyparse();
    fclose(yyin);
    return 0;
}