local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)

require(ProfilePlatform.Types.Component)

local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)
local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)

function GetProfilePlatform(s1: string, p1) -- line: 16
	-- upvalues: FFlagProfilePlatformRefreshActionsRespectPolicies (copy), Enums (copy), FFlagProfilePlatformCTAsRefactor (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy), getProfilePlatform (copy)
	local v9 = if not FFlagProfilePlatformRefreshActionsRespectPolicies or p1 == nil then {
		component = Enums.Components.Actions,
		isActionsV2Supported = not not FFlagProfilePlatformCTAsRefactor or nil
	} else p1
	local t1 = {
		{
			component = Enums.Components.UserProfileHeader
		},
		v9
	}

	if FFlagProfilePlatformAddCurrentlyPlaying then
		table.insert(t1, {
			component = Enums.Components.CurrentlyPlaying
		})
	end

	return getProfilePlatform.API({
		includeComponentOrdering = false,
		profileId = s1,
		profileType = Enums.ProfileTypes.User,
		components = t1
	})
end

return GetProfilePlatform
