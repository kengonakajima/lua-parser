class Lua

rule

chunk :   { push( :chunk ) }
| statlist1 { sl= mpop(:stat); push( :chunk,[:statlist]+sl ) }
| statlist1 laststat { t "CHUNK-STATLIST1 LASTSTAT " }
| laststat { t "CHUNK-LASTSTAT " }
;

statlist1: stat { t "STATLIST1-STAT=#{@sout} " }
| statlist1 stat { t "STATLIST1-STATLIST1-STAT " }
;

stat : varlist1 '=' explist1 semi { el=mpop(:exp); vl=mpop(:var); push( :asign,[:varlist]+vl,[:explist]+el); a=pop(); push(:stat,a) }
| functioncall  { t "STAT-functioncall " }
| DO block END  { t "STAT-do-block-end " }
| WHILE exp DO block END
| REPEAT block UNTIL exp
| FOR NAME '=' exp ',' exp DO block END
| FOR NAME '=' exp ',' exp ',' exp DO block END
| FOR namelist IN explist1 DO block END
| FUNCTION funcname funcbody { t "STAT-FUNCTION " }
| LOCAL FUNCTION NAME funcbody { t "STAT-LOCAL-FUNCTION-NAME-FUNCBODY=#{val[0]} " }
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

semi :   #{ t "SEMI-EMPTYEOL " }
| ';' #{  t "SEMI-SEMICOLON " }
;


laststat : RETURN semi { t "RETURN " }
| RETURN explist1 semi { t "RETURN-explist1 " }
| BREAK semi { t "BREAK " }
;


funcname : calleeobjlist  { t "CALLEEOBJLIST " }
| calleeobjlist ':' NAME { t "CALLEEOBJLIST-NAME=#{val[0]} " }
;

calleeobjlist : NAME  { t "CALLEEOBJLIST-NAME=#{val[0]} " }
| calleeobjlist '.' NAME { t "CALLEEOBJLIST-DOT-NAME=#{val[0]} " }
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

namelist : NAME { t "NAMEILST-NAME=#{val[0]} " }
| namelist ',' NAME { t "NAMELIST-NAME-COMMA-NAME=#{val[0]} " } 
;

varlist1 : var { t "VARLIST1-VAR " }
| varlist1 ',' var { t "varlist1-varlist1-var " }
;

var : NAME  { push( :var, val[0].to_sym ) } # "VAR-NAME=#{val[0]} " }
| prefixexp '[' exp ']' { t "VAR-prefixexp-exp " }
| prefixexp '.' NAME { t "VAR-prefixexp-dot-name=#{val[0]} " }
;

explist1 : exp { t( "EXPLIST1 ") }
| explist1 ',' exp  { t "EXPLIST1-exp " }
;

exp : NIL { t "EXP-NIL " }
| FALSE { t "EXP-FALSE " }
| TRUE { t "EXP-TRUE " }
| number { n=pop(); push( :exp, n ) }
| STRING {t "EXP-STRING=#{val[0]}" }
| DOTDOTDOT { t "EXP-DOTDOTDOT " }
| function { t "EXP-FUNCTION " }
| prefixexp { t "EXP-PREFIXEXP " }
| tableconstructor { t "EXP-TABLECONSTRUCTOR " }
| exp binop exp { t "EXP-EXP-BINOP-EXP " }
| unop exp { t "EXP-UNOP-EXP " }
;

number : INTNUMBER { push(:lit, val[0].to_i) } 
| FLOATNUMBER { push( :lit, val[0].to_f ) }
| EXPNUMBER { push( :lit, val[0].to_f ) } 
| HEXNUMBER { push( :lit, val[0].to_i(16)) }
;


prefixexp : var { t "PREFIXEXP-VAR " }
| functioncall { t "PREFIXEXP-FUNCTIONCALL " }
| '(' exp ')' { t "PAREN-EXP " } 
;

functioncall : prefixexp args { t "FUNCTIONCALL-prefixexp-args "}
| prefixexp ':' NAME args { t "FUNCTIONCALL-prefixexp-colon-name-args=#{val[0]} "}
;

args : '(' explist1 ')' { t "ARGS-explist1 " }
| '(' ')' { t "ARGS-empty " }
| tableconstructor { t "ARGS-tableconstructor " }
| STRING { t "ARGS-STRING=#{val[0]} " }
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
| NAME '=' exp { t "FIELD-NAME=exp(#{val[0]}) " }
| exp { t "FIELD-exp " }
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
| NEQ { t "BINOP-NOTEQUAL " }
| AND { t "BINOP-AND " }
| OR { t "BINOP-OR " }
;

unop : MINUS { t "UNOP-MINUS " }
| NOT { t "UNOP-NOT "  }
| LENGTH { t "UNOP-LENGTH " }
;




end


---- header = header.rb
---- inner = inner.rb
---- footer = footer.rb
