local USERS_URL = require(script.Parent.Parent.USERS_URL)

return function(p1) -- line: 3
	-- upvalues: USERS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetUsernameHistoryFromUserId"
	}, function(p2, p3) -- line: 6
		-- upvalues: USERS_URL (copy)
		return p2(USERS_URL):path("v1"):path("users"):id(p3):path("username-history")
	end)
end
