local parent = script.Parent
local networkRequests = parent.networkRequests
local createGetUserSettings = require(networkRequests.createGetUserSettings)
local createUpdateUserSettings = require(networkRequests.createUpdateUserSettings)
local createGetUserSettingsMetadata = require(networkRequests.createGetUserSettingsMetadata)
require(parent.Types.networkRequestsTypes)

return function(p)
	return {
		GetUserSettings = createGetUserSettings(p),
		UpdateUserSettings = createUpdateUserSettings(p),
		GetUserSettingsMetadata = createGetUserSettingsMetadata(p)
	}
end
