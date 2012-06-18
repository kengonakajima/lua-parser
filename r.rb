require "rubygems"
require 'ruby_parser'

def showit(s)
  @p = RubyParser.new
  print "#{s} \n          ", @p.parse(s),"\n" 
end

showit( "a=1" )
showit( "def a() end" )
showit( "def a(a,b) return a,b end" )
showit( "s=\"aho\"" )
showit( "s=a+1")
showit( "s=a and b")
showit( "if a then b() else c() end")
showit( "a,b=1,2" )
