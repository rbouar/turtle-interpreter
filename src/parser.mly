%{
    open Ast
%}

(* opérateurs binaires *)
%token PLUS MOINS FOIS DIV ET OU COMP DIFF

(* instructions *)
%token AVANCE TOURNE BASPINCEAU HAUTPINCEAU EPAISSEUR EGAL DEBUT FIN SI ALORS SINON TANTQUE FAIRE COULEUR

(* couleurs prédifinies *)
%token NOIR BLANC ROUGE VERT BLEU JAUNE CYAN MAGENTA

%token VAR PARENG PAREND PTVIRG EOF
%token<string> IDENT
%token<int> NB


(* Priorité et associativité des opérations *)

(* On donne à + et - la plus faible priorité. En revanche, on les rend
   associatifs à gauche i.e. :
   [1 + 2 + 3] interprété comme [(1 + 2) + 3]
   [1 - 2 - 3] -> [(1 - 2) - 3] *)

(* De même, pour * et / à la seule différence que / est prioritaire sur *. *)

(* L'instruction [SI expr1 ALORS SI expr2 ALORS ins1 SINON ins2] provoque
   un conflit shift-reduce.

   Le conflit se produit après avoir découvert [SINON].

   Reduce:
   Si on réduit en utilisant [instruction -> SI expression ALORS instruction]
   alors on interprète notre expression comme [SI expr1 ALORS (SI expr2 ALORS ins1) SINON ins2]

   Shift:
   On interprète comme [SI expr1 ALORS (SI expr2 ALORS ins1 SINON ins2)]
   On privilégie cette dernière interprétation. *)

%left MOINS PLUS
%left FOIS
%left DIV
%left OU ET
%left COMP DIFF
%nonassoc ALORS
%nonassoc SINON

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
  | EPAISSEUR e=expression { Epaisseur e }
  | i=IDENT EGAL e=expression { Assignation (i, e) }
  | DEBUT ins=blocInstruction FIN { Bloc ins }
  | SI e=expression ALORS oui=instruction SINON non=instruction { SiAlorsSinon (e, oui, non) }
  | SI e=expression ALORS ins=instruction { SiAlors (e, ins) }
  | TANTQUE e=expression FAIRE ins=instruction { TantQue (e,ins) }
  | COULEUR c=couleur { Couleur c }

couleur:
  | NOIR      { Graphics.black }
  | BLANC     { Graphics.white }
  | ROUGE     { Graphics.red }
  | VERT      { Graphics.green }
  | BLEU      { Graphics.blue }
  | JAUNE     { Graphics.yellow }
  | CYAN      { Graphics.cyan }
  | MAGENTA   { Graphics.magenta }

blocInstruction:
  | i=instruction PTVIRG bloc=blocInstruction { i :: bloc }
  | { [] }

expression:
  | nb=NB { Nombre nb }
  | i=IDENT { Var i }
  | PARENG e=expression PAREND  { e }
  | l=expression o=op r=expression { EOpBin (l,o,r) }
  | MOINS e=expression { Neg e }
%inline op:
  | PLUS { Plus }
  | MOINS { Moins }
  | FOIS { Fois }
  | DIV { Div }
  | ET { Et }
  | OU { Ou }
  | COMP { Comp }
  | DIFF { Diff }
