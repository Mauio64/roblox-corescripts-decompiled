local parent = script.Parent.Parent
local ACCOUNT_SETTINGS_URL = require(parent.ACCOUNT_SETTINGS_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "UnblockUserById" }, function(callback, p2)
		return callback(ACCOUNT_SETTINGS_URL, { params = p2.currentUserId }):path("v1"):path("users"):id(p2.userId):path("unblock"):body({})
	end)
end
