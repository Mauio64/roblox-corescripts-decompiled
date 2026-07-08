local function newSymbol(p1) -- line: 1
	local v14 = newproxy(true)
	local u15 = ("Mocks.%s"):format(p1)

	getmetatable(v14).__tostring = function() -- line: 4
		-- upvalues: u15 (ref)
		return u15
	end

	return v14
end

local t1 = {}
local v3 = newproxy(true)
local u4 = ("Mocks.%s"):format("Calls")

getmetatable(v3).__tostring = function() -- line: 4
	-- upvalues: u4 (ref)
	return u4
end
t1.Calls = v3

local v5 = newproxy(true)
local u6 = ("Mocks.%s"):format("Children")

getmetatable(v5).__tostring = function() -- line: 4
	-- upvalues: u6 (ref)
	return u6
end
t1.Children = v5

local v7 = newproxy(true)
local u8 = ("Mocks.%s"):format("Lock")

getmetatable(v7).__tostring = function() -- line: 4
	-- upvalues: u8 (ref)
	return u8
end
t1.Lock = v7

local v9 = newproxy(true)
local u10 = ("Mocks.%s"):format("None")

getmetatable(v9).__tostring = function() -- line: 4
	-- upvalues: u10 (ref)
	return u10
end
t1.None = v9

local v11 = newproxy(true)
local u12 = ("Mocks.%s"):format("ReturnValue")

getmetatable(v11).__tostring = function() -- line: 4
	-- upvalues: u12 (ref)
	return u12
end
t1.ReturnValue = v11

return t1
