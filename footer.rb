#
# racc footer
#

if ARGV.size < 1 then 
  STDERR.print "need input file path or -s option\n"
  exit 1
end

infile = nil
sout = false
ARGV.each do |arg|
  if arg == "-s" then
    sout = true
  else
    infile = arg
  end
end

lp = Lua.new
s = File.open( infile).read
lp.parse(s,sout)



    

