#
# racc inner file
#

$KCODE='u'

def initialize()
  @tested = Hash.new(0)
end

def ep(*args)
  STDERR.print(*args)
end

def t(s)
  ep(s)
  @tested[s] += 1
end


def next_token
  @q.shift
end

def on_error(t,v,values)
  raise "ERROR: t:#{t} v:#{v} values:#{values}\n"
end


# get string literal
def findstring(s)
  chars = s.split("")
  top = chars.shift

  longtop = nil
  stype = nil
  if top == "\"" then
    stype = :NORMALSTR
  elsif top == "'" then
    stype = :CHARSTR
  elsif s =~ /^(\[(=*)\[)/ then
    stype = :LONGSTR
    longtop = $&
    chars = s[longtop.size..-1].split("")
#    print "LONG! TOP:#{longtop} chars.size:#{chars.size} longtop.size:#{longtop.size}\n"
  else
    return false
  end

  escaping = false
  out = ""
  while chars.size > 0
    ch = chars.shift
    if escaping then
      out+=ch
      # escape character
      if ch =~ /b|t|n|f|r|\"|\'|\\/
        escaping=false
      end
      # octal escaping
      if ch =~ /[0-9]/ then
        nch = chars.shift
#        print "NCH:#{nch} "
        if nch =~ /[0-9]/ then
          nnch = chars.shift
#          print "NNCH:#{nnch} "
          out+=nch
          if nnch =~ /[0-9]/ then
            out+=nnch
          else
            chars.unshift(nnch)
          end
        else
          chars.unshift(nch)
        end
        escaping=false
      end

      # unicode escape : TODO: \u notation not working in 5.1?
            
      next
    end

    if ch == "]" and longtop then 
      tofetch = longtop.size - 1 
      fetched = chars[0..(tofetch-1)]
      ok=true
      fetched.size.times do |i|
        if i==fetched.size-1 then
          if fetched[i]!="]" then
            ok = false
            break
          end
        else
          if fetched[i] != "=" then 
            ok = false
            break
          end
        end
      end
      if ok then 
        return out, longtop.size*2 + out.size
      end
    end

    if ch == "\"" and stype == :NORMALSTR then
      return out, out.size + 2
    end
    if ch == "'" and stype == :CHARSTR then
      return out, out.size + 2
    end

    if ch == "\\" then
      escaping = true
      out+=ch
    else
      out+=ch
    end
  end
  return false
end


def parse(s)
  @q=[]   
  keywords = [ :FUNCTION, :RETURN, :END, :DO, :WHILE, :UNTIL, :REPEAT, :IF, :THEN, :ELSE, :ELSEIF, :FOR, :LOCAL, :AND, :OR, :BREAK, :NOT, :NIL, :FALSE, :TRUE ]
  kwh = {}
  keywords.each do |sym| kwh[sym.to_s.downcase] = sym end
  until s.empty? 

    gotstr,gotlen = findstring(s)
#    ep "FINDSTR: #{gotstr},#{gotlen}\n"
    if gotstr then 
      @q.push([:STRING, gotstr])
      s = s[gotlen..-1]
      next
    end

    case s
    when /\A\s+/      
    when /\A--\[\[.*?\]\]/m
      ep "LCOMMENT:-- "
    when /\A--(.*)$/
      ep "COMMENT:-- "
    when /\A\d+/
      ep "N:#{$&} "
      @q.push([ :NUMBER, $&.to_i ])
    when /\A([a-zA-Z_][a-zA-Z_0-9]*)/
      ss = $&
      
      if kwh[ss] then
        ep "KW:#{ss} "
        @q.push([ kwh[ss],ss])
      else
        ep "W:#{ss} "
        @q.push([ :NAME, ss ])
      end
    when /\A\.\.\./
      ep "W:... "
      @q.push([:DOTDOTDOT,$&])
    when /\A==/
      ep "OP:== "
      @q.push([:EQUAL,$&])
    when /\A\+/
      ep "OP:+ "
      @q.push([:PLUS,$&])
    when /\A-/
      ep "OP:- "
      @q.push([:MINUS,$&])
    when /\A\*/
      ep "OP:* "
      @q.push([:MUL,$&])
    when /\A\//      
      ep "OP:/ "
      @q.push([:DIV,$&])
    when /\A\^/      
      ep "OP:^ "
      @q.push([:POWER,$&])
    when /\A%/      
      ep "OP:% "
      @q.push([:MOD,$&])
    when /\A\.\./
      ep "OP:.. "
      @q.push([:APPEND,$&])
# | LT
# | LTE
# | GT
# | GTE
# | NOTEQUAL
# | AND
# | OR


    when /\A.|\n/o
      ss = $&
      ep "C:#{ss} "
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


