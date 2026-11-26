local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.GET("GetFollowersCount", function(callback, p3)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(p3):path("followers"):path("count")
	end)
end
