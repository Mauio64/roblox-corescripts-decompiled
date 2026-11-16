local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)
require(parent.Types.networkRequestsTypes)

return function(p)
	return p.roduxNetworking.GET(script.Name, function(callback, p2)
		return callback(API_URL):path("user-settings-api"):path("v1"):path("user-settings"):queryArgs(p2)
	end)
end
