local scriptParent = script.Parent
local networkRequests = scriptParent.networkRequests
local createGetUserSettings = require(networkRequests.createGetUserSettings)
local createUpdateUserSettings = require(networkRequests.createUpdateUserSettings)
local createGetUserSettingsMetadata = require(networkRequests.createGetUserSettingsMetadata)

require(scriptParent.Types.networkRequestsTypes)

return function(p1) -- line: 8
	-- upvalues: createGetUserSettings (copy), createUpdateUserSettings (copy), createGetUserSettingsMetadata (copy)
	return {
		GetUserSettings = createGetUserSettings(p1),
		UpdateUserSettings = createUpdateUserSettings(p1),
		GetUserSettingsMetadata = createGetUserSettingsMetadata(p1)
	}
end
