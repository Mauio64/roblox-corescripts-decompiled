local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.POST({ Name = "RequestFriendshipFromUserId" }, function(callback, data)
		return callback(FRIENDS_URL, { currentUserId = data.currentUserId }):path("v1"):path("users"):id(data.targetUserId):path("request-friendship"):body({
			friendshipOriginSourceType = data.friendshipOriginSourceType,
			senderNickname = data.senderNickname
		})
	end)
end
