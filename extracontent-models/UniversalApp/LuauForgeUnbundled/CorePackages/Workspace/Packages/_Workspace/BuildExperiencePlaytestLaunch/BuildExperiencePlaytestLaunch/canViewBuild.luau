local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/AppCommonLib")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/SharedFlags")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/UniversalAppPolicy")

local isVRAppBuild = AppCommonLib.IsVRAppBuild
local isTenFootInterface = AppCommonLib.isTenFootInterface
local fFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local fFlagEnableBuildTabOverride = SharedFlags.FFlagEnableBuildTabOverride

local function canViewBuild(p2)
	return (fFlagEnableBuildTabOverride or fFlagAppNavMyStatsTab and p2.getCanViewBuild())
		and not (isVRAppBuild() or isTenFootInterface())
end

return canViewBuild
