local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

require(ParentParent.Types.networkRequestsTypes)

return function(p1) -- line: 5
	-- upvalues: API_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "GetContactEntitiesByContactId"
	}, function(p2, p3) -- line: 10
		-- upvalues: API_URL (copy)
		return p2(API_URL):path("contacts-api"):path("v1"):path("contacts"):path("entities"):body({
			userContactIds = p3
		})
	end)
end
