local parent = script:FindFirstAncestor("EditProfile").Parent
local RoactAppExperiment = require(parent.RoactAppExperiment)

local defineFastString = game:DefineFastString("RealNamesInDisplayNamesIXP_v1", "Social.DisplayNameSetting")

local defineFastString2 = game:DefineFastString("RealNamesInDisplayNamesExperimentDefinition", "can_see_real_names")
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
	useIsExperimentEnabled = function(p)
		return useUserExperiment({ defineFastString }, fn, p.isExposureEnabled)
	end
}
