local parent = script.Parent.Parent
local ACCOUNT_SETTINGS_URL = require(parent.ACCOUNT_SETTINGS_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "BlockUserById" }, function(callback, p2)
		return callback(ACCOUNT_SETTINGS_URL, { currentUserId = p2.currentUserId }):path("v1"):path("users"):id(p2.userId):path("block"):body({})
	end)
end
