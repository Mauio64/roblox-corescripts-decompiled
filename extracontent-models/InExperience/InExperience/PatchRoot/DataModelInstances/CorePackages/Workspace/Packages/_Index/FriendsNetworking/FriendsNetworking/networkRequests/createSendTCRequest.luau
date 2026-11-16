local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.POST("SendTCRequest", function(callback, p2)
		return callback(FRIENDS_URL):path("v1"):path("users"):id(p2):path("send-trusted-friend-request"):body({})
	end)
end
