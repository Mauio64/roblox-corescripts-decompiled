local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")

local FFlagProfilePlatformAddCurrentlyPlaying = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformAddCurrentlyPlaying")

local FFlagProfilePlatformRefreshActionsRespectPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformRefreshActionsRespectPolicies")
local FFlagProfilePlatformGracefulVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformGracefulVisibility")

function LUAUFORGE_MODULE_GLOBALS_fft_GetProfilePlatform(p2, p3)
	local v5 = (not FFlagProfilePlatformRefreshActionsRespectPolicies or p3 == nil)
		and { component = Enums.Components.Actions, isActionsV2Supported = true }
		or p3

	local v6 = {
		{ component = Enums.Components.UserProfileHeader },
		v5
	}

	if FFlagProfilePlatformAddCurrentlyPlaying then
		table.insert(v6, { component = Enums.Components.CurrentlyPlaying })
	end

	if FFlagProfilePlatformGracefulVisibility then
		table.insert(v6, { component = Enums.Components.Friends })
	end

	return getProfilePlatform.API({
		profileId = p2,
		profileType = Enums.ProfileTypes.User,
		components = v6,
		includeComponentOrdering = false
	})
end

return LUAUFORGE_MODULE_GLOBALS_fft_GetProfilePlatform
