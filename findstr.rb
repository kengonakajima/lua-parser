$KCODE='u'

# get string literal
def findstring(s)
  chars = s.split("")
  top = chars.shift

  stype = nil
  if top == "\"" then
    stype = :NORMALSTR
  elsif top == "'" then
    stype = :CHARSTR
  elsif top == "[" then
    stype = :LONGSTR
  else
    return false
  end

  escaping = false
  out = ""
  while chars.size > 0
    ch = chars.shift
    if escaping then
      out+=ch
      if ch =~ /b|t|n|f|r|\"|\'|\\/
        escaping=false
      end
      if ch =~ /[0-9]/ then
        nch = chars.shift
        print "NCH:#{nch} "
        if nch =~ /[0-9]/ then
          nnch = chars.shift
          print "NNCH:#{nnch} "
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
            
      next
    end

    if ch == "\"" and stype == :NORMALSTR then
      return out      
    end
    if ch == "'" and stype == :CHARSTR then
      return out
    end

    if ch == "\\" then
      escaping = true
      out+=ch
    else
      out+=ch
    end
  end
  return false
end


def expecteq(t,a,b)
  if a==b then
    print t,"\n"
  else
    raise "FATAL: #{t} : A:'#{a}' B:'#{b}'\n"
  end
end

#nonstring
expecteq( "notstring", findstring("a=\"ahoあほ\"") , false )

# normalstring
expecteq( "nstrfull", findstring("\"ahoあほ\"") , "ahoあほ" )
expecteq( "nstr", findstring("\"ahoあほ\"ahoaho") , "ahoあほ" )
expecteq( "nstresc", findstring("\"ahoあほ\\\"aho\"ahoaho") , "ahoあほ\\\"aho" )
expecteq( "nstresc2", findstring("\"ahoあほ\\\\aho\"ahoaho") , "ahoあほ\\\\aho" )
expecteq( "nstrescetc", findstring("\"ahoあほ\\b\\t\\n\\f\\raho\"ahoaho") , "ahoあほ\\b\\t\\n\\f\\raho" )
expecteq( "nstrnotterm", findstring("\"ahoあほ\\\"ahoahoaho") , false )
expecteq( "nstru1", findstring("\"aho\\0aho\"hoge" ), "aho\\0aho" )
expecteq( "nstru2", findstring("\"aho\\01aho\"hoge" ), "aho\\01aho" )
expecteq( "nstru3", findstring("\"aho\\012aho\"hoge" ), "aho\\012aho" )

# charstring
expecteq( "chstrfull", findstring("'ahoあほ'"), "ahoあほ" )
expecteq( "chstr", findstring("'ahoあほ'ahoaho") , "ahoあほ" )
expecteq( "chstresc", findstring("'ahoあほ\\'aho'ahoaho") , "ahoあほ\\'aho" )
expecteq( "chstresc2", findstring("'ahoあほ\\\\aho'ahoaho") , "ahoあほ\\\\aho" )
expecteq( "chstrescetc", findstring("'ahoあほ\\b\\t\\n\\f\\raho'ahoaho") , "ahoあほ\\b\\t\\n\\f\\raho" )
expecteq( "chstrnotterm", findstring("'ahoあほ\\'ahoahoaho") , false )
expecteq( "chstru1", findstring("'aho\\0aho'hoge" ), "aho\\0aho" )
expecteq( "chstru2", findstring("'aho\\01aho'hoge" ), "aho\\01aho" )
expecteq( "chstru3", findstring("'aho\\012aho'hoge" ), "aho\\012aho" )
