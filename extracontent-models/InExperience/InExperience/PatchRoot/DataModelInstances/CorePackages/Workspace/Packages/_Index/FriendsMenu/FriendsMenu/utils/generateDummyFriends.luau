local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent

require(FriendsMenu.friendsMenuModalType)
local Constants = require(FriendsMenu.Constants)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagFriendsMenuDummyLoadingFriendsFix = SharedFlags.GetFFlagFriendsMenuDummyLoadingFriendsFix

local function fn(i: number)
	return {
		displayName = "",
		friendFrequentRank = i,
		friendRank = i,
		hasVerifiedBadge = false,
		id = GetFFlagFriendsMenuDummyLoadingFriendsFix() and Constants.DummyFriendsPrefix .. tostring(i) or tostring(i),
		isFetching = true,
		isFriend = true,
		lastLocation = "",
		lastOnline = DateTime.now(),
		name = "",
		presence = "",
		isLoadingPlaceholder = true
	}
end

return function(p: number)
	local result = {}

	for i = 1, p do
		result[i] = fn(i)
	end

	return result
end
