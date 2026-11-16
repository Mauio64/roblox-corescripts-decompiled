local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.GET("GetExtendedFriendshipStatus", function(callback, p3)
		return callback(FRIENDS_URL):path("v1"):path("my"):path("friends"):id(p3.targetUserId):path("status")
	end)
end
