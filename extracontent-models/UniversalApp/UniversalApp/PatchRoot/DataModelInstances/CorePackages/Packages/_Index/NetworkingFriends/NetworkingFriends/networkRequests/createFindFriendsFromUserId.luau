local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 11
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "FindFriendsFromUserId"
	}, function(p2, p3, t1: {[any]: any}?) -- line: 14
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("users"):id(p3):path("friends"):path("find"):queryArgs({
			userSort = if not t1 then nil else t1.userSort,
			cursor = if not t1 then nil else t1.cursor,
			limit = if not t1 then nil else t1.limit
		})
	end)
end
