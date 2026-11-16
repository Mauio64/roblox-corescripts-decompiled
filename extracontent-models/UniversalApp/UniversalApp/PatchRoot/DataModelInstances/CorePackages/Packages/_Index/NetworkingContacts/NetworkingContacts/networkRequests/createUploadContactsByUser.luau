local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)
require(parent.Types.networkRequestsTypes)

game:DefineFastString("ContactImporterUploadUrl", "contacts")
local fastString = game:GetFastString("ContactImporterUploadUrl")

return function(p)
	return p.roduxNetworking.POST({ Name = "UploadContactsByUser" }, function(callback, p2)
		return callback(API_URL):path("contacts-api"):path("v1"):path(fastString):body({
			countryCode = p2.countryCode,
			contacts = p2.contacts
		})
	end)
end
