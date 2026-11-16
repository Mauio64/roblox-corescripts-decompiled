local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.POST("GetFollowingExists", function(callback, p2)
		return callback(FRIENDS_URL):path("v1"):path("user"):path("following-exists"):body({
			targetUserIds = p2.targetUserIds
		})
	end)
end
