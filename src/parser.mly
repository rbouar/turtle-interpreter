%{
open Ast
%}

%token VAR PLUS MOINS AVANCE TOURNE BASPINCEAU HAUTPINCEAU EGAL LPAREN RPAREN DEBUT FIN PTVIRG EOF
%token<string> IDENT
%token<int> NB

%start<Ast.expression>
input

%%

input: e=expression EOF { e }

expression:
x=IDENT PTVIRG { Var x }
| DEBUT e=expression FIN { e }
| AVANCE e=expression { Avance e }
| TOURNE e=expression { Tourne e }
| BASPINCEAU { BasPinceau }
| HAUTPINCEAU { HautPinceau }
| x=IDENT EGAL e=expression { Replace (x, e) }
| LPAREN nb=NB RPAREN { nb }
| nb1=NB PLUS nb2=NB { Plus (nb1, nb2) }
| nb1=NB MOINS nb2=NB { Moins (nb1, nb2) }
