local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)

function GetProfilePlatform(s1: string) -- line: 7
	-- upvalues: getProfilePlatform (copy), Enums (copy)
	return getProfilePlatform.API({
		includeComponentOrdering = false,
		profileId = s1,
		profileType = Enums.ProfileTypes.User,
		components = {{
			component = Enums.Components.UserProfileHeader
		}}
	})
end

return GetProfilePlatform
