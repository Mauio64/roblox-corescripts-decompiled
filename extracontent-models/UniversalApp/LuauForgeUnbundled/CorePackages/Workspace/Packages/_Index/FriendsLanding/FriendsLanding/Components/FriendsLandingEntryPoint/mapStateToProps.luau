local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

local friendsNetworking = dependencies.FriendsNetworking

return function(p2)
	local deepValue = getDeepValue(p2, string.format("FriendsLanding.Friends.byUserId.%s", p2.LocalUserId))

	return {
		localUserId = p2.LocalUserId,
		screenSize = p2.ScreenSize,
		inactiveFriendsNetworkRequestStatus = friendsNetworking.GetInactiveFriends.getStatus(
			p2,
			p2.LocalUserId
		),
		friendRequestCount = getDeepValue(p2, "FriendsLanding.Friends.requests.receivedCount") or 0,
		totalFriendCount = deepValue and #deepValue or 0
	}
end
