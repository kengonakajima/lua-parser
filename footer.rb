#
# racc footer
#

if ARGV.size < 1 then 
  STDERR.print <<EOF
Need input file(s).
Options: [-q|-a|-c] [-x]
 -q : be quiet(parse only)
 -x : test by executing out-put sexp
 -a : print as array literal
 -c : print only comments in array format
EOF
  exit 1
end

fmt = "s"
exectest = false

ARGV.each do |arg|
  if arg =~ /^-/ then
    if arg == "-q" then
      fmt = nil
    elsif arg == "-x"
      exectest = true
    elsif arg == "-a"
      fmt = "a"
    elsif arg == "-c"
      fmt = "c"
    end
    
  else
	lp = Lua.new
    s = File.open(arg).read
    lp.parse(s,fmt,exectest)
  end
end




    

