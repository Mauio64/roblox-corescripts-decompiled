local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 4
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "RemoveTC"
	}, function(p2, p3) -- line: 7
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL):path("v1"):path("users"):id(p3):path("remove-trusted-friend"):body({})
	end)
end
