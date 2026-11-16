local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET("GetFollowingsCount", function(callback, p2)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(p2):path("followings"):path("count")
	end)
end
