local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetExtendedFriendshipStatus" }, function(callback, p2)
		return callback(FRIENDS_URL):path("v1"):path("my"):path("friends"):id(p2.targetUserId):path("status")
	end)
end
