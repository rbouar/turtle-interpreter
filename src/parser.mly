%{
    open Ast
%}

%token VAR PLUS MOINS AVANCE TOURNE BASPINCEAU HAUTPINCEAU EGAL PARENG PAREND DEBUT FIN PTVIRG EOF
%token<string> IDENT
%token<int> NB

%left MOINS
%left PLUS

%start <Ast.programme> s
%%

s: p=programme EOF { p }

programme: decl=declarations ins=instruction { (decl, ins) }

declarations:
  | VAR id=IDENT PTVIRG decl=declarations { id :: decl }
  | { [] }

instruction:
  | AVANCE e=expression { Avance e }
  | TOURNE e=expression { Tourne e }
  | BASPINCEAU { BasPinceau }
  | HAUTPINCEAU { HautPinceau }
  | i=IDENT EGAL e=expression { Assignation (i, e) }
  | DEBUT ins=blocInstruction FIN { Bloc ins }

blocInstruction:
  | i=instruction PTVIRG bloc=blocInstruction { i :: bloc }
  | { [] }

expression:
  | nb=NB { Nombre nb }
  | i=IDENT { Var i }
  | PARENG e=expression PAREND  { e }
  | l=expression o=op r=expression { EOpBin (l,o,r) }
%inline op:
  | PLUS { Plus }
  | MOINS { Moins }
