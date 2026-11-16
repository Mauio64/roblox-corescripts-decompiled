local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET("GetFriendRequestsCount", function(callback, _)
		return callback(FRIENDS_URL):path("v1"):path("user"):path("friend-requests"):path("count")
	end)
end
