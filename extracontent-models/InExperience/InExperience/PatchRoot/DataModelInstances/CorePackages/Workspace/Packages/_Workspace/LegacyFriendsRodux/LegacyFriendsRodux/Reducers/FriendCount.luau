local LegacyFriendsRodux = script:FindFirstAncestor("LegacyFriendsRodux")
local Actions = require(LegacyFriendsRodux.Actions)
local SetFriendCount = Actions.SetFriendCount

return function(value, p)
	return p.type ~= SetFriendCount.name and (value or 0) or p.count
end
