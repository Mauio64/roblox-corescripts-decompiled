local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local FriendsNetworking = dependencies.FriendsNetworking

return function(p1) -- line: 8
	-- upvalues: getDeepValue (copy), FriendsNetworking (copy)
	local v6 = getDeepValue(p1, string.format("FriendsLanding.Friends.byUserId.%s", p1.LocalUserId))

	return {
		localUserId = p1.LocalUserId,
		screenSize = p1.ScreenSize,
		inactiveFriendsNetworkRequestStatus = FriendsNetworking.GetInactiveFriends.getStatus(p1, p1.LocalUserId),
		friendRequestCount = getDeepValue(p1, "FriendsLanding.Friends.requests.receivedCount") or 0,
		totalFriendCount = v6 and #v6 or 0
	}
end
