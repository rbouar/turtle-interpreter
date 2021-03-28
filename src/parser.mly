%{
open Ast
%}

%token VAR PLUS MOINS AVANCE TOURNE BASPINCEAU HAUTPINCEAU EGAL LPAREN RPAREN DEBUT FIN PTVIRG VIDE EOF
%token<string> IDENT
%token<int> NB

%start <Ast.programme> s
%%

s: p=programme EOF { p }

programme: d=declarations i=instruction {(d, i)}

declarations:
| VAR i=IDENT PTVIRG declarations { i } /*todo liste TP9 pour declarations*/
| VIDE {  }

instruction:
| AVANCE e=expression { Avance e }
| TOURNE e=expression { Tourne e }
| BASPINCEAU { BasPinceau }
| HAUTPINCEAU { HautPinceau }
| i=IDENT EGAL e=expression { Assignation (i, e) }
| DEBUT bi=blocInstruction FIN {  } /*liste TP9*/

blocInstruction: /*TP9 liste*/
| i=instruction PTVIRG bi=blocInstruction {  }
| VIDE {  }

expression:
| nb=NB es=expressionSuite { Nombre nb } /*liste TP9*/
| i=IDENT es=expressionSuite { i } /*liste TP9*/
| LPAREN e=expression RPAREN es=expressionSuite { e } /*liste TP9*/

expressionSuite:
| PLUS e=expression { Plus e }
| MOINS e=expression { Moins e }
| VIDE {  }
