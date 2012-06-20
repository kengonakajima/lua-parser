OUT=../lua2sexp
CMD=time ruby

all: test

test: $(OUT)
		$(CMD) $(OUT) ret2.lua
		$(CMD) $(OUT) num.lua

		$(CMD) $(OUT) var.lua	

		$(CMD) $(OUT) mlstr.lua
		$(CMD) $(OUT) long.lua


		$(CMD) $(OUT) forin.lua
		$(CMD) $(OUT) for.lua
		$(CMD) $(OUT) repeat.lua
		$(CMD) $(OUT) while.lua
		$(CMD) $(OUT) do.lua

		$(CMD) $(OUT) local.lua

		$(CMD) $(OUT) bool.lua

		$(CMD) $(OUT) unops.lua
		$(CMD) $(OUT) ops.lua

		$(CMD) $(OUT) lcomment.lua
		$(CMD) $(OUT) comment.lua

		$(CMD) $(OUT) table3.lua
		$(CMD) $(OUT) lstr.lua
		$(CMD) $(OUT) nstr.lua

		$(CMD) $(OUT) elseif.lua
		$(CMD) $(OUT) ifthen.lua

		$(CMD) $(OUT) dot3f.lua
		$(CMD) $(OUT) table2.lua
		$(CMD) $(OUT) table1.lua
		$(CMD) $(OUT) dot3.lua
		$(CMD) $(OUT) func2.lua
		$(CMD) $(OUT) func.lua

		$(CMD) $(OUT) empty.lua
		$(CMD) $(OUT) mini.lua
		$(CMD) $(OUT) ret.lua
		$(CMD) $(OUT) semi.lua

		$(CMD) $(OUT) lumino.lua

testpl:
		$(CMD) $(OUT) pl/app.lua
		$(CMD) $(OUT) pl/array2d.lua
		$(CMD) $(OUT) pl/class.lua
		$(CMD) $(OUT) pl/comprehension.lua
		$(CMD) $(OUT) pl/config.lua
		$(CMD) $(OUT) pl/data.lua
		$(CMD) $(OUT) pl/Date.lua
		$(CMD) $(OUT) pl/file.lua
		$(CMD) $(OUT) pl/func.lua
		$(CMD) $(OUT) pl/init.lua
		$(CMD) $(OUT) pl/input.lua
		$(CMD) $(OUT) pl/lapp.lua
		$(CMD) $(OUT) pl/lexer.lua
		$(CMD) $(OUT) pl/List.lua
		$(CMD) $(OUT) pl/luabalanced.lua
		$(CMD) $(OUT) pl/Map.lua
		$(CMD) $(OUT) pl/MultiMap.lua
		$(CMD) $(OUT) pl/operator.lua
		$(CMD) $(OUT) pl/OrderedMap.lua
		$(CMD) $(OUT) pl/path.lua
		$(CMD) $(OUT) pl/permute.lua
		$(CMD) $(OUT) pl/pretty.lua
		$(CMD) $(OUT) pl/seq.lua
		$(CMD) $(OUT) pl/Set.lua
		$(CMD) $(OUT) pl/sip.lua
		$(CMD) $(OUT) pl/strict.lua
		$(CMD) $(OUT) pl/stringio.lua
		$(CMD) $(OUT) pl/stringx.lua
		$(CMD) $(OUT) pl/tablex.lua
		$(CMD) $(OUT) pl/template.lua
		$(CMD) $(OUT) pl/test.lua
		$(CMD) $(OUT) pl/text.lua
		$(CMD) $(OUT) pl/utils.lua
		$(CMD) $(OUT) pl/xml.lua

