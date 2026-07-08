local function newSymbol(p1) -- line: 1
	local v30 = newproxy(true)
	local u31 = ("Mocks.%s"):format(p1)

	getmetatable(v30).__tostring = function() -- line: 4
		-- upvalues: u31 (ref)
		return u31
	end

	return v30
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
local u8 = ("Mocks.%s"):format("None")

getmetatable(v7).__tostring = function() -- line: 4
	-- upvalues: u8 (ref)
	return u8
end
t1.None = v7

local v9 = newproxy(true)
local u10 = ("Mocks.%s"):format("ReturnValue")

getmetatable(v9).__tostring = function() -- line: 4
	-- upvalues: u10 (ref)
	return u10
end
t1.ReturnValue = v9

local v11 = newproxy(true)
local u12 = ("Mocks.%s"):format("Name")

getmetatable(v11).__tostring = function() -- line: 4
	-- upvalues: u12 (ref)
	return u12
end
t1.Name = v11

local v13 = newproxy(true)
local u14 = ("Mocks.%s"):format("Address")

getmetatable(v13).__tostring = function() -- line: 4
	-- upvalues: u14 (ref)
	return u14
end
t1.Address = v13

local v15 = newproxy(true)
local u16 = ("Mocks.%s"):format("Operations")

getmetatable(v15).__tostring = function() -- line: 4
	-- upvalues: u16 (ref)
	return u16
end
t1.Operations = v15

local v17 = newproxy(true)
local u18 = ("Mocks.%s"):format("Spec")

getmetatable(v17).__tostring = function() -- line: 4
	-- upvalues: u18 (ref)
	return u18
end
t1.Spec = v17

local v19 = newproxy(true)
local u20 = ("Mocks.%s"):format("SideEffect")

getmetatable(v19).__tostring = function() -- line: 4
	-- upvalues: u20 (ref)
	return u20
end
t1.SideEffect = v19

local v21 = newproxy(true)
local u22 = ("Mocks.%s"):format("isSpy")

getmetatable(v21).__tostring = function() -- line: 4
	-- upvalues: u22 (ref)
	return u22
end
t1.isSpy = v21

local v23 = newproxy(true)
local u24 = ("Mocks.%s"):format("isTuple")

getmetatable(v23).__tostring = function() -- line: 4
	-- upvalues: u24 (ref)
	return u24
end
t1.isTuple = v23

local v25 = newproxy(true)
local u26 = ("Mocks.%s"):format("isMagicMock")

getmetatable(v25).__tostring = function() -- line: 4
	-- upvalues: u26 (ref)
	return u26
end
t1.isMagicMock = v25

local v27 = newproxy(true)
local u28 = ("Mocks.%s"):format("isPredicate")

getmetatable(v27).__tostring = function() -- line: 4
	-- upvalues: u28 (ref)
	return u28
end
t1.isPredicate = v27

return t1
