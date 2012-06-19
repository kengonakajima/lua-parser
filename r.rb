require "rubygems"
require 'ruby_parser'

def showit(s)
  @p = RubyParser.new
  print "#{s} \n          ", @p.parse(s),"\n" 
end

showit( <<EOF
if 1 then 
  "A"
else
  if 2 then
    "B"
  end
  "C"
end
EOF
)
showit( <<EOF
if 1 then
  "A"
elsif 2 then
  "B"
elsif 3 then
  "C"
else
  "D"
end
EOF
)


showit( "a.b.c.d")
showit( "a=nil")
showit( "a=1\nb=2\nif false then end\nx=1")
showit( "if a then b() end")
showit( "if a then b() else c() end")
showit( "if a then b() elsif x then c() else d() end")

showit( "8" )
showit( "a=1" )
showit( "a=1.2" )
showit( "a,b=1,2" )
showit( "a[1]=2" )
showit( "a.b=2" )

showit( "nil" )
showit( "true" )
showit( "false" )
showit( "1+2" )

showit( "def a() end" )
showit( "def a(a,b) return a,b end" )
showit( "a(2,3)")
showit( "s=\"aho\"" )
showit( "s=a+1")
showit( "s=a and b")

showit( "a,b,c=1,2" )
showit( "a,b=1,2,3" )
showit( "while true do end" )
showit( "while true do a+=1 end" )
showit( "[1,2]" )
showit( "[1,2].each do end" )
showit( "[1,2].each do |a| end" )
showit( "{:a=>1,:b=>2}")



