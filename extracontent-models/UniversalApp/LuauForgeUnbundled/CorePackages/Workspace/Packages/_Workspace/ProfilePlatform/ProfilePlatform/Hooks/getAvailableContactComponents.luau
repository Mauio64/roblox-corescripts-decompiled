require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local getSupportedActionsForProfileType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getSupportedActionsForProfileType")

return function()
	return {
		{ component = Enums.Components.ContactProfileHeader },
		{ component = Enums.Components.ContactDescription },
		{
			component = Enums.Components.Actions,
			supportedActions = getSupportedActionsForProfileType(Enums.ProfileTypes.Contact),
			isActionsV2Supported = true
		}
	}
end
