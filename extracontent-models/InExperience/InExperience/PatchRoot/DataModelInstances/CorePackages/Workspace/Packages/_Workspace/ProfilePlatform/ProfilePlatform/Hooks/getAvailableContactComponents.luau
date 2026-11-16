local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Types.Component)
local Enums = require(ProfilePlatform.Common.Enums)
local getSupportedActionsForProfileType = require(ProfilePlatform.Hooks.getSupportedActionsForProfileType)

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
