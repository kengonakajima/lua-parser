OUT=luaparse.rb

all: $(OUT)

$(OUT):  lua.y inner.rb footer.rb
		racc -E -l lua.y -o $(OUT)
		ruby $(OUT) empty.lua
		ruby $(OUT) mini.lua
		ruby $(OUT) ret.lua
		ruby $(OUT) semi.lua
		ruby $(OUT) func.lua
		ruby $(OUT) lumino.lua
clean:
		rm $(TARGET)

