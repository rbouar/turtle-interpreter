type variable = string

type opbin =
  | Plus
  | Moins

type expression =
  | EOpBin of expression * opbin * expression
  | Nombre of int  
  | Var of variable

type instruction =
  | Avance of expression
  | Tourne of expression
  | BasPinceau
  | HautPinceau
  | Assignation of variable * expression

type programme = variable list * instruction list

(* Fonctions pour afficher *)
let opbin_to_string = function
  | Plus -> "+"
  | Moins -> "-"

let rec expression_to_string = function
  | EOpBin (l, op, r) -> "(" ^ expression_to_string l ^ opbin_to_string op ^ expression_to_string r ^ ")"
  | Nombre n -> string_of_int n
  | Var v -> v

let instruction_to_string = function
  | Avance expr -> "(Avance " ^ expression_to_string expr ^ ")"
  | Tourne expr -> "(Tourne " ^ expression_to_string expr ^ ")"
  | BasPinceau -> "(BasPinceau)"
  | HautPinceau -> "(HautPinceau)"
  | Assignation (v,e) -> "(" ^ v ^ " = " ^ expression_to_string e ^ ")"

let rec programme_to_string (vl, il) =
  variable_list_to_string vl ^ "\n" ^ instruction_list_to_string il
  
and variable_list_to_string vl =
  match vl with
  | [] -> "\n"
  | v :: vl' -> v ^ "\n" ^ variable_list_to_string vl'

and instruction_list_to_string il =
  match il with
  | [] -> ""
  | i :: il' -> instruction_to_string i ^ "\n" ^ instruction_list_to_string il'
