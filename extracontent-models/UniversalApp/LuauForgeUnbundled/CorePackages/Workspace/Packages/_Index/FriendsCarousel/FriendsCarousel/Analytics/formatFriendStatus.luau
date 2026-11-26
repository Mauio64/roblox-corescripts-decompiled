local friendStatuses = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/dependencies").SocialLuaAnalytics.Analytics.Enums.FriendStatuses
require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Common/LocalTypes")

return function(data)
	if data.isFriendWithUser then
		return friendStatuses.Friends
	end

	if data.hasPendingFriendRequest then
		return friendStatuses.RequestSent
	end

	if data.hasIncomingFriendRequest then
		return friendStatuses.RequestReceived
	end

	return friendStatuses.NotFriends
end
