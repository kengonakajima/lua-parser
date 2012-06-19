OUT=lua2sexp

all: $(OUT) test
	make -C test

$(OUT):  lua.y inner.rb footer.rb 
	racc -g -E -l lua.y -o $(OUT) --executable=/usr/bin/ruby


s: $(OUT)
#		ruby $(OUT) -s test/num.lua # done
#		ruby $(OUT) test/ifthen.lua # done

		ruby $(OUT) t.lua

#		ruby $(OUT) test/elseif.lua


#		ruby $(OUT) test/var.lua	


# 		ruby $(OUT) test/mlstr.lua
# 		ruby $(OUT) test/long.lua


# 		ruby $(OUT) test/forin.lua
# 		ruby $(OUT) test/for.lua
# 		ruby $(OUT) test/repeat.lua
# 		ruby $(OUT) test/while.lua
# 		ruby $(OUT) test/do.lua

# 		ruby $(OUT) test/local.lua

# 		ruby $(OUT) test/bool.lua

# 		ruby $(OUT) test/unops.lua
# 		ruby $(OUT) test/ops.lua

# 		ruby $(OUT) test/lcomment.lua
# 		ruby $(OUT) test/comment.lua

# 		ruby $(OUT) test/table3.lua
# 		ruby $(OUT) test/lstr.lua
# 		ruby $(OUT) test/nstr.lua



# 		ruby $(OUT) test/dot3f.lua
# 		ruby $(OUT) test/table2.lua
# 		ruby $(OUT) test/table1.lua
# 		ruby $(OUT) test/dot3.lua
# 		ruby $(OUT) test/func2.lua
# 		ruby $(OUT) test/func.lua

# 		ruby $(OUT) test/empty.lua
# 		ruby $(OUT) test/mini.lua
# 		ruby $(OUT) test/ret.lua
# 		ruby $(OUT) test/semi.lua

# 		ruby $(OUT) test/lumino.lua




clean:
		rm $(TARGET)

