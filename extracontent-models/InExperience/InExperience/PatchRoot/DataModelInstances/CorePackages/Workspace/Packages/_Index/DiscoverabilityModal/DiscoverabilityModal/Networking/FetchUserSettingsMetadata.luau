local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local networkingUserSettings = dependencies.NetworkingUserSettings

return function()
	return function(object)
		object:dispatch(networkingUserSettings.GetUserSettingsMetadata.API())
	end
end
