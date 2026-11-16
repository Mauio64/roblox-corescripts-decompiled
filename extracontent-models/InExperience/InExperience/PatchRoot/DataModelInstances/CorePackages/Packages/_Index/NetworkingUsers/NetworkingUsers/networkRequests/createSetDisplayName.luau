local USERS_URL = require(script.Parent.Parent.USERS_URL)

return function(p)
	return p.roduxNetworking.PATCH({ Name = "SetDisplayName" }, function(callback, p2, newDisplayName)
		return callback(USERS_URL):path("v1"):path("users"):id(p2):path("display-names"):body({
			newDisplayName = newDisplayName
		})
	end)
end
