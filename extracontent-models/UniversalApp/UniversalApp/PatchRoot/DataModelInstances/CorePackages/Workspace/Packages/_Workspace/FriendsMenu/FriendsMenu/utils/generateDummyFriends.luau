local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent

require(FriendsMenu.friendsMenuModalType)

local Constants = require(FriendsMenu.Constants)
local GetFFlagFriendsMenuDummyLoadingFriendsFix = require(FriendsMenuParent.SharedFlags).GetFFlagFriendsMenuDummyLoadingFriendsFix

local function v5(n1: number) -- line: 9
	-- upvalues: GetFFlagFriendsMenuDummyLoadingFriendsFix (copy), Constants (copy)
	return {
		displayName = "",
		hasVerifiedBadge = false,
		isFetching = true,
		isFriend = true,
		lastLocation = "",
		name = "",
		presence = "",
		isLoadingPlaceholder = true,
		friendFrequentRank = n1,
		friendRank = n1,
		id = GetFFlagFriendsMenuDummyLoadingFriendsFix() and Constants.DummyFriendsPrefix .. tostring(n1) or tostring(n1),
		lastOnline = DateTime.now()
	}
end

return function(n2: number) -- line: 28
	-- upvalues: v5 (copy)
	local t1 = {}

	for i = 1, n2 do
		t1[i] = v5(i)
	end

	return t1
end
