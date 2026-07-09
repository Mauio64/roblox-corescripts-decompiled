local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Common.Enums)

local SupportedProfileTypes = require(ProfilePlatform.Components.CTARow.ProfileActions.SupportedProfileTypes)

return function(p1) -- line: 6
	-- upvalues: SupportedProfileTypes (copy)
	return SupportedProfileTypes[p1] or {}
end
