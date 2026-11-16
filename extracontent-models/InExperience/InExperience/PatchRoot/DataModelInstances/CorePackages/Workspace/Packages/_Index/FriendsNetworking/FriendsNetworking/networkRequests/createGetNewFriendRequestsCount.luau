local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET("GetNewFriendRequestsCount", function(callback, p2)
		return callback(FRIENDS_URL, { currentUserId = p2.currentUserId }):path("v1"):path("my"):path("new-friend-requests"):path("count")
	end)
end
