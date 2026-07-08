local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 19
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "RequestFriendshipFromUserId"
	}, function(p2, p3) -- line: 24
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL, {
			currentUserId = p3.currentUserId
		}):path("v1"):path("users"):id(p3.targetUserId):path("request-friendship"):body({
			friendshipOriginSourceType = p3.friendshipOriginSourceType,
			senderNickname = p3.senderNickname
		})
	end)
end
