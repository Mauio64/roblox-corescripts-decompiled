local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local getDeepValue = require(ParentParent.getDeepValue)

require(ParentParent.roduxFriendsTypes)

local Object = require(ParentParentParent.LuauPolyfill).Object

return function(p1) -- line: 9
	-- upvalues: getDeepValue (copy), Object (copy)
	local keyPath = p1.keyPath

	return function(p2) -- line: 11
		-- upvalues: getDeepValue (copy), keyPath (copy), Object (copy)
		return function(s1: string) -- line: 12
			-- upvalues: getDeepValue (copy), p2 (copy), keyPath (copy), Object (copy)
			local v9 = getDeepValue(p2, string.format("%s.recommendations.bySource.%s", keyPath, s1 or "")) or {}

			return Object.keys(v9)
		end
	end
end
