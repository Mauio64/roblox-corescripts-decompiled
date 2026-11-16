local parent = script:FindFirstAncestor("EditProfile").Parent
local RoactAppExperiment = require(parent.RoactAppExperiment)
local SharedFlags = require(parent.SharedFlags)
local getFStringSelfProfileView = SharedFlags.getFStringSelfProfileView

local useUserExperiment = RoactAppExperiment.useUserExperiment
local FFlagEditProfileSetupNewExperimentFlow = require(script.Parent.FFlagEditProfileSetupNewExperimentFlow)

local defineFastString = game:DefineFastString("EditProfileExperimentKey", "can_view_edit_profile")

local function fn(options): boolean
	local v = (options or {})[getFStringSelfProfileView()] or {}

	if FFlagEditProfileSetupNewExperimentFlow then
		return v[defineFastString] == true
	end

	return v.can_view_edit_profile == true
end

return {
	isExperimentEnabled = fn,
	useIsExperimentEnabled = function(p)
		local v = { getFStringSelfProfileView() }
		local v2

		if p then
			v2 = p.isExposureEnabled
		end

		return useUserExperiment(v, fn, v2)
	end
}
