local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local Arguments = {}

require(parent.GraphQL)

require(script.Parent["merge-typedefs_types"])

local Utils = require(parent.Utils)

local compareNodes = Utils.compareNodes
local isSome = Utils.isSome

local deduplicateArguments

function Arguments.mergeArguments(p, p2, p3)
	local v = deduplicateArguments(Array.filter(Array.concat({}, p2, p), isSome))

	if p3 and p3.sort then
		Array.sort(v, compareNodes)
	end

	return v
end

deduplicateArguments = function(filtered)
	return Array.reduce(filtered, function(p, p2)
		local v = Array.find(p, function(p3): boolean
			return p3.name.value == p2.name.value
		end)

		if Boolean.toJSBoolean(v) then
			return p
		end

		return Array.concat(p, { p2 })
	end, {})
end

return Arguments
