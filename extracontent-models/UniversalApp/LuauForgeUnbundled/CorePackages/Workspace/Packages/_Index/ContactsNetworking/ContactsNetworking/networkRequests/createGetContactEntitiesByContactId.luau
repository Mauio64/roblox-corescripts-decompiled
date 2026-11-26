local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/API_URL")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/Types/networkRequestsTypes")

return function(p2)
	return p2.roduxNetworking.POST("GetContactEntitiesByContactId", function(callback, p3)
		return callback(API_URL):path("contacts-api"):path("v1"):path("contacts"):path("entities"):body({
			userContactIds = p3
		})
	end)
end
