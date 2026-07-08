local Parent = script:FindFirstAncestor("EditProfile").Parent
local RoactAppExperiment = require(Parent.RoactAppExperiment)
local v3 = game:DefineFastString("RealNamesInDisplayNamesIXP_v1", "Social.DisplayNameSetting")
local v4 = game:DefineFastString("RealNamesInDisplayNamesExperimentDefinition", "can_see_real_names")
local v5 = game:DefineFastFlag("RealNamesInDisplayNamesEnabledForAll", false)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local function v7(p1) -- line: 12
	-- upvalues: v5 (copy), v3 (copy), v4 (copy)
	if v5 then
		return true
	end

	return ((p1 or {})[v3] or {})[v4] == true
end

return {
	isExperimentEnabled = v7,
	useIsExperimentEnabled = function(t1: {[any]: any}) -- line: 25
		-- upvalues: useUserExperiment (copy), v3 (copy), v7 (copy)
		return useUserExperiment({ v3 }, v7, t1.isExposureEnabled)
	end
}
