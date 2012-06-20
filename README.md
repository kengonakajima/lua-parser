lua-parser
==========

[![Build Status](https://secure.travis-ci.org/kengonakajima/lua-parser.png)](http://travis-ci.org/kengonakajima/lua-parser)


WHAT
====
Parse and convert Lua script into Ruby's executable S expression. 

It parses full Penlight source (10kLOC) for about 5 or 8 seconds.

Status
====
In early experiments, but should parse most of existing Lua code.


Build : no dependency on Lua
====
Depends only on Ruby and Racc.

Type this:


    > git clone https://github.com/kengonakajima/lua-parser.git
    > cd lua-parser
    > make


And then you get "lua2sexp" ruby script. Depends on Racc.



Usage
====

Print usage:

    > ruby ./lua2sexp
    need input file(s)
    Options:
    -q : be quiet(parse only)
    -x : test by executing out-put sexp

To convert:

    > ruby ./lua2sexp mini.lua
    s(:chunk,s(:statlist,s(:asign,s(:varlist,s(:var,s(:name,:a))),s(:explist,s(:exp,s(:lit,1))))),nil)Examples====
Lua:

    a=1
    
Ruby:

    s(:chunk,s(:statlist,s(:asign,s(:varlist,s(:var,s(:name,:a))),s(:explist,s(:exp,s(:lit,1))))),nil)Lua:

    function hello(t)      print("world")    endRuby:    s(:chunk,s(:statlist,s(:function,s(:funcname,s(:name,:hello),nil),s(:funcbody,s(:parlist,s(:namelist,s(:name,:t))),s(:block,s(:chunk,s(:statlist,s(:call,s(:prefixexp,s(:var,s(:name,:print))),nil,s(:args,s(:explist,s(:exp,s(:str,"world")))))),nil))))),nil)

Lua:

    t = { a=1, b=2 }

Ruby:

    s(:chunk,s(:statlist,s(:asign,s(:varlist,s(:var,s(:name,:t))),s(:explist,s(:exp,s(:tcons,s(:fieldlist,s(:field,s(:name,:a),s(:exp,s(:lit,1))),s(:field,s(:name,:b),s(:exp,s(:lit,2))))))))),nil)


TODO
====
 * Shorter Sexp mode (It's a trade-off. If longer Sexp, easier to use. so it could be switchable. )
 * print line number when syntax error
 
    
See Also
====
[Full Lua5.1 Syntax](http://www.lua.org/manual/5.1/manual.html)

[ANTLR Lua5.1 grammer file](http://www.antlr.org/grammar/1178608849736/Lua.g)

[Ruby Parser](https://github.com/seattlerb/ruby_parser)


License
====
Apache2.0
