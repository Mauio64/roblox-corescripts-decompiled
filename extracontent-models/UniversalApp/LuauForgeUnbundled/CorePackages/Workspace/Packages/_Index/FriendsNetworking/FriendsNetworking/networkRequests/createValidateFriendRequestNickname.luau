local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.POST("ValidateFriendRequestNickname", function(callback, p3)
		return callback(FRIENDS_URL, { currentUserId = p3.currentUserId }):path("v1"):path("my"):path("friends"):path("validate-nickname"):body({
			senderNickname = p3.senderNickname
		})
	end)
end
