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
  | '\n'		{ next_line lexbuf; main lexbuf }
  | formatage		{ main lexbuf }
  | ')'			{ PAREND }
  | '('			{ PARENG }
  | '='			{ EGAL }
  | ';'			{ PTVIRG }
  | '+'			{ PLUS }
  | '-'			{ MOINS }
  | '*'     		{ FOIS }
  | '/'     		{ DIV }
  | '>'    		{ SUP }
  | '<'    		{ INF }
  | ">="   		{ SUPEG }
  | "<="   		{ INFEG }
  | "&&"   		{ ET }
  | "||"   		{ OU }
  | "=="   		{ COMP }
  | "!="    		{ DIFF }
  | "!"     		{ NON }
  | "Var"		{ VAR }
  | "Debut"		{ DEBUT }
  | "Fin"		{ FIN }
  | "BasPinceau"	{ BASPINCEAU }
  | "HautPinceau"	{ HAUTPINCEAU }
  | "ChangeEpaisseur" 	{ EPAISSEUR }
  | "Avance"		{ AVANCE }
  | "Tourne"		{ TOURNE }
  | "Si"		{ SI }
  | "Alors"		{ ALORS }
  | "Sinon"		{ SINON }
  | "Tant que"		{ TANTQUE }
  | "Faire"		{ FAIRE }
  | "ChangeCouleur"	{ COULEUR }
  | "noir"		{ NOIR }
  | "blanc"		{ BLANC }
  | "rouge"		{ ROUGE }
  | "vert"		{ VERT }
  | "bleu"		{ BLEU }
  | "jaune"		{ JAUNE }
  | "cyan"		{ CYAN }
  | "magenta"		{ MAGENTA }
  | "(*"		{ multi_line_comment lexbuf }
  | "//"		{ one_line_comment lexbuf }
  | identificateur	{ IDENT(Lexing.lexeme lexbuf) }
  | nombre		{ NB(int_of_string (Lexing.lexeme lexbuf)) }
  | eof			{ EOF }
  | _			{ raise (Error (Lexing.lexeme lexbuf)) }

and multi_line_comment = parse
  | "*)"	        { main lexbuf }
  | '\n'		{ next_line lexbuf; multi_line_comment lexbuf }
  | eof 		{ raise (Error "EOF dans les commentaires") }
  | _			{ multi_line_comment lexbuf }

and one_line_comment = parse
  | '\n'	        { next_line lexbuf; main lexbuf }
  | eof			{ EOF }
  | _			{ one_line_comment lexbuf }