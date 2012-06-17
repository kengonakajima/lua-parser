#
# racc inner file
#

def initialize()
end

def next_token
  @q.shift
end

def on_error(t,v,values)
  raise "ERROR: t:#{t} v:#{v} values:#{values}\n"
end

def parse(s)
  @q=[]   
  until s.empty? 
    case s
    when /\A\s+/
    when /\A\d+/
      @q.push([ :NUMBER, $&.to_i ])
    when /\A([a-zA-Z_][a-zA-Z_0-9]*)/
      ss = $&
      STDERR.print "W:#{ss} "
      if ss == "function" then
        @q.push([:FUNCTION,ss])
      elsif ss == "return" then
        @q.push([:RETURN,ss])
      elsif ss == "end" then
        @q.push([:END,ss])
      else
        @q.push([ :NAME, ss ])
      end
    when /\A\.\.\./
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


