local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode

local function isPortrait(p1) -- line: 13
	-- upvalues: IsVRAppBuild (copy), DeviceOrientationMode (copy)
	if IsVRAppBuild() then
		return true
	end

	return p1.DeviceOrientation == DeviceOrientationMode.Portrait
end

return isPortrait
