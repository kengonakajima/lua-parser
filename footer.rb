#
# racc footer
#

if ARGV.size != 1 then 
  STDERR.print "need input file path\n"
  exit 1
end

infile = ARGV[0]

lp = Lua.new
s = File.open( infile).read
lp.parse(s)



    

