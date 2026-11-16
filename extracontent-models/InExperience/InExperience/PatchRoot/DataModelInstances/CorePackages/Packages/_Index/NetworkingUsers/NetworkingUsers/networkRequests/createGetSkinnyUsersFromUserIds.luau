local USERS_URL = require(script.Parent.Parent.USERS_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "GetSkinnyUsersFromUserIds" }, function(callback, userIds)
		return callback(USERS_URL):path("v1"):path("users"):body({ userIds = userIds })
	end)
end
