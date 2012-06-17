$KCODE='u'

# get string literal
def findstring(s)
  chars = s.split("")
  top = chars.shift

  longtop = nil
  stype = nil
  if top == "\"" then
    stype = :NORMALSTR
  elsif top == "'" then
    stype = :CHARSTR
  elsif s =~ /^(\[(=*)\[)/ then
    stype = :LONGSTR
    longtop = $&
    chars = s[longtop.size..-1].split("")
    print "LONG! TOP:#{longtop} chars.size:#{chars.size} longtop.size:#{longtop.size}\n"
  else
    return false
  end

  escaping = false
  out = ""
  while chars.size > 0
    ch = chars.shift
    if escaping then
      out+=ch
      # escape character
      if ch =~ /b|t|n|f|r|\"|\'|\\/
        escaping=false
      end
      # octal escaping
      if ch =~ /[0-9]/ then
        nch = chars.shift
#        print "NCH:#{nch} "
        if nch =~ /[0-9]/ then
          nnch = chars.shift
#          print "NNCH:#{nnch} "
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

      # unicode escape : TODO: \u notation not working in 5.1?
            
      next
    end

    if ch == "]" and longtop then 
      print "LONG-CLOSING? "
      tofetch = longtop.size - 1 
      fetched = chars[0..(tofetch-1)]
      ok=true
      fetched.size.times do |i|
        if i==fetched.size-1 then
          if fetched[i]!="]" then
            print "FALSE 2 "
            ok = false
            break
          end
        else
          if fetched[i] != "=" then 
            print "FALSE 3 "
            ok = false
            break
          end
        end
      end
      if ok then 
        return out
      end
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
expecteq( "nstrnl", findstring("\"ahoあほ\nahoaho") , false )
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
expecteq( "chstrnl", findstring("'ahoあほ\naho") , false )
expecteq( "chstru1", findstring("'aho\\0aho'hoge" ), "aho\\0aho" )
expecteq( "chstru2", findstring("'aho\\01aho'hoge" ), "aho\\01aho" )
expecteq( "chstru3", findstring("'aho\\012aho'hoge" ), "aho\\012aho" )

# longstring
expecteq( "lstrfull", findstring("[[ahoあほ]]"), "ahoあほ" )
expecteq( "lstrnl", findstring("[[aho\nあほ]]"), "aho\nあほ" )
expecteq( "lstrnl2", findstring("[[\naho\nあほ\n]]"), "\naho\nあほ\n" )  # TODO: lua skips topline "\n"
expecteq( "lstr3", findstring("[===[\naho\nあほ]===]"), "\naho\nあほ" )  # TODO: lua skips topline "\n"
expecteq( "lstr3_1", findstring("[===[\naho\nあほ\n]===]"), "\naho\nあほ\n" )  # TODO: lua skips topline "\n"
expecteq( "lstr3_1_esc", findstring("[===[\naho\n\"'あほ\\012aho\n]===]"), "\naho\n\"'あほ\\012aho\n" )  # TODO: lua skips topline "\n"


