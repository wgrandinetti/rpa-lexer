DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
WHITESPACE  [ \t\r]+
NEWLINE     [\n]

%x COMMENT DIRECTIVE STRING_MODE COMMENT_BRACE COMMENT_PAREN COMMENT_BACKSLASH

%%

"(*"                     { BEGIN(COMMENT_PAREN); /* Capturar los comentarios con (* *) */ }
<COMMENT_PAREN>"*)"      { BEGIN(INITIAL); }
<COMMENT_PAREN>[^\n()*]+   { /* ignora texto dentro del comentario */ }
<COMMENT_PAREN>.           { /* ignora cualquier otro caracter */ }
<COMMENT_PAREN>\n          { /* ignora saltos de línea */ }

"{"                     { BEGIN(COMMENT_BRACE); /* Capturar los comentarios con {} */ }
<COMMENT_BRACE>"}"      { BEGIN(INITIAL); }
<COMMENT_BRACE>[^}]+    { /* ignora cualquier cosa */ }


"//"                        { BEGIN(COMMENT_BACKSLASH); /* Capturar los comentarios con // */ }
<COMMENT_BACKSLASH>\n       { BEGIN(INITIAL); }
<COMMENT_BACKSLASH>[^\n]+   { /* ignora cualquier cosa */ }


%%