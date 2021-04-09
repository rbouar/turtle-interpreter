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
  | Bloc of instruction list

type programme = variable list * instruction

(* Fonctions pour afficher *)
let opbin_to_string = function
  | Plus -> "+"
  | Moins -> "-"

let rec expression_to_string = function
  | EOpBin (l, op, r) -> "(" ^ expression_to_string l ^ opbin_to_string op ^ expression_to_string r ^ ")"
  | Nombre n -> string_of_int n
  | Var v -> v

let rec instruction_to_string = function
  | Avance expr -> "(Avance " ^ expression_to_string expr ^ ")"
  | Tourne expr -> "(Tourne " ^ expression_to_string expr ^ ")"
  | BasPinceau -> "(BasPinceau)"
  | HautPinceau -> "(HautPinceau)"
  | Assignation (v,e) -> "(" ^ v ^ " = " ^ expression_to_string e ^ ")"
  | Bloc l -> (List.fold_left (fun str ins -> str ^ instruction_to_string ins ^ "\n") "[" l) ^ "]\n"

let rec programme_to_string (var_l, ins) =
  variable_list_to_string var_l ^ instruction_to_string ins
  
and variable_list_to_string vl =
  match vl with
  | [] -> ""
  | v :: vl' -> v ^ "\n" ^ variable_list_to_string vl'
