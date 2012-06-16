#
# racc inner file
#

def initialize()
end

def next_token
  @q.shift
end

def on_error(t,v,values)
  print "ERROR: t:#{t} v:#{v} values:#{values}\n"
end

def parse(s)
  @q=[]   
  print "AHo\n"
  until s.empty?
    case s
    when /\A\s+/
    when /\A\d+/
      @q.push([ :NUMBER, $&.to_i ])
    when /\A.|\n/o
      pk = $&
      @q.push([pk,pk])
    else
      raise s
    end
    s = $'
  end
  @q.push([ false, '$end' ])
  do_parse
end


