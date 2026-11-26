local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface

local function getHasBackgroundMusic()
	return isVRAppBuild() or isTenFootInterface()
end

return getHasBackgroundMusic
