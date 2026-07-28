local ParentParent = script.Parent.Parent
local getDeepValue = require(ParentParent.getDeepValue)

require(ParentParent.roduxFriendsTypes)

local filterByKeys = require(script.Parent.filterByKeys)

return function(p1) -- line: 9
	-- upvalues: getDeepValue (copy), filterByKeys (copy)
	local keyPath = p1.keyPath

	return function(p2) -- line: 11
		-- upvalues: getDeepValue (copy), keyPath (copy), filterByKeys (copy)
		return function(t1: {[any]: any}?) -- line: 12
			-- upvalues: getDeepValue (copy), p2 (copy), keyPath (copy), filterByKeys (copy)
			local v8 = getDeepValue(p2, string.format("%s.friendshipStatus", keyPath)) or {}

			if not t1 then
				return v8
			end

			return filterByKeys(t1, v8)
		end
	end
end
