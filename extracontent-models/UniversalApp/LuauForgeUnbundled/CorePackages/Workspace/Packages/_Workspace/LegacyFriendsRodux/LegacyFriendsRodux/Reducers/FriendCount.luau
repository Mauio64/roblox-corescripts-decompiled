local setFriendCount = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/LegacyFriendsRodux/Actions").SetFriendCount

return function(value, p2)
	return p2.type ~= setFriendCount.name and (value or 0) or p2.count
end
