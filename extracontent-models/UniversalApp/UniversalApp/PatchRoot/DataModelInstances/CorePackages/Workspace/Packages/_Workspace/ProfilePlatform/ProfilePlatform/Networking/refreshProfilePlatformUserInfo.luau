local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Types.Component)

local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)

function GetProfilePlatform(s1: string) -- line: 10
	-- upvalues: Enums (copy), getProfilePlatform (copy)
	local t1 = {
		{
			component = Enums.Components.UserProfileHeader
		},
		{
			component = Enums.Components.About
		}
	}

	table.insert(t1, {
		component = Enums.Components.ProfileBackground
	})

	return getProfilePlatform.API({
		includeComponentOrdering = false,
		profileId = s1,
		profileType = Enums.ProfileTypes.User,
		components = t1
	})
end

return GetProfilePlatform
