local parent = script.Parent.Parent

local API_URL = require(parent.API_URL)
require(parent.Types.networkRequestsTypes)

return function(p)
	return p.roduxNetworking.POST("UploadContactsByUser", function(callback, data)
		return callback(API_URL):path("contacts-api"):path("v1"):path("contacts"):body({
			countryCode = data.countryCode,
			contacts = data.contacts,
			source = data.source
		})
	end)
end
