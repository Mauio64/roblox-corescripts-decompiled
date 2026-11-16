local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/API_URL")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/Types/networkRequestsTypes")

return function(p2)
	return p2.roduxNetworking.POST("UploadContactsByUser", function(callback, data)
		return callback(API_URL):path("contacts-api"):path("v1"):path("contacts"):body({
			countryCode = data.countryCode,
			contacts = data.contacts,
			source = data.source
		})
	end)
end
