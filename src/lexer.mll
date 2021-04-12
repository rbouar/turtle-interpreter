{
open Parser
}

let formatage	= [ ' ' '\t' '\n' ]

let digit     	= [ '0'-'9' ]
let minus_char 	= [ 'a'-'z' ]
let upper_char	= [ 'A'-'Z' ]

let identificateur = minus_char (minus_char | upper_char | digit)*
let nombre = (digit#'0')digit* | '0'

rule main = parse
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
  | _			{ failwith "unexpected character" }
