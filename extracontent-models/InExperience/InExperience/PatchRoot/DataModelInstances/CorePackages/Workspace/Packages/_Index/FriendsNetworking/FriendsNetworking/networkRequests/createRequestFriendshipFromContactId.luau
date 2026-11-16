local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.POST("RequestFriendshipFromContactId", function(callback, p2)
		return callback(FRIENDS_URL, { currentUserId = p2.currentUserId }):path("v1"):path("contacts"):id(p2.contactId):path("request-friendship"):body({})
	end)
end
