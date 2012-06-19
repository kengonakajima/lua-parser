OUT=lua2sexp

all: $(OUT) test
	make -C test

$(OUT):  lua.y inner.rb footer.rb 
	racc -g -E -l lua.y -o $(OUT) --executable=/usr/bin/ruby


s: $(OUT)

		ruby $(OUT) -s t.lua

		echo
		echo
		echo

		ruby $(OUT) -s test/elseif.lua # done
		ruby $(OUT) -s test/ifthen.lua # done
		ruby $(OUT) -s test/num.lua # done
		ruby $(OUT) -s test/var.lua	# done
		ruby $(OUT) -s test/mlstr.lua  # done
		ruby $(OUT) -s test/bool.lua   # done
		ruby $(OUT) -s test/ops.lua # done
		ruby $(OUT) -s test/semi.lua # done
		ruby $(OUT) -s test/ret.lua # done
		ruby $(OUT) -s test/mini.lua # done
		ruby $(OUT) -s test/empty.lua # done
		ruby $(OUT) -s test/func.lua  #done
		ruby $(OUT) -s test/func2.lua




#		ruby $(OUT) -s test/long.lua


# 		ruby $(OUT) -s test/forin.lua
# 		ruby $(OUT) -s test/for.lua
# 		ruby $(OUT) -s test/repeat.lua
# 		ruby $(OUT) -s test/while.lua
# 		ruby $(OUT) -s test/do.lua

# 		ruby $(OUT) -s test/local.lua



# 		ruby $(OUT) -s test/unops.lua


# 		ruby $(OUT) -s test/lcomment.lua
# 		ruby $(OUT) -s test/comment.lua

# 		ruby $(OUT) -s test/table3.lua
# 		ruby $(OUT) -s test/lstr.lua
# 		ruby $(OUT) -s test/nstr.lua



# 		ruby $(OUT) -s test/dot3f.lua
# 		ruby $(OUT) -s test/table2.lua
# 		ruby $(OUT) -s test/table1.lua
# 		ruby $(OUT) -s test/dot3.lua








# 		ruby $(OUT) -s test/lumino.lua




clean:
		rm $(TARGET)

