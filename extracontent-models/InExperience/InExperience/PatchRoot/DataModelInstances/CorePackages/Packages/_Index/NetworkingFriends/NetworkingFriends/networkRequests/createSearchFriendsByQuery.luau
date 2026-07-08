local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 12
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "SearchFriendsByQuery"
	}, function(p2, p3, t1: {[any]: any}?) -- line: 15
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("users"):id(p3):path("friends"):path("search"):queryArgs({
			query = if not t1 then nil else t1.query,
			userSort = if not t1 then nil else t1.userSort,
			cursor = if not t1 then nil else t1.cursor,
			limit = if not t1 then nil else t1.limit
		})
	end)
end
