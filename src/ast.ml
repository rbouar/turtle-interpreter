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

(* Fonctions pour afficher *)
let rec expression_to_string expr =
  match expr with
  | Plus (l, r) -> "(" ^ expression_to_string l ^ " + " ^ expression_to_string r ^ ")"
  | Moins (l,r) -> "(" ^ expression_to_string l ^ " - " ^ expression_to_string r ^ ")"
  | Nombre n -> string_of_int n
  | Var v -> v

let rec instruction_to_string ins =
  match ins with
  | Avance expr -> "(Avance " ^ expression_to_string expr ^ ")\n"
  | Tourne expr -> "(Tourne " ^ expression_to_string expr ^ ")\n"
  | BasPinceau -> "(BasPinceau)\n"
  | HautPinceau -> "(HautPinceau)\n"
  | Assignation (v,e) -> "(" ^ v ^ " = " ^ expression_to_string e ^ ")\n"

let rec programme_to_string (vl, il) =
  variable_list_to_string vl ^ "\n" ^ instruction_list_to_string il
  
and variable_list_to_string vl =
  match vl with
  | [] -> "\n"
  | v :: vl' -> v ^ "\n" ^ variable_list_to_string vl'

and instruction_list_to_string il =
  match il with
  | [] -> ""
  | i :: il' -> instruction_to_string i ^ instruction_list_to_string il'
