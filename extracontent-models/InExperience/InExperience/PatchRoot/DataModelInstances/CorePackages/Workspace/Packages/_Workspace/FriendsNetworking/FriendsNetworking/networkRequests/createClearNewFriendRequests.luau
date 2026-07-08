local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 9
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.DELETE({
		Name = "ClearNewFriendRequests"
	}, function(p2, p3) -- line: 14
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL, {
			currentUserId = p3.currentUserId
		}):path("v1"):path("my"):path("new-friend-requests")
	end)
end
