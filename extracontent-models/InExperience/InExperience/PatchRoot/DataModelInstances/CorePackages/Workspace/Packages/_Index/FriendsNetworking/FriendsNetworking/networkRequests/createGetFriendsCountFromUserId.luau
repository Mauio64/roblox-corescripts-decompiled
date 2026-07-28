local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 8
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetFriendsCountFromUserId"
	}, function(p2, p3) -- line: 13
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("users"):id(p3):path("friends"):path("count")
	end)
end
