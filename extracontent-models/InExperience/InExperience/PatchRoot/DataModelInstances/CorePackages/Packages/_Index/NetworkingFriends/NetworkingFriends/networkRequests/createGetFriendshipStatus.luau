local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 6
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetFriendshipStatus"
	}, function(p2, p3) -- line: 11
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("users"):id(p3.currentUserId):path("friends"):path("statuses"):expandedQueryArgsWithIds("userIds", { p3.targetUserId })
	end)
end
