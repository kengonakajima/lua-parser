class Lua

rule

chunk :   { ep("SL0"); push( :chunk ) }
| statlist1 { ep("SL1"); sl= mpopstat(); pushflat( :chunk, sl ) }
| statlist1 laststat { ep("SLL"); ls=pop(:laststat); sl=mpopstat(); ary=[:chunk]+sl; ary.push(ls); push(*ary) }
| laststat { ep("LS"); ls=pop(:laststat); pushflat(:chunk,ls) }
;

statlist1: stat { t "STATLIST1-STAT " }
| statlist1 stat { t "STATLIST1-STATLIST1-STAT " }
;

stat : varlist1 '=' explist1 semi { el=mpoprev(:exp); vl=mpoprev(:var); push( :asign,[:varlist]+vl,[:explist]+el) } 
| functioncall  { push( *pop(:call)) }
| DO block END  { t "STAT-do-block-end " }
| WHILE exp DO block END
| REPEAT block UNTIL exp
| FOR NAME '=' exp ',' exp DO block END
| FOR NAME '=' exp ',' exp ',' exp DO block END
| FOR namelist IN explist1 DO block END
| FUNCTION funcname funcbody { b=pop(:funcbody);n=pop(:funcname); push(:function,n,b) }
| LOCAL FUNCTION NAME funcbody { t "STAT-LOCAL-FUNCTION-NAME-FUNCBODY=#{val[0]} " }
| LOCAL namelist
| LOCAL namelist '=' explist1
| ifstat { push(*pop(:if)) }
;

ifstat : IF exp THEN block END { tru=pop(:block);e=pop(:exp); push(:if,e,tru,nil) }
| IF exp THEN block ELSE block END { fal=pop(:block);tru=pop(:block);e=pop(:exp); push(:if,e,tru,fal) }
| IF exp THEN block elseifstat END { elif=pop(:block); tru=pop(:block);e=pop(:exp); push(:if,e,tru,elif) }
;
elseifstat : ELSEIF exp THEN block { tru=pop(:block);e=pop(:exp); push(:block, [:if,e,tru,nil]) }
| ELSEIF exp THEN block ELSE block { fal=pop(:block);tru=pop(:block); e=pop(:exp); push(:block,[:if,e,tru,fal]) }
| elseifstat ELSEIF exp THEN block {
    tru=pop(:block);e=pop(:exp); elif=pop(:block); 
    elif_if = elif[1];
    push(:block,[:if,elif_if[1],elif_if[2], [:block, [:if, e,tru,nil]]])
        }
;

#elsestat : ELSE block { t "ELSESTAT-ELSE-BLOCK " }
#;

semi :   #{ t "SEMI-EMPTYEOL " }
| ';' #{  t "SEMI-SEMICOLON " }
;


laststat : RETURN semi { t "LASTSTAT-RETURN " }
| RETURN explist1 semi { el=mpoprev(:exp); ep("#EL:",el.size,"\n"); push(:laststat, [:return, [:explist]+el] ) } 
| BREAK semi { t "LASTSTAT-BREAK " }
;


funcname : NAME  { push( :funcname, val[0].to_sym) }
| NAMEWIDHDOTS  { push( :funcname, val[0].to_sym) }
| NAME ':' NAME{ push( :funcname, (val[0]+":"+val[2]).to_sym) }
| NAMEWIDHDOTS ':' NAME { push( :funcname,(val[0]+":"+val[2]).to_sym) }
;


function : FUNCTION funcbody { t "FUNCTION-funcbody " }
;

funcbody : '(' parlist1 ')' block END { t "FUNCBODY-PARLIST1 " }
| '(' ')' block END { push( :funcbody, pop(:block)) }
;

block : chunk { push(:block, pop(:chunk)) }
;

parlist1 :namelist { t "PARLIST1-NAMELIST " }
| namelist ',' DOTDOTDOT { t "PARLIST1-NAMELIST-DOTDOTDOT " }
| DOTDOTDOT { t "PARLIST1-DOTDOTDOT " }
;

namelist : NAME { t "NAMEILST-NAME=#{val[0]} " }
| namelist ',' NAME { t "NAMELIST-NAME-COMMA-NAME=#{val[0]} " } 
;

varlist1 : var { t "VARLIST1-VAR " }
| varlist1 ',' var { t "varlist1-varlist1-var " }
;

var : NAME  { push( :var, val[0].to_sym ) }
| NAMEWIDHDOTS { push( :var, val[0].to_sym ) }
| prefixexp '[' exp ']' { e=pop(:exp); pe=pop(:prefixexp); push( :var, [:tblget,pe,e]) }
| prefixexp '.' NAME { pe=pop(:prefixexp); push(:var, [:tblget,pe,[:var,val[0].to_sym]]) }
;

explist1 : exp { t( "EXPLIST1 ") }
| explist1 ',' exp  { t "EXPLIST1-exp " }
;

exp : NIL { push(:exp,[:nil]) }
| FALSE { t "EXP-FALSE " }
| TRUE { t "EXP-TRUE " }
| number { push( :exp, pop()) }
| STRING { push( :exp, [:str, "\"#{val[0]}\""] ) } 
| DOTDOTDOT { t "EXP-DOTDOTDOT " }
| function { t "EXP-FUNCTION " }
| prefixexp { push(:exp,pop(:prefixexp)) }
| tableconstructor { t "EXP-TABLECONSTRUCTOR " }
| exp binop exp { ep("EXP-BINOP-EXP"); e1=pop(:exp); op=pop(:op); e2=pop(:exp); push(:exp, [:binop, e2,op,e1] ) }
| unop exp { t "EXP-UNOP-EXP " }
;

number : INTNUMBER { push(:lit, val[0].to_i) } 
| FLOATNUMBER { push( :lit, val[0].to_f ) }
| EXPNUMBER { push( :lit, val[0].to_f ) } 
| HEXNUMBER { push( :lit, val[0].to_i(16)) }
;


prefixexp : var { v=pop(:var); push(:prefixexp,v)  } 
| functioncall { t "PREFIXEXP-FUNCTIONCALL " }
| '(' exp ')' { t "PAREN-EXP " } 
;

functioncall : prefixexp args { a=pop(:args); pe=pop(:prefixexp); push(:call, pe,a) }
| prefixexp ':' NAME args { t "FUNCTIONCALL-prefixexp-colon-name-args=#{val[0]} "}
;

args : '(' explist1 ')' { push(:args, [:explist]+mpoprev(:exp)) }
| '(' ')' { push( :args ) }
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




binop : PLUS { push(:op, :plus) }
| MINUS { push(:op, :minus) }
| MUL { push(:op, :mul ) }
| DIV { push(:op, :div) }
| POWER { push(:op, :power) }
| MOD { push(:op, :mod) }
| APPEND { push(:op, :append) }
| LT { push(:op, :lt) }
| LTE { push(:op, :lte) }
| GT { push(:op, :gt) }
| GTE { push(:op, :gte) }
| EQUAL  { push(:op, :equal) }
| NEQ { push(:op, :neq) }
| AND { push(:op, :and) }
| OR { push(:op, :or) }
;

unop : MINUS { push(:op, :minus ) }
| NOT { push(:op, :not ) }
| LENGTH { push(:op, :length ) }
;




end


---- header = header.rb
---- inner = inner.rb
---- footer = footer.rb
