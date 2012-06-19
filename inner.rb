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
  STDERR.print(*args)
end

def t(s)
  ep(s)
  @tested[s] += 1
end


# expand 1 depth
def pushflat(*args)
  topush=[]
  args.each do |arg|
    if typeof(arg)==Array then
      arg.each do |e| topush.push(e) end
    else
      topush.push(arg)
    end
  end
  push(*topush)
end

def push(*args)
  raise "push: cannot push empty array" if args.size == 0
  raise "push: first element must be a symbol" if typeof(args[0]) != Symbol
#  ep "(#{args.join(':')}) "
  ep "(#{args[0]}) "
  @stack.push(args)
end

def pop(*args)
  top = @stack.pop()
  if !top then
    raise "pop: stack top is nil! args:'#{args}'"
  end
  sym = args[0]
  if sym and sym != top[0] then 
    ep "\n==================\n"
    pp @stack
    raise "pop: found invlalid sym '#{top[0]}'(#{typeof(top[0])}) expected:#{sym}"
  else
    return top
  end
end

# get statements reversed
def mpopstat()
  ep "mpopstat(stacklen=#{@stack.size}}):"
  out=[]
  syms= { :if => true, :asign=>true, :function=>true, :call=>true }
  while true
    top = @stack.pop
    break if !top
    if syms[top[0]] then
      out.push(top)
    else
      ep "[mpopstat:#{top[0]} is not found]"
      @stack.push(top)
      break
    end
  end
  if out.size==0 then
    raise "mpopstat: output is empty"
  end
  return out
end

# get multiple node with the 
def mpoprev(sym)
  ep "mpop(#{sym}):\n"
  out=[]
  while true
    top = @stack.pop
    break if !top
    if top[0] == sym then 
#      ep "FOUND on top:#{top[0]}\n"
      out.push(top)
    else
      @stack.push(top)
      break
    end
  end
  if out.size == 0 then
    raise "mpoprev: output is empty for '#{sym}'"
  end
  return out.reverse
end

def next_token
  @q.shift
end

def on_error(t,v,values)
  raise "ERROR: t:#{t} v:#{v} values:#{values}\n"
end

def ary2s(ary)
  raise if !ary
  out= "s(" 
  if typeof(ary[0])!=Symbol 
    raise "first element have to be a symbol:#{typeof(ary[0])}, #{ary.join(':')}" 
  end
  ary.size.times do |i|
    o = ary[i]
    if typeof(o) == Symbol then
      out+= ":#{o}"
    elsif typeof(o) == Array then
      out+=ary2s(o)
    elsif typeof(o) == NilClass then
      out+="nil"
    else
      out+= o.to_s
    end
    out+= "," if i < ary.size-1 
  end
  out+= ")"
  return out
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
    when /\A([a-zA-Z_][a-zA-Z_0-9.]*)/
      ss = $&
      
      if kwh[ss] then
        lep "KW:#{ss} " 
        @q.push([ kwh[ss],ss])
      else
        if ss.include?( "." ) then
          lep "NWD:#{ss} " 
          @q.push([ :NAMEWIDHDOTS, ss ])
        else
          lep "N:#{ss} " 
          @q.push([ :NAME, ss ])
        end
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


  @stack = []

  do_parse

  pp @stack

  topary = @stack.pop
  if @stack.size > 0 then
    raise "stack mismatch! size:#{@stack.size}\n"
  end

  STDERR.print ary2s(topary),"\n"


end


