local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.POST("RequestFriendshipFromUserId", function(callback, data)
		return callback(FRIENDS_URL, { currentUserId = data.currentUserId }):path("v1"):path("users"):id(data.targetUserId):path("request-friendship"):body({
			friendshipOriginSourceType = data.friendshipOriginSourceType,
			senderNickname = data.senderNickname
		})
	end)
end
