class Lua

prechigh
 nonassoc MINUS NOT
 left AND
 left OR
preclow


rule

chunk :   { ep("chk-empty "); push( :chunk ) }
| statlist1 { ep("chk-sl "); sl= mpopstat(); ary=[:chunk]+sl; push( *ary ) }
| statlist1 laststat { ep("chk-sl-l "); ls=poplaststat(); sl=mpopstat(); ary=[:chunk]+sl; ary.push(ls); push(*ary) }
| laststat { ep("chk-l "); ls=poplaststat(); push(:chunk,ls) }
;

statlist1: stat { t "sl1-first " }
| statlist1 stat { t "sl1-append " }
;

stat : varlist1 '=' explist1 semi { ep"st-asign "; el=mpoprev(:exp); vl=mpoprev(:var); push( :asign,[:varlist]+vl,[:explist]+el) } 
| functioncall  { ep"st-funcall "; push( *pop(:call)) }
| DO block END  { ep"st-do " }
| WHILE exp DO block END
| REPEAT block UNTIL exp
| FOR name '=' exp ',' exp DO block END
| FOR name '=' exp ',' exp ',' exp DO block END
| FOR namelist IN explist1 DO block END
| FUNCTION funcname funcbody { b=pop(:funcbody);n=pop(:funcname); push(:function,n,b) }
| LOCAL FUNCTION name funcbody { t "STAT-LOCAL-FUNCTION-NAME-FUNCBODY=#{val[0]} " }
| LOCAL namelist
| LOCAL namelist '=' explist1
| ifstat { push(*pop(:if)) }
;

ifstat : IF exp THEN block END { ep"if-then-end ";  tru=pop(:block);e=pop(:exp); push(:if,e,tru,nil) }
| IF exp THEN block ELSE block END { ep"if-then-else-end "; fal=pop(:block); tru=pop(:block); e=pop(:exp); push(:if,e,tru,fal); }
| IF exp THEN block elseifblock { ep"if-then-elseif ";
    fal=pop(:block);
    tru=pop(:block);
    e=pop(:exp);
    push(:if,e,tru,fal);
}
;
elseifblock : elseifpart END { ep"elseifblock ";  }
| elseifpart ELSE block END { ep"elseifblock-else "; b=pop(:block); prevbl=pop(:block); previf=findlastelse(prevbl); previf[3]=b; push(*prevbl) }
;
elseifpart : ELSEIF exp THEN block { ep"elseifpart-first "; tru=pop(:block); e=pop(:exp); push(:block,[:if,e,tru,nil]); }
| elseifpart ELSEIF exp THEN block { ep"elseifpart-append "; tru=pop(:block); e=pop(:exp); prevbl=pop(:block); previf=findlastelse(prevbl); previf[3]=[:block,[:if,e,tru,nil]]; push(*prevbl) }  
;

#ifstat : IF exp THEN block END { ep"if-then-end "; tru=pop(:block);e=pop(:exp); push(:if,e,tru,nil) }
#| IF exp THEN block ELSE block END { ep"if-then-else-end "; fal=pop(:block);tru=pop(:block);e=pop(:exp); push(:if,e,tru,fal) }
#| IF exp THEN block elseifstat END { ep"if-then-elseif-end "; elif=pop(:block); tru=pop(:block);e=pop(:exp); push(:if,e,tru,elif) }
#| IF exp THEN block elseifstat ELSE block END {
#    ep"if-then-elseif-else-end ";
#    fal=pop(:block);
#    elif=pop(:block);
#    tru=pop(:block);
#    e=pop(:exp);
#    pp elif
#}
#;
#elseifstat : ELSEIF exp THEN block { ep"elseif-then "; tru=pop(:block);e=pop(:exp); push(:block, [:if,e,tru,nil]) }
#| ELSEIF exp THEN block ELSE block { ep"elseif-then-else "; fal=pop(:block);tru=pop(:block); e=pop(:exp); push(:block,[:if,e,tru,fal]) }
#| elseifstat ELSEIF exp THEN block {
#    ep"elseif-elseif-then ";
#    tru=pop(:block);e=pop(:exp); elif=pop(:block);
#    pp elif
#    elif_if = elif[1];
#    push(:block,[:if,elif_if[1],elif_if[2], [:block, [:if, e,tru,nil]]])
#        }
#| elseifstat ELSEIF exp then block ELSE block END {
#    ep"elseif-elseif-then-else ";
#}
#;
#elsestat : ELSE block { t "ELSESTAT-ELSE-BLOCK " }
#;

semi :   #{ t "SEMI-EMPTYEOL " }
| ';' #{  t "SEMI-SEMICOLON " }
;


laststat : RETURN semi { t "LASTSTAT-RETURN " }
| RETURN explist1 semi { el=mpoprev(:exp); ep("#EL:",el.size,"\n"); push(:return, [:explist]+el ) } 
| BREAK semi { t "LASTSTAT-BREAK " }
;


funcname : name  { nm=pop(:name); push( :funcname, nm) }
| name ':' NAME{ nm=pop(:name); push( :funcname, (nm[1].to_s+":"+val[2]).to_sym) }
;


function : FUNCTION funcbody { t "FUNCTION-funcbody " }
;

funcbody : '(' parlist1 ')' block END { ep"fb-prms "; b=pop(:block); pl=pop(:parlist); push( :funcbody, pl,b ) }
| '(' ')' block END { ep"fb-noprms "; push( :funcbody, pop(:block)) }
;

block : chunk { push(:block, pop(:chunk)) }
;

parlist1 :namelist { ep"pl1-nl "; nl=pop(:namelist); push(:parlist,nl) }
| namelist ',' DOTDOTDOT { ep "pl1-nl-vararg "; nl=pop(:namelist); nl.push([:vararg]); push(:parlist, nl) }
| DOTDOTDOT { ep"pl1-vararg "; push(:parlist, [:vararg]) }
;

namelist : name { ep"nl-first "; nm=pop(:name); push(:namelist, nm ) }
| namelist ',' name { ep "nl-append "; nm=pop(:name); nl=pop(:namelist); nl.push(nm); push(*nl) }
;

varlist1 : var { ep"vl-first " }
| varlist1 ',' var { ep"vl-append " }
;

var : name  { nm=pop(:name); push( :var, nm ) }
| prefixexp '[' exp ']' { e=pop(:exp); pe=pop(:prefixexp); push( :var, [:tblget,pe,e]) }
| prefixexp '.' NAME { pe=pop(:prefixexp); push(:var, [:tblget,pe,[:var,val[0].to_sym]]) }
;

explist1 : exp { t( "EXPLIST1 ") }
| explist1 ',' exp  { t "EXPLIST1-exp " }
;

exp : NIL { push(:exp,[:nil]) }
| FALSE { push(:exp, [:false]) }
| TRUE { push(:exp, [:true]) }
| number { push( :exp, pop()) }
| STRING { push( :exp, [:str, "\"#{val[0]}\""] ) } 
| DOTDOTDOT { t "EXP-DOTDOTDOT " }
| function { t "EXP-FUNCTION " }
| prefixexp { ep"exp-pfexp "; push(:exp,pop(:prefixexp)) }
| tableconstructor { ep"exp-tcons "; tc=pop(:tcons); push(:exp,tc) }
| exp binop exp { ep("EXP-BINOP-EXP"); e1=pop(:exp); op=pop(:op); e2=pop(:exp); push(:exp, [:binop, e2,op,e1] ) }
| unop exp { e=pop(:exp); op=pop(:op); push(:exp, [:unop, e, op] ) }
;

number : INTNUMBER { push(:lit, val[0].to_i) } 
| FLOATNUMBER { push( :lit, val[0].to_f ) }
| EXPNUMBER { push( :lit, val[0].to_f ) } 
| HEXNUMBER { push( :lit, val[0].to_i(16)) }
;


prefixexp : var { ep"pfexp-var "; v=pop(:var); push(:prefixexp,v)  } 
| functioncall { ep "pfexp-funcall "; c=pop(:call), push(:prefixexp,c) }
| '(' exp ')' { ep"pfexp-paren-exp "; e=pop(:exp); push(:prefixexp,e) }                                 
;

functioncall : prefixexp args { a=pop(:args); pe=pop(:prefixexp); push(:call, pe,a) }
| prefixexp ':' NAME args { t "FUNCTIONCALL-prefixexp-colon-name-args=#{val[0]} "}
;

args : '(' explist1 ')' { push(:args, [:explist]+mpoprev(:exp)) }
| '(' ')' { push( :args ) }
| tableconstructor { t "ARGS-tableconstructor " }
| STRING { ep"args-str "; push(:args,[:str, "\"#{val[0]}\""] ) }
;

tableconstructor : '{' fieldlist '}' { ep"tblcons "; fl=pop(:fieldlist); push(:tcons, fl) }
| '{' fieldlist fieldsep '}' { t "TABLECONSTRUCTOR-2 " }
;

fieldlist : { ep"fl-empty "; push(:fieldlist) }
| field  { ep"fl-first "; f=pop(:field); push(:fieldlist, f) }
| fieldlist fieldsep field { ep"fl-append "; f=pop(:field); fl=pop(:fieldlist); fl.push(f); push(*fl) }
;

fieldsep : ',' { ep"fsep-, " }
| ';' { ep"fsep-; " }
;

field :  '[' exp ']' '=' exp  { ep"fld-expset ";  val=pop(:exp); ind=pop(:exp); push(:field, ind, val ) }
| NAME '=' exp { ep"fld-nameset "; e=pop(:exp); push(:field, [:name,val[0].to_sym], e ) }
| exp { ep"fld-exp "; e=pop(:exp); push(:field,nil,e) }
;

name : NAME { ep"name-first=#{val[0]} "; push( :name, val[0].to_sym) }
| name '.' NAME { ep"name-dotappend=#{val[2]} "; nm=pop(:name); nnm=nm[1].to_s+"."+val[2]; push(:name,nnm.to_sym)}
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
