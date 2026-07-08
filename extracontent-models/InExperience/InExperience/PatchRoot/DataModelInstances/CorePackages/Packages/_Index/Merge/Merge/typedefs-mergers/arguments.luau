local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local t1 = {}

require(ParentParent.GraphQL)
require(script.Parent["merge-typedefs_types"])

local Utils = require(ParentParent.Utils)
local compareNodes = Utils.compareNodes
local isSome = Utils.isSome
local deduplicateArguments = nil

function t1.mergeArguments(p1, p2, p3) -- line: 30
	-- upvalues: deduplicateArguments (ref), Array (copy), isSome (copy), compareNodes (copy)
	local v13 = deduplicateArguments(Array.filter(Array.concat({}, p2, p1), isSome))

	if p3 and p3.sort then
		Array.sort(v13, compareNodes)
	end

	return v13
end
function deduplicateArguments(p4) -- line: 52
	-- upvalues: Array (copy), Boolean (copy)
	return Array.reduce(p4, function(p5, p6) -- line: 56
		-- upvalues: Array (copy), Boolean (copy)
		local v17 = Array.find(p5, function(p7) -- line: 57
			-- upvalues: p6 (copy)
			return p7.name.value == p6.name.value
		end)

		if not Boolean.toJSBoolean(v17) then
			return Array.concat(p5, { p6 })
		end

		return p5
	end, {})
end

return t1
