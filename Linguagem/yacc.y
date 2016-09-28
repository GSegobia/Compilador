%{
#include <stdio.h>

void yyerror(char *); /* ver abaixo */
%}

%token INTEIRO
%token FIM_LINHA
%left '+' '-'
%left '*' '/'
%left '(' ')'

%start linha

%%

linha: expressao FIM_LINHA { printf("valor: %d\n", $1); }
     ;

expressao: expressao '+' expressao { $$ = $1 + $3; }
         | termo { $$ = $1; }
         | expressao '-' expressao { $$ = $1 - $3; }
         | expressao '*' expressao { $$ = $1 * $3; }
         | expressao '/' expressao { $$ = $1 / $3; }
         | expressao '^' { $$ = $1 * $1; }
         | '(' expressao ')' { $$ = $2; }
         ;

termo: INTEIRO { $$ = $1; }
     ;

%%

int main(int argc, char **argv)
{
  return yyparse();
}

/* função usada pelo bison para dar mensagens de erro */
void yyerror(char *msg)
{
  fprintf(stderr, "erro: %s\n", msg);
}
