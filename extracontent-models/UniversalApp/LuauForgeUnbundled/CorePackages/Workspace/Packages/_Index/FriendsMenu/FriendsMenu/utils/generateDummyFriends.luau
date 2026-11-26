require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Constants")
local getFFlagFriendsMenuDummyLoadingFriendsFix = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags").GetFFlagFriendsMenuDummyLoadingFriendsFix

local function fn(i)
	return {
		displayName = "",
		friendFrequentRank = i,
		friendRank = i,
		hasVerifiedBadge = false,
		id = getFFlagFriendsMenuDummyLoadingFriendsFix() and Constants.DummyFriendsPrefix .. tostring(i) or tostring(i),
		isFetching = true,
		isFriend = true,
		lastLocation = "",
		lastOnline = DateTime.now(),
		name = "",
		presence = "",
		isLoadingPlaceholder = true
	}
end

return function(p2)
	local result = {}

	for i = 1, p2 do
		result[i] = fn(i)
	end

	return result
end
