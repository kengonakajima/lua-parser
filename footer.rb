#
# racc footer
#

if ARGV.size < 1 then 
  STDERR.print "need input file(s)\nOptions:\n-q : be quiet(parse only)\n-x : test by executing out-put sexp\n"
  exit 1
end

sout = true
exectest = false

ARGV.each do |arg|
  if arg =~ /^-/ then
    if arg == "-q" then
      sout = false
    elsif arg == "-x"
      exectest = true
    end
    
  else
	lp = Lua.new
    s = File.open(arg).read
    lp.parse(s,sout,exectest)
  end
end




    

