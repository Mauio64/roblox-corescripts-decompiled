local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Types.Component)

local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)

function GetProfilePlatform(profileId: string)
	local components = {
		{ component = Enums.Components.UserProfileHeader },
		{ component = Enums.Components.About }
	}

	table.insert(components, { component = Enums.Components.ProfileBackground })

	return getProfilePlatform.API({
		profileId = profileId,
		profileType = Enums.ProfileTypes.User,
		components = components,
		includeComponentOrdering = false
	})
end

return GetProfilePlatform
