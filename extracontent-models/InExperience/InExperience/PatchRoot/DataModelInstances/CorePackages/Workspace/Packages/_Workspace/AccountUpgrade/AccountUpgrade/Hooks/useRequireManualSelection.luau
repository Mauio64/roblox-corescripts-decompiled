local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local RoactAppExperiment = require(parent.RoactAppExperiment)
local useBrowserTrackerExperiment = RoactAppExperiment.useBrowserTrackerExperiment
local ExperimentLayers = require(parent.ExperimentLayers)
local AppBtidLayers = ExperimentLayers.AppBtidLayers
local SharedFlags = require(parent.SharedFlags)

local AuthSignup = require(parent.AuthSignup)
local resolveBirthdaySelectVariant = AuthSignup.Util.resolveBirthdaySelectVariant

local GetFFlagSignUpBirthdayPickerRequireManualSelection = SharedFlags.GetFFlagSignUpBirthdayPickerRequireManualSelection

local GetFIntSignUpBirthdayPickerManualSelectVariantOverride = SharedFlags.GetFIntSignUpBirthdayPickerManualSelectVariantOverride

local function useRequireManualSelection()
	local v = useBrowserTrackerExperiment({ AppBtidLayers.SignupLayer }, function(p)
		return {
			birthdayManualSelectVariant = (p[AppBtidLayers.SignupLayer] or {}).birthdayManualSelectVariant
		}
	end, false)

	return resolveBirthdaySelectVariant(
		GetFFlagSignUpBirthdayPickerRequireManualSelection(),
		GetFIntSignUpBirthdayPickerManualSelectVariantOverride(),
		v.birthdayManualSelectVariant
	)
end

return useRequireManualSelection
