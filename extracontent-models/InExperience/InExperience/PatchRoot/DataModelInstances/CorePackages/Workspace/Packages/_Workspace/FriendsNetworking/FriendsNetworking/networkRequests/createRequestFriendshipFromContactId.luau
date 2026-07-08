local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 11
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "RequestFriendshipFromContactId"
	}, function(p2, t1: {[any]: any}) -- line: 16
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL, {
			currentUserId = t1.currentUserId
		}):path("v1"):path("contacts"):id(t1.contactId):path("request-friendship"):body({})
	end)
end
