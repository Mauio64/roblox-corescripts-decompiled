local useBrowserTrackerExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/RoactAppExperiment").useBrowserTrackerExperiment
local appBtidLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/ExperimentLayers").AppBtidLayers
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/SharedFlags")

local resolveBirthdaySelectVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthSignup").Util.resolveBirthdaySelectVariant

local getFFlagSignUpBirthdayPickerRequireManualSelection = SharedFlags.GetFFlagSignUpBirthdayPickerRequireManualSelection

local getFIntSignUpBirthdayPickerManualSelectVariantOverride = SharedFlags.GetFIntSignUpBirthdayPickerManualSelectVariantOverride

local function useRequireManualSelection()
	local v5 = useBrowserTrackerExperiment({ appBtidLayers.SignupLayer }, function(p2)
		return {
			birthdayManualSelectVariant = (p2[appBtidLayers.SignupLayer] or {}).birthdayManualSelectVariant
		}
	end, false)

	return resolveBirthdaySelectVariant(
		getFFlagSignUpBirthdayPickerRequireManualSelection(),
		getFIntSignUpBirthdayPickerManualSelectVariantOverride(),
		v5.birthdayManualSelectVariant
	)
end

return useRequireManualSelection
