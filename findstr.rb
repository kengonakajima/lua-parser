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
#    print "LONG! TOP:#{longtop} chars.size:#{chars.size} longtop.size:#{longtop.size}\n"
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
      tofetch = longtop.size - 1 
      fetched = chars[0..(tofetch-1)]
      ok=true
      fetched.size.times do |i|
        if i==fetched.size-1 then
          if fetched[i]!="]" then
            ok = false
            break
          end
        else
          if fetched[i] != "=" then 
            ok = false
            break
          end
        end
      end
      if ok then 
        return out, longtop.size*2 + out.size
      end
    end

    if ch == "\"" and stype == :NORMALSTR then
      return out, out.size + 2
    end
    if ch == "'" and stype == :CHARSTR then
      return out, out.size + 2
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
  res,uselen = findstring(a)
  if res==b then
    if b==false then
      print t,"\n"
    else
      print t," #{res.size},#{uselen}\n"
    end
  else
    raise "FATAL: #{t} : A:'#{a}' B:'#{b}'\n"
  end
end

#nonstring
expecteq( "notstring", "a=\"ahoあほ\"", false )

# normalstring
expecteq( "nstrfull", "\"ahoあほ\"", "ahoあほ" )
expecteq( "nstr", "\"ahoあほ\"ahoaho", "ahoあほ" )
expecteq( "nstresc", "\"ahoあほ\\\"aho\"ahoaho", "ahoあほ\\\"aho" )
expecteq( "nstresc2", "\"ahoあほ\\\\aho\"ahoaho", "ahoあほ\\\\aho" )
expecteq( "nstrescetc", "\"ahoあほ\\b\\t\\n\\f\\raho\"ahoaho", "ahoあほ\\b\\t\\n\\f\\raho" )
expecteq( "nstrnotterm", "\"ahoあほ\\\"ahoahoaho", false )
expecteq( "nstrnl", "\"ahoあほ\nahoaho", false )
expecteq( "nstru1", "\"aho\\0aho\"hoge", "aho\\0aho" )
expecteq( "nstru2", "\"aho\\01aho\"hoge", "aho\\01aho" )
expecteq( "nstru3", "\"aho\\012aho\"hoge", "aho\\012aho" )


# charstring
expecteq( "chstrfull", "'ahoあほ'", "ahoあほ" )
expecteq( "chstr", "'ahoあほ'ahoaho", "ahoあほ" )
expecteq( "chstresc", "'ahoあほ\\'aho'ahoaho", "ahoあほ\\'aho" )
expecteq( "chstresc2", "'ahoあほ\\\\aho'ahoaho", "ahoあほ\\\\aho" )
expecteq( "chstrescetc", "'ahoあほ\\b\\t\\n\\f\\raho'ahoaho", "ahoあほ\\b\\t\\n\\f\\raho" )
expecteq( "chstrnotterm", "'ahoあほ\\'ahoahoaho", false )
expecteq( "chstrnl", "'ahoあほ\naho", false )
expecteq( "chstru1", "'aho\\0aho'hoge" , "aho\\0aho" )
expecteq( "chstru2", "'aho\\01aho'hoge", "aho\\01aho" )
expecteq( "chstru3", "'aho\\012aho'hoge", "aho\\012aho" )

# longstring
expecteq( "lstrfull", "[[ahoあほ]]", "ahoあほ" )
expecteq( "lstrnl", "[[aho\nあほ]]", "aho\nあほ" )
expecteq( "lstrnl2", "[[\naho\nあほ\n]]", "\naho\nあほ\n" )  # TODO: lua skips topline "\n"
expecteq( "lstr3", "[===[\naho\nあほ]===]", "\naho\nあほ" )  # TODO: lua skips topline "\n"
expecteq( "lstr3_1", "[===[\naho\nあほ\n]===]", "\naho\nあほ\n" )  # TODO: lua skips topline "\n"
expecteq( "lstr3_1_esc", "[===[\naho\n\"'あほ\\012aho\n]===]", "\naho\n\"'あほ\\012aho\n" )  # TODO: lua skips topline "\n"


