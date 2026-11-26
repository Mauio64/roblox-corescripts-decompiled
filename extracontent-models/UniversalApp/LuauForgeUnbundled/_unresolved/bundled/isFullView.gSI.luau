require("@luauforge/bundled/dKT")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView

local function isFullView(p2, p3)
	if isVRAppBuild() then
		return fullView.None
	end

	return p2.AvatarExperience.Common.FullView[p3]
end

return isFullView
