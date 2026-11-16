local parent = script.Parent.Parent

local getDeepValue = require(parent.getDeepValue)
require(parent.roduxFriendsTypes)
local filterByKeys = require(script.Parent.filterByKeys)

return function(p)
	local keyPath = p.keyPath
	return function(p2)
		return function(p3)
			local selected = getDeepValue(p2, string.format("%s.friendshipStatus", keyPath)) or {}

			if p3 then
				return filterByKeys(p3, selected)
			end

			return selected
		end
	end
end
