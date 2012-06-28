#
# racc inner file
#

$KCODE='u'


def initialize()
  @tested = Hash.new(0)
end


def ep(*args)
#  STDERR.print *args
end
def lep(*args)
#  STDERR.print *args
end


def push(*args)
  raise "push: cannot push empty array" if args.size == 0
  raise "push: first element must be a symbol" if typeof(args[0]) != Symbol
#  ep "(#{args.join(':')}) "
  if args[0] == :lit then
    ep "(#{args[0]}=#{args[1]}) "
  else
    ep "(#{args[0]}) "
  end
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

# get return or break
def poplaststat()
  top = @stack.pop()
  if top and top[0] == :break or top[0] == :return then
    return top
  else
    raise "poplaststat: not found!"
  end
end


# go through block and find last else placeholder
def findlastelse(blk)
#  pp "FFFFFFFFFFFFFFFFFF: findlastelse:", blk
  curblk = blk
  depth=0
  while true
    nextif = curblk[1]
    nextelse = nextif[3]
    if nextelse == nil then
      return nextif
    else
      depth+=1
      curblk = nextelse
    end
  end
  raise "should never reached"
end


def next_token
  @q.shift
end

def on_error(t,v,values)
  pp @stack
  raise "ERROR: t:#{t} v:#{v} values:#{values}\n"
end

def escapestr(s)
#  STDERR.print "ESCAPE:#{s}\n"
  ary = s.split("")
  out = []
  ary.each do |ch|
    if ch == "\n" then
      out.push( "\\n" )
    elsif ch == "\"" then
      out.push( "\\\"")
    elsif ch == "\\" then 
      out.push( "\\\\" )
    else
      out.push(ch)
    end
  end
  return out.join("")
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
    elsif typeof(o) == String then
      out+= "\"" + escapestr(o) + "\""
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

def omitShebang(s)
  lines = s.split("\n")
  if lines[0] and lines[0][0..0] == "#" then
    lines.shift
  end
  return lines.join("\n")
end

def parse(s,fmt,exectest)
  s=omitShebang(s)
  @comments = []
  @q=[]   
  keywords = [ :FUNCTION, :RETURN, :END, :DO, :WHILE, :UNTIL, :REPEAT, :IF, :THEN, :ELSE, :ELSEIF, :FOR, :LOCAL, :AND, :OR, :BREAK, :NOT, :NIL, :FALSE, :TRUE, :IN ]
  kwh = {}
  keywords.each do |sym| kwh[sym.to_s.downcase] = sym end
  until s.empty? 
    gotstr,gotlen = findstring(s)

    if gotstr then 
      @q.push([:STRING, gotstr])
      s = s[gotlen..-1]
      next
    end

    case s
    when /\A\s+/      
    when /\A--\[\[.*?\]\]/m
      @comments.push([:comment,$&])
    when /\A--(.*)$/
      @comments.push([:comment,$&])
    when /\A(\d+\.\d+[eE][+\-]?\d+)/
      lep "EXPNUM1:#{$&} "
      @q.push([ :EXPNUMBER, $& ])
    when /\A(\d+[eE][+\-]?\d+)/
      lep "EXPNUM2:#{$&} "
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
        lep "N:#{ss} " 
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


  @stack = []

  do_parse

#  pp @stack

  topary = @stack.pop
  if @stack.size > 0 then
    ep "stack mismatch! size:#{@stack.size} : \n"
    pp @stack
    raise "FATAL"
  end


  ep "\n"

  if fmt =="s" then
    print ary2s(topary),"\n"
  elsif fmt =="a" then
    pp topary
  elsif fmt =="c" then
    pp [:commentlist, *@comments]  
  end
  if exectest then
    src = "$cnt=0\ndef s(*args)\n$cnt+= args.size\nend\n" + ary2s(topary) + "\nprint $cnt,'\n'\n"
    begin
      eval(src)
    rescue Exception => e
      STDERR.print "FATAL: parse error: #{e}\n",src
      exit 1
    end
  end

end


