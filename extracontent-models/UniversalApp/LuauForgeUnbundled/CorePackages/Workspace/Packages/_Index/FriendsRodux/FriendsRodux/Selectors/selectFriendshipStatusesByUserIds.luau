local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/getDeepValue")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")
local filterByKeys = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Selectors/filterByKeys")

return function(p2)
	local keyPath = p2.keyPath
	return function(p3)
		return function(p4)
			local v5 = getDeepValue(p3, string.format("%s.friendshipStatus", keyPath)) or {}

			if p4 then
				return filterByKeys(p4, v5)
			end

			return v5
		end
	end
end
