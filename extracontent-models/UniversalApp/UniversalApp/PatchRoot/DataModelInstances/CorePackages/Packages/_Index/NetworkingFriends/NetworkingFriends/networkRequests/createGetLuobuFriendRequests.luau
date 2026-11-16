local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetLuobuFriendRequests" }, function(callback, data)
		return callback(FRIENDS_URL):path("v1"):path("my"):path("luobu-friends"):path("requests"):queryArgs({
			userOpenId = data.userOpenId,
			userAccessToken = data.userAccessToken,
			type = data.type,
			appType = data.appType,
			sortOrder = data.sortOrder,
			limit = data.limit,
			cursor = data.cursor
		})
	end)
end
