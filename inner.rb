#
# racc inner file
#

$KCODE='u'

def initialize()
  @tested = Hash.new(0)
end

def t(s)
  STDERR.print(s)
  @tested[s] += 1
end

def next_token
  @q.shift
end

def on_error(t,v,values)
  raise "ERROR: t:#{t} v:#{v} values:#{values}\n"
end


def findstring(s)
  if s =~ /\A\"a-zA-Z\"/
end

def parse(s)
  @q=[]   
  keywords = [ :FUNCTION, :RETURN, :END, :DO, :WHILE, :UNTIL, :REPEAT, :IF, :THEN, :ELSE, :ELSEIF, :FOR, :LOCAL, :AND, :OR, :BREAK, :NOT, :NIL, :FALSE, :TRUE ]
  kwh = {}
  keywords.each do |sym| kwh[sym.to_s.downcase] = sym end
  until s.empty? 
    sret = findstring(s)
    if sret then 
      s = s[sret..-1]
    end
      
    case s
    when /\A\s+/      
    when /\A\d+/
      STDERR.print "N:#{$&} "
      @q.push([ :NUMBER, $&.to_i ])
    when /\A([a-zA-Z_][a-zA-Z_0-9]*)/
      ss = $&
      
      if kwh[ss] then
        STDERR.print "KW:#{ss} "
        @q.push([ kwh[ss],ss])
      else
        STDERR.print "W:#{ss} "
        @q.push([ :NAME, ss ])
      end
    when /\A==/
      STDERR.print "OP:== "
      @q.push([:EQUAL,$&])
    when /\A\+/
      STDERR.print "OP:+ "
      @q.push([:PLUS,$&])
    when /\A-/
      STDERR.print "OP:- "
      @q.push([:MINUS,$&])
    when /\A\*/
      STDERR.print "OP:* "
      @q.push([:MUL,$&])
    when /\A\//      
      STDERR.print "OP:/ "
      @q.push([:DIV,$&])
    when /\A\^/      
      STDERR.print "OP:^ "
      @q.push([:POWER,$&])
    when /\A%/      
      STDERR.print "OP:% "
      @q.push([:MOD,$&])
    when /\A\.\./
      STDERR.print "OP:.. "
      @q.push([:APPEND,$&])
# | LT
# | LTE
# | GT
# | GTE
# | NOTEQUAL
# | AND
# | OR

    when /\A\.\.\./
      STDERR.print "W:... "
      @q.push([:DOTDOTDOT,$&])
    when /\A.|\n/o
      ss = $&
      STDERR.print "C:#{ss} "
      @q.push([ss,ss])
    else
      raise s
    end
    s = $'
  end
  @q.push([ false, '$end' ])
#  @yydebug=true
  print "\n"
  do_parse
  print "\n"
end


