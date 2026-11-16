local networkRequests = script.Parent.networkRequests
local createGetUserProfileSettings = require(networkRequests.createGetUserProfileSettings)
local createSetUserProfileSettings = require(networkRequests.createSetUserProfileSettings)

return function(p)
	return {
		GetUserProfileSettings = createGetUserProfileSettings(p),
		SetUserProfileSettings = createSetUserProfileSettings(p)
	}
end
