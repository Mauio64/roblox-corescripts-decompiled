local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)
require(parent.Types.networkRequestsTypes)

return function(p)
	return p.roduxNetworking.POST("GetContactEntitiesByContactId", function(callback, userContactIds)
		return callback(API_URL):path("contacts-api"):path("v1"):path("contacts"):path("entities"):body({
			userContactIds = userContactIds
		})
	end)
end
