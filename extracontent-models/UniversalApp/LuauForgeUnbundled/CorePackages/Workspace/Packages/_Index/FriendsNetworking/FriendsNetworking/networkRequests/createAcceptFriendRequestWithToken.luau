local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.POST("AcceptFriendRequestWithToken", function(callback, data)
		return callback(FRIENDS_URL, { currentUserId = data.currentUserId }):path("v1"):path("users"):id(data.targetUserId):path("accept-friend-request-with-token"):body({
			friendingToken = data.friendingToken
		})
	end)
end
