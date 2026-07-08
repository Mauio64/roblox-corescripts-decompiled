local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 5
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "AcceptFriendRequestWithToken"
	}, function(p2, p3) -- line: 8
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL, {
			currentUserId = p3.currentUserId
		}):path("v1"):path("users"):id(p3.targetUserId):path("accept-friend-request-with-token"):body({
			friendingToken = p3.friendingToken
		})
	end)
end
