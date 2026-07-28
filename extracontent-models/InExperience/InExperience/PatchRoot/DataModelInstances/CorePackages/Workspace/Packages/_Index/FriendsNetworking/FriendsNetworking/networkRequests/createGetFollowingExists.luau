local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 4
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "GetFollowingExists"
	}, function(p2, p3) -- line: 9
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("user"):path("following-exists"):body({
			targetUserIds = p3.targetUserIds
		})
	end)
end
