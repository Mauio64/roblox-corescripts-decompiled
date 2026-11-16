local symbols = require(script.Parent.symbols)
local Spy = require(script.Parent.Spy)
local setReturnValue = require(script.Parent.setReturnValue)
local setSideEffect = require(script.Parent.setSideEffect)

local function isKeyInSpec(metatable, p) -- 2 equivalent calls inferred from this helper
	local v = metatable[symbols.Spec]

	if not v then
		return true
	end

	local success, result = pcall(function()
		return v[p]
	end)

	return success and result
end

local MagicMock = {}
MagicMock.is = require(script.Parent.isAMagicMock)

local v = {}
function v.__tostring(p)
	local metatable = getmetatable(p)
	local v2 = { "id=" .. metatable[symbols.Address] }

	local v3 = metatable[symbols.Name]

	if v3 ~= nil and v3 ~= "mock" then
		table.insert(v2, "name=" .. v3)
	end

	return "<MagicMock " .. table.concat(v2, " ") .. ">"
end

function v.__index(p, p2)
	local metatable = getmetatable(p)

	if not isKeyInSpec(metatable, p2) then -- inferred equivalent call
		error(string.format("MagicMock Error: Cannot index key %q since it is out of spec.", (tostring(p2))))
	end

	local v2 = metatable[symbols.Children][p2]

	if v2 == nil then
		local v3 = MagicMock.new({
			name = metatable[symbols.Name] .. "." .. tostring(p2)
		})
		metatable[symbols.Children][p2] = v3
		return v3
	else
		return if v2 ~= symbols.None then v2 else nil
	end
end

function v.__newindex(p, p2, callback)
	local metatable = getmetatable(p)

	if not isKeyInSpec(metatable, p2) then -- inferred equivalent call
		error(string.format("MagicMock Error: Cannot write key %q since it is out of spec", (tostring(p2))))
	end

	if type(callback) == "function" then
		local _
		_, callback = Spy.new(callback)
	elseif callback == nil then
		callback = symbols.None
	end

	if p2 == symbols.ReturnValue then
		metatable[symbols.ReturnValue] = {
			callback,
			n = 1
		}
	else
		metatable[symbols.Children][p2] = callback
	end
end

local function isTuple(p) -- 2 equivalent calls inferred from this helper
	if type(p) == "table" and p[symbols.isTuple] then
		return not MagicMock.is(p)
	end
end

local function getReturnValue(metatable, ...)
	if metatable[symbols.ReturnValue] then
		return metatable[symbols.ReturnValue]
	end

	local v2 = metatable[symbols.SideEffect]

	if not v2 then
		return nil
	end

	v2.calls += 1

	if type(v2.value) == "function" or Spy.is(v2.value) then
		return { v2.value(...) }
	end

	if type(v2.value) == "table" then
		local calls = v2.calls

		local tuple = isTuple(v2.value) -- inferred equivalent call
		local v3

		if tuple then
			v3 = v2.value.values[calls]
		else
			v3 = v2.value[calls]
		end

		if v3 then
			return { v3 }
		end

		error("MagicMock Error: SideEffect iteration reached")
	else
		error("MagicMock Error: Invalid SideEffect")
	end

	return nil
end

function v.__call(p, ...)
	local metatable = getmetatable(p)
	local v2 = {
		args = table.pack(...),
		result = getReturnValue(metatable, ...)
	}

	if v2.result == nil then
		v2.result = {
			MagicMock.new({
				name = metatable[symbols.Name] .. "()"
			}),
			n = 1
		}
		metatable[symbols.ReturnValue] = v2.result
	elseif v2.result == symbols.None then
		v2.result = { n = 1 }
	elseif isTuple(v2.result[1]) then -- inferred equivalent call
		v2.result = v2.result[1].values
	end

	table.insert(metatable[symbols.Calls], v2)
	return table.unpack(v2.result)
end

local function operation(p) -- 8 equivalent calls inferred from this helper
	return function(value, p2)
		local metatable, v2

		if type(value) == "string" or not getmetatable(value) then
			metatable = getmetatable(p2)
			v2 = string.format("__r_%s()", p)
		else
			metatable = getmetatable(value)
			v2 = string.format("__%s()", p)
		end

		local v3 = metatable[symbols.Operations][v2]

		if v3 ~= nil then
			return v3
		end

		local v4 = MagicMock.new({
			name = metatable[symbols.Name] .. "." .. v2
		})
		metatable[symbols.Operations][v2] = v4
		return v4
	end
end

v.__add = operation("add") -- inferred equivalent call
v.__sub = operation("sub") -- inferred equivalent call
v.__div = operation("div") -- inferred equivalent call
v.__mul = operation("mul") -- inferred equivalent call
v.__mod = operation("mod") -- inferred equivalent call
v.__pow = operation("pow") -- inferred equivalent call
v.__unm = operation("neg") -- inferred equivalent call
v.__concat = operation("concat") -- inferred equivalent call

function MagicMock.new(options)
	local v2 = options or {}

	local function getName() -- 1 equivalent call inferred from this helper
		if v2.name then
			return v2.name
		end

		if v2.spec then
			return (tostring(v2.spec))
		end

		return "mock"
	end

	local v3 = {}
	local class = { [symbols.isMagicMock] = true, [symbols.Address] = tostring(v3) }
	local name = symbols.Name
	class[name] = getName() -- inferred equivalent call
	class[symbols.Operations] = {}
	class[symbols.Calls] = {}
	class[symbols.Children] = {}
	class[symbols.Spec] = v2.spec or nil
	class[symbols.ReturnValue] = nil
	class[symbols.SideEffect] = nil

	for k, v4 in pairs(v) do
		class[k] = v4
	end

	local self = setmetatable(v3, class)

	if v2.returnValue then
		setReturnValue(self, v2.returnValue)
	end

	if v2.sideEffect then
		setSideEffect(self, v2.sideEffect)
	end

	return self
end

function MagicMock.is(p): boolean
	local metatable = getmetatable(p)

	if metatable then
		return metatable[symbols.isMagicMock] ~= nil
	end

	return false
end

return MagicMock
