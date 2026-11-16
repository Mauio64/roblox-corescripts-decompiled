local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET("GetFriendRecommendationsFromUserId", function(callback, data)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(data.targetUserId):path("friends"):path("recommendations"):queryArgs({
			source = data.source,
			includeProfileFrame = data.includeProfileFrame
		})
	end)
end
