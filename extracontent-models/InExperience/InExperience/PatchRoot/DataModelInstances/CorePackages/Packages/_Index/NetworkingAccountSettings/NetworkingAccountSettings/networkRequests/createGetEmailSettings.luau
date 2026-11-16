local parent = script.Parent.Parent
require(parent.Types.networkRequestsTypes)

local ACCOUNT_SETTINGS_URL = require(parent.ACCOUNT_SETTINGS_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetEmailSettings" }, function(callback)
		return callback(ACCOUNT_SETTINGS_URL):path("v1"):path("email")
	end)
end
