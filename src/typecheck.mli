(* typechecker *)

exception Error of string

val check_program: Ast.programme -> unit
