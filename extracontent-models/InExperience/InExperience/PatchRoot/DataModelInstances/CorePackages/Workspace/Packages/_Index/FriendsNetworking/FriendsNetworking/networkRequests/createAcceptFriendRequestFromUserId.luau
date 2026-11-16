local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.POST("AcceptFriendRequestFromUserId", function(callback, p2)
		return callback(FRIENDS_URL, { currentUserId = p2.currentUserId }):path("v1"):path("users"):id(p2.targetUserId):path("accept-friend-request"):body({})
	end)
end
