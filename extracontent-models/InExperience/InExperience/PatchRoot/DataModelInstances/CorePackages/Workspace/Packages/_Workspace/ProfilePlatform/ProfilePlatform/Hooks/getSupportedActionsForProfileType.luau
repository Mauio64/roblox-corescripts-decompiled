local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Common.Enums)
local SupportedProfileTypes = require(ProfilePlatform.Components.CTARow.ProfileActions.SupportedProfileTypes)

return function(p)
	return SupportedProfileTypes[p] or {}
end
