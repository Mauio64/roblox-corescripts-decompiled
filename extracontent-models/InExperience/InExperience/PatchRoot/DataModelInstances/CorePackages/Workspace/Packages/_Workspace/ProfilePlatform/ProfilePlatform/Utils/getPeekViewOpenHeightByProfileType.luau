local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)

return function(p)
	if p == Enums.ProfileTypes.Community then
		return Constants.COMMUNITY_PEEK_VIEW_OPEN_HEIGHT
	end

	return Constants.USER_PEEK_VIEW_OPEN_HEIGHT
end
