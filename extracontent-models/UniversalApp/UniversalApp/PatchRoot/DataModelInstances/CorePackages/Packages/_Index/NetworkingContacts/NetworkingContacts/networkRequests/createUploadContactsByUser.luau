local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

require(ParentParent.Types.networkRequestsTypes)
game:DefineFastString("ContactImporterUploadUrl", "contacts")

local FastString = game:GetFastString("ContactImporterUploadUrl")

return function(p1) -- line: 8
	-- upvalues: API_URL (copy), FastString (copy)
	return p1.roduxNetworking.POST({
		Name = "UploadContactsByUser"
	}, function(p2, p3) -- line: 13
		-- upvalues: API_URL (copy), FastString (copy)
		return p2(API_URL):path("contacts-api"):path("v1"):path(FastString):body({
			countryCode = p3.countryCode,
			contacts = p3.contacts
		})
	end)
end
