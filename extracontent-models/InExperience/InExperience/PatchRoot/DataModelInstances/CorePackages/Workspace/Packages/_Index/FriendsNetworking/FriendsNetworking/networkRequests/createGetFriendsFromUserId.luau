local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 8
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetFriendsFromUserId"
	}, function(p2, p3, t1: {[any]: any}?) -- line: 13
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("users"):id(p3):path("friends"):queryArgs({
			userSort = t1 and t1.userSort or nil
		})
	end)
end
