local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 4
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetLuobuFriendsFromUserId"
	}, function(p2, p3, p4) -- line: 9
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("users"):id(p3):path("luobu-friends"):queryArgs({
			userOpenId = p4.userOpenId,
			userAccessToken = p4.userAccessToken,
			type = p4.type,
			appType = p4.appType
		})
	end)
end
