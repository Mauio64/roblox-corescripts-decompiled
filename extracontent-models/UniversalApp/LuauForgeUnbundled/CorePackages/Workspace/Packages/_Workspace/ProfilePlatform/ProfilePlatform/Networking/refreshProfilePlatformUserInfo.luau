local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")

local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")

function LUAUFORGE_MODULE_GLOBALS_fgf_GetProfilePlatform(p2)
	local v5 = {
		{ component = Enums.Components.UserProfileHeader },
		{ component = Enums.Components.About }
	}

	table.insert(v5, { component = Enums.Components.ProfileBackground })

	return getProfilePlatform.API({
		profileId = p2,
		profileType = Enums.ProfileTypes.User,
		components = v5,
		includeComponentOrdering = false
	})
end

return LUAUFORGE_MODULE_GLOBALS_fgf_GetProfilePlatform
