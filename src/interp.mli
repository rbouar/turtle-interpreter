(* interp.mli *)
exception Error of string

val show : Ast.programme -> unit
