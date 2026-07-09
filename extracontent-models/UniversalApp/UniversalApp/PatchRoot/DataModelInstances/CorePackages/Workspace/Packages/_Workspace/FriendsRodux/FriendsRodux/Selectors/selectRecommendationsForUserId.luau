local ParentParent = script.Parent.Parent
local getDeepValue = require(ParentParent.getDeepValue)

require(ParentParent.roduxFriendsTypes)

local filterByKeys = require(script.Parent.filterByKeys)

return function(p1) -- line: 10
	-- upvalues: getDeepValue (copy), filterByKeys (copy)
	local keyPath = p1.keyPath

	return function(p2) -- line: 12
		-- upvalues: getDeepValue (copy), keyPath (copy), filterByKeys (copy)
		return function(s1: string, t1: {[any]: any}?) -- line: 13
			-- upvalues: getDeepValue (copy), p2 (copy), keyPath (copy), filterByKeys (copy)
			local v9 = getDeepValue(p2, string.format("%s.recommendations.byUserId.%s", keyPath, s1 or "")) or {}

			if t1 then
				return (filterByKeys(t1, v9))
			end

			return v9
		end
	end
end
