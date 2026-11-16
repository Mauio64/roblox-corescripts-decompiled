local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.POST("RemoveTC", function(callback, p2)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(p2):path("remove-trusted-friend"):body({})
	end)
end
