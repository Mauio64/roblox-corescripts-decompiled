local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView

local function isFullView(p1) -- line: 13
	-- upvalues: IsVRAppBuild (copy), FullView (copy)
	if IsVRAppBuild() then
		local t1 = {}

		setmetatable(t1, {
			__index = function() -- line: 18
				-- upvalues: FullView (copy)
				return FullView.None
			end
		})

		return t1
	end

	return p1.AvatarExperience.Common.FullView
end

return isFullView
