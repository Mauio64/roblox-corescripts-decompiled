require("@luauforge/bundled/dKT")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView

local function isFullView(p2)
	if not isVRAppBuild() then
		return p2.AvatarExperience.Common.FullView
	end

	local v5 = {}
	setmetatable(v5, {
		__index = function()
			return fullView.None
		end
	})

	return v5
end

return isFullView
