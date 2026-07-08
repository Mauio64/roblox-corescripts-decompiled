local USERS_URL = require(script.Parent.Parent.USERS_URL)

return function(p1) -- line: 3
	-- upvalues: USERS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "SetDescription"
	}, function(p2, p3, p4) -- line: 6
		-- upvalues: USERS_URL (copy)
		return p2(USERS_URL, {
			LocalUserId = p3
		}):path("v1"):path("description"):body({
			description = p4
		})
	end)
end
