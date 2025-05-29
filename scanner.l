%{
#undef BEGIN
#include "parser.tab.h"

/* Necesario para evitar error de enlazado */
int yywrap(void) { return 1; }
%}

%x COMMENT_BRACE COMMENT_PAREN

%%

"//".* { /* ignorar comentario de línea */ }

"{"                     { BEGIN(COMMENT_BRACE); /* Comentario entre llaves que puede ocupar varias líneas */ }
<COMMENT_BRACE>[^}]* { /* ignorar contenido del comentario */ }
<COMMENT_BRACE>"}"      { BEGIN(INITIAL); }
<COMMENT_BRACE>\n       { /* ignorar nueva línea en comentario */ }

"(*"                    { BEGIN(COMMENT_PAREN); /* Comentario entre paréntesis y asterisco (* ... *) */}
<COMMENT_PAREN>[^*]*\*+([^*/][^*]*\*+)*\*)"{ BEGIN(INITIAL); }
<COMMENT_PAREN>[^*]* { /* ignorar contenido del comentario */ }
<COMMENT_PAREN>\n       { /* ignorar nueva línea en comentario */ }

"\{\$"[^}]*"}"          { /* ignorar directiva al compilador {$...} */ }

// Palabras reservadas de Pascal
"begin"             return T_BEGIN;
"end"               return T_END;
"if"                return T_IF;
"then"              return T_THEN;
"else"              return T_ELSE;
"while"             return T_WHILE;
"do"                return T_DO;
"for"               return T_FOR;
"to"                return T_TO;
"repeat"            return T_REPEAT;
"until"             return T_UNTIL;

// Operadores y símbolos
":="                return ASSIGN;
";"                 return SEMI;

// Literales y otros identificadores
[0-9]+              return NUMBER;
[a-zA-Z_][a-zA-Z0-9_]* return IDENTIFIER;

// Ignorar espacios y saltos de línea
[ \t\r\n]+          /* ignorar espacios */;

// Cualquier otro símbolo se retorna tal cual
.                   return yytext[0];

%%