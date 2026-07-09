local Parent = script:FindFirstAncestor("EditProfile").Parent
local RoactAppExperiment = require(Parent.RoactAppExperiment)
local getFStringSelfProfileView = require(Parent.SharedFlags).getFStringSelfProfileView
local useUserExperiment = RoactAppExperiment.useUserExperiment
local FFlagEditProfileSetupNewExperimentFlow = require(script.Parent.FFlagEditProfileSetupNewExperimentFlow)
local v6 = game:DefineFastString("EditProfileExperimentKey", "can_view_edit_profile")

local function v7(p1) -- line: 11
	-- upvalues: getFStringSelfProfileView (copy), FFlagEditProfileSetupNewExperimentFlow (copy), v6 (copy)
	local v9 = (p1 or {})[getFStringSelfProfileView()] or {}

	if FFlagEditProfileSetupNewExperimentFlow then
		return v9[v6] == true
	end

	return v9.can_view_edit_profile == true
end

return {
	isExperimentEnabled = v7,
	useIsExperimentEnabled = function(t1: {[any]: any}?) -- line: 25
		-- upvalues: useUserExperiment (copy), getFStringSelfProfileView (copy), v7 (copy)
		return useUserExperiment({ getFStringSelfProfileView() }, v7, if not t1 then nil else t1.isExposureEnabled)
	end
}
