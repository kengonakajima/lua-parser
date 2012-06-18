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
def lep(*args)
#  STDERR.print(*args)
end

def t(s)
  ep(s)
  @tested[s] += 1
end


def newproc(sexp)
  return lambda do  return sexp end
end

def out(*args)
  sexp="s("
  converted=[]
  args.each do |s|
    if typeof(s) == Symbol then
      converted.push(":#{s}")
    elsif typeof(s) == Fixnum then
      converted.push(s.to_s)
    else
      ep "out: unknown type:#{typeof(s)}\n"
    end
  end
  sexp += converted.join(", ") + ")"
#  ep "PUSH:", sexp,"\n"
#  @stack.push(sexp)
end


def next_token
  @q.shift
end

def on_error(t,v,values)
  raise "ERROR: t:#{t} v:#{v} values:#{values}\n"
end


# get string literal
def findstring(s)
  chars = nil
  top = s[0..0]
  multilinecount=0

  longtop = nil
  stype = nil
  if top == "\"" then
    stype = :NORMALSTR
    chars = s.split("")
    chars.shift
  elsif top == "'" then
    stype = :CHARSTR
    chars = s.split("")
    chars.shift
  elsif top == "[" and s =~ /^(\[(=*)\[)/ then
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
        if nch =~ /[0-9]/ then
          nnch = chars.shift
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
      return out, out.size + 2 + multilinecount
    end
    if ch == "'" and stype == :CHARSTR then
      return out, out.size + 2 + multilinecount
    end

    if ch == "\\" then
      nch = chars.shift
      if nch == "\n" then
        out+="\n"
        multilinecount += 1
      else
        chars.unshift(nch)
        escaping = true
        out+=ch
      end
    else
      out+=ch
    end
  end
  return false
end


def parse(s,sout)
  ep "SOUT:#{sout}\n"

  @q=[]   
  keywords = [ :FUNCTION, :RETURN, :END, :DO, :WHILE, :UNTIL, :REPEAT, :IF, :THEN, :ELSE, :ELSEIF, :FOR, :LOCAL, :AND, :OR, :BREAK, :NOT, :NIL, :FALSE, :TRUE, :IN ]
  kwh = {}
  keywords.each do |sym| kwh[sym.to_s.downcase] = sym end
  until s.empty? 
    gotstr,gotlen = findstring(s)

    if gotstr then 
      lep "STR=#{gotstr},#{gotlen}\n"
      @q.push([:STRING, gotstr])
      s = s[gotlen..-1]
      next
    end

    case s
    when /\A\s+/      
    when /\A--\[\[.*?\]\]/m
      lep "LCOMMENT:-- "
    when /\A--(.*)$/
      lep "COMMENT:-- "
    when /\A(\d+\.\d+[eE][+\-]\d+)/
      lep "EXPNUM2:#{$&} "
      @q.push([ :EXPNUMBER, $& ])
    when /\A(\d+[eE][+\-]\d+)/
      lep "EXPNUM1:#{$&} "
      @q.push([ :EXPNUMBER, $& ])
    when /\A(0x[0-9a-fA-F]+)/
      lep "HEXNUM:#{$&} "
      @q.push([ :HEXNUMBER, $& ])
    when /\A(\d+\.\d+)/
      lep "FNUM:#{$&} "
      @q.push([ :FLOATNUMBER, $& ])
    when /\A\d+/
      lep "NUM:#{$&} "
      @q.push([ :INTNUMBER, $& ])
    when /\A([a-zA-Z_][a-zA-Z_0-9]*)/
      ss = $&
      
      if kwh[ss] then
        lep "KW:#{ss} " 
        @q.push([ kwh[ss],ss])
      else
        lep "W:#{ss} " 
        @q.push([ :NAME, ss ])
      end
    when /\A\.\.\./
      lep "W:... " 
      @q.push([:DOTDOTDOT,$&])
    when /\A==/
      lep "OP:== "
      @q.push([:EQUAL,$&])
    when /\A<=/
      lep "OP:<= "
      @q.push([:LTE,$&])
    when /\A>=/
      lep "OP:>= "
      @q.push([:GTE,$&])
    when /\A~=/
      lep "OP:~= "
      @q.push([:NEQ,$&])
    when /\A\+/
      lep "OP:+ "
      @q.push([:PLUS,$&])
    when /\A-/
      lep "OP:- "
      @q.push([:MINUS,$&])
    when /\A\*/
      lep "OP:* "
      @q.push([:MUL,$&])
    when /\A\//      
      lep "OP:/ "
      @q.push([:DIV,$&])
    when /\A\^/      
      lep "OP:^ "
      @q.push([:POWER,$&])
    when /\A%/      
      lep "OP:% "
      @q.push([:MOD,$&])
    when /\A\.\./
      lep "OP:.. "
      @q.push([:APPEND,$&])
    when /\A</
      lep "OP:< "
      @q.push([:LT,$&])
    when /\A>/
      lep "OP:> "
      @q.push([:GT,$&])
    when /\A\#/
      lep "OP:# "
      @q.push([:LENGTH,$&])
    when /\A.|\n/o
      ss = $&
      lep "C:#{ss} "
      @q.push([ss,ss])
    else
      raise s
    end
    s = $'
  end
  @q.push([ false, '$end' ])
  lep "\n"

#  et = Time.now()
#  STDERR.print "TOKENIZETIME:", (et-st), "\n" 

#  @yydebug=true

  @stack = []
  @stack.push([:var,:a])
  @stack.push([:var,:b]) 
  @stack.push([:lit,1])

  @stack.push([:expr,@stack.pop])
  @stack.push([:lit,2]) 
  @stack.push([:expr,@stack.pop])

  dumpstack()

  params=[]
  while true 
    e = @stack.pop
    break if !e
    if e[0] == :expr or e[0] == :var then
      params.push(e)
    else
      @stack.push(e)
      break 
    end
  end
  dumpstack()
  ep "params.size:#{params.size}\n"
    
  @stack.push([:asign]+params)
  
  topary = @stack.pop
  if @stack.size > 0 then
    raise "stack mismatch! size:#{@stack.size}\n"
  end
  ep ary2s(topary),"\n"

  do_parse
  lep "\n"


end


def ary2s(ary)
  raise if !ary
  out= "s(" 
  raise "first element have to be a symbol:#{typeof(ary[0])}, #{ary.join(':')}" if typeof(ary[0])!=Symbol 
  ary.size.times do |i|
    o = ary[i]
    if typeof(o) == Symbol then
      out+= ":#{o}"
    elsif typeof(o) == Array then
      out+=ary2s(o)
    else
      out+= o.to_s
    end
    out+= ", " if i < ary.size-1 
  end
  out+= ")"
  return out
end

def dumpstack()
  ep "dumpstack: size:#{@stack.size}\n"
  @stack.size.times do |i|
    e = @stack[i]
    raise "invalid type#{typeof(e)} " if typeof(e) !=Array
    e.each do |ee|
      ep "#{ee}(#{typeof(ee)}) "
    end
    ep "\n"
  end
end
