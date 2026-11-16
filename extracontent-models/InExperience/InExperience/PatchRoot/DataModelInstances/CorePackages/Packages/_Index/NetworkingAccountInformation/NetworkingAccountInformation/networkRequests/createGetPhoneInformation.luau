local parent = script.Parent.Parent
require(parent.Types.networkRequestsTypes)

local ACCOUNT_INFORMATION_URL = require(parent.ACCOUNT_INFORMATION_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetPhoneInformation" }, function(callback)
		return callback(ACCOUNT_INFORMATION_URL):path("v1"):path("phone")
	end)
end
