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

	ruby $(OUT) -s test/elseif.lua
	ruby $(OUT) -s test/ifthen.lua
	ruby $(OUT) -s test/num.lua 
	ruby $(OUT) -s test/var.lua	
	ruby $(OUT) -s test/mlstr.lua
	ruby $(OUT) -s test/bool.lua 
	ruby $(OUT) -s test/ops.lua
	ruby $(OUT) -s test/semi.lua 
	ruby $(OUT) -s test/ret.lua 
	ruby $(OUT) -s test/mini.lua 
	ruby $(OUT) -s test/empty.lua 
	ruby $(OUT) -s test/func.lua  
	ruby $(OUT) -s test/func2.lua
	ruby $(OUT) -s test/unops.lua
	ruby $(OUT) -s test/dot3.lua
	ruby $(OUT) -s test/table1.lua
	ruby $(OUT) -s test/table2.lua
	ruby $(OUT) -s test/table3.lua
	ruby $(OUT) -s test/dot3f.lua
	ruby $(OUT) -s test/nstr.lua
	ruby $(OUT) -s test/lstr.lua
	ruby $(OUT) -s test/comment.lua
	ruby $(OUT) -s test/lcomment.lua
	ruby $(OUT) -s test/local.lua
	ruby $(OUT) -s test/do.lua
	ruby $(OUT) -s test/while.lua
	ruby $(OUT) -s test/repeat.lua
	ruby $(OUT) -s test/for.lua
	ruby $(OUT) -s test/forin.lua
	ruby $(OUT) -s test/long.lua
	ruby $(OUT) -s test/lumino.lua

pl: $(OUT)
	ruby $(OUT) -s t.lua
	echo
	echo OKOKOK
	echo


	sleep 30

	ruby $(OUT) test/pl/pretty.lua

	ruby $(OUT) test/pl/OrderedMap.lua
	ruby $(OUT) test/pl/path.lua
	ruby $(OUT) test/pl/permute.lua

	ruby $(OUT) test/pl/MultiMap.lua
	ruby $(OUT) test/pl/operator.lua

	ruby $(OUT) test/pl/Map.lua
	ruby $(OUT) test/pl/luabalanced.lua

	ruby $(OUT) test/pl/List.lua


	ruby $(OUT) test/pl/lapp.lua
	ruby $(OUT) test/pl/lexer.lua
	ruby $(OUT) test/pl/input.lua
	ruby $(OUT) test/pl/init.lua
	ruby $(OUT) test/pl/func.lua
	ruby $(OUT) test/pl/file.lua
	ruby $(OUT) test/pl/app.lua

	ruby $(OUT) test/pl/array2d.lua
	ruby $(OUT) test/pl/class.lua
	ruby $(OUT) test/pl/comprehension.lua
	ruby $(OUT) test/pl/config.lua
	ruby $(OUT) test/pl/data.lua
	ruby $(OUT) test/pl/Date.lua



		#ruby $(OUT) test/pl/seq.lua
		#ruby $(OUT) test/pl/Set.lua
		#ruby $(OUT) test/pl/sip.lua
		#ruby $(OUT) test/pl/strict.lua
		#ruby $(OUT) test/pl/stringio.lua
		#ruby $(OUT) test/pl/stringx.lua
		#ruby $(OUT) test/pl/tablex.lua
		#ruby $(OUT) test/pl/template.lua
		#ruby $(OUT) test/pl/test.lua
		#ruby $(OUT) test/pl/text.lua
		#ruby $(OUT) test/pl/utils.lua
		#ruby $(OUT) test/pl/xml.lua

clean:
		rm $(OUT)

