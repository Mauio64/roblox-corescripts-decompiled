local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET("GetLuobuFriendsFromUserId", function(callback, p2, data)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(p2):path("luobu-friends"):queryArgs({
			userOpenId = data.userOpenId,
			userAccessToken = data.userAccessToken,
			type = data.type,
			appType = data.appType
		})
	end)
end
