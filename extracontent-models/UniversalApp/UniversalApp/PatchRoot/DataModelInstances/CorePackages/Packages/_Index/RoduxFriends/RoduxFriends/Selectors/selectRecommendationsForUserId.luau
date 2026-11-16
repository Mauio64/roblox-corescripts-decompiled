local parent = script.Parent.Parent

local getDeepValue = require(parent.getDeepValue)
require(parent.roduxFriendsTypes)
local filterByKeys = require(script.Parent.filterByKeys)

return function(p)
	local keyPath = p.keyPath
	return function(p2)
		return function(value: string, p3)
			local selected = getDeepValue(p2, string.format("%s.recommendations.byUserId.%s", keyPath, value or ""))
				or {}

			if p3 then
				return (filterByKeys(p3, selected))
			end

			return selected
		end
	end
end
