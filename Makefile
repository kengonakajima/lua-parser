OUT=lua2sexp

all: $(OUT) test
	make -C test

$(OUT):  lua.y inner.rb footer.rb 
	racc -g -E -l lua.y -o $(OUT) --executable=/usr/bin/ruby


s: $(OUT)
	cat t.lua; ruby $(OUT) -s t.lua
#	ruby r.rb



clean:
		rm $(TARGET)

