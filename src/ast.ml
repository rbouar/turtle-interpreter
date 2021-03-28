type programme = variable list * instruction list

type variable = string

type instruction =
  | Avance of expression
  | Tourne of expression
  | BasPinceau
  | HautPinceau
  | Assignation of variable * expression

type expression =
  | Plus of expression * expression
  | Moins of expression * expression
  | Nombre of int  
