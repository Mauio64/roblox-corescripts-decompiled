local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.GET("GetFriendsFromUserId", function(callback, p3, p4)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(p3):path("friends"):queryArgs({
			userSort = p4 and p4.userSort or nil
		})
	end)
end
