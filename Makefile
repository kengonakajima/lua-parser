OUT=luaparse.rb

all: test


test: $(OUT)
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

