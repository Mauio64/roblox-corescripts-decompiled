local networkRequests = script.Parent.networkRequests
local createGetUserProfileSettings = require(networkRequests.createGetUserProfileSettings)
local createSetUserProfileSettings = require(networkRequests.createSetUserProfileSettings)

return function(t1: {[any]: any}) -- line: 6
	-- upvalues: createGetUserProfileSettings (copy), createSetUserProfileSettings (copy)
	return {
		GetUserProfileSettings = createGetUserProfileSettings(t1),
		SetUserProfileSettings = createSetUserProfileSettings(t1)
	}
end
