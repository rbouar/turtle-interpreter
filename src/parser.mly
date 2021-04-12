%{
    open Ast
%}

(* opérateurs binaires *)
%token PLUS MOINS

(* instructions *)
%token AVANCE TOURNE BASPINCEAU HAUTPINCEAU EGAL DEBUT FIN SI ALORS SINON

%token VAR PARENG PAREND PTVIRG EOF
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
  | SI e=expression ALORS oui=instruction SINON non=instruction { Condition (e, oui, non) }

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
