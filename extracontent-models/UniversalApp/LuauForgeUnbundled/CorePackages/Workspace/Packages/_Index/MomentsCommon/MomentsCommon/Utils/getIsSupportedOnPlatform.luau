local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/AppCommonLib")
local isVRAppBuild = AppCommonLib.IsVRAppBuild
local isTenFootInterface = AppCommonLib.isTenFootInterface

local function getIsSupportedOnPlatform(): boolean
	return not (isVRAppBuild() or isTenFootInterface())
end

return getIsSupportedOnPlatform
