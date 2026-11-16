local parent = script:FindFirstAncestor("BuildExperiencePlaytestLaunch").Parent

local AppCommonLib = require(parent.AppCommonLib)
local SharedFlags = require(parent.SharedFlags)
require(parent.UniversalAppPolicy)

local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local isTenFootInterface = AppCommonLib.isTenFootInterface
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local FFlagEnableBuildTabOverride = SharedFlags.FFlagEnableBuildTabOverride

local function canViewBuild(p)
	return (FFlagEnableBuildTabOverride or FFlagAppNavMyStatsTab and p.getCanViewBuild())
		and not (IsVRAppBuild() or isTenFootInterface())
end

return canViewBuild
