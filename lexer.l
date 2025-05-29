%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

extern int yylineno;
extern int statement_count;
extern void count_statement();
%}

%option noyywrap
%option yylineno
%option bison-bridge

DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
WHITESPACE  [ \t\r]+
NEWLINE     [\n]

%x COMMENT DIRECTIVE STRING_MODE COMMENT_BRACE COMMENT_PAREN COMMENT_BACKSLASH

%%

"(*"                     { BEGIN(COMMENT_PAREN); /* Capturar los comentarios con (* *) */}
<COMMENT_PAREN>"*)"      { BEGIN(INITIAL); }

"{"                      { BEGIN(COMMENT_BRACE); /* Capturar los comentarios con {} */ }
<COMMENT_BRACE>"}"       { BEGIN(INITIAL); }
<COMMENT_BRACE>[^}]*     { /* ignorar contenido del comentario */ }
<COMMENT_BRACE>\n        { /* ignorar nueva línea en comentario */ }


<INITIAL>"{$"            { BEGIN(DIRECTIVE); }
<DIRECTIVE>"}"           { BEGIN(INITIAL); }
<DIRECTIVE>[^}\n]+       { /* Ignorar texto de directiva */ }
<DIRECTIVE>\n            { /* Mantener seguimiento de líneas */ }

<INITIAL>\"              { BEGIN(STRING_MODE); }
<STRING_MODE>\"          { BEGIN(INITIAL); }
<STRING_MODE>[^"\n\\]+   { /* Capturar contenido de string */ }
<STRING_MODE>\\[ntr"\\]  { /* Secuencias de escape */ }
<STRING_MODE>\n          { fprintf(stderr, "Error: String no cerrado\n"); }

{WHITESPACE}             { /* Ignorar espacios en blanco */ }
{NEWLINE}                { /* Actualizar número de línea */ }

<INITIAL>"program"       { return PROGRAM; }
<INITIAL>"var"           { return VAR; }
<INITIAL>"begin"         { return BEGIN; }
<INITIAL>"end"           { return END; }
<INITIAL>"if"            { return IF; }
<INITIAL>"then"          { return THEN; }
<INITIAL>"else"          { return ELSE; }
<INITIAL>"while"         { return WHILE; }
<INITIAL>"do"            { return DO; }
<INITIAL>"for"           { return FOR; }
<INITIAL>"to"            { return TO; }
<INITIAL>"downto"        { return DOWNTO; }
<INITIAL>"repeat"        { return REPEAT; }
<INITIAL>"until"         { return UNTIL; }
<INITIAL>"case"          { return CASE; }
<INITIAL>"of"            { return OF; }
<INITIAL>"procedure"     { return PROCEDURE; }
<INITIAL>"function"      { return FUNCTION; }
<INITIAL>"write"         { return WRITE; }
<INITIAL>"writeln"       { return WRITELN; }
<INITIAL>"read"          { return READ; }
<INITIAL>"readln"        { return READLN; }

<INITIAL>";"             { return ';'; }
<INITIAL>":"             { return ':'; }
<INITIAL>","             { return ','; }
<INITIAL>"."             { return '.'; }
<INITIAL>"("             { return '('; }
<INITIAL>")"             { return ')'; }
<INITIAL>"["             { return '['; }
<INITIAL>"]"             { return ']'; }
<INITIAL>":="            { return ASSIGN; }
<INITIAL>"="             { return EQ; }
<INITIAL>"<>"            { return NEQ; }
<INITIAL>"<"             { return LT; }
<INITIAL>"<="            { return LE; }
<INITIAL>">"             { return GT; }
<INITIAL>">="            { return GE; }
<INITIAL>"+"             { return '+'; }
<INITIAL>"-"             { return '-'; }
<INITIAL>"*"             { return '*'; }
<INITIAL>"/"             { return '/'; }
<INITIAL>"div"           { return DIV; }
<INITIAL>"mod"           { return MOD; }
<INITIAL>"and"           { return AND; }
<INITIAL>"or"            { return OR; }
<INITIAL>"not"           { return NOT; }
<INITIAL>"^"             { return '^'; }

<INITIAL>{IDENTIFIER}    { yylval->string = strdup(yytext); return IDENTIFIER; }
<INITIAL>{DIGIT}+        { yylval->number = atoi(yytext); return NUMBER; }
<INITIAL>{DIGIT}+"."{DIGIT}* { yylval->real = atof(yytext); return REAL; }
<INITIAL>'.'             { return '.'; }

<INITIAL>.               { fprintf(stderr, "Caracter no válido: %c\n", *yytext); }

%%

void count_statement() {
    statement_count++;
}