local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.POST("AcceptFriendRequestWithToken", function(callback, data)
		return callback(FRIENDS_URL, { currentUserId = data.currentUserId }):path("v1"):path("users"):id(data.targetUserId):path("accept-friend-request-with-token"):body({
			friendingToken = data.friendingToken
		})
	end)
end
