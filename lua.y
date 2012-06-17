class Lua

rule

chunk :  
  | statlist1 
  | statlist1 laststat 
  | laststat
  ;

statlist1: stat { STDERR.print "STAT " }
| statlist1 stat { STDERR.print "STAT-STAT " }
;

stat : varlist1 '=' explist1 semi { STDERR.print "STAT " }
| functioncall 
| DO block END 
| WHILE exp DO block END
| REPEAT block UNTIL exp
| FOR NAME '=' exp ',' exp DO block END
| FOR NAME '=' exp ',' exp ',' exp DO block END
| FUNCTION funcname funcbody { print "STAT-FUNCTION " }
| LOCAL FUNCTION NAME funcbody
| LOCAL namelist
| LOCAL namelist '=' explist1 
|
;

semi :   { STDERR.print "EMPTYEOL " }
| ';' {  STDERR.print "SEMICOLON " }
;


laststat : RETURN semi { STDERR.print "RETURN " }
| RETURN explist1 semi { STDERR.print "RETURN-explist1 " }
| BREAK semi { STDERR.print "BREAK " }
;


funcname : calleeobjlist  { STDERR.print "CALLEEOBJLIST " }
| calleeobjlist ':' NAME { STDERR.print "CALLEEOBJLIST : NAME " }
;

calleeobjlist : NAME  { STDERR.print "CALLEEOBJLIST-NAME " }
| calleeobjlist '.' NAME { STDERR.print "CALLEEOBJLIST-DOT-NAME " }
;

function : FUNCTION funcbody { STDERR.print "FUNCTION-funcbody " }
;

funcbody : '(' parlist1 ')' block END { STDERR.print "FUNCBODY " }
;

block : chunk { print "BLOCK-CHUNK " }
;

parlist1 :  { STDERR.print "PARLIST1-NONE " }
| namelist { STDERR.print "PARLIST1-NAMELIST " }
| namelist ',' DOTDOTDOT { STDERR.print "PARLIST1-NAMELIST-DOTDOTDOT " }
| DOTDOTDOT { STDERR.print "PARLIST1-DOTDOTDOT " }
;

namelist : NAME { print "NAMEILST-NAME " }
| namelist ',' NAME { print "NAMELIST-NAME-COMMA-NAME " } 
;

varlist1 : var { STDERR.print "VARLIST1 " }
| var ',' var
;

var : NAME  { STDERR.print "VARNAME=#{val[0]} " }
;

explist1 : exp { STDERR.print( "EXP ") }
| explist1 ',' exp       
;

exp : NIL
| FALSE
| TRUE
| NUMBER {STDERR.print "EXP-NUMBER=#{val[0]} "}
| STRING
| DOTDOTDOT
| function { STDERR.print "EXP-FUNCTION " }
| prefixexp
| tableconstructor
| exp binop exp
| unop exp
;

prefixexp : var { STDERR.print "PREFIXEXP-VAR " }
| functioncall { STDERR.print "PREFIXEXP-FUNCTIONCALL " }
| '(' exp ')' { STDERR.print "PAREN-EXP " } 
;

tableconstructor : '{' fieldlist '}' { STDERR.print "TABLECONSTRUCTOR " }
| '{' fieldlist fieldsep '}' { STDERR.print "TABLECONSTRUCTOR-2 " }
;

fieldlist : { STDERR.print "FIELDLIST-empty " }
| field  { STDERR.print "FIELDLIST-field " }
| fieldlist fieldsep field { STDERR.print "FIELDLIST-fieldsep-field " }
;

fieldsep : ',' { STDERR.print "FIELDSEP-COMMA " }
| ';' { STDERR.print "FIELDSEP-SEMICOLLON " }
;

field :  '[' exp ']' '=' exp  { STDERR.print "FIELD-[exp]=exp " }
| NAME '=' exp { STDERR.print "FIELD-NAME=exp " }
| exp { STDERR.print "FIELD-exp " }
;


end


---- header
---- inner = inner.rb
---- footer = footer.rb
