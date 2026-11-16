local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.POST("RemoveTC", function(callback, p3)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(p3):path("remove-trusted-friend"):body({})
	end)
end
