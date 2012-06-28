OUT=lua2sexp

all: $(OUT)

fulltest : 
	make -C test

$(OUT):  lua.y inner.rb footer.rb 
	racc -g -E -l lua.y -o $(OUT) --executable=/usr/bin/ruby

hoge: $(OUT)
	ruby lua2sexp -x -a t.lua

clean:
		rm $(OUT)

