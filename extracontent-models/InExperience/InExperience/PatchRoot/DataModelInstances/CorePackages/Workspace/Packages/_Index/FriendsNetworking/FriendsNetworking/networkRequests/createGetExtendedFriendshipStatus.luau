local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 6
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetExtendedFriendshipStatus"
	}, function(p2, t1: {[any]: any}) -- line: 11
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("my"):path("friends"):id(t1.targetUserId):path("status")
	end)
end
