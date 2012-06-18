require "rubygems"
require 'ruby_parser'

def showit(s)
  @p = RubyParser.new
  print "#{s} \n          ", @p.parse(s),"\n" 
end


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
showit( "if a then b() else c() end")
showit( "a,b,c=1,2" )
showit( "a,b=1,2,3" )
showit( "while true do end" )
showit( "while true do a+=1 end" )
showit( "[1,2]" )
showit( "[1,2].each do end" )
showit( "[1,2].each do |a| end" )
showit( "{:a=>1,:b=>2}")



