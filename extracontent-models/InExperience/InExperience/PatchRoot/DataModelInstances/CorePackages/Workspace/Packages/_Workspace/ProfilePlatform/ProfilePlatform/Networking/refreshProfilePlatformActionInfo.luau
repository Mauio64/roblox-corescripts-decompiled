local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)

local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
require(ProfilePlatform.Types.Component)

local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)

local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)
local FFlagProfilePlatformGracefulVisibility = require(ProfilePlatform.Flags.FFlagProfilePlatformGracefulVisibility)

function GetProfilePlatform(profileId: string, p)
	local v = (not FFlagProfilePlatformRefreshActionsRespectPolicies or p == nil)
		and { component = Enums.Components.Actions, isActionsV2Supported = true }
		or p

	local components = {
		{ component = Enums.Components.UserProfileHeader },
		v
	}

	if FFlagProfilePlatformAddCurrentlyPlaying then
		table.insert(components, { component = Enums.Components.CurrentlyPlaying })
	end

	if FFlagProfilePlatformGracefulVisibility then
		table.insert(components, { component = Enums.Components.Friends })
	end

	return getProfilePlatform.API({
		profileId = profileId,
		profileType = Enums.ProfileTypes.User,
		components = components,
		includeComponentOrdering = false
	})
end

return GetProfilePlatform
