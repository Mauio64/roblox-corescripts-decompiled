local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local MergeNamedTypeArray = {}

require(parent.GraphQL)

require(script.Parent["merge-typedefs_types"])

local Utils = require(parent.Utils)
local compareNodes = Utils.compareNodes

local function alreadyExists(p, p2) -- 1 equivalent call inferred from this helper
	return Boolean.toJSBoolean(Array.find(p, function(p3): boolean
		return p3.name.value == p2.name.value
	end)) and true or false
end

function MergeNamedTypeArray.mergeNamedTypeArray(p, p2, p3)
	local v = p == nil and {} or p
	local v2 = p2 == nil and {} or p2
	local v3 = p3 == nil and {} or p3
	local joined = Array.concat({}, v2, Array.filter(v, function(p4): boolean
		return not Boolean.toJSBoolean(alreadyExists(v2, p4)) -- inferred equivalent call
	end))

	if v3 and Boolean.toJSBoolean(v3.sort) then
		Array.sort(joined, compareNodes)
	end

	return joined
end
return MergeNamedTypeArray
