local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET("GetFriendsFromUserId", function(callback, p2, p3)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(p2):path("friends"):queryArgs({
			userSort = p3 and p3.userSort or nil
		})
	end)
end
