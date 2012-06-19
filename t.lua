q={ [1]=8, ["aaa"]=99,1,2 }

a={b=1,c=2}

b={1,2}
c={1}
d={}



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


--x0,y0,x1 = poly[1],poly[2],poly[3]

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



