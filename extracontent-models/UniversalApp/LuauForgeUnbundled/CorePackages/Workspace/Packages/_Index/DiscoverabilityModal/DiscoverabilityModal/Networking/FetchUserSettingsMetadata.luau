local networkingUserSettings = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies").NetworkingUserSettings

return function()
	return function(object)
		object:dispatch(networkingUserSettings.GetUserSettingsMetadata.API())
	end
end
