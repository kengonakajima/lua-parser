a=1e70

-- t{iter()}



--[[
    a=1
b=2;
c=3
local out;
return d;
--]]


--out, pos = lb.match_explist(expr, pos)
--assert(out, "syntax error: missing expression list")
--out = table_concat(out, ', ')

--[[
function a()
  i=1
  return function()
    j=2
    return 3
  end
end
--]]

  --[[
function array2d.iter (a,indices,i1,j1,i2,j2)
  assert_arg(1,a,'table')
  local norowset = not (i2 and j2)
  i1,j1,i2,j2 = default_range(a,i1,j1,i2,j2)
  local n,i,j = i2-i1+1,i1-1,j1-1
  local row,nr = nil,0
  local onr = j2 - j1 + 1
  return function()
    j=1
--    j = j + 1

  end
end  
  --]]
  
--[[
    if j > nr then
      j = j1
      i = i + 1
      if i > i2 then return nil end
      row = a[i]
      nr = norowset and #row or onr      
    end
    




      

    if indices then
      return i,j,row[j]
    else
      return row[j]
    end
  end
  --]]

  


--[[

function t:getChar(x,y)
  return self.data[int(y)][int(x)] 
end  



function _G.dumpbytes(str)
  local out={}

  for i=1,#str do
    insert(out, str:byte(i,i))
  end
  return table.concat(out," ")

end
--]]

--  a,b=1,2


--[[
if 1 then
  return 1
end

--function _G.b2i(b) if b then return 1 else return 0 end end
function _G.b2i(b)
  if 1 then
    return 1
  end
end
--]]

--function a()
--  return
--end




--for a,b in pairs(a) do
--  local c = {a,b}
--end

--[[
for a=1,2 do
  function aho()
  end
end
for a=1,2,1 do
  local a = {}
end
--]]

--while true do
--end
--while a==2 do
--end
--while true do
--  function aho()
--  end
--end

--do
--  do
--  end
--end

--[[
local a = function() end

local function x()
end
function a()
  local a
  local b=2
  local c,d=3,4
end

local e={}
local c,d=3,4
local b=2
local a
--]]

--[[

local a = function() end
--]]

--function a(...)
--  t={...}
--end

--t={10,20;30,}
--q={ [1]=8, ["aaa"]=99,1,2 }
--a={b=1,c=2}
--b={1,2}
--c={1}
--d={}



--[[
function noarg()
end
function hoge(a)
end
function hoge(a,b)
end
function hoge(a,b,c)
  return 2
end
--]]
--function piyo(a,b)
--  return a
--end



--[[
function noarg()
end
function a.b()
end
--]]

--[[
if 1 then
--  f()
elseif 2 then
elseif 3 then
--  g()
--elseif 3 then
--elseif 5 then

--  h()
else
  i()
--  i()
end
--]]


--[[
if a==nil then
  f()
else
 g()
end
--]]
--a.b=1

--[[
function hoge(a,b,c)
  return 2
end
function piyo(a,b)
  return a
end
--]]


--[[
out=a~=2
out=a<=2
out=a>=2
out=a>2
out=a<2
out=a.."2"
out=a.b..a.c
out=a%2
out=a^2
out=a/2
out=a*2
out=a-2
out=a+2
out=a==1
--]]

--[[
out= a and true
out= a and not true
out= not a and not true
out= ((not a) and (not true))
out= not a and (not true)
--]]





--function a() local x={1,2,3,4,5,6,7,8,9,10,11,12,13} end

--[[
if a==nil then
--  f()
elseif b==2 then
--  g()
--elseif c==3 then
--  h()
--else
--  i()
end
--]]


--[[
if a==nil then
  f()
else
  g()
end
--]]

--function a()
--  return 2
--end

--[[
if a then
elseif b then
  if e then
  end
  
elseif c then
  if d then
  end  
end
]]--




--a.b=c.d
--a.b=c
--a[1]=2


--[[
if a.b then
  p()
end
if a[1] then
  q()
end
--]]



--a()
--a(1,2)

-- function a()
-- end
-- function a.b()
-- end
-- function a:b()
-- end
-- function a.b:c()
-- end

--a=b
--a,b=1,2,3
--c="AAAAAA\nAAAA"
--return 2



