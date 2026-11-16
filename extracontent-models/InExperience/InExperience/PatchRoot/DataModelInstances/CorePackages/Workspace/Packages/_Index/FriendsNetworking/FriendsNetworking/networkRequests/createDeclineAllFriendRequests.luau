local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.POST("DeclineAllFriendRequests", function(callback, p2)
		return callback(FRIENDS_URL, { currentUserId = p2.currentUserId }):path("v1"):path("user"):path("friend-requests"):path("decline-all"):body({})
	end)
end
