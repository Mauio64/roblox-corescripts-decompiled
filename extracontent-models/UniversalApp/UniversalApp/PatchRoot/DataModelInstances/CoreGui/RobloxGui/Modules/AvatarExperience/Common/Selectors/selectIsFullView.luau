local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView

local function isFullView(p1, s1: string) -- line: 13
	-- upvalues: IsVRAppBuild (copy), FullView (copy)
	if IsVRAppBuild() then
		return FullView.None
	end

	return p1.AvatarExperience.Common.FullView[s1]
end

return isFullView
