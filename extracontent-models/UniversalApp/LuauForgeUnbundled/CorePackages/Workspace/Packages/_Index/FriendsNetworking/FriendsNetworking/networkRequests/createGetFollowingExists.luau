local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.POST("GetFollowingExists", function(callback, p3)
		return callback(FRIENDS_URL):path("v1"):path("user"):path("following-exists"):body({
			targetUserIds = p3.targetUserIds
		})
	end)
end
