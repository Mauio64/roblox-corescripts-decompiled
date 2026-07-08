local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 10
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetLuobuFriendRequests"
	}, function(p2, p3) -- line: 13
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("my"):path("luobu-friends"):path("requests"):queryArgs({
			userOpenId = p3.userOpenId,
			userAccessToken = p3.userAccessToken,
			type = p3.type,
			appType = p3.appType,
			sortOrder = p3.sortOrder,
			limit = p3.limit,
			cursor = p3.cursor
		})
	end)
end
