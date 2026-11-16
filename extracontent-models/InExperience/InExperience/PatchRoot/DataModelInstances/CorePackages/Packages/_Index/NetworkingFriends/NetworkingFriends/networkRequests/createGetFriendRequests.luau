local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetFriendRequests" }, function(callback, data)
		return callback(FRIENDS_URL, { currentUserId = data.currentUserId }):path("v1"):path("my"):path("friends"):path("requests"):queryArgs({
			fetchMutualFriends = data.fetchMutualFriends,
			sortOrder = data.sortOrder,
			limit = data.limit,
			cursor = data.cursor
		})
	end)
end
