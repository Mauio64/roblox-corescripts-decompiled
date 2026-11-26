local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/getDeepValue")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")
local filterByKeys = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Selectors/filterByKeys")

return function(p2)
	local keyPath = p2.keyPath
	return function(p3)
		return function(value, p4)
			local v5 = getDeepValue(p3, string.format("%s.recommendations.byUserId.%s", keyPath, value or ""))
				or {}

			if p4 then
				return (filterByKeys(p4, v5))
			end

			return v5
		end
	end
end
