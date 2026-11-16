local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.GET("GetFriendRecommendationsFromUserId", function(callback, data)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(data.targetUserId):path("friends"):path("recommendations"):queryArgs({
			source = data.source,
			includeProfileFrame = data.includeProfileFrame
		})
	end)
end
