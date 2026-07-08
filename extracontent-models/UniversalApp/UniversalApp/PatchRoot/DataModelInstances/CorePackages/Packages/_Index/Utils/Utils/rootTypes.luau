local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local t1 = {}

require(ParentParent.GraphQL)

local memoize1 = require(script.Parent.memoize).memoize1
local u10 = nil
local u11 = nil

function t1.getDefinedRootType(p1, p2) -- line: 32
	-- upvalues: u10 (ref), Error (copy)
	local v15 = u10(p1):get(p2)

	if v15 == nil then
		error(Error.new(("Root type for operation \"%s\" not defined by the given schema."):format((tostring(p2)))))
	end

	return v15
end

local function setToArray(p3) -- line: 47
	local t2 = {}

	p3:forEach(function(p4) -- line: 49
		-- upvalues: t2 (copy)
		table.insert(t2, p4)
	end)

	return t2
end

t1.getRootTypeNames = memoize1(function(p5) -- line: 55
	-- upvalues: u11 (ref), Set (copy), Array (copy)
	local v19 = u11(p5)
	local new = Set.new
	local map = Array.map
	local concat = Array.concat
	local t3 = {}

	v19:forEach(function(p6) -- line: 49
		-- upvalues: t3 (copy)
		table.insert(t3, p6)
	end)

	return new(map(concat({}, t3), function(p7) -- line: 59
		return p7.name
	end))
end)
u11 = memoize1(function(p8) -- line: 67
	-- upvalues: u10 (ref), Set (copy)
	local v25 = u10(p8)

	return Set.new(v25:values())
end)
t1.getRootTypes = u11
u10 = memoize1(function(p9) -- line: 75
	-- upvalues: Map (copy), Boolean (copy)
	local v27 = Map.new()
	local v28 = p9:getQueryType()

	if Boolean.toJSBoolean(v28) then
		v27:set("query", v28)
	end

	local v29 = p9:getMutationType()

	if Boolean.toJSBoolean(v29) then
		v27:set("mutation", v29)
	end

	local v30 = p9:getSubscriptionType()

	if Boolean.toJSBoolean(v30) then
		v27:set("subscription", v30)
	end

	return v27
end)
t1.getRootTypeMap = u10

return t1
