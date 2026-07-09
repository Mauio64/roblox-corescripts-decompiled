local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Types.Component)

local Enums = require(ProfilePlatform.Common.Enums)
local getSupportedActionsForProfileType = require(ProfilePlatform.Hooks.getSupportedActionsForProfileType)
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)

return function() -- line: 8
	-- upvalues: Enums (copy), FFlagProfilePlatformCTAsRefactor (copy), getSupportedActionsForProfileType (copy)
	return {
		{
			component = Enums.Components.ContactProfileHeader
		},
		{
			component = Enums.Components.ContactDescription
		},
		{
			component = Enums.Components.Actions,
			supportedActions = if not FFlagProfilePlatformCTAsRefactor then nil else getSupportedActionsForProfileType(Enums.ProfileTypes.Contact),
			isActionsV2Supported = not not FFlagProfilePlatformCTAsRefactor or nil
		}
	}
end
