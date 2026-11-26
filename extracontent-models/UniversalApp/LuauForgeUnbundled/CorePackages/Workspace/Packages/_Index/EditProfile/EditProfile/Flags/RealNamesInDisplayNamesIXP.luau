local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RoactAppExperiment")

local defineFastString = game:DefineFastString("RealNamesInDisplayNamesIXP_v1", "Social.DisplayNameSetting")

local defineFastString2 = game:DefineFastString(
	"RealNamesInDisplayNamesExperimentDefinition",
	"can_see_real_names"
)
local defineFastFlag = game:DefineFastFlag("RealNamesInDisplayNamesEnabledForAll", false)

local useUserExperiment = RoactAppExperiment.useUserExperiment

local function fn(options): boolean
	if defineFastFlag then
		return true
	end

	return ((options or {})[defineFastString] or {})[defineFastString2] == true
end

return {
	isExperimentEnabled = fn,
	useIsExperimentEnabled = function(p2)
		return useUserExperiment({ defineFastString }, fn, p2.isExposureEnabled)
	end
}
