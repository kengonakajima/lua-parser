OUT=luaparse.rb

all: $(OUT) test
	make -C test

$(OUT):  lua.y inner.rb footer.rb 
		racc -g -E -l lua.y -o $(OUT)

clean:
		rm $(TARGET)

