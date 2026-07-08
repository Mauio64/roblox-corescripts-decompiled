local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 5
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetFriendRequests"
	}, function(p2, p3) -- line: 8
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL, {
			currentUserId = p3.currentUserId
		}):path("v1"):path("my"):path("friends"):path("requests"):queryArgs({
			fetchMutualFriends = p3.fetchMutualFriends,
			sortOrder = p3.sortOrder,
			limit = p3.limit,
			cursor = p3.cursor
		})
	end)
end
