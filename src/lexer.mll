{
  open Lexing
  open Parser

  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_bol = lexbuf.lex_curr_pos;
                 pos_lnum = pos.pos_lnum + 1
      }

  exception Error of string


}

let formatage	= [ ' ' '\t' '\n' ]

let digit     	= [ '0'-'9' ]
let minus_char 	= [ 'a'-'z' ]
let upper_char	= [ 'A'-'Z' ]

let identificateur = minus_char (minus_char | upper_char | digit)*
let nombre = (digit#'0')digit* | '0'

rule main = parse
  | '\n'    { next_line lexbuf; main lexbuf }
  | formatage		{ main lexbuf }
  | ')'			{ PAREND }
  | '('			{ PARENG }
  | '='			{ EGAL }
  | ';'			{ PTVIRG }
  | '+'			{ PLUS }
  | '-'			{ MOINS }
  | '*'     { FOIS }
  | '/'     { DIV }
  | "Var"		{ VAR }
  | "Debut"		{ DEBUT }
  | "Fin"		{ FIN }
  | "BasPinceau"	{ BASPINCEAU }
  | "HautPinceau"	{ HAUTPINCEAU }
  | "Avance"		{ AVANCE }
  | "Tourne"		{ TOURNE }
  | "Si"		{ SI }
  | "Alors"		{ ALORS }
  | "Sinon"		{ SINON }
  | "Tant que"		{ TANTQUE }
  | "Faire"		{ FAIRE }
  | identificateur	{ IDENT(Lexing.lexeme lexbuf) }
  | nombre		{ NB(int_of_string (Lexing.lexeme lexbuf)) }
  | eof			{ EOF }
  | _			{ raise (Error (Lexing.lexeme lexbuf)) }
