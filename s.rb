$d=0
def s(*args)
  print "s("
  $d+=1
  print args.join(",")
  print ")\n"
end

s(:chunk,s(:function,s(:funcname,s(:name,:_G,:_G)),s(:funcbody,s(:parlist,s(:namelist,s(:name,:str))),s(:block,s(:chunk,s(:deflocal,s(:namelist,s(:name,:out)),s(:explist,s(:exp,s(:tcons,s(:fieldlist))))),s(:for,s(:name,:i),s(:exp,s(:lit,1)),s(:exp,s(:unop,s(:exp,s(:prefixexp,s(:var,s(:name,:str)))),s(:op,:length))),nil,s(:block,s(:chunk,s(:call,s(:prefixexp,s(:var,s(:name,:insert))),nil,s(:args,s(:explist,s(:exp,s(:prefixexp,s(:var,s(:name,:out)))),s(:exp,s(:prefixexp,nil)))))))),s(:return,s(:explist,s(:exp,s(:prefixexp,nil)))))))))
