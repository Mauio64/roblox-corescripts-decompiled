local USERS_URL = require(script.Parent.Parent.USERS_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetUserV2FromUserId" }, function(callback, p2)
		return callback(USERS_URL):path("v1"):path("users"):id(p2)
	end)
end
