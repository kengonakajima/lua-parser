class Lua

rule

chunk :  |
  stat |
  stat laststat |
  laststat
  ;

stat :FUNCTION;

laststat : RETURN;


end


---- header
---- inner = inner.rb
---- footer = footer.rb
