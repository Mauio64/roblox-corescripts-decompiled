local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

require(ParentParent.Types.networkRequestsTypes)

return function(p1) -- line: 7
	-- upvalues: API_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "UploadContactsByUser"
	}, function(p2, p3) -- line: 12
		-- upvalues: API_URL (copy)
		return p2(API_URL):path("contacts-api"):path("v1"):path("contacts"):body({
			countryCode = p3.countryCode,
			contacts = p3.contacts,
			source = p3.source
		})
	end)
end
