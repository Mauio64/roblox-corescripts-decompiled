local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)

local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)

function GetProfilePlatform(profileId: string)
	return getProfilePlatform.API({
		profileId = profileId,
		profileType = Enums.ProfileTypes.User,
		components = {
			{ component = Enums.Components.UserProfileHeader }
		},
		includeComponentOrdering = false
	})
end

return GetProfilePlatform
