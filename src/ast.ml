type variable = string

type expression =
  | Plus of expression * expression
  | Moins of expression * expression
  | Nombre of int  
  | Var of variable

type instruction =
  | Avance of expression
  | Tourne of expression
  | BasPinceau
  | HautPinceau
  | Assignation of variable * expression

type programme = variable list * instruction list
