local module = require("@luauforge/bundled/dFu")
local fFlagShareTargetGameCleanup = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagShareTargetGameCleanup

local function getIsAndroidBackButtonHandlerDisabled(p2): boolean
	return p2 == module.GameDetail
		or not fFlagShareTargetGameCleanup and p2 == module.ShareGameToChat
		or (p2 == module.AvatarExperienceWrapperTransparent or p2 == module.AvatarExperienceWrapper or p2 == module.ProfilePlatform)
end

return getIsAndroidBackButtonHandlerDisabled
