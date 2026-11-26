local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

return function(p2)
	if p2 == Enums.ProfileTypes.Community then
		return Constants.COMMUNITY_PEEK_VIEW_OPEN_HEIGHT
	end

	return Constants.USER_PEEK_VIEW_OPEN_HEIGHT
end
