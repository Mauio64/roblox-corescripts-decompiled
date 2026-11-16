local USERS_URL = require(script.Parent.Parent.USERS_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetDisplayNameValidation" }, function(callback, p2, displayName)
		return callback(USERS_URL):path("v1"):path("users"):id(p2):path("display-names"):path("validate"):queryArgs({
			displayName = displayName
		})
	end)
end
