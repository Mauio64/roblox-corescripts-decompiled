local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RoactAppExperiment")
local getFStringSelfProfileView = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").getFStringSelfProfileView

local useUserExperiment = RoactAppExperiment.useUserExperiment
local FFlagEditProfileSetupNewExperimentFlow = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileSetupNewExperimentFlow")

local defineFastString = game:DefineFastString("EditProfileExperimentKey", "can_view_edit_profile")

local function fn(options): boolean
	local v5 = (options or {})[getFStringSelfProfileView()] or {}

	if FFlagEditProfileSetupNewExperimentFlow then
		return v5[defineFastString] == true
	end

	return v5.can_view_edit_profile == true
end

return {
	isExperimentEnabled = fn,
	useIsExperimentEnabled = function(p2)
		local v6 = { getFStringSelfProfileView() }

		local v8 = if p2 then p2.isExposureEnabled else nil
		return useUserExperiment(v6, fn, v8)
	end
}
