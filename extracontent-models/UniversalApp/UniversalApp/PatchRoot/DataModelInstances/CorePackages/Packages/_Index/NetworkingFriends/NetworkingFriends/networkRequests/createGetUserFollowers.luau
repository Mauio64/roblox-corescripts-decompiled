local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetUserFollowers" }, function(callback, p2)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(p2.targetUserId):path("followers")
	end)
end
