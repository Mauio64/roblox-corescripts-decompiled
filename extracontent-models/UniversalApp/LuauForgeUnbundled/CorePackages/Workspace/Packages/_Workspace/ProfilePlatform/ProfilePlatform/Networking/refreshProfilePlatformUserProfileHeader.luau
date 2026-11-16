local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")

function LUAUFORGE_MODULE_GLOBALS_fft_GetProfilePlatform(p2)
	return getProfilePlatform.API({
		profileId = p2,
		profileType = Enums.ProfileTypes.User,
		components = {
			{ component = Enums.Components.UserProfileHeader }
		},
		includeComponentOrdering = false
	})
end

return LUAUFORGE_MODULE_GLOBALS_fft_GetProfilePlatform
