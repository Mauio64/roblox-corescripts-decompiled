local AVATAR_URL = require(script.Parent.Parent.AVATAR_URL)

return function(p1) -- line: 8
	-- upvalues: AVATAR_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetCurrentlyWearing"
	}, function(p2, p3) -- line: 11
		-- upvalues: AVATAR_URL (copy)
		return p2(AVATAR_URL):path("v1"):path("users"):id(p3):path("currently-wearing")
	end)
end
