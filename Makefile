OUT=luaparse.rb

all: test


test: $(OUT)
		ruby $(OUT) forin.lua
		ruby $(OUT) for.lua
		ruby $(OUT) repeat.lua
		ruby $(OUT) while.lua
		ruby $(OUT) do.lua

		ruby $(OUT) local.lua

		ruby $(OUT) bool.lua

		ruby $(OUT) unops.lua
		ruby $(OUT) ops.lua

		ruby $(OUT) lcomment.lua
		ruby $(OUT) comment.lua

		ruby $(OUT) table3.lua
		ruby $(OUT) lstr.lua
		ruby $(OUT) nstr.lua

		ruby $(OUT) elseif.lua
		ruby $(OUT) ifthen.lua

		ruby $(OUT) dot3f.lua
		ruby $(OUT) table2.lua
		ruby $(OUT) table1.lua
		ruby $(OUT) dot3.lua
		ruby $(OUT) func2.lua
		ruby $(OUT) func.lua

		ruby $(OUT) empty.lua
		ruby $(OUT) mini.lua
		ruby $(OUT) ret.lua
		ruby $(OUT) semi.lua




#		ruby $(OUT) lumino.lua

$(OUT):  lua.y inner.rb footer.rb *.lua
		racc -g -E -l lua.y -o $(OUT)

clean:
		rm $(TARGET)

