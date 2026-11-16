local parent = script:FindFirstAncestor("MomentsCommon").Parent

local AppCommonLib = require(parent.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local isTenFootInterface = AppCommonLib.isTenFootInterface

local function getIsSupportedOnPlatform(): boolean
	return not (IsVRAppBuild() or isTenFootInterface())
end

return getIsSupportedOnPlatform
