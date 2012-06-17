class Lua

rule

chunk :  
  | statlist1 
  | statlist1 laststat 
  | laststat
  ;

statlist1: stat { t "STAT " }
| statlist1 stat { t "STAT-STAT " }
;

stat : varlist1 '=' explist1 semi { t "STAT " }
| functioncall 
| DO block END 
| WHILE exp DO block END
| REPEAT block UNTIL exp
| FOR NAME '=' exp ',' exp DO block END
| FOR NAME '=' exp ',' exp ',' exp DO block END
| FUNCTION funcname funcbody { t "STAT-FUNCTION " }
| LOCAL FUNCTION NAME funcbody
| LOCAL namelist
| LOCAL namelist '=' explist1
| ifstat { t "STAT-ifstat " }
;

ifstat : IF exp THEN block elseifstat elsestat END { t "IFSTAT " }
;
elseifstat : { t "ELSEIFSTAT-EMPTY " }
| ELSEIF exp THEN block { t "ELSEIFSTAT-ELSEIF-EXP-THEN-BLOCK " }
| elseifstat ELSEIF exp THEN block { t "ELSEIFSTAT-ELSEIFSTAT-ELSEIF-EXP-THEN-BLOCK " }
;

elsestat : { t "ELSESTAT-EMPTY " }
| ELSE block { t "ELSESTAT-ELSE-BLOCK " }
;

semi :   { t "EMPTYEOL " }
| ';' {  t "SEMICOLON " }
;


laststat : RETURN semi { t "RETURN " }
| RETURN explist1 semi { t "RETURN-explist1 " }
| BREAK semi { t "BREAK " }
;


funcname : calleeobjlist  { t "CALLEEOBJLIST " }
| calleeobjlist ':' NAME { t "CALLEEOBJLIST : NAME " }
;

calleeobjlist : NAME  { t "CALLEEOBJLIST-NAME " }
| calleeobjlist '.' NAME { t "CALLEEOBJLIST-DOT-NAME " }
;

function : FUNCTION funcbody { t "FUNCTION-funcbody " }
;

funcbody : '(' parlist1 ')' block END { t "FUNCBODY " }
;

block : chunk { t "BLOCK-CHUNK " }
;

parlist1 :  { t "PARLIST1-NONE " }
| namelist { t "PARLIST1-NAMELIST " }
| namelist ',' DOTDOTDOT { t "PARLIST1-NAMELIST-DOTDOTDOT " }
| DOTDOTDOT { t "PARLIST1-DOTDOTDOT " }
;

namelist : NAME { t "NAMEILST-NAME " }
| namelist ',' NAME { t "NAMELIST-NAME-COMMA-NAME " } 
;

varlist1 : var { t "VARLIST1 " }
| var ',' var
;

var : NAME  { t "VARNAME=#{val[0]} " }
;

explist1 : exp { t( "EXPLIST1 ") }
| explist1 ',' exp  { t "EXPLIST1-exp " }
;

exp : NIL { t "EXP-NIL " }
| FALSE { t "EXP-FALSE " }
| TRUE { t "EXP-TRUE " }
| NUMBER {t "EXP-NUMBER=#{val[0]} "}
| string {t "EXP-STRING" }
| DOTDOTDOT { t "EXP-DOTDOTDOT " }
| function { t "EXP-FUNCTION " }
| prefixexp { t "EXP-PREFIXEXP " }
| tableconstructor { t "EXP-TABLECONSTRUCTOR " }
| exp binop exp { t "EXP-EXP-BINOP-EXP " }
| unop exp { t "EXP-UNOP-EXP " }
;

prefixexp : var { t "PREFIXEXP-VAR " }
| functioncall { t "PREFIXEXP-FUNCTIONCALL " }
| '(' exp ')' { t "PAREN-EXP " } 
;

functioncall : prefixexp args { t "FUNCTIONCALL-prefixexp-args "}
| prefixexp ':' NAME args { t "FUNCTIONCALL-prefixexp-colon-name-args "}
;

args : '(' explist1 ')' { t "ARGS-explist1 " }
| '(' ')' { t "ARGS-empty " }
| tableconstructor { t "ARGS-tableconstructor " }
| string { t "ARGS-STRING " }
;

tableconstructor : '{' fieldlist '}' { t "TABLECONSTRUCTOR " }
| '{' fieldlist fieldsep '}' { t "TABLECONSTRUCTOR-2 " }
;

fieldlist : { t "FIELDLIST-empty " }
| field  { t "FIELDLIST-field " }
| fieldlist fieldsep field { t "FIELDLIST-fieldsep-field " }
;

fieldsep : ',' { t "FIELDSEP-COMMA " }
| ';' { t "FIELDSEP-SEMICOLLON " }
;

field :  '[' exp ']' '=' exp  { t "FIELD-[exp]=exp " }
| NAME '=' exp { t "FIELD-NAME=exp " }
| exp { t "FIELD-exp " }
;

string : NORMALSTRING { t "STRING-NORMALSTRING " }
| CHARSTRING { t "STRING-CHARSTRING " }
| LONGSTRING { t "STRING-LONGSTRING " }
;



binop : PLUS { t "BINOP-PLUS " }
| MINUS { t "BINOP-MINUS " }
| MUL { t "BINOP-MUL " }
| DIV { t "BINOP-DIV " }
| POWER { t "BINOP-POWER " }
| MOD { t "BINOP-MOD " }
| APPEND { t "BINOP-APPEND " }
| LT { t "BINOP-LT " }
| LTE { t "BINOP-LTE " }
| GT { t "BINOP-GT " }
| GTE { t "BINOP-GTE " }
| EQUAL  { t "BINOP-EQUAL " }
| NOTEQUAL { t "BINOP-NOTEQUAL " }
| AND { t "BINOP-AND " }
| OR { t "BINOP-OR " }





end


---- header
---- inner = inner.rb
---- footer = footer.rb
