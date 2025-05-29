%{
int brace_comment_level = 0;
%}

DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
WHITESPACE  [ \t\r]+
NEWLINE     [\n]

%x COMMENT DIRECTIVE STRING_MODE COMMENT_BRACE COMMENT_PAREN COMMENT_BACKSLASH

%%

"(*"                     { BEGIN(COMMENT_PAREN); /* Capturar los comentarios con (* *) */}
<COMMENT_PAREN>"*)"      { BEGIN(INITIAL); }


"{"                     { /* Capturar los comentarios con {} con posible anidamiento */
                            brace_comment_level = 1;
                            BEGIN(COMMENT_BRACE);
                        }
<COMMENT_BRACE>"{"      { /* Si aparece una llave que abre dentro de un comentario incrementa el nivel */
                            brace_comment_level++;
                        }
<COMMENT_BRACE>"}"      { /* Decrementa el nivel y si llega a 0 cambia el estado */
                            brace_comment_level--;
                            if (brace_comment_level == 0)
                                BEGIN(INITIAL);
                        }
<COMMENT_BRACE>[^{}]*   { /* ignorar cualquier cosa diferente a { o }  */ }
%%
