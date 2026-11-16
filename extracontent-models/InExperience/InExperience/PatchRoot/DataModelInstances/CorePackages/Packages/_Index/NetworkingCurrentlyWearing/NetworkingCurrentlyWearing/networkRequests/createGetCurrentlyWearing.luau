local AVATAR_URL = require(script.Parent.Parent.AVATAR_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetCurrentlyWearing" }, function(callback, p2)
		return callback(AVATAR_URL):path("v1"):path("users"):id(p2):path("currently-wearing")
	end)
end
