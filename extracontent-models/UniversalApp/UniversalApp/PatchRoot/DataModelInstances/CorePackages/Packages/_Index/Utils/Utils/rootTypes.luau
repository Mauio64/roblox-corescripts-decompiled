local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set

local RootTypes = {}
require(parent.GraphQL)

local memoize = require(script.Parent.memoize)
local memoize1 = memoize.memoize1

local getRootTypeMap = nil
local getRootTypes = nil

function RootTypes.getDefinedRootType(p, p2)
	local definedRootType = getRootTypeMap(p):get(p2)

	if definedRootType == nil then
		error(Error.new(("Root type for operation \"%s\" not defined by the given schema."):format((tostring(p2)))))
	end

	return definedRootType
end

local function setToArray(object) -- 1 equivalent call inferred from this helper
	local v = {}
	object:forEach(function(p)
		table.insert(v, p)
	end)
	return v
end

RootTypes.getRootTypeNames = memoize1(function(p)
	local v = getRootTypes(p)

	local new = Set.new
	local map = Array.map
	local concat = Array.concat
	local v2 = setToArray(v) -- inferred equivalent call
	return new(map(concat({}, v2), function(p2)
		return p2.name
	end))
end)

getRootTypes = memoize1(function(p)
	local v = getRootTypeMap(p)
	return Set.new(v:values())
end)

RootTypes.getRootTypes = getRootTypes

getRootTypeMap = memoize1(function(object)
	local v = Map.new()
	local queryType = object:getQueryType()

	if Boolean.toJSBoolean(queryType) then
		v:set("query", queryType)
	end

	local mutationType = object:getMutationType()

	if Boolean.toJSBoolean(mutationType) then
		v:set("mutation", mutationType)
	end

	local subscriptionType = object:getSubscriptionType()

	if Boolean.toJSBoolean(subscriptionType) then
		v:set("subscription", subscriptionType)
	end

	return v
end)

RootTypes.getRootTypeMap = getRootTypeMap
return RootTypes
