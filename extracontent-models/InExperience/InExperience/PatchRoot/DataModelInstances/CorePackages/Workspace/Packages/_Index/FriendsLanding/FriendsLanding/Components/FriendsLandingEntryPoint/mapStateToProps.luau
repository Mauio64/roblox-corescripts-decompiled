local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

local friendsNetworking = dependencies.FriendsNetworking

return function(p)
	local deepValue = getDeepValue(p, string.format("FriendsLanding.Friends.byUserId.%s", p.LocalUserId))

	return {
		localUserId = p.LocalUserId,
		screenSize = p.ScreenSize,
		inactiveFriendsNetworkRequestStatus = friendsNetworking.GetInactiveFriends.getStatus(p, p.LocalUserId),
		friendRequestCount = getDeepValue(p, "FriendsLanding.Friends.requests.receivedCount") or 0,
		totalFriendCount = deepValue and #deepValue or 0
	}
end
