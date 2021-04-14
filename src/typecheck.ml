open Ast

exception Error of string

let rec get_declarations = function
  | [] -> []
  | (v,t)::r -> let rl = get_declarations r in
    if List.mem_assoc v rl
    then raise (Error ("Declared twice: "^v))
    else (v,t)::rl

(* types of binary operators *)
let type_operator = function
  | Plus | Moins | Fois | Div -> (Int,Int,Int)

(* compute the type of an expression *)
let rec type_expression decs = function
  | EOpBin (e1, o, e2) ->
    let t1 = type_expression decs e1
    and t2 = type_expression decs e2
    and (to1, to2, tor) = type_operator o
    in if t1 = to1 && t2 = to2 then tor
    else raise (Error "Type error in operator application")
  | Nombre _ -> Int
  | Var v -> begin
      try List.assoc v decs
      with Not_found -> raise (Error ("Variable not declared : "^v))
  end

let rec check_instruction decs = function
  | Avance e -> if type_expression decs e = Int then ()
    else raise (Error ("Calling Avance on non-int"))
  | Tourne e -> if type_expression decs e = Int then ()
    else raise (Error ("Calling Tourne on non-int"))
  | Bloc il -> check_instructions decs il
  | Condition (e, i1, i2) -> if type_expression decs e = Int
    then (check_instruction decs i1; check_instruction decs i2)
    else raise (Error ("Non-int condition"))
  | TantQue (e, i) -> if type_expression decs e = Int then
      check_instruction decs i
    else raise (Error ("Non-int condition"))
  | HautPinceau -> ()
  | BasPinceau -> ()
  | Assignation (v, e) ->
    try (if List.assoc v decs = type_expression decs e then ()
      else raise (Error ("Inconsistent types in assignment")))
    with Not_found -> raise (Error ("Variable not declared : "^v))

and check_instructions decs il =
  List.iter (function i -> check_instruction decs i) il

let check_program (dl, i) =
  check_instruction (get_declarations dl) i
