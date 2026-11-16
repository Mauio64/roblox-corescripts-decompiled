local USERS_URL = require(script.Parent.Parent.USERS_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "SetDescription" }, function(callback, localUserId, description)
		return callback(USERS_URL, { LocalUserId = localUserId }):path("v1"):path("description"):body({
			description = description
		})
	end)
end
